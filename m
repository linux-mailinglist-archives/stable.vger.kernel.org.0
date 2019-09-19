Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242ECB7F78
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 18:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390990AbfISQzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 12:55:36 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:38614 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391254AbfISQzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 12:55:35 -0400
Received: by mail-wm1-f44.google.com with SMTP id 3so4784011wmi.3
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 09:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FmSCx4JnuTPub+j7R1rChbOrwkEDnQQBm5H+50gYJIc=;
        b=PykYZSX9Dx+7CH2RUrWhGXKRiosTS1XyPGhcGCo4j31NiLXUrejogUOQS66lfCFqAr
         Z7jGunLvUnagQ+PIBMsz37JfUqPwysHvYrvjFcE6wJSYBMKCLPIw/+PrbTNBqqT4AsKG
         K07QjIL6bDDu5wEfIkG+DZXgbyN3YHAviFKOGejrL/RHx7inzm8/8XGWXg8BQ56sejy4
         57slbekVav7K4BRP+MZRfFE91FLOAiIFZ0UrBSFRjxRUNPf5sV/Die7Ig+XCBta5fb8E
         DqxpVNXNPiAyMRbFdkfkzH6Pjix4VcDdkklNhn+AEzuubb+IMbPPfMg4IDl6uWp6SpGx
         +pvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FmSCx4JnuTPub+j7R1rChbOrwkEDnQQBm5H+50gYJIc=;
        b=oqiMagGnU0hQ6h+SwDxQNnmHGZdL5BfgeEmZoC+u1R5jfymHVnfOEQALP7KSt0zbW4
         Nw7kJHeXk9SBmrv9GgqPKvzFFvxBcbvlZ/kwH/a+6a4/9l7v4pJCRqDyvh5uX+ztnyMv
         ZpJtmE6TmEZxDVkCSM+2BFA1VGQcxmArKBGMJt2oXjZi7ZN7YQpS1Owb5E5kc4Ta9TeT
         RHQXKUZA65MTynAKizdDEq6CT26B73EUYw1DUSwIRGIU000IRVVged63mcxA52RLDVRJ
         7hAxE3LtrBosgaslsofK1ujJj45L/+JPlpWrk9DD7RDdxBCWGVXJgLbsci3aJ2vKNGmU
         bQ/w==
X-Gm-Message-State: APjAAAUxygHgtamqSKcNKA2bhv4Zsxzjl1CEA8b4JNOqosZ0ZZricbHD
        WazDA9hH9gOS6x0xbwsRl3AdQZBUKIxn7Q==
X-Google-Smtp-Source: APXvYqyDmb3fxv5j9b3r8/GU0FsH2DSANBiTZ9PRn8hurP2R3a1DNew2L+1eDOqvNcsdumQt+37ahg==
X-Received: by 2002:a05:600c:c2:: with SMTP id u2mr3382650wmm.37.1568912132621;
        Thu, 19 Sep 2019 09:55:32 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x16sm8870272wrl.32.2019.09.19.09.55.31
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 09:55:31 -0700 (PDT)
Message-ID: <5d83b303.1c69fb81.4f527.92a3@mx.google.com>
Date:   Thu, 19 Sep 2019 09:55:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.145
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 129 boots: 0 failed,
 114 passed with 15 offline (v4.14.145)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 129 boots: 0 failed, 114 passed with 15 offlin=
e (v4.14.145)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.145/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.145/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.145
Git Commit: b10ab5e2c476b69689bc0c46d309471b597c880c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 23 SoC families, 13 builds out of 201

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
