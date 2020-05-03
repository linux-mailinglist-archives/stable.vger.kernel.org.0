Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE45C1C2A10
	for <lists+stable@lfdr.de>; Sun,  3 May 2020 07:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgECFKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 May 2020 01:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgECFKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 May 2020 01:10:54 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0AEC061A0C
        for <stable@vger.kernel.org>; Sat,  2 May 2020 22:10:54 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a31so2170022pje.1
        for <stable@vger.kernel.org>; Sat, 02 May 2020 22:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iJKAE6VKIjJq0Gumc0PQHhfIq14SP3fFa9UvEC9//bM=;
        b=k7zReUBi+jHRsQnHFfZwzqOVdJGuRGAKSPWrTus8eUrne8CJ4/WwOfx63peypVM8CZ
         I9Dj7IWF3AwI9D2zJ4SSaPZHVlidIf5jcD8nDMd5h2bqohBlHMkOfcQRQHwEVn1+H8jh
         92JrFaMybLXOtCYh/IN7jczeXAbObYdOybbtgZHAnHFx2Wyju1tndXv2eAHOiF6NhYh1
         yOawA3ZE2WIXglUm+YVzvn6J7+xciO2H+v4eImyQJ7ZBzXwtlQGfZN6v8weEIKOlgTdv
         +WrVh2lWJuDp5sc+bYIScKdpHKEjEWSy7y8RTlmT+QMXs2vA/Zs0Hnof8jZLYKlBWXdx
         YTqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iJKAE6VKIjJq0Gumc0PQHhfIq14SP3fFa9UvEC9//bM=;
        b=UY/p0fzUn393MVfMFJ3NvRbyzsMGW4XDPyNajNNAHBccaHD3/mLBq8RBu+gwKR9JuA
         iz2W4KgJyJZvfELsKPpG5scDAS3JQuM300MJscL5+BGf8EbnOv/CYwZeOUhJC3y7afhW
         N8ZjBrFdjUtrvA4Q8OyopnBF6gbEnm7lAZEA1FkzNrcRZDT6glm6FEaa2Dk8IpdzUAL9
         rS+ZDg1EUsIcb2/CiqKT4Bv4LhJMLolxkx5zhTrF28cP0Jy9lA8wHpFPfV2Z5GSIp5lO
         aP9cz9U6ji6g5ie8qFgh6Xyp+DmI2H2YUkOljkZEF1mldlMkL1jAbFv32bXJBQeGwguQ
         5Wcg==
X-Gm-Message-State: AGi0PubdOEUe5AQ/OiTiJjOsdbNh0lPTGo0r4dIvjHV9defMB/2sS0rn
        Routewq2jV4yod3upGFdnGldm2EZ3Hg=
X-Google-Smtp-Source: APiQypKbh+D+a7nZSW/IHePGbWwh8RfbbSYFkgOxMrA+eHNeAr0HApti0VJg2P6OU1C+BlPkH4SFWQ==
X-Received: by 2002:a17:902:8ec1:: with SMTP id x1mr12242655plo.180.1588482653246;
        Sat, 02 May 2020 22:10:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y24sm5676366pfn.211.2020.05.02.22.10.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 22:10:52 -0700 (PDT)
Message-ID: <5eae525c.1c69fb81.bc0f8.925f@mx.google.com>
Date:   Sat, 02 May 2020 22:10:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.178
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 123 boots: 3 failed,
 110 passed with 5 offline, 5 untried/unknown (v4.14.178)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 123 boots: 3 failed, 110 passed with 5 offline=
, 5 untried/unknown (v4.14.178)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.178/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.178/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.178
Git Commit: 773e2b1cd56a17bab4cdd4fe7db12f2140951668
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 84 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 72 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.177-118-g9a493f6=
18fcf)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
