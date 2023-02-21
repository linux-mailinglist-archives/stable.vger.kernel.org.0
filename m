Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A2269DC74
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 10:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbjBUJAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 04:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbjBUJAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 04:00:30 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4711CF48
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 01:00:29 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id m10so1590134vso.4
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 01:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676970028;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=snrQn0Tlo0gQ0uyxV6hinZ9sS9jKVp6Wr9FYbxThYg0=;
        b=Ihnac5gfGHfOeKIQ6rEZ747/YTP2w/waPucMxpymT9yMA4q5aG/5WwANfn3AIGnxSG
         L0TBbDRH1Iz1xP3I2Ip0KkjxjJ3TmsoeCBstrVs6DtpCf9VeCxhNr3fjIjkVf8N7E6Z+
         rrnCykcs5UxfoLJ6+ljrRqGjd4nWN0g4klu6u3heskV2b1v4BQoiV9aDetD5y2YR2H8U
         eI9cBVXZeCi4Kb/JLeCv3OwstOTqNN6vg5zKFyxS1ibf+2cAiWLRb5aVi4Nud3aFPhKm
         ZwU74tNe2xcAlRVdDtyd4xCwRqrRbKLE9yN9ftJ6F3FegpXAU3Tk0vDR0mCeNIyR9Jyn
         /h+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676970028;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=snrQn0Tlo0gQ0uyxV6hinZ9sS9jKVp6Wr9FYbxThYg0=;
        b=XfXvLb7zgRFsWs5eY8DVoAJOLKCpzmXt24e9oQGhD5YeoOaQVG+CQ/ID7oj4RhiqNz
         tDmmWal2aWgtt8y+0s94GL3CCAE/jPA+UoWE0rTf1UJ7gpdguapYsnnenWZXRHQoPTuT
         NPnWHOGXiKtgTFV7raoReV9B+XGOTWZ/eqkyvxza4qmwK03h/B2J1rDivOWLPyiMcFst
         7rDGFthH9BTzfQ34knmagi25U0T3PmhtgBJBjGUMlgcO2azeYnz4iQ+rZzlvIK28By0u
         GrGFDzAvdsWB/aBwK007gLY38ghZkfBRF3N9E6Y9gOjQjZJeTWWCUBkb1w/YLk+1pH9n
         hgmw==
X-Gm-Message-State: AO0yUKUulGLqOKynCcTunQfbvVZSQ9Iz4JfctlfGjVaqPqueNK6T/00V
        yUod6Ydf41QAht/MBXjSvurZz/diRJM8euAi8rD9fg==
X-Google-Smtp-Source: AK7set+3kFO9Mj/lchoJZ/OJccFPwKQD+LlOMwYfhMHf93Wr+N7ICLxTR5wKhJAMLAVWhex11pcwB4yjBiMiNk5Me/4=
X-Received: by 2002:a05:6102:a24:b0:41e:991d:8814 with SMTP id
 4-20020a0561020a2400b0041e991d8814mr134187vsb.71.1676970028117; Tue, 21 Feb
 2023 01:00:28 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Feb 2023 14:30:17 +0530
Message-ID: <CA+G9fYt9T=ELCLaB9byxaLW2Qf4pZcDO=huCA0D8ug2V2+irJQ@mail.gmail.com>
Subject: stable-rc: 5.10: riscv: defconfig: clang-nightly: build failed -
 Invalid or unknown z ISA extension: 'zifencei'
To:     llvm@lists.linux.dev,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, conor@kernel.org,
        Heiko Stuebner <heiko@sntech.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The riscv defconfig and tinyconfig builds failed with clang-nightly
due to below build warnings / errors on latest stable-rc 5.10.

Regression on riscv:
  - build/clang-nightly-tinyconfig - FAILED
  - build/clang-nightly-defconfig - FAILED

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

metadata:
-----
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git_sha: 7d11e4c4fc56eb25c5b41da93748dbcf21956316
  git_short_log: 7d11e4c4fc56 ("Linux 5.10.169-rc1")
  git_describe: v5.10.168-58-g7d11e4c4fc56

Build log:
----
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/build ARCH=riscv
CROSS_COMPILE=riscv64-linux-gnu- HOSTCC=clang CC=clang LLVM=1
LLVM_IAS=1 LD=riscv64-linux-gnu-ld
riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p0:
Invalid or unknown z ISA extension: 'zifencei'
riscv64-linux-gnu-ld: failed to merge target specific data of file
init/version.o
riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p0:
Invalid or unknown z ISA extension: 'zifencei'
riscv64-linux-gnu-ld: failed to merge target specific data of file
init/do_mounts.o
riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p0:
Invalid or unknown z ISA extension: 'zifencei'
riscv64-linux-gnu-ld: failed to merge target specific data of file
init/noinitramfs.o
riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p0:
Invalid or unknown z ISA extension: 'zifencei'
riscv64-linux-gnu-ld: failed to merge target specific data of file
init/calibrate.o
riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p0:
Invalid or unknown z ISA extension: 'zifencei'

Build details,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.168-58-g7d11e4c4fc56/testrun/14869376/suite/build/test/clang-nightly-tinyconfig/details/

Build history,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.168-58-ga96fb51aec5a/testrun/14866489/suite/build/test/clang-nightly-defconfig/details/

https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.168-58-g7d11e4c4fc56/testrun/14869376/suite/build/test/clang-nightly-tinyconfig/history/

steps to reproduce:
-----------
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.
# tuxmake --runtime podman --target-arch riscv --toolchain
clang-nightly --kconfig tinyconfig LLVM=1 LLVM_IAS=1
LD=riscv64-linux-gnu-ld

--
Linaro LKFT
https://lkft.linaro.org
