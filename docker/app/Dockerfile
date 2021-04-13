FROM php:8.0.3-cli-alpine3.13

# install neovim and dependencies
RUN apk add --no-cache \
    neovim \
    # needed by dockerfile
    curl g++ \
    # needed by neovim as provider
    python3-dev py-pip gcc musl-dev \
    nodejs yarn \
    # needed by fzf
    bash file git ripgrep

# create user
RUN adduser -D -g '' phpuser
USER phpuser

# configure neovim
COPY --chown=phpuser editor/config /home/phpuser/.config
RUN \
    # install python's neovim plugin
    pip install pynvim \
    # install node's neovim plugin
    && yarn global add neovim \
    # install plugin manager for neovim
    && curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    # install neovim plugins
    && nvim --headless +PlugInstall +qall \
    # install coc extensions (one at a time otherwise some fail)
    && nvim --headless +'CocInstall -sync coc-snippets ' +qall \
    && nvim --headless +'CocInstall -sync coc-markdownlint' +qall \
    && nvim --headless +'CocInstall -sync coc-phpls' +qall

# install composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# install tools from composer
ENV PATH="/home/phpuser/.composer/vendor/bin:${PATH}"
RUN composer global require \
    # format
    friendsofphp/php-cs-fixer \
    # static analyses
    phpstan/phpstan \
    phpstan/extension-installer \
    phpstan/phpstan-strict-rules \
    phpstan/phpstan-phpunit \
    phpstan/phpstan-deprecation-rules \
    ergebnis/phpstan-rules \
    thecodingmachine/phpstan-strict-rules \
    # test watcher
    spatie/phpunit-watcher \
    # mutation testing
    infection/infection

# set aliases
RUN echo 'echo -e "Welcome! The following aliases exist:\n \
run_editor (re): Edit the code.\n \
run_lint (rl): Lint the code without changing it.\n \
run_fmt (rf): Format the code by the linting rules.\n \
run_analyse (ra): Analyse the code statically.\n \
run_test (rt): Run all tests.\n \
run_watch (rw): Watch all unit tests.\n \
run_ci (rc): Run pipeline steps."' >> ~/.bashrc \
    && echo 'alias run_editor="nvim /app"' >> ~/.bashrc \
    && echo 'alias re=run_editor' >> ~/.bashrc \
    && echo 'alias run_lint="php-cs-fixer fix --allow-risky=yes -vvv --dry-run"' >> ~/.bashrc \
    && echo 'alias rl=run_lint' >> ~/.bashrc \
    && echo 'alias run_fmt="php-cs-fixer fix --allow-risky=yes"' >> ~/.bashrc \
    && echo 'alias rf=run_fmt' >> ~/.bashrc \
    && echo 'alias run_analyse="phpstan analyse"' >> ~/.bashrc \
    && echo 'alias ra=run_analyse' >> ~/.bashrc \
    && echo 'alias run_test="/app/vendor/bin/phpunit --testdox"' >> ~/.bashrc \
    && echo 'alias rt=run_test' >> ~/.bashrc \
    && echo 'alias run_watch="phpunit-watcher watch"' >> ~/.bashrc \
    && echo 'alias rw=run_watch' >> ~/.bashrc \
    && echo 'run_ci() { run_lint; run_analyse; run_test; }' >> ~/.bashrc \
    && echo 'alias rc=run_ci' >> ~/.bashrc

COPY --chown=phpuser app /app
WORKDIR /app

RUN \
    # init a git repo for fzf and ripgrep to work properly
    git init \
    # install app dependencies
    && composer install

CMD [ "bash" ]
