Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D79B12CB4E
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 00:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfL2XGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 18:06:34 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39892 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfL2XGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 18:06:34 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so31281035wrt.6
        for <stable@vger.kernel.org>; Sun, 29 Dec 2019 15:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BjTTSt1PBX4O4pyLQueaNMlGhUV8nOzteFSFJfku9Tk=;
        b=NqmJJyvwM8H//axMivAgFt6BCzHS4mFUJWobkItaVjBpz63IeVQdSx7GBlHwhOfcsg
         c++x798HWM882lCQ9NAyjNWVPiOeEHT/rnJXGnvllWwq/8sSNDubbhFMEnCMzJB5uhnC
         mPU9nA6x7Qk/CDIeNYXSto/1bZkc/+yVm9SBo1U6cg0prygx61dwuea75afZ7/kh6YWS
         0AfTcB+ujnmqRrBfSn/jTRypwi2ULweuwo/u2iz1Un5aeUiBIkqElgU/SMvwHxRqwkGc
         RKzrmLAigvm3bDSQ4Y0t12CRqPIsTNBavcJLp7ThT3RFxUd8sNzdE8j30a9RdlH/wjwW
         XrMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BjTTSt1PBX4O4pyLQueaNMlGhUV8nOzteFSFJfku9Tk=;
        b=lBfVpGnAzD1wihYWeo4LUt4cPXNi9yl7dOthSeVrfg/wsUAVyXuyj8H3WP9AsJvF40
         L7/aP+hYi1DPDN5McYESkVqNm2h30t8dwSfjCD4H6lMNKlTUTZt3SVRYolgdRaqYgyaH
         zLXFCewiYmXQhj51Z4sllwP5kuVwnpLpWpUQ+/M0rucOH38kw9Jc5AHi5t5N59hDeI2P
         zLJBnL9aCdbzsIBmc/9KO1PESxxAFsXI+yaYzXoOnTGiolq2soiZrtBg4qdst6ZT0q/v
         1OHChP3Ozr+PCnKtLhbAGTaLqf3Slbm5zc8NcfXGKyx8yXFH3WW7wK52uOnC6j11ecxs
         H22w==
X-Gm-Message-State: APjAAAVBVZiHUniEA+IyzSeu7z9QFOKTSf1lDuYof7JzQnFraIPtepdh
        JEuSS811l2mPveWWlShdc57yJN4isM9i0w==
X-Google-Smtp-Source: APXvYqwdW1WFsf+A6P59XiTTzds41GeqG8yvOH4HDPh2UkIvL/1N2nehQ31a+37vWHYah72dXDsBWQ==
X-Received: by 2002:a5d:6a83:: with SMTP id s3mr60649711wru.99.1577660792058;
        Sun, 29 Dec 2019 15:06:32 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z3sm43341933wrs.94.2019.12.29.15.06.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2019 15:06:31 -0800 (PST)
Message-ID: <5e093177.1c69fb81.224cf.8b6a@mx.google.com>
Date:   Sun, 29 Dec 2019 15:06:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.160-162-g9973cdd1885a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 110 boots: 1 failed,
 96 passed with 12 offline, 1 untried/unknown (v4.14.160-162-g9973cdd1885a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 110 boots: 1 failed, 96 passed with 12 offline=
, 1 untried/unknown (v4.14.160-162-g9973cdd1885a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.160-162-g9973cdd1885a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.160-162-g9973cdd1885a/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.160-162-g9973cdd1885a
Git Commit: 9973cdd1885ac46b53c6db9f07b9e22003b8b1fd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 20 SoC families, 15 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.14.160-151-g=
b53246546618)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.160-151-g=
b53246546618)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
