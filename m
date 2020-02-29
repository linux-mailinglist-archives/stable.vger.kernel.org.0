Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0735174890
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 19:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgB2SEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 13:04:25 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46164 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbgB2SEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 13:04:24 -0500
Received: by mail-pg1-f195.google.com with SMTP id y30so3209342pga.13
        for <stable@vger.kernel.org>; Sat, 29 Feb 2020 10:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XJcHi4+cbFnm7Q/sXGqWR8SsruF/fVrig59PKVsaND4=;
        b=OSlGfC2RDc+w3PWlHNvEv9mMWIIyLSbbfMud7aKlnzUVlhD0Tn83QFnFACKcJrKJ3v
         c26O0H9L3kGk5OiDIhfNq8+z3XOB3XaFhB0U0PotAqmyY8NxUaSEaaIwavOIpoHWpVed
         PGKoy57iiueHkq9FpQjcH5+fmOLoHDH6ZJn6uFG37ew2Qo6HMqYXj4AdQmwPpv+eS2Z1
         NBqpeArztLC3+6VT/Tv8pLKe2d63cOv7LsLqgm5swjqXYs9eXu7yQcsuHRtwn/N0IxCq
         z+p1/AZ7inecw43Lt8q8S6zfwFrzFsLRvO+IDc0o48CJVOhZGwej5E0GgsizJpqwHZsO
         vL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XJcHi4+cbFnm7Q/sXGqWR8SsruF/fVrig59PKVsaND4=;
        b=LaV4AnzOaTSKSw/tDyTKzwb9KG5bFti1TQ4zK897AVD1wYY6algD+bY12oFAJtjm6I
         LeFhEgahFWLewRKDmU145nGbs5Pfi7x5IEb+6Pd03qYWDHbXDWh3XpcEezOgWGN++L5C
         BdbQFNIzo8YlcZwrZwn7K1SfKIr44x8p3TB+jTXLk8+ulPRZK795HVTb3MMw/W1F6qJK
         QRbNMMSm02ebqevAiZZgD/Vn2ddSEKen1wX3MZNMSX7QZFjtpigUk6Vtii+hfNd8Qj6A
         ScCQLxAw8CMRX9MXUZwNqShBq+RtbQ6N1JLD24U0J3BB+n5IpIgOLyeMNrgprp3cGjDr
         BflQ==
X-Gm-Message-State: APjAAAVMFutNEN/RJ7G/+DjVLR79T0oiw6AWUvCSCXF7aMkgPIsTizbP
        QYMmXqQCEaK2PicPCno7iy5aLx/zdlw=
X-Google-Smtp-Source: APXvYqxu2jsHATHnGd0i2jJTflejR9p/ThiKK1LsFQJWjf1GqD2RF1cuKQIX2FvNq3akvoYXqrpX3Q==
X-Received: by 2002:a63:4c0b:: with SMTP id z11mr10867570pga.385.1582999463502;
        Sat, 29 Feb 2020 10:04:23 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k3sm14859610pgh.34.2020.02.29.10.04.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 10:04:22 -0800 (PST)
Message-ID: <5e5aa7a6.1c69fb81.25271.56b8@mx.google.com>
Date:   Sat, 29 Feb 2020 10:04:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.172
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 32 boots: 2 failed,
 28 passed with 2 untried/unknown (v4.14.172)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 32 boots: 2 failed, 28 passed with 2 untried/u=
nknown (v4.14.172)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.172/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.172/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.172
Git Commit: 78d697fc93f98054e36a3ab76dca1a88802ba7be
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 30 unique boards, 10 SoC families, 11 builds out of 201

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 9 days (last pass: v4.14.170-141-=
g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    sunxi_defconfig:
        gcc-8:
          sun8i-a33-olinuxino:
              lab-clabbe: new failure (last pass: v4.14.171-235-g7184e90f61=
c3)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
