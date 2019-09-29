Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DECFC190B
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 21:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbfI2TAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 15:00:34 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53917 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729109AbfI2TAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Sep 2019 15:00:33 -0400
Received: by mail-wm1-f65.google.com with SMTP id i16so10897008wmd.3
        for <stable@vger.kernel.org>; Sun, 29 Sep 2019 12:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=dq1noghuki3s05Ms2hjQ2tq/heCYmToBu8e3a/R//7k=;
        b=Z5LKGHGid/K7epxcforaYglsNnSUaV8lnCarCN9CdgBD4Qatjnn9cnsZytP9ky59ba
         qB9zPJu0h2qcPHVPL/J+51KdrPOytzAmwLR1/kHWJoyMCVPB8zGLrGdrLha1im3vXMSg
         bz56XJ9ykAdYr6o6krDqocZlt6CEkWarxKRKRuII1wjLcsvSHgzpq/DNx7NukuC9vPB/
         dv1II0TaVlwLAYf8Tw/YP0Tp8ELv6SYSj12mFGgXU0mFgLiMgzMTqQHzlzxPunwLBWiY
         NH3/sEHN0XioDah1YTnGvYnNKb+j73/N9L1sP5/Xjuoa2FyGy2aPWuRGUKIDs6fpHKwn
         sHuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=dq1noghuki3s05Ms2hjQ2tq/heCYmToBu8e3a/R//7k=;
        b=c246BFoCkpPGvUPRsN/dNuZfuD15m5AIOcq8lO7zNWGrK1cwcHXH6sFcrwz32pQwn2
         PtKv8m1gr3FmYNzISKe9lJkSAMq5xJNJ1sIwVmaZymvTY6q9kqzpc9AGxI4r+iAaCF7I
         C/nsOUUU1dYUlQgl1GK3R5+6igvuvX3r/toI93zsrFgZWfA6AiBhwdxpRg8LjTWMI0GE
         7GfLTs0j01bIlotkmLVNfIRkaS9FcNlXkFf825bb6uTFjyAVybTPr4RVbAtmVio7qVFX
         qzuFMQGAJfpZBG16wVmWSoXntRgTuLzLfIz5DGQMznRkEY/Ar5BW+n4aUHdyKSTZuLgW
         2yWg==
X-Gm-Message-State: APjAAAWrdkbHIWxTYsLNjwdxM3XAn7xBofadq7trhJvZxDmwiftug4U5
        7weQ6XM8/EVOcdOFE958t+WtqA==
X-Google-Smtp-Source: APXvYqyFtlLEZu69YPYh3aY2ZYV4LXZ+eLcytsMIjpAYY/55CwRALUe4eIvg9U+aZQRlgfBnYgDa2g==
X-Received: by 2002:a05:600c:d4:: with SMTP id u20mr15397343wmm.66.1569783631912;
        Sun, 29 Sep 2019 12:00:31 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o9sm26711912wrh.46.2019.09.29.12.00.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 12:00:31 -0700 (PDT)
Message-ID: <5d90ff4f.1c69fb81.12517.7d4b@mx.google.com>
Date:   Sun, 29 Sep 2019 12:00:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.75-64-gb52c75f7b978
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/63] 4.19.76-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 80 boots: 1 failed, 78 passed with 1 conflict =
(v4.19.75-64-gb52c75f7b978)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.75-64-gb52c75f7b978/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.75-64-gb52c75f7b978/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.75-64-gb52c75f7b978
Git Commit: b52c75f7b9785d0d0e6bf145787ed2fc99f5483c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 15 SoC families, 13 builds out of 206

Boot Regressions Detected:

arm:

    tegra_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v4.19.75-33-gdab8e08e7=
087)

Boot Failure Detected:

arm:
    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    exynos_defconfig:
        exynos5422-odroidxu3:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
