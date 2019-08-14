Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074498E0E2
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 00:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbfHNWhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 18:37:36 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:33407 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfHNWhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 18:37:36 -0400
Received: by mail-wr1-f44.google.com with SMTP id u16so607816wrr.0
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 15:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oj0hiMpymPXol1ueA+RVPbGRQRBHE7nRWC8Jc3SIHJQ=;
        b=toxvYY3nkGilhyMWFgIO1Zm48dJint/eiry5GmInwyHQ/xyx1JyXhiJ8MFoc60RIho
         O4egkANzbq+wbEr1vRV2FP97s3LE+amW7BZ724a2oWGHqHs1i10KfkMnuthh3iKhh6cF
         d4VAoTB2L0Hg7PlxKvcdzXamBkOybhDbNVcCOtfE2lp6mI+nwzn4Ucm8Q5V7llXE7Jb7
         Y+unbYAy2pxdvo9S4T6BZyEpzKZQ43JSPGFlYABJSJAdq1N+Dx/fWE11udom5U5Tq7EX
         2fL4XZfHeuCvSMkXAD9EMaBV6TjCox/IOHdWv7S5CP1w/gN6JuZazMwKMpDI8ywoYebM
         WZig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oj0hiMpymPXol1ueA+RVPbGRQRBHE7nRWC8Jc3SIHJQ=;
        b=iCX9erdMLqyN8TtngXP+yMHulNISOTrmL80yfABo+3L9wyb6nKVHJ4ezrS5iI+zAhP
         eLFn593tu6B4Tby0uxt0ELha4wxva2CjIDHp7M1UIVdTiOxJ2YblnzxgclEaGCBsR/JK
         u4k21qyBErfgiq7CCnbRINl7Ahb4Jtw3La/IYubdUc8n8nFi7mY7tgXxWUBlu/8ZZpXw
         zl35t1gJvdIquELHvgGFEc4cPtn4Y0piy4qQNYLneoO3faiLVVQa+LqkRYu8c2JNlN8v
         15sd54w0uhEat3HWfEF0zaRFnfPnpdlCDpOW4DiySdG0ppRHIARRRN41MUgtfJ3xWJ2S
         bNlg==
X-Gm-Message-State: APjAAAUKoMPib8FRltsw7gkOqxWA3yvEOEw/68BSz5WSDLUoE7RanOZ1
        BIuoZVC8Zuj3WmNZ7f+HqewXmZsyJoBAEA==
X-Google-Smtp-Source: APXvYqy8bOf1FpSBnHwFlNPwyZfZbRIWnDC1mqmhg2GbzrTwnukfVE3/37uk8rxbVQuDNqlihWUlsQ==
X-Received: by 2002:a5d:698f:: with SMTP id g15mr1936968wru.310.1565822253792;
        Wed, 14 Aug 2019 15:37:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j16sm948471wrp.62.2019.08.14.15.37.33
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 15:37:33 -0700 (PDT)
Message-ID: <5d548d2d.1c69fb81.4676c.4fa7@mx.google.com>
Date:   Wed, 14 Aug 2019 15:37:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.138-70-g736c2f07319a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 132 boots: 2 failed,
 117 passed with 12 offline, 1 untried/unknown (v4.14.138-70-g736c2f07319a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 132 boots: 2 failed, 117 passed with 12 offlin=
e, 1 untried/unknown (v4.14.138-70-g736c2f07319a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.138-70-g736c2f07319a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.138-70-g736c2f07319a/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.138-70-g736c2f07319a
Git Commit: 736c2f07319a323c55007bcf8fca70481e9c7175
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 25 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.14.138)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: new failure (last pass: v4.14.138)

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab

---
For more info write to <info@kernelci.org>
