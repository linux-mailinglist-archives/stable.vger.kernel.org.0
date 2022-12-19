Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99082650E81
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 16:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiLSPSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 10:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbiLSPRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 10:17:46 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77397BAF
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 07:17:45 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id p9so2137814uam.12
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 07:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Hzg9lEbdoeIi95HGge8FIicgyWxpuv5ofad+2T9Oo+w=;
        b=vf+EdVAqFRrbZV6gfZgTJTQZFxIIxxcX/kzR2qP1xzXQ0BvyLOHyhqcm0TZ8Sd/k9u
         zmWHDKo7VDm/fHJ88Yxwmmw0sVCY9N9KsiHYMwsA5rnIE6hfTKNyDnY4bTbZyOHSywQ0
         sD6gdp+RW+TEyLMYAvxibdK/BRYuYKWrPXjrsijq0gsiI7K1aPLTeviNrOgT+VzHzCC1
         HnL/qb9SSb7sbztMpCgnCWcI2Y6DZ0iJNT9IWpys9BF0HZQ0ZXIamagLlTFXiwE4ortf
         hH1FQSusn8bqh14f2/uLxL5kItJp7e3OMa7J6ZAIPsYcHEStyeoQyWrFGK/t1nMX2ZpX
         Eukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hzg9lEbdoeIi95HGge8FIicgyWxpuv5ofad+2T9Oo+w=;
        b=j9+n6t6n4hWbEx2sPCtP7eTs3CY0hUbtS3+VwM8ZxM4A43dy53K3JucA6rdk956m5N
         E/6fh5gwnGa97f+6f+vkKJwHwMlunb1OJ4XBg8VaTOkXU3EL+B7R2MiMFlRtug91Z66d
         cxzsMZA3MhtBGJw/w/1WoMXjJC0Oo7uKmXJKgwRfl343eNaWfkubhskEicKXkB0gl5LQ
         iuThX9pNfj4k3qDl2/1Mh2LbelQV3sHRfu6hWYBc2b2s4d8j+GDKuwurj7HKyfApsdeb
         a+HnZeSCQA56fRk+VKG7v3ais9OJuvh+KKFjYWGLcJQcODdmMzHrHbjvmj4a5kXvG0fQ
         /MbA==
X-Gm-Message-State: ANoB5pnTGoxiM8Rm24+VDbJQK8ZrwETeyE5/NH+zeI9KTh2ZatkfIk5E
        cspZTnjbYUuMYX/qaeVjOA+zcDusLIiFXAjtMnRr0SkkvE1qvauc
X-Google-Smtp-Source: AA0mqf5MLDW8jZ95Id9Fy4LwMIM44AGn9kHCeWhushX2D+H1XHrWeoYu94ghiY/VR5EVuElL/fPp0ny1hXipMlmzOmw=
X-Received: by 2002:a9f:3588:0:b0:418:7beb:6f42 with SMTP id
 t8-20020a9f3588000000b004187beb6f42mr51439847uad.92.1671463064068; Mon, 19
 Dec 2022 07:17:44 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 19 Dec 2022 20:47:32 +0530
Message-ID: <CA+G9fYs=G_AAbkNOfLv7Oyvt6uOZ8CYun8fUQ-GghoKtbD5WAw@mail.gmail.com>
Subject: Linux-stable-rc/ queue_5.10
To:     linux-stable <stable@vger.kernel.org>, llvm@lists.linux.dev
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <shuah@kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The MIPS tinyconfig with clang nightly  build failed,

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build warnings / errors,
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=0
ARCH=mips CROSS_COMPILE=mips-linux-gnu- HOSTCC=clang CC=clang
tinyconfig

/tmp/calibrate-9ea8cf.s: Assembler messages:
/tmp/calibrate-9ea8cf.s:134: Error: .module is not permitted after
generating code
/tmp/calibrate-9ea8cf.s:168: Error: .module is not permitted after
generating code
/tmp/calibrate-9ea8cf.s:192: Error: .module is not permitted after
generating code
/tmp/calibrate-9ea8cf.s:216: Error: .module is not permitted after
generating code
clang: error: assembler command failed with exit code 1 (use -v to see
invocation)
make[2]: *** [/builds/linux/scripts/Makefile.build:286:
init/calibrate.o] Error 1

Build link,
https://storage.tuxsuite.com/public/linaro/lkft/builds/2J8KYpCyqe9C5esb4CrLQjCT3SN/

Steps to reproduce:
------------------
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.
# tuxmake --runtime podman --target-arch mips --toolchain
clang-nightly --kconfig tinyconfig LLVM=1 LLVM_IAS=0

tuxmake --runtime podman --target-arch mips --toolchain clang-nightly
--kconfig https://storage.tuxsuite.com/public/linaro/lkft/builds/2J8KYpCyqe9C5esb4CrLQjCT3SN/config
LLVM=1 LLVM_IAS=0

--
Linaro LKFT
https://lkft.linaro.org
