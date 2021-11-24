Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57DB45B811
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 11:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239728AbhKXKME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 05:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbhKXKMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 05:12:03 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0516BC061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 02:08:54 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id y13so7768513edd.13
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 02:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=A4N6h+ko6ojDrjCQkwoG1gmVUx+VTm+hLT1+3GyZYDw=;
        b=RIeusKhDonqEJzRQa4QkE8z1OEdnuA2p5sKFcaXqR8trn12KyHnxd9LkAzr0L7Ajqb
         60IYLUKImMwIBGq8gMnw7RbM1RLPOTeoH6dVnqQSqRJZLj1LvBcWmo0vFvRy1P5XnXQm
         cUt3aAKPx/1PzP1jO9Uoy4NH6yefFNK4VUc3qsZAK76+jAhhq1r5LUj/y05Qc0pg9YYd
         Ycu4liBKV+Y7N1Y28NRBLWchvy41PzEYpaqq0u7h9dGv8oUQ3yaROpbBeE8XR9JzDqp3
         d3tbQ2j2d4lLDvh6E55oISGhHT4mD2uOnHU0z18Mnq95/lRmaEKSVzJNn32Z0z7dbvUE
         flsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=A4N6h+ko6ojDrjCQkwoG1gmVUx+VTm+hLT1+3GyZYDw=;
        b=uBOATj8lcMCvL135Wo63sq5QjPMeoEIjzat+qvTX8WbOq1ITth+FovTTITDswQd5vc
         adSSXBBdW/PBIT1fSeqaVjoz8NnS2vmZUPDhilVxh2HsJLGvaXDfrmkZcMgkaia7ChNo
         5b3cTtG3QAJmwvNt6dbOgoUjAqNEoXrFbQ4EKo6Knj1HtP4AQ31DHKvcRD0ltPw3+rGk
         8Zqtj90Y/EQ6HsSwZOl2e76AjkKmUw2+eEr+W7ufNFBWhu9LgOih70o5KXDOz2X9rjNc
         734THG8kiDxzLSAzjXjjF1+qlzAYV3fA3ZPwjN/1Iwnn5a3uiehNjXDxgeW7u9XcQZ/F
         an5w==
X-Gm-Message-State: AOAM533i5kR07dafMtL40+VS+JVtg/2D2lga/Q5iX+7nvOLgWFQtyUbd
        AhZQalKTxuTAE3rlGHsb6Y6c81HUkr030bRy3H3S1vKXXu6FYQ==
X-Google-Smtp-Source: ABdhPJw5PjXrRBErTLg9wG+/m+29tC90c1qJw+iDEeq69e+Pbjk3ZU8GwlYm/72xz8LKZTr+vQTGmiHanq08sGPsqIA=
X-Received: by 2002:aa7:c415:: with SMTP id j21mr22192315edq.357.1637748531704;
 Wed, 24 Nov 2021 02:08:51 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Nov 2021 15:38:40 +0530
Message-ID: <CA+G9fYuqTWxyKjWix6R2f9E7Y5q1PExm4wOvxBnDhqr-Uc26zA@mail.gmail.com>
Subject: qcom: msm8916-longcheer-l8150.dts:191.1-14 Label or path pm8916_usbin
 not found
To:     linux-stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Regression found on arm64 gcc-11 builds
Following build warnings / errors reported on stable-rc 5.15.

metadata:
    git_describe: v5.15.4-281-g6257dfb34612
    git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
    git_short_log: 6257dfb34612 (\"Linux 5.15.5-rc1\")
    target_arch: arm64
    toolchain: gcc-11

build error :
--------------
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
'HOSTCC=sccache gcc'
Error: arch/arm64/boot/dts/qcom/msm8916-longcheer-l8150.dts:191.1-14
Label or path pm8916_usbin not found
FATAL ERROR: Syntax error parsing input tree
make[3]: *** [scripts/Makefile.lib:358:
arch/arm64/boot/dts/qcom/msm8916-longcheer-l8150.dtb] Error 1
arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space
arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space
arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space
arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space
make[3]: Target '__build' not remade because of errors.
make[2]: *** [scripts/Makefile.build:540: arch/arm64/boot/dts/qcom] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [Makefile:1407: dtbs] Error 2
make[1]: Target '__all' not remade because of errors.
make: *** [Makefile:219: __sub-make] Error 2
make: Target '__all' not remade because of errors.


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

build link:
-----------
https://builds.tuxbuild.com//21MNVowrRWKFzlosmqCOp5644Eo/build.log

build config:
-------------
https://builds.tuxbuild.com//21MNVowrRWKFzlosmqCOp5644Eo/config

# To install tuxmake on your system globally
# sudo pip3 install -U tuxmake
tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
--kconfig defconfig \
      --kconfig-add
https://builds.tuxbuild.com//21MNVowrRWKFzlosmqCOp5644Eo/config

--
Linaro LKFT
https://lkft.linaro.org
