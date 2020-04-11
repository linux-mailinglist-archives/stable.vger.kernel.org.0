Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B991A53A8
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 22:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgDKUdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 16:33:06 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39388 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgDKUdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Apr 2020 16:33:06 -0400
Received: by mail-pf1-f196.google.com with SMTP id k15so2653586pfh.6
        for <stable@vger.kernel.org>; Sat, 11 Apr 2020 13:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0zCu0Bi/YAiuOZbXCgP2Rfauol9vn7HeEAbx7ZKz/do=;
        b=Ou+rEHIl0LipqQhf7UBkHvrY4A3maGnGNQ9xhqXsH0ze4sT/ePxd9sx14V1xqC1suW
         +RaSFSy0p8Ks1db6v870Am/ADNKN5qU6/fP5XsQYkzxtEy2yKONio35oHyqfyU+J4aft
         O9/qTCLuYMpEBOi6cdjKVZeauZNndv0bfxZQo7JOcoTs6jPzj/HgGE0JXzdiQpUmvPKz
         itAJrwuYv8xqug4rGXgQxCIjlkIyVc/9dvAbBJjv15TIreYvX5NUOE11Y/jMHAm3+jsl
         YeUssike3TgcfJuy7+DK8KeoDyfA+/MStS6lLq5DT/zALchTLkvIEoJrxe7h3SZywVRZ
         XYzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0zCu0Bi/YAiuOZbXCgP2Rfauol9vn7HeEAbx7ZKz/do=;
        b=FbeAwwmrCtnj92rvri93g5zS96OPURngvJs9t1G8zVDpnnMrod4yYslUZea/JJA4bJ
         X/ihEpQg6bKZnqOn/YMh03baJIzrkeG9icFg3+D1McxKhHlLOt15bfUxT+g0VUgVuSYM
         C9rNsKJqy3gUy6l4mjbnshvIRNut5/qAaTcAKNc/HWZgMnqrZhiBGp87kY3CnuDeRxlH
         xouo4/W2Wyqs22WBXqRLElcMCdXWozRdCVM2OH5b/32fiPZ3g17aDNQugIZSAxa+iqqo
         6H/WwqgLW53UHK0Lk3NOvmsOJH9qg7VaL3uCNmhhK4Y7plFpGHLVRjdcYHMlPKMMKOnz
         nclw==
X-Gm-Message-State: AGi0PuYh77FO2Yi6ZhiqEw7/pwqMdcyLiIEqy/2DU+TsMSVHQp3EuKmb
        g8RrgclOLxNJaMMpmAXLWPeQvQvK2Uk=
X-Google-Smtp-Source: APiQypJhmRuTaMSWsb0iR6DvBy7N9tGshSf1+yNpYtuwK7Jmu9nJBcCjHuzwhQoyJXAEXbKkrAWe2Q==
X-Received: by 2002:aa7:9af8:: with SMTP id y24mr11532268pfp.91.1586637183535;
        Sat, 11 Apr 2020 13:33:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b11sm4901133pfr.155.2020.04.11.13.33.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2020 13:33:02 -0700 (PDT)
Message-ID: <5e92297e.1c69fb81.e8e89.ff9b@mx.google.com>
Date:   Sat, 11 Apr 2020 13:33:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.175-39-g42fb2965c7ca
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 127 boots: 3 failed,
 117 passed with 2 offline, 5 untried/unknown (v4.14.175-39-g42fb2965c7ca)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 127 boots: 3 failed, 117 passed with 2 offline=
, 5 untried/unknown (v4.14.175-39-g42fb2965c7ca)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.175-39-g42fb2965c7ca/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.175-39-g42fb2965c7ca/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.175-39-g42fb2965c7ca
Git Commit: 42fb2965c7ca26057bc47af5ef45f170bbf2cade
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 20 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 63 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 51 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.175-21-g4ff8bc99=
64b1)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
