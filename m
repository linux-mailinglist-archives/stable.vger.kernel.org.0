Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72A691E541
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 00:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfENWlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 18:41:49 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:52234 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfENWls (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 18:41:48 -0400
Received: by mail-wm1-f45.google.com with SMTP id y3so650013wmm.2
        for <stable@vger.kernel.org>; Tue, 14 May 2019 15:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7nEilbM0DckSPwWnJlbi9Ou8y05n8Msd31QdQz/aK68=;
        b=oX72fA3V5pXfO3dxQ1i9gTJZCDp+R0e+BTg2ZxEsWslsQapFNWOc83dBo5kcyQhl2H
         tS0PUmGWcg0uz26fyHvX03CJt+wQsVcskQBnIIe4tOTr/xTtE/YrV7s3zfJHFSn6rSc8
         yEser4CMrxyjIjlv86JtvkEnMXTCJYy+qsDYaA1cNmo8TFGLLwfwO/F9jlMaFVsbNlRW
         S8kltiZ12X71DcbFzFKPdPkm7KlQ1c9qgQLQCA5X87QedjXQgtI9830QmzRs94pA2Yod
         kyRIZtcYZPCLIXos1vk6TI/rC2Kc4BC/mls0TkKQ+MZvbHdThbJgyvE0lE1mtnwRsfxM
         ESVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7nEilbM0DckSPwWnJlbi9Ou8y05n8Msd31QdQz/aK68=;
        b=hbhl2ZLIhzPE1VfXrRnsnXDnivJeBdT2AYrSCT9/CHWY0Tplz6t4I7NlA6Ei76+N+y
         48T7OpV0E2/d205+HZQ3PInRNqq7Qip0ZZiuzLZFGBv98NKNd2m76s9aB0gGYCRyfEzg
         9ba6w1HKPy+ZR0JqNez1Rp5MJOTxLf8VJQDymhv78FsT0mIVS8A9KkpqcjjAd/8pvk9q
         DIZXsOh0Kh5q/I2jqOt+CnbDRrj5sMKw0Og4bP2FfYqSKivk8tc7KP3XGF1bFLZXzZlT
         eya+iVoNKlhUmktObaaNLQYGldOE+vMnqCRub7bTLOwYiilnY8V6LmxKgbBhUKrXfL9h
         aiZA==
X-Gm-Message-State: APjAAAVEvvYX/2cjTVDJ1iJfVUPSD6QFyqWBqf6CA4wBiXZQncrUtK/b
        LRBfIU7Pxvn/Ba60huvGqU6jA4oRD32CaQ==
X-Google-Smtp-Source: APXvYqzLGVQlrZhmKVna6f8pLuP82kHla4ChUL5foBmbuzsIHEzTUg7bg8XCWfp9r4PP9xOqTuKVRQ==
X-Received: by 2002:a1c:4087:: with SMTP id n129mr20622495wma.14.1557873706222;
        Tue, 14 May 2019 15:41:46 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r14sm196393wrm.21.2019.05.14.15.41.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 15:41:45 -0700 (PDT)
Message-ID: <5cdb4429.1c69fb81.b271a.12a6@mx.google.com>
Date:   Tue, 14 May 2019 15:41:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.43
Subject: stable-rc/linux-4.19.y boot: 131 boots: 0 failed,
 127 passed with 2 offline, 1 untried/unknown, 1 conflict (v4.19.43)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 131 boots: 0 failed, 127 passed with 2 offline=
, 1 untried/unknown, 1 conflict (v4.19.43)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.43/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.43/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.43
Git Commit: 3351e9d39947881910230a73be77e6f29ab8b72e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.19.42-86-gc8e3be30c4=
b6)

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
