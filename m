Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 362CF4F886
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 00:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfFVWUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 18:20:08 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:54610 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfFVWUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 18:20:08 -0400
Received: by mail-wm1-f53.google.com with SMTP id g135so9323811wme.4
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 15:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7DJ+0+S8bf+KOsC8VZdYXS7dpqmy3S1AI+GTeLXZqgs=;
        b=YkYzNo2wE7UiQsRr47NADrriTTNaROf340prQLBwIYhQXOY3+lVS3Td8eq5pFD9cVT
         2V76e2k/9WVsqvlKu/Ow7eybJArSj52p8rape5urB/6mm6JDU5IvhQBPORbyux1tuF5/
         yPHd7owTXgYpk3fkUBf5dfrf5kjNk7Ckg3GbVt/B29mD2WuJH2qjSsflbmVew1XoJM8t
         +igP41Lqfx/1tre+9b9U0QflYGzLBFUU7Ph8ASUdd8SpHnVIRmtr2XvGQEKnKlUX/Kxq
         xZTHp/zs8rp2+vUsspr/R7IWHpCbAiWDVozX/WO3e/VWKCZ1+D2PiPDdXLXu74UPF3y/
         JDAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7DJ+0+S8bf+KOsC8VZdYXS7dpqmy3S1AI+GTeLXZqgs=;
        b=pxl6OUuS5a/3knKB9Lcui21zwNJMELX9M6cM4e1JvodJEXjfFxGKJ1ZittSaJgVxpY
         U8UqDJlapmtNX3jBYRVEBpThO8mNmHm0+I4+K3fa44Z14sj+2q1CvAaEKX6E+L95DILX
         5i47J8+ZRUpzwf4eFgUt5Jw21pjD9XUByiFmhHw37UfDafwRkoVfp5pninn9fdliTbD6
         uGfYZvS1OqKLyghGRgULiLoHGQqysXoN4+UENhivOq8tqiGZc0KQbMHOzch+mdmp7IGA
         c45EbKI4CHBqq9RsduyDThFO7k+HBsjbXK2v37WcjqURORpAVA/fMvqUbu7Im9HOzEk1
         F6Fw==
X-Gm-Message-State: APjAAAWhCpYDK+nDyMHfvacQ3vzbC9onIidP74DHim2tXn5km4Mwm7Kj
        XFKRqx25yAguzbFSg8TIPrNm5EMF698=
X-Google-Smtp-Source: APXvYqxChMaVzJSQbxHVISDyQeZ1+4HKcOCZP3ym5SGS5YEsuC869v3o+vmZDYAk3lWdr7aPeg28Pg==
X-Received: by 2002:a1c:9e4d:: with SMTP id h74mr9550631wme.9.1561242006151;
        Sat, 22 Jun 2019 15:20:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s8sm8399162wra.55.2019.06.22.15.20.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 15:20:05 -0700 (PDT)
Message-ID: <5d0ea995.1c69fb81.2d208.ef43@mx.google.com>
Date:   Sat, 22 Jun 2019 15:20:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.183-3-g5e8cf492a4b1
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 93 boots: 2 failed,
 83 passed with 7 offline, 1 conflict (v4.4.183-3-g5e8cf492a4b1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 93 boots: 2 failed, 83 passed with 7 offline, 1=
 conflict (v4.4.183-3-g5e8cf492a4b1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.183-3-g5e8cf492a4b1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.183-3-g5e8cf492a4b1/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.183-3-g5e8cf492a4b1
Git Commit: 5e8cf492a4b12d9762b4ffdb38a587a8a47a3cdc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 19 SoC families, 13 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.183)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: failing since 2 days (last pass: v4.4.182 - fir=
st fail: v4.4.182-85-g847c345985fd)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
