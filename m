Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB047436B
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 04:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389344AbfGYCqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 22:46:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42281 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388165AbfGYCqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 22:46:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id x1so33998369wrr.9
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 19:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ChE7em+j3U0y9KQIioYhMfN05FqaOuCZwoNCnuzNKAE=;
        b=B3qbS5deVjiaU9HWW+nl7X0SzOYzFcBCFP/HyMkRWml73P5Y2tu8UECwW7QbCG26fj
         kifEu69xhMiEJGfX0IO4GjQZ9zYcHutJQz4/aMv3zrUAmtYZM9MCodbrZyQYJfpd2L3i
         M+pKaV5A2tN9tfIYfoik9H2b8YNrWL09N2QhWTtb7G5H+i7RW97Lrk3QFaPPbApO1jbQ
         ncnkBS+kGAiA35DeMSkmiYVSAWrKsTVIVWSvituZdFQF689CLtkvI3B+m0zExu1ac10K
         J1m/ih25YWqHWAk8gCt3rQ7mb2XDJTjwmmbtQ8niL+HUNielJiqp8kt9pFNRgCTAAuQ8
         NMzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ChE7em+j3U0y9KQIioYhMfN05FqaOuCZwoNCnuzNKAE=;
        b=lfoCtiVb2dt1Csty5NH1upt81Yv2teW+C717X4pT/RBEPSgVcT4OVOdU44/JlJBwtd
         FsOvHpBAKAEQWTTTHDAWFL4CPwyIVsx7lI7wmxHJLngMxVqnvjmJLWeQbGZIWBmAEP/O
         Mmgaivwjzz/BGG3KLaTn6ka+87ZnypSZGiKCaEG7KsjpM8w0M+qWXkjwPWtEiiwr2mVa
         PA2r/IGG2p3HM6tLxqNZ5Xas4Da1Ayq9W2e1J2oQ36ofhTdU09AMzObaVeA751Fg3AB+
         NKB0gHVXRlI/2RKLmB3dEYXPb3JxfHubI/TSdLQt6YsRGHesWFrB+iO1v7H+fIhbqcFA
         BzKw==
X-Gm-Message-State: APjAAAW1n6JvRf+7qpiiB6shTswUV9PCVuBfZjdaScyFtIO1N/oaxuFg
        eJi5e9LXExxyubOSDc6Gx5pv9UJtXG8=
X-Google-Smtp-Source: APXvYqxYx0/Rp9ctDvGla4JGDt4jI8Ou/XiwM1WjkIEzXsGhG2oDX5Q7UvEVYcGjTATm+MtlcZWgRw==
X-Received: by 2002:adf:f544:: with SMTP id j4mr91520112wrp.150.1564022808134;
        Wed, 24 Jul 2019 19:46:48 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l17sm30797779wrr.94.2019.07.24.19.46.47
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 19:46:47 -0700 (PDT)
Message-ID: <5d391817.1c69fb81.b239c.7a3a@mx.google.com>
Date:   Wed, 24 Jul 2019 19:46:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.186-126-ge18d357305a9
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 106 boots: 1 failed,
 103 passed with 1 offline, 1 untried/unknown (v4.9.186-126-ge18d357305a9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 106 boots: 1 failed, 103 passed with 1 offline,=
 1 untried/unknown (v4.9.186-126-ge18d357305a9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.186-126-ge18d357305a9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.186-126-ge18d357305a9/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.186-126-ge18d357305a9
Git Commit: e18d357305a9aaf6125c08c8038320ad1c2b1dce
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 23 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-mhart: new failure (last pass: v4.9.186-126-g97ad1fbc1478)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            qcom-apq8064-cm-qs600: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
