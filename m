Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FE31AB559
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 03:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbgDPBS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 21:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730994AbgDPBRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 21:17:44 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F2BC061A0F
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 18:17:38 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x3so883707pfp.7
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 18:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=coLx/v0JktVo4RFMZbnSRAoyVMxkJ2n5uSfb6rpMJLk=;
        b=A+H3JjfWkH8zAy194H2hitZmZsMJCd2KSY8EA37gSrs3x3uN+woaYA8odZVInJR1oh
         NdHG5eZJB+56eITUK5e18SMoS6WaLllv/K49ORc1+q9uPHQgg6lvRvRgN+Tg3FctZSMv
         L7FZSmQjCH62XoNbYVAxb9CVnjFf3C2l68nJzVMNdc4wNknUze+ypU9aAnDnd5xwfCWp
         sSV+4g8QX4ykSHHAezPVM4J0UavfgYluYhJ3Yj1WJ2LXmlkNO8qprz5STtOm/r3XHPMe
         VWJHxeumTnDvuVkf4vjjiRj63anHlxlo7lp5BCR+R2S5Wxs3iY5m6phongU53JVoo+SP
         i6cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=coLx/v0JktVo4RFMZbnSRAoyVMxkJ2n5uSfb6rpMJLk=;
        b=hBo2hNGQZgmkSnZGwTQO/gcdnjsbKshmk8t78vNE6Nb8oAVbML3O67im9XVbjRvNyU
         cn2tQdNQvUu4kPIM8KnoJUwjzy5HldnvGC+B7/J18CXEzvRQT/Yj88q/5+wE6hzlJZEU
         Tc8LAmur5K+gwq41MuVlUUypEMCMBVCFHl4OV1hZnX/ZOZYZj0MB/GqcLwjk1AlGFw2n
         bujCiijnTCRHvezdXwOu4U+67JrG7Ti4IY9YhHi/uoKdutTMnCItf4fFf4RVGNwY1uoW
         +MdCpVhfDmk0e8/HPkS3zoormJEiYwzJiu+yD+ltgLdGs8yA5t9UP4MbNFLx1lYB/rZZ
         8GQA==
X-Gm-Message-State: AGi0PuYOl/FUzECZIiMmMVLQm8IiCi+g4Ju+VVhBI++FeIwzSuI/QLS6
        ZM9FwcyTHplgY1na+oyhEcEld+KgxD8=
X-Google-Smtp-Source: APiQypIjd3PiZ7w3956s3WNaE5sDBvx4BrQAcTZhXpZ4ffe2NtLRIdew/22hSL7EV480p8qptCxH5g==
X-Received: by 2002:a63:6302:: with SMTP id x2mr18134147pgb.375.1586999857117;
        Wed, 15 Apr 2020 18:17:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ml24sm728469pjb.48.2020.04.15.18.17.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 18:17:36 -0700 (PDT)
Message-ID: <5e97b230.1c69fb81.69bf8.28a7@mx.google.com>
Date:   Wed, 15 Apr 2020 18:17:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.6.3-285-g1113b108c404
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.6.y
Subject: stable-rc/linux-5.6.y boot: 165 boots: 4 failed,
 149 passed with 7 offline, 5 untried/unknown (v5.6.3-285-g1113b108c404)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 165 boots: 4 failed, 149 passed with 7 offline,=
 5 untried/unknown (v5.6.3-285-g1113b108c404)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.3-285-g1113b108c404/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.3-285-g1113b108c404/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.3-285-g1113b108c404
Git Commit: 1113b108c4047527f9d1b308ff1e758535a9f8aa
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 103 unique boards, 25 SoC families, 21 builds out of 200

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v5.6.2-70-g6225=
1e4703ac)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v5.6.2-70-g6225=
1e4703ac)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.2-70-g62251e4703a=
c)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.6.2-70-g6225=
1e4703ac)
          meson-g12b-a311d-khadas-vim3:
              lab-baylibre: new failure (last pass: v5.6.2-70-g62251e4703ac)
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.6.2-70-g62251e4703ac)
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v5.6.2-70-g62251e4703ac)
          meson-gxm-q200:
              lab-baylibre: new failure (last pass: v5.6.2-70-g62251e4703ac)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
