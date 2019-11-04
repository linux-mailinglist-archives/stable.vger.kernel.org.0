Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12947EE8DF
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 20:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbfKDTmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 14:42:02 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:38091 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728974AbfKDTmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 14:42:02 -0500
Received: by mail-wr1-f50.google.com with SMTP id v9so18531907wrq.5
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 11:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QMPRIYP27leOHZHrwgue0iS078Nt9gfJJ08dTF5nqMw=;
        b=xm6mUYRib8dMBnChMmNxG2iec1L3XlirL7F6wjaCux5j6anq/dJYspy3dcIQcoBRfA
         K6hRG9USbl0Lj9yx2Qf+low/0q3mAJcEGCJklgvbTwalIqKvnpYxZD4reBikWse5WjF3
         3UNg9ZqJbc2fXkCvnJKkl6CNXgrEkUGEhwGsu652L8Y4415d8+FRNC9ZTiA47fd9Nnc6
         DRUt5Zk9tP01qP5PDTMJknwwOiDK+F0z/QX5MzqZzolcqm9PLmoN0sykuFg+pXM5aPKn
         86tsTm3c1iriS7xETdSoaUW99IjWhiWG79ioxnZo7su6Lo8ehPUFP8DWHLQzNKfSCQET
         /e4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QMPRIYP27leOHZHrwgue0iS078Nt9gfJJ08dTF5nqMw=;
        b=Ax0WZTSoT1PtSwIGLYsbcc6jIIikXlgxliAcqJphGKt5DsU3ST9WeQt0l72L0jWl8x
         Ke+IWddZFefNzSIjv+ZaOkpFmbYAH5KKMeMS0IzFg7SqEwOYLoXqiXTIJryVvUmdkyTn
         8HzX26IYDf73PVguUurC7bubC1YOkfmYh0H5YDY83v3hVv2HKBaoLvpQtGunLMHV1YKf
         Q8dpXa/5Vc3rfYB1ZbGoRGaG0+45m5zmd72s+TsP2zYcE3o3UQF5g3+9ZQ8VCPF+pRse
         MIYdSbqPqlHXUkm1qo519UYE2pdF14NTeb/HcxAOlSfq6h4QMWyKgQf5DmxQRDjeRIoo
         6ILQ==
X-Gm-Message-State: APjAAAUA43o2sRTjAtY9Dz52UKJjjWNrZVAozGyMqRV4S6Hhh7l/b2+J
        KKjGw5yfSYy1oFPCpxd86M3Bg+dcBrda/A==
X-Google-Smtp-Source: APXvYqwcc5qvnXzzQbL9XEvbj8758Wh6P8bUpwmIwa4wkbUkUjy32w4s+/wgujVoHwCYVSb64+a2tA==
X-Received: by 2002:adf:8088:: with SMTP id 8mr23905861wrl.230.1572896518779;
        Mon, 04 Nov 2019 11:41:58 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f14sm19440598wrv.17.2019.11.04.11.41.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 11:41:58 -0800 (PST)
Message-ID: <5dc07f06.1c69fb81.1b2c0.f909@mx.google.com>
Date:   Mon, 04 Nov 2019 11:41:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.81-145-g3d8e1366ea55
Subject: stable-rc/linux-4.19.y boot: 116 boots: 0 failed,
 109 passed with 7 offline (v4.19.81-145-g3d8e1366ea55)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 116 boots: 0 failed, 109 passed with 7 offline=
 (v4.19.81-145-g3d8e1366ea55)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.81-145-g3d8e1366ea55/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.81-145-g3d8e1366ea55/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.81-145-g3d8e1366ea55
Git Commit: 3d8e1366ea55e7033be040ed601d05b78d24d549
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 23 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
