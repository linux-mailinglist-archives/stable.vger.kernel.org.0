Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C32894F780
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 19:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfFVRpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 13:45:31 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:53265 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFVRpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 13:45:31 -0400
Received: by mail-wm1-f52.google.com with SMTP id x15so9015444wmj.3
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 10:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rBsVPinUnFPTRWZXvqoRnmFKEMNQB/lqfp05lGjVeYM=;
        b=1RqETHIlM6NvRPYTk0F8hqk2woksf1ifcCxQmKiw0ykvG/YyWrGFksiM6FsFyMFBo3
         3UTQtxU9uzSvoMHdhheUCwMntVgGL/NwRTFUPwOeD2vIN3a3NxeeE2JlmLgAyAFFdWB2
         jsBbM9AnpKjjf2//1G3BERk+qkFbIC5XOW/Ie9tZsqEh5MZW2Td2F47Pz/ejx3djn0cY
         0GJ6/sIPn0dgH74f8/dTHE5oTg7vFL1gD53Lz7IcJg+cP1kDBOwHLcB8a4HAiAr6uAyj
         jF4YHkmZZdyqJ4tsH909XdgV7+d4ezsNY4Vjpfug5u6lNCJha5A4IlTSCtEVbmDwiOwp
         TFLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rBsVPinUnFPTRWZXvqoRnmFKEMNQB/lqfp05lGjVeYM=;
        b=A2eYgzNVX3MxgB94jVTcM+gQTxtZUsauxFOCx5jQ86r786nCychZkgmELmgvsWkDob
         q1HYWbo9omW7S0ppqd8iYQyOb6w4A9fB8gQ931YEfJNmHqrbH2fwcTIBeNaHbtzJ375i
         xKRPhjSyx0WYlXTw/nOSqI9LhcxHMQUNDRAHCINUvttEFjgWyNfrcO9XP7V3BdhWHRiY
         vf/rd1MPa1uev+MqiGiK/GsSiawvv+w3+XOmxflIVugfduc3kHR4/GWA+hi3rrIHLFng
         v7Rn19Pezulvwrk0i9rHYoCPEvg+yTaEHIrqB4ebIdzKM6FdWjZ5tQ7/QHXwVyjM9+wY
         j4yA==
X-Gm-Message-State: APjAAAXic6LMTvqvfIZ/V2gHfeWX0FNYiaShR43u0FW1nEfGiePmL9Ve
        xc28+DubX8RErkeCOlBjVC7/3pNEpXg20A==
X-Google-Smtp-Source: APXvYqztXfhxyPN5dmPLrG5yF4XF+zwTmi44m2edVjhHWcPS3WdeyXhHk7yBNqwhQ9+Ry01fNJsc3A==
X-Received: by 2002:a1c:1a06:: with SMTP id a6mr8658916wma.128.1561225529529;
        Sat, 22 Jun 2019 10:45:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s3sm10364350wmh.27.2019.06.22.10.45.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 10:45:29 -0700 (PDT)
Message-ID: <5d0e6939.1c69fb81.2bf47.9fe4@mx.google.com>
Date:   Sat, 22 Jun 2019 10:45:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.183
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 102 boots: 1 failed,
 93 passed with 7 offline, 1 conflict (v4.4.183)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 102 boots: 1 failed, 93 passed with 7 offline, =
1 conflict (v4.4.183)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.183/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.183/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.183
Git Commit: 30874325504004c57f7b4f7163cead251a91662a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: failing since 1 day (last pass: v4.4.182 - firs=
t fail: v4.4.182-85-g847c345985fd)

Boot Failure Detected:

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
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
