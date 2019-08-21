Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5F0981CA
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 19:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbfHURxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 13:53:15 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55544 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbfHURxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 13:53:15 -0400
Received: by mail-wm1-f66.google.com with SMTP id f72so3000714wmf.5
        for <stable@vger.kernel.org>; Wed, 21 Aug 2019 10:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x5RFq/+6RqQIRyOLD3PAuSaDvrDltOGEdB6qWWdQ/9w=;
        b=UJ7vEXqUtHGEBMixBS/SDFYwPFi5WpOfaa2h3FOj6sr7+DFue7zppNL+93hdmuRivZ
         Tmb2fP7FXcojGeaw3IeP3M65FRypPu/zstUGl72SvHjuZsZZYex8JSQOk4EDdER6lN0j
         hxEh7toHokMFNKehRUSIYJ9L93ev1ETIyu026NhZ4bdNgdSWkV+goXavx8qAkHMjJ4Ou
         bo74i7NourgGwu1W4IBpYZsvcaCwv/O0OvDOslUltC26a0ki3JyDruGH3oYgThwFbwe3
         9JN88OGNm7mFBZEJ9hrWIF4HzV8DFwGrzpEDpkvDBzJR29ggwGxPSM6yHeCG3fkXk+pV
         7PKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x5RFq/+6RqQIRyOLD3PAuSaDvrDltOGEdB6qWWdQ/9w=;
        b=b7+1EiT+jUSVImmzkkkXiX61IE2Gsm+AATR2YyBCQniF3iOFgDNSJA4SZiXW04Kejo
         eqT9S4HxisGrV9nNmKLgM+6HbG8Unj1nh6xhvMGjJU/gJ5V8HllquAJCrqVoJ5HvtdpB
         ioEwtpdfQCR6omsnXEac1ncmVJE0O0OLDOZB55dRxuimTCqKx3yDiUUjPdjEE3mA0Wfj
         bzOpmFZMhHIiDp+U95wxLaxyqWGfPQ9ZLulcWVbI5RrpDuRMTmKKDAHO0DBGomKshRln
         Rrq9ld+YCXjx0MSJGAUipBAm14fgTTFm2Q4g9vsH0JHSHf+bgL07yCDyjgoQIldg7cE2
         sxDw==
X-Gm-Message-State: APjAAAWgdVsjq7DOhSy/k72Uvji2YcHm0FKUiDEpsKubuav/nY/WVlTR
        w7y6h2TxO7Ovqn6tDTJU5IHEJPINw9c4jg==
X-Google-Smtp-Source: APXvYqyn8WjI9SAYN3VcFq1WktDs00NRTREgHgEYMIZhirIPYSZUF3pDAE2yXg4HwLNat2l6zhXoPw==
X-Received: by 2002:a1c:cfc7:: with SMTP id f190mr1297033wmg.85.1566409992747;
        Wed, 21 Aug 2019 10:53:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i93sm30539539wri.57.2019.08.21.10.53.11
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 10:53:11 -0700 (PDT)
Message-ID: <5d5d8507.1c69fb81.d43b7.da31@mx.google.com>
Date:   Wed, 21 Aug 2019 10:53:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.67-87-gbfa969cef25a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 122 boots: 0 failed,
 106 passed with 16 offline (v4.19.67-87-gbfa969cef25a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 122 boots: 0 failed, 106 passed with 16 offlin=
e (v4.19.67-87-gbfa969cef25a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.67-87-gbfa969cef25a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.67-87-gbfa969cef25a/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.67-87-gbfa969cef25a
Git Commit: bfa969cef25aed1baa68fa3eeb12fe09af9b0159
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 26 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
