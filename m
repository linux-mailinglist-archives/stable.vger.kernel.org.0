Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC05210245
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 00:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfD3WSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 18:18:22 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:46603 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfD3WSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 18:18:22 -0400
Received: by mail-wr1-f50.google.com with SMTP id r7so3037511wrr.13
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 15:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VXYwZpX1d+wknY0tSOqvdnHG027bEu0WR2/eqUIGUnc=;
        b=OavHJZXW1zF7v6zKR5DFrINhbe1yMKSLFf68vIhsR7iDdROBg74g++idjOFF7UDVP/
         5/q7NIhCHK+A7edRRAHhr5oZlSIoilqap6TSzvcK4u7q0Z54pFhUqH7FqLoVKq1wmpwf
         Vfi5PvYhiszdXLBV0cRTP7JQF424BkeJQJ7WYl4cEeou/VDtnjYRPHXID0hI2SNJbH3u
         sghYjl+EW5ttSLfEele7lTwpcJAHtrpp4UwdwJtmevlyFpuu8NA26H3cT7byGEjkeT1P
         kHQa3r10k4D5tPi8s4TbwtHUsLql39/kexVyaVjQQo35rCwPgVry2bStttcrg5p2a0EE
         Heqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VXYwZpX1d+wknY0tSOqvdnHG027bEu0WR2/eqUIGUnc=;
        b=J6N9gu+GJj5P2X66P1KaG2SdIMLU9BGZtDJkasq09GigJUE55FUgCVQYy//n5ks6Q7
         V4sGz5VgRpd7HwYMosFr1EvTOf1Nu0I/RN4ErJRqgam2dFJZpCgBQKbRbMRQsGoIw+qe
         FInIxFigoH0SwyEjxrDIkM9D4GPpCVFl8/MtDa5uDPKEmS17OJ3il9e8nTLXqTmFwik5
         2ecJk5HlWHjzDiMnrGhiLasHConqbV4lzvAtEPZZHiyB1H9Wsq31cK7zujJobZhFgMmy
         tfNHbhn/m9krj0diwVRvOfR8xBIN8HzmDeU6PhLgS0G/GgyTjZJ0AO6JSXgyoNB26clX
         T/bQ==
X-Gm-Message-State: APjAAAW6IBi7qryfJYBWIWB4C8Kb6eoxVqkQyBdI1RILMPYwlPdHtDa7
        GR9ZY4D2oPkZHaXckM2600eqO7K/S8Vo+A==
X-Google-Smtp-Source: APXvYqxXmUgH4AQxsWwkYzl6sEXbA5AI1f/Pa46sJ044sySCbujYDK9ls49WmY+thmfIEk+zLqHvsg==
X-Received: by 2002:adf:f852:: with SMTP id d18mr3618714wrq.71.1556662700985;
        Tue, 30 Apr 2019 15:18:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l21sm2514380wmh.35.2019.04.30.15.18.20
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 15:18:20 -0700 (PDT)
Message-ID: <5cc8c9ac.1c69fb81.440a.dc3a@mx.google.com>
Date:   Tue, 30 Apr 2019 15:18:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.171-42-ga707069e56d0
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 99 boots: 0 failed,
 96 passed with 3 offline (v4.9.171-42-ga707069e56d0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 99 boots: 0 failed, 96 passed with 3 offline (v=
4.9.171-42-ga707069e56d0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.171-42-ga707069e56d0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.171-42-ga707069e56d0/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.171-42-ga707069e56d0
Git Commit: a707069e56d0b0365daa528a05c6388b41cfe4fa
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-7
            tegra20-iris-512: 1 offline lab

---
For more info write to <info@kernelci.org>
