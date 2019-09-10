Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD554AF2EF
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 00:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfIJW2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 18:28:14 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:50482 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbfIJW2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 18:28:14 -0400
Received: by mail-wm1-f46.google.com with SMTP id c10so1218361wmc.0
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 15:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o0D4oN/78Qh7t3i6Z1vHOwPS5ZJwkhyRbs4TFBiw3aM=;
        b=rThgBmol1tGm3kQsUCJoGA3hs+ky0iWz/YdkFU7jiCYeVy2mMivhaidtx/NVeEv/Yt
         atF4IvKlZ+xJFdC+4dvbkts62Z3iWE65Rfk9B9kyaWbVD7GdrccAYlFZCJ09EVASPuAD
         lKfJ3kp8BIb07J7ycIU+6oTal2S5suKUKVn2Nfb+y9BO/X5oqTSmAuqPkVB4j0dHwOBq
         JmoLJ4DLCe/ElEM8rIr8x57UzV3xQfXGUqMErjYlDhOZ/ktV3K9EABhch/Zu+facigc/
         erXCN8R53S5EJsKcFBpqezH3zngylJpC8EgGCQ2V/NOCTzOPElWS12eIddoFGmiq1aiQ
         HprQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o0D4oN/78Qh7t3i6Z1vHOwPS5ZJwkhyRbs4TFBiw3aM=;
        b=E43yox0jogk4JgIGOHyCqjCDiiaWO+HA2reSmz5ObiapIGvfrLdjNOwe3sKOUPtrx/
         38DD4Gal522AVZbBniMJ+zhYUzNypvFCwq2qawNfQ2n2yq/YJ3mCOxAA0Ob8dzSFKkJ4
         VP8EPbBE70AvbeVpdpdIET9/owmF/hzb3e6V57t/t/czPmWQtAReNJ6+l84e51ghbmty
         x9CqN6vER6jH2jA/C7svWOJ+j595cCQanonD4lz7dOwBCh7Wj2bjEX8h/bgwygadya1o
         5XAArNXhpSGJreUzr3LcQODxKVk2rJ0jv8RoOZmLU1v7sD/IrJfbUvCr7/GSsADWQXxj
         liHw==
X-Gm-Message-State: APjAAAXGQBrTtGr0/diDQEtpXoX9oPaUGSYRS0pkPM5nfKj8B/dDmBzd
        7kioBQNOg2nK5mGW6Dv8kRnv6O269mh+Cg==
X-Google-Smtp-Source: APXvYqyboGM+CzUiRsz4BshcFDiLRwNGrFK070JWEhw5zqyDaQZTtQ3NxDLIk31WvJ+baXaf83kbNw==
X-Received: by 2002:a1c:1f47:: with SMTP id f68mr53399wmf.78.1568154491953;
        Tue, 10 Sep 2019 15:28:11 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x5sm27283718wrg.69.2019.09.10.15.28.11
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 15:28:11 -0700 (PDT)
Message-ID: <5d78237b.1c69fb81.b79c5.46ca@mx.google.com>
Date:   Tue, 10 Sep 2019 15:28:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.72-11-ge1b4ee14c015
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 129 boots: 0 failed,
 121 passed with 8 offline (v4.19.72-11-ge1b4ee14c015)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 129 boots: 0 failed, 121 passed with 8 offline=
 (v4.19.72-11-ge1b4ee14c015)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.72-11-ge1b4ee14c015/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.72-11-ge1b4ee14c015/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.72-11-ge1b4ee14c015
Git Commit: e1b4ee14c015a8b1182da0b00bd3684af5f64545
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 25 SoC families, 15 builds out of 206

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
