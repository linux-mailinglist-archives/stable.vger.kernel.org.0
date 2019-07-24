Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C444074129
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 00:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbfGXWBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 18:01:07 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:39996 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727931AbfGXWBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 18:01:07 -0400
Received: by mail-wr1-f49.google.com with SMTP id r1so48522285wrl.7
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 15:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZacacMkkIay4oC8LbbwJxvdstDUmQf+9nUXUBVqfFQo=;
        b=0nT3sPagq/Omxp8Tgo6ytM81/fvGSg+t3tDLuWfr+GBB6wR0HUevjLBb3yUufijpwO
         qP5Bto1is1uBnM0s2WKr3OO/zPYUIxWQFnBfIEQ0fRC/6VX3WZpZ/9txKqPfvGA+gZ/U
         jt8KXGLlEiLWeZrMwq5L1NktFEBJNvwwq6IDtwYKfGWclQhG5MvJHAbxzUE6nYj6GBBA
         pAV3A20FsL5l5Ti+M4MuZ01Eayi03fKy01OInAYSR5CCKFBi/yBV7sxPN3S7A+CSmJYw
         KPrRF3+v5Fc5RctC/AcwNd981PDi+CdJauseuIjuzA/XtfVwDKZ2PzYU90vHObBmZDXb
         WRlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZacacMkkIay4oC8LbbwJxvdstDUmQf+9nUXUBVqfFQo=;
        b=fipltITpJEEmfl6rGR4REHdGCeVxq6uSQUsui/adHaYmVBQPwS6+PVbKDrXLeNR5TI
         bjwKwXUdIDi5I4Y90LBJIm292guAEp/L8Ae8TTwAmIbcSxY1oYIflmOD0u3P1lyL45oP
         Kvt1o+isirzrd1B/F8/VCF+73J9/Zkr0Ft6R4326qBpEtRNxA+e101bJMPSJxH/pgzfR
         glBNqtBnZ+1UIUShqhk24NWiHKVvB1g6PrARNoH155vQQrXS67NEQpY/bfCrZrUl21op
         LayH/fgmpkYVEwBtOwbWfwgi6pmOyR3ef7J0yiqlUjQQw7HYL2yl+pA0GC+YtN/543Vn
         anwQ==
X-Gm-Message-State: APjAAAUz2GBuOi2tnbfdn88rH7GluPk194eQb7wYI0L6/8G1MUPw88TY
        GnAPC5Oqsp6tATFRP1iMjdA4iV8zerk=
X-Google-Smtp-Source: APXvYqwSblVI3BFch9lxdcYo473OQ6uIcC8p3zJXsu3913t9JmBlBQ5ZxptVPKW+OwY8qLaAp9/PUQ==
X-Received: by 2002:a05:6000:12c8:: with SMTP id l8mr37933778wrx.72.1564005665862;
        Wed, 24 Jul 2019 15:01:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f70sm57071469wme.22.2019.07.24.15.01.04
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 15:01:05 -0700 (PDT)
Message-ID: <5d38d521.1c69fb81.3caa6.3a25@mx.google.com>
Date:   Wed, 24 Jul 2019 15:01:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.60-272-g975cffe32ab5
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 128 boots: 2 failed,
 125 passed with 1 offline (v4.19.60-272-g975cffe32ab5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 128 boots: 2 failed, 125 passed with 1 offline=
 (v4.19.60-272-g975cffe32ab5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.60-272-g975cffe32ab5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.60-272-g975cffe32ab5/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.60-272-g975cffe32ab5
Git Commit: 975cffe32ab513d7307a360d34c483c3b53840fd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 27 SoC families, 17 builds out of 206

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
