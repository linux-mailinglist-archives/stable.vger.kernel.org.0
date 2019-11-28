Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3AD410C23B
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 03:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfK1CXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 21:23:12 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51424 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbfK1CXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 21:23:12 -0500
Received: by mail-wm1-f68.google.com with SMTP id g206so9327462wme.1
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 18:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R1GYy2eEH5nwdrEd30jsALGErKN9EOvhEpPaQiVV0CE=;
        b=F2wyvSB41N5C3qnEsf/uTXcZ00xGRUb5/gIyiIMfaDBmKWw7mlKeTMspjfSywXYdSn
         ZYOcSLTKlVV+SfQn9P2J25M2GfbLWoYD6665L+kZ5b/wBLKwK+/SWc4CYGcJpnS6h0Ae
         9q1+k59jazrDmoXTX3RAZaE3X7R7m2XxvWh/c5RIiwfv1HxJSK6eaOaqGe7RDpl7AzNN
         9yj0MDx6rHLdUorIL9t5x4KUkSRTURNGkvfHsyKCASdcHxDDqdVreLuMNtiCNK8HHasQ
         FsRJxPAgeaT69AFOmJ0TeHcygUCzlS0ntL3VLpyGbAd0gv9/jE6eEpnlvVxPnnHMroJs
         muoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R1GYy2eEH5nwdrEd30jsALGErKN9EOvhEpPaQiVV0CE=;
        b=WmYMJL1S7H9rXL/pWkYtsfJiaM/sswO78722FqE8wvpAJcDYgIF8aHoJovcMzjtitq
         7hs07jv9sv1Qt0BVSAUzqptTkQD7i5P1PWU+HXxytcvofGIf41LjDCH6wxQxjTxWxZ0b
         AqVJ4L8uOAA8z1NK2diijhhj74kYQUuvh7GfMGGnnXTLFXI+xR3G9+xvx+jyBF1rlhR1
         /SSO0JzamzNJ3Omp6jUGIX4Coyseta5sNdj6S9lgFXPlJo50Ykr9ynLRA7LGCV8yrBrU
         fD7gP4ZoHBIBavXq7hpgYkj9JDeaNxU7G4ATEtf7QrFMPv8opjlek/e1VPQC1+dim6th
         VOmg==
X-Gm-Message-State: APjAAAUHbuwzM7YhMub/HFpWNbXQ+aC/lXs8XOjppboAnQMPTDc8G91O
        br/O4rrq2IRKi1pd4YJIp/U2oczUSaxs/Q==
X-Google-Smtp-Source: APXvYqwahCD+xgseC7+YWgKsUCSB6Apjhkwliy49OJlrU0xyhHHIIkyjl8lSkWfKnN0aYgloP2PRGA==
X-Received: by 2002:a1c:f00a:: with SMTP id a10mr6927236wmb.167.1574907788352;
        Wed, 27 Nov 2019 18:23:08 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r2sm9241449wma.44.2019.11.27.18.23.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 18:23:07 -0800 (PST)
Message-ID: <5ddf2f8b.1c69fb81.70fa.ec2c@mx.google.com>
Date:   Wed, 27 Nov 2019 18:23:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.86-307-g57c5d287ed48
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 103 boots: 2 failed,
 95 passed with 6 offline (v4.19.86-307-g57c5d287ed48)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 103 boots: 2 failed, 95 passed with 6 offline =
(v4.19.86-307-g57c5d287ed48)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.86-307-g57c5d287ed48/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.86-307-g57c5d287ed48/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.86-307-g57c5d287ed48
Git Commit: 57c5d287ed483d6100bdca528c57562b894487b5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 21 SoC families, 14 builds out of 206

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab

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

---
For more info write to <info@kernelci.org>
