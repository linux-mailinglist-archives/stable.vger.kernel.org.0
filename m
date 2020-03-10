Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21BEF17F0C2
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 07:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgCJGta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 02:49:30 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40334 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgCJGta (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 02:49:30 -0400
Received: by mail-pg1-f196.google.com with SMTP id t24so5882641pgj.7
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 23:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jbH6xRdOX8dHubxzlGA2hLGPEMz1wek009x1ElXWMXU=;
        b=IGG2ferCueV9nt0bOHPi5XTe4zpeDSBlKmUtb95/2YoRVc7cIowfFcSolklZnji/Yb
         gDl5FhvxP0/SctSnShN5WHBsNLmyVSKOT8BJFd12rLEGYp+phe9R7m/amnZWhrCuV6Sw
         HiJ9d9+R5blRq/8H6X5NnQYUbPpvj7EFLc7i4eWQ7u3e74Te/N3iG4YY/B6J/vAPf+uc
         2QKYVmDu6UdJeIzaWB/JgRlINrt2pySWkK65km4g8ZKg3wdc9o+D7s42Li++zl+RwfKQ
         41L3P8JdSTWU920BRCkTgk2MZwKuwmQc2UZv583gsABME5JzIzChknxHNC/TVO1Q3/9H
         xorA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jbH6xRdOX8dHubxzlGA2hLGPEMz1wek009x1ElXWMXU=;
        b=gFfMKmKg3tX59sAsGlk62XYJiK9Sz0MauACAjJ3iEhEnIU/vG6GTxw4LL80gSUCJQD
         CRV80U5Nyl9r2OGoIqI6tMNIFIzC8xy588/uXu3APWwiEhUZeaAWye+Aqajc1tWlpkjl
         HgFFCqm90ErUNHdo4LtsEhiQUj2zZUHcz1tQoT9PSRiyd5wOrsslHY4503qmiVeaKldi
         TNPDP+sMGiTHCfWj5FJR8mImedF+SpN0J852ddi/Hv6lGNCJRAf8C8SBoF0QZh6sS3GQ
         k4GcRnU2npwokRw//eeghPSTA+Ue2COYrL7f9gbcK7cRC4T2hj/rajT27itcaEziqS5m
         446A==
X-Gm-Message-State: ANhLgQ0mtKix5KOzdTtKgH/EvOkEQk/EpZp8Jb5qlczrQsqNj3RaSdfJ
        0PMrAm8FG8PVYm1v+AtuBzKFC/TBYwY=
X-Google-Smtp-Source: ADFU+vtz8sBWK3DQLdm1P9DQknMWMrV8z9SfTl2Enfk4RKjVg+plvjbSPPC/7z8DzkmI+kaJ5xKuww==
X-Received: by 2002:a63:fc1c:: with SMTP id j28mr19954740pgi.289.1583822967530;
        Mon, 09 Mar 2020 23:49:27 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b21sm48706618pfp.0.2020.03.09.23.49.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 23:49:26 -0700 (PDT)
Message-ID: <5e673876.1c69fb81.45a63.56bf@mx.google.com>
Date:   Mon, 09 Mar 2020 23:49:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.24-123-g6201d69ba49e
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 122 boots: 1 failed,
 117 passed with 3 offline, 1 untried/unknown (v5.4.24-123-g6201d69ba49e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 122 boots: 1 failed, 117 passed with 3 offline,=
 1 untried/unknown (v5.4.24-123-g6201d69ba49e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.24-123-g6201d69ba49e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.24-123-g6201d69ba49e/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.24-123-g6201d69ba49e
Git Commit: 6201d69ba49e810a10a557a4f41fd95c55a61983
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 90 unique boards, 23 SoC families, 18 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 30 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.24)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.24)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
