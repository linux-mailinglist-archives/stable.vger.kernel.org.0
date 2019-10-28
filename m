Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1094DE7D3F
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 00:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbfJ1Xtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 19:49:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38856 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728952AbfJ1Xta (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 19:49:30 -0400
Received: by mail-wm1-f68.google.com with SMTP id 22so655099wms.3
        for <stable@vger.kernel.org>; Mon, 28 Oct 2019 16:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qaSYekzC7VrfYopDogYNH8RrD/xm5SMvoNuKHm78fIM=;
        b=bovkXcx4Vj3bs577y37akR+ORkAwuZviNZhNyZloQ8ZfmZ3BSyValg20z+8JHV33cX
         cRHAvjhhDu1QxN67EmQ4NZzggM2yUJ5JErf1/njF5NclJrXuXqkl9WpFFD6BaoPxh8tc
         nBe1WBeR+hibWSzFDYWvl8J0HCZWlLw4sp135Q499L7m15mv0WAWmZVUByJ5jYwlH0hG
         krJtOil+wC/JPZTwN6EpNRCTW/Yoir0600s9eWfo3R3Ukye7aJ0f001xE/JYlzvx5QT0
         qYGTgkokRcOyNG4pfz8wdtKlJjSQ0SM6qDizYcscOdAqsVmYFU+wIFxp8PoTHOEBZlvl
         Y2+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qaSYekzC7VrfYopDogYNH8RrD/xm5SMvoNuKHm78fIM=;
        b=PXCXBifCTfJleIIJMg4SREDIKbIwQH9/4ijF4DtqIgL1JdxZJEb8oKMN2VdeOvkRN5
         uV7ffHdSreLR13mR2U3KVDHoNEmD5GbQOd3Yqu8b2Cd6BIH3Wcbhs9CTbezXNpoZ50VK
         BueCIeGWMS8qkgNWjnWHnOYl3bLpWnlIzoAQWAmHdSfDqFtp9edfGo50CRqcgUvELelv
         UXREfEGytuEOC+8RQfUWBk6keG/7Y9UyScju0xGYCRzdMIf98/VZtAZ9UfDc/e/ukD3T
         DLoaeZSRePNMzZMacFHG+8fh2x4w1xo3vY27AFELdyWU9DWuVZfu3mjbMlC09Tv6cF47
         H3gA==
X-Gm-Message-State: APjAAAVONwLZKs6ni9qGGLkRshe3eDvbahGLaIEL7y9jTbU+qIM29Zkp
        JIXFBrhHxTw++Vxi8JlFQHYbiHQmWfCOyA==
X-Google-Smtp-Source: APXvYqy6V4TMHMCg2qvuh2pAz+FPauS/bC00LsbL5uSnJWsgsoU6B44ERwvvdkxE03AlEdjxYbAj+w==
X-Received: by 2002:a1c:1a4b:: with SMTP id a72mr1498844wma.17.1572306568464;
        Mon, 28 Oct 2019 16:49:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g69sm1068541wme.31.2019.10.28.16.49.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 16:49:28 -0700 (PDT)
Message-ID: <5db77e88.1c69fb81.4c342.6974@mx.google.com>
Date:   Mon, 28 Oct 2019 16:49:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.197-40-g3e3483176187
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 83 boots: 0 failed,
 76 passed with 6 offline, 1 conflict (v4.4.197-40-g3e3483176187)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 83 boots: 0 failed, 76 passed with 6 offline, 1=
 conflict (v4.4.197-40-g3e3483176187)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.197-40-g3e3483176187/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.197-40-g3e3483176187/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.197-40-g3e3483176187
Git Commit: 3e3483176187700a1041c9c454d38c9d361d6a60
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 39 unique boards, 16 SoC families, 10 builds out of 163

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
