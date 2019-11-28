Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38B9810C95C
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 14:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfK1NTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 08:19:13 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34902 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfK1NTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 08:19:12 -0500
Received: by mail-wr1-f68.google.com with SMTP id s5so31060515wrw.2
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 05:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3GCutVq57dnGPHpoDmZjwV8SJLow8unCAQwCp/GdQsQ=;
        b=uQY1ijWnQt/Shc8FDJuJ6P2/6vyU0UON1SXosPLHxw6jgXDUsVuI6Odyuqm+wOfoIc
         ScX7NiRkVUPjJaQjAsa4lV8rRDHi2x2L7tSsO8dopcSqZX70AWcYcOtnGms4W1PLlvIp
         bQF8YwRRyBMhaCm/RdMz9wws/Q/YsLUQTIH+XZu+PrMTpW3o2ERcvlKDrDrROX/eDykS
         BtaFwRAsFH/Px5VSivzo2Thf9/WeQ4qEMbT0H8gbikXDjwAr+TrOeEUSt2ZyYcOhtFHt
         0zAOsnn6LZi8gXUHdUMMexsu4DCgVW50rb2s1wAh/thMuBe4Yzh6TLnTCX5jr9IlCbWj
         Revg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3GCutVq57dnGPHpoDmZjwV8SJLow8unCAQwCp/GdQsQ=;
        b=LWkxfEibldzdHfImVUsHUsrqTCr6GjN2h2KJWLc9D75+86As/MLfi8E7dWlh/MU5aC
         tFGOBZPXwKxXyfiE29qs/ie7g22GJBEWMJR6QJmHQHeb0qBO3Is5nkHa22QhLaLiO9ly
         iW7+bM3ATeD68/uuj7ix/wlX1TB9efVTLXOZbH/4+LEr0Vf4zZwNXLWc2Dqp0O5u830J
         yQyW8NevCifQcVejHCPW8jQFMBS4JbXfXGLQqzpwe8ao6BEDWPdStwZamtG2s5EDzAu1
         ZIfungm01aHxVdJkM85X5O/LCB/Qu8i+sdjGZ8VeCzi3ng+eTHEN28FtekGXdGYICj7q
         uW7A==
X-Gm-Message-State: APjAAAUZuiMhwrW5Oo0NWTE+0fv3jt4+oDSmNJDLvkkSDSj6RZWa9Dvh
        K72tg874nt+GymOCZX3T2V+PWQ2sxDs7ZA==
X-Google-Smtp-Source: APXvYqwZt7KjetI2lkzQwdwBU8FuJkVUW2Vmhp1WEYF1Zn1FECcI4vHScyoEbEPNPzrZAUNTBF49eQ==
X-Received: by 2002:adf:e312:: with SMTP id b18mr50955732wrj.203.1574947149763;
        Thu, 28 Nov 2019 05:19:09 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g11sm10551638wmh.27.2019.11.28.05.19.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 05:19:09 -0800 (PST)
Message-ID: <5ddfc94d.1c69fb81.3a9b.5c4b@mx.google.com>
Date:   Thu, 28 Nov 2019 05:19:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.86-309-g63633b307be0
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 131 boots: 1 failed,
 122 passed with 7 offline, 1 untried/unknown (v4.19.86-309-g63633b307be0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 131 boots: 1 failed, 122 passed with 7 offline=
, 1 untried/unknown (v4.19.86-309-g63633b307be0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.86-309-g63633b307be0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.86-309-g63633b307be0/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.86-309-g63633b307be0
Git Commit: 63633b307be0161e7bd6f854a28d7d9fa05f69ef
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 23 SoC families, 14 builds out of 206

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
