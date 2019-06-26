Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6FA56AFA
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 15:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfFZNn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 09:43:58 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36584 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfFZNn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 09:43:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so2828361wrs.3
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 06:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Dxad/ytFGbL9ezHM/aPHjnIHOs47a2rrMiae8+lP2qs=;
        b=ceh4v+2RaM17YAOudYS71egQ4s8PR1eLTsPWUpMZjzfG4TgcNc/D/82k7lMGJpS95S
         1VGZgSbYIcSItkj4j3tJBcIL8R4ziHCKNuTCV/MJhNqNo/op2GQdcbPisVUTmpkLUOld
         dj2mPj663kByqWO0cetGo8TOYi6Zkgm+8vCVg+UqP39bvouyAa7ANeSeNfd5taeFdi1f
         83a261RABDrIM7ncPMzrUPLnMNz23IJ1iwbbJ5oBi/Uoet6wMDNT0JsYV8ERRLnjIh6r
         XQ+GQrKfARVSo/k22Glzq8ilowbdHMuB/i/O9dAREoBCW4Wfc/80ZMrHT0P6bVRopYLY
         ZIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Dxad/ytFGbL9ezHM/aPHjnIHOs47a2rrMiae8+lP2qs=;
        b=ZznKqYoqKtQT/++660EXo0x/8c+78F6Mh/m23Yt4nSqO2nG2xZGjqSycQ79g6ZZ1FK
         OGVUFEKa0ATqeR+wtPrNd6IDj/TVML2d7LdAjvptOzsE3xCJr/pVpa/fLaVnbihXVxw/
         sw2umLKL9xhM0o3ur05Ng8iu7Bz/4kn7D7e71AOMDuNLW7N+H791YqRzhdU9KETlAvm2
         DJeA8zSZA20YdbnjbcykFOSuqgPi0I8fDokVhAZGAN2qWimPbR3uXLIGNIe5jU9TUcmZ
         kxUTsubZ1Nxb6LVaejtDlo4u6vRY1q++NjARDYQDx2KF4X6LlNHiutPmYhtAA8KZ+Xhc
         e/LA==
X-Gm-Message-State: APjAAAWx5QSeGs4d7qLPZpV+BRqMg2RmHA8gZ4sChoAZjSb6XCojQ4oa
        HBJf5CUQx+vSoY+wGmqtBt+FgMFxeoRFYQ==
X-Google-Smtp-Source: APXvYqxblsubpNZQDq7IHFOjLV5PwJL5gEsBpbLiCnI6NG04Bt4sgWlcIc9mX6vQ+wltNDLJ0d7qjw==
X-Received: by 2002:a5d:67cd:: with SMTP id n13mr2501514wrw.138.1561556636687;
        Wed, 26 Jun 2019 06:43:56 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f197sm3192142wme.39.2019.06.26.06.43.55
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 06:43:56 -0700 (PDT)
Message-ID: <5d13769c.1c69fb81.41c09.0947@mx.google.com>
Date:   Wed, 26 Jun 2019 06:43:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.56-7-gba8d1b75298c
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 136 boots: 2 failed,
 134 passed (v4.19.56-7-gba8d1b75298c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 136 boots: 2 failed, 134 passed (v4.19.56-7-gb=
a8d1b75298c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.56-7-gba8d1b75298c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.56-7-gba8d1b75298c/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.56-7-gba8d1b75298c
Git Commit: ba8d1b75298c25449b5958a0b763d9b88fe1981e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 25 SoC families, 16 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.5=
5-92-gd8e5ade617e9 - first fail: v4.19.56)

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.5=
5-92-gd8e5ade617e9 - first fail: v4.19.56)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
