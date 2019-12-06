Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68DC3114B07
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 03:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfLFCqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 21:46:05 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:42704 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbfLFCqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 21:46:05 -0500
Received: by mail-wr1-f41.google.com with SMTP id a15so6080938wrf.9
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 18:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Lj5fiSJIl4ThGa6tzZ/4cogHJhHBZYzbiVoW9WHjdi0=;
        b=0FA6EeALOg+0ZbShTYDQkBl6NvtACggMuzP5bmh9+ZRGJ53yXyfe0oA8FoVNrYHOdZ
         Dt147/bAGOZZec3itz+07VqWdc2RrlCbSrtOUK6TmKMHsyNedy1NbQ0DhAXl/q/UNg+/
         18qyf7KJNT2CgOPld4FDzOrS1ECWXFo4m+8HE3sN5R2Fwm7vtbtK5ffeaVe76dIcR5Qa
         THH2F5fQbwZei4XJFUGQo/rEiLdTHcV/Cei9O5V0TiyGuIGaB9SODjlh0vILM2ESbWaB
         j/MN/gnbZZ6+nEeWLEOJQ+NehC7zvDxcXM9IjdDtLEcBe1XQxS31RCFjUjwIfHB8i4yp
         0qzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Lj5fiSJIl4ThGa6tzZ/4cogHJhHBZYzbiVoW9WHjdi0=;
        b=AHgFpLT3Rfqp1oc+XY2EcgU7c7k+hgtg9WkMsdn2YeGMFr0dbiC/ceZSn0LmzNMGLL
         FMEDMhapsl5NLX1CpGpFBMblNYEp41poAY2wwPfjz0xoCtqr4EXdK52g56rC06VXK26i
         0YMkoM1Ul0r3jHlnV/PqNPHTAj1MbCUFFbhyl8y+nqWN1ECMgJ8ET5l5pbYYinYecz7g
         WSJkaD+mJ2B6UJiJ56E8DmnympIxRuueGuoCc1CRyBncFXh1IIVGxXhtTUNdJmC05Rav
         UDtQ+A9ghb/yiqD2qfz5MTam5OFX5Cm28tH9IYR+OQi/p/RgTAVyq1wl6vkMRpvUVKvU
         PXcA==
X-Gm-Message-State: APjAAAUkx/x6NsIkA+fVMT9Zbwlm8GmtOiaq2VSagD5maT94vUwIJiuJ
        telTz28PIdtBA9S97qJJTJ1tAmcX7fcDEQ==
X-Google-Smtp-Source: APXvYqyNON74CVBVEcFepmGhqZ4k4RLGFNT2duvaWVDfRw+2Xl9oO1PdC0ANQX9qiPDANMtWJDHNiQ==
X-Received: by 2002:adf:e812:: with SMTP id o18mr12593063wrm.127.1575600363002;
        Thu, 05 Dec 2019 18:46:03 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h2sm14735867wrv.66.2019.12.05.18.46.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 18:46:02 -0800 (PST)
Message-ID: <5de9c0ea.1c69fb81.1ec5a.d34e@mx.google.com>
Date:   Thu, 05 Dec 2019 18:46:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.158
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 127 boots: 0 failed,
 119 passed with 6 offline, 2 untried/unknown (v4.14.158)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 127 boots: 0 failed, 119 passed with 6 offline=
, 2 untried/unknown (v4.14.158)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.158/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.158/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.158
Git Commit: a844dc4c544291470aa69edbe2434b040794e269
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 21 SoC families, 15 builds out of 201

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
