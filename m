Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FADBF8603
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 02:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfKLBYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 20:24:39 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56184 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbfKLBYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 20:24:39 -0500
Received: by mail-wm1-f67.google.com with SMTP id b11so1273651wmb.5
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 17:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HYxWEJ2jB9Avv7QCrzEt4pAf/E9P6F8o8yvkfyktLnM=;
        b=wA5x6ThAXpIYVnly3X/u0Oo4ZRNM1VxJeLM4RN7VurT7I51xilMogkoKLeDQ9ks1bW
         Wb+8IEU8V+pMy43MMm3nauy86JDO/MapeamvlXFX4TQ+p/GEkh6aLliZ3gR1Lc3YgDoW
         ExLW/RBZItkdaCK4NUj8S+7mtQVLrKVx+37TERQ1LGI2X9uAJYm2p/MiBx+kIoZbmzRg
         APQQqo5KF6UFeSdddvtIvpcJwT3QwSxIUVofMaAUh8+AmZ+Fez/0xsC53yHCHq+F3oiY
         h7sE2CJM8GkqVYFcSghgNitk6C6Mum1FSg2Qaj+vYIxQuGPW4bEnC35HjoZAusv+Cye7
         3ONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HYxWEJ2jB9Avv7QCrzEt4pAf/E9P6F8o8yvkfyktLnM=;
        b=h4UKU1SJXEjRejONSFWMqmFroQY3k6KFmj8SEslFk8II9ED6KTAFBMp7duMBns8oWO
         b8bPAbtKZSQ02qeRZnw4goedC0EGYRhAIqsBnkxCvyf/v8XafjTUWJYR0MLiyWQmZfOe
         86IdH0CebBKlRmJe4dQQ3oXGOmQc8GG1ygqR8LoStn72TpRIYBQ9xCiySjjdebM8NYIW
         /UmEl1mWA0goTPO3cP2SOqk5p/TtppNZll00S9mYjDc0T4Gao8GSlxpJYeQkrgVZj09I
         /8HLsPby0IljfMYqdQXjVopw7oofVm9dNHBIZT0P31CHQAfX0IwtXxj/mDHoEavpbvxg
         lPrQ==
X-Gm-Message-State: APjAAAUBPvrmGLSLh0bweCjHEXRjxBvG8jBaTthtSbRhk75RFyyr9eFU
        SQ5LbgravKj2rH2V+bmJbbMJlh8D9ro4Zw==
X-Google-Smtp-Source: APXvYqwJkp9Tl57kpxGLbAYv39SxdbiPTEzHDz5WYpi5GNRQ0khtdnmdsrPncZXuZ231ON6lYnl5Tw==
X-Received: by 2002:a1c:9c54:: with SMTP id f81mr1527744wme.89.1573521876935;
        Mon, 11 Nov 2019 17:24:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v19sm1187384wmh.16.2019.11.11.17.24.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 17:24:36 -0800 (PST)
Message-ID: <5dca09d4.1c69fb81.5373.56a9@mx.google.com>
Date:   Mon, 11 Nov 2019 17:24:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.200-44-g92b9901ba23d
Subject: stable-rc/linux-4.4.y boot: 42 boots: 8 failed,
 33 passed with 1 conflict (v4.4.200-44-g92b9901ba23d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 42 boots: 8 failed, 33 passed with 1 conflict (=
v4.4.200-44-g92b9901ba23d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.200-44-g92b9901ba23d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.200-44-g92b9901ba23d/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.200-44-g92b9901ba23d
Git Commit: 92b9901ba23dbd26e916a393e557a5ffec117124
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 20 unique boards, 9 SoC families, 8 builds out of 190

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs
            exynos5800-peach-pi: 1 failed lab
            rk3288-rock2-square: 1 failed lab
            rk3288-veyron-jaq: 1 failed lab
            tegra124-jetson-tk1: 1 failed lab
            tegra124-nyan-big: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
