Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B643B1BEB
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 13:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387897AbfIMLDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 07:03:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39860 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387858AbfIMLDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 07:03:45 -0400
Received: by mail-wm1-f67.google.com with SMTP id v17so1756873wml.4
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 04:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PZIBkiNRyMAHwTw/JYzoAsQo0+LBUHwtX7CrGVLEniw=;
        b=UoaEfe8rR09fYl9QM/5o8jEQGV1KliA8tHyqxgKeeB3a+9ugUrJx8hPVzqLZ6lQRIs
         VLvUFUT3c/butnQ/ipuriSIh4OPM0RprJjVBLsWwB1PiqfvH29JjjxbCTIOX5uafjibi
         pOz2ebxj4ogbohxH/PvdcfOqTHPCKXEAL6anMX5dUlPg+c9bMey7Mq6TxoO4ARyKM/Ch
         BB23oeeYUQp6oWPoKo+IaWDd5SpF98EARYXuMJ0YLvyRM6ShOfPtGUSoqu7i6jwC8OZs
         /OnmAVFSs/wt30yfr7lx2w3xoXzwQ2HlS2YQbJ27spcV/1a09ojJ8BaugT/MuIylT+4A
         XBhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PZIBkiNRyMAHwTw/JYzoAsQo0+LBUHwtX7CrGVLEniw=;
        b=lnZw2UjSgjifpmvXnmUUarsgi4nKslt5CpWt/mKVLkAH1alNd3wE7w65NaOZyP0KBp
         oi8OALG3xTqp6gXwNGw+c+uu2pWFzyty+AlZGtP0FurZl+MJCXMd/EkIKPJx+e1w4uE/
         8IVaPcpbndjrEshmFbjRoWTv5rDmpm93l0xLCPeIBVaAt4bfQIIHMhBSfdFFrH9UR3jp
         7mcC1G5An8KfIOMmRKPOFjwTJluYuGc8Bm1NV57eqT/VDUGSkZw78Q0zyfhLB1fqkr8o
         E72Pdga0KoBT9yqAosv/YHnYISlQi623PjzQRacP4h9iR8wA8b//mtGLrf92DjDOCDP6
         Z/gg==
X-Gm-Message-State: APjAAAVl7Q8ktieq8/610T+uqRoF24h6vmtfB76JbazW+19Due7mMXT5
        xC2Rx7GNhaDBddUiHzXdURUmGXljzmU=
X-Google-Smtp-Source: APXvYqzry/Z/s4GeEjaahgnDXrXxzhosnW70l4Sy09J06UQf6C0LFUmVf9FqHOUUvJJDzPWCMomZyA==
X-Received: by 2002:a7b:cc0a:: with SMTP id f10mr3081830wmh.6.1568372623243;
        Fri, 13 Sep 2019 04:03:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a18sm41585217wrh.25.2019.09.13.04.03.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 04:03:42 -0700 (PDT)
Message-ID: <5d7b778e.1c69fb81.529e5.7f0f@mx.google.com>
Date:   Fri, 13 Sep 2019 04:03:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.14-35-g4cc71036e95e
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 144 boots: 1 failed,
 133 passed with 9 offline, 1 untried/unknown (v5.2.14-35-g4cc71036e95e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 144 boots: 1 failed, 133 passed with 9 offline,=
 1 untried/unknown (v5.2.14-35-g4cc71036e95e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.14-35-g4cc71036e95e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.14-35-g4cc71036e95e/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.14-35-g4cc71036e95e
Git Commit: 4cc71036e95e04498aa42628ed0b50cf7e854f0e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 83 unique boards, 28 SoC families, 17 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
