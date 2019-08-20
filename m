Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5B496C11
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 00:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730649AbfHTWTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 18:19:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39237 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbfHTWTQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 18:19:16 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so109318wra.6
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 15:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8qrnnsuTlOSm7//yeAAApHiZ8BgFfIbVIZSe/eU20so=;
        b=YzgWy5mFTuHGRbXY2pCgG2CDhvNaGfajLy9lvUCTeJZy9zqQ9myp+NxC9m50AsJthF
         8HhD0ODhczQwswTDeXiHV9YiD63zkQkMzNONHjJKkPBg79R7cQiOPaesaOcahg/mRANb
         vtBHzhyIQzcyVWf7/Yzd1ruf8aLZ3kFgNcl3Gnot0L+u937JqyXENew1NtKv0ei+HtlT
         0FqgeAPQDDOg4KKun7QG94BcF0Iy9otD2mWgyCVjFYJc6qEIMzxW+KQC97VXOTH7vGYf
         3eh2Cjs5VUq7ZQ+zZjQiph6uRYa9OdjJOxfZYcrcZog69f8Nzst3QjuxUbPYuU+qKGq1
         cjzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8qrnnsuTlOSm7//yeAAApHiZ8BgFfIbVIZSe/eU20so=;
        b=l+fxMwgKqvxHs5SKcc2ON2X8i8u2bwjZjVtoma3/S74PG4YYMgk+zBbspXjBs86but
         WqKjMeybsMSSWyp89vC6FJFgHPLuoSxVBMlee+vvP49qofEDyAsX7s3U42ZCvcdSoPO6
         Q5cW9qBk2DyEM8aLQEClHC7t0Qz05+PQc3YyOgTYkH6O3XR8tC/2JlbUpVlVa+oeuXOa
         s/t6hgcqLQ9ZSHLCfj5UPpZYAIgG2H5J2SWDS9CB3o0aMhDBXvKu3lnznyhnTuENyQKl
         Hy+OTUxUPT6ZDZt4xyo4++0jTQKWwtbQCfzLFmbJ9bUSklOdr+EQwOFskNq8CsF5lYoZ
         NAcg==
X-Gm-Message-State: APjAAAWw0UJnu9zOxS/Q3+2W65VXZCIkQFG+44WYPp1LiRO+MjMBc8R8
        Zg/sOxmBYcjha/iRIqsYlvhJUQCwtdbnqA==
X-Google-Smtp-Source: APXvYqyzlLvdB9spbZZHsRkSdLsH+6TJBM95+OLuEJp3YSjPsVe1DsMQFKIEtXH1/N6aVBBDpEvn1A==
X-Received: by 2002:a5d:4a0e:: with SMTP id m14mr36347622wrq.72.1566339553581;
        Tue, 20 Aug 2019 15:19:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o9sm31058511wrm.88.2019.08.20.15.19.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 15:19:12 -0700 (PDT)
Message-ID: <5d5c71e0.1c69fb81.35ba5.6003@mx.google.com>
Date:   Tue, 20 Aug 2019 15:19:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.66-164-gd0331f9a5a7e
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 128 boots: 0 failed,
 119 passed with 8 offline, 1 untried/unknown (v4.19.66-164-gd0331f9a5a7e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 128 boots: 0 failed, 119 passed with 8 offline=
, 1 untried/unknown (v4.19.66-164-gd0331f9a5a7e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.66-164-gd0331f9a5a7e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.66-164-gd0331f9a5a7e/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.66-164-gd0331f9a5a7e
Git Commit: d0331f9a5a7ee94e23bb30a98f8345f097cb0c37
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 26 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
