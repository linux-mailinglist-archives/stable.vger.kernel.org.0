Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B42EA10D948
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 19:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfK2SCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 13:02:22 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:44434 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbfK2SCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 13:02:22 -0500
Received: by mail-wr1-f54.google.com with SMTP id q10so36947wrm.11
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 10:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=91xTliVVyqisdlRh7zHlYUxTs+OlTUJ8D1y8Q4yqV3g=;
        b=jroDL57DE3maChJ2+xroWurpz86fvA7s2PTOw/9a/+E4fDiBXUgb99gk45YjHjuIES
         83Gzbq8gPmQFCptWiEZK8JqaLdhZpKFIp9J3EuxrKrKDCd4iRQpvwRCORY0X2iZacwcZ
         LKvESlgNzpIg8Ysi+/G63qgVpXtZdjIXRKkyOQtpjYa4o1WbXkrdvxajG++F6LnkGpa2
         SxkgfD/xqUXCvVK/TKE+lSzldJrL5eEULgrwXxl6zfuMDJDXtts6atqzs21QUgYI57Am
         ySFFC3YTASkBjW4cMz9Xw18Eg0C8RTQu5EEQD/MjAwpcakciaTfh/WiJq298A0ihrZQW
         6w/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=91xTliVVyqisdlRh7zHlYUxTs+OlTUJ8D1y8Q4yqV3g=;
        b=Lrj9K6ThE/KygUe6nuHrrc78cRVGBzXuuyKhGHimETghbXrJmObovzDvYU+LR0cxnq
         sL0csKmdbhlbgKPk+TzCMSZHbSkTbFw4UalGl2uEPN+QkZJ9u9qXtFp+rCqor4TuiZTw
         KAO1d073FzCPn5thynWyqzUdh5kfF/IyAVyGZUeocnis9LARN6DNLMm1YeGkH7xRy3dl
         h1BAYWjLoMm4xgXa91/JDZj2Qj4BvOl/gM/GwVqJMU52W0AeJNNCRJ7WrXjZe9ZftFff
         5bpBo713WflDjdrUbWsOLzYKYndMEKdQrZBtIpURnE4AaFtxR7SATm9L6/ZMrMkP3j9+
         FPtA==
X-Gm-Message-State: APjAAAVMUZjqp47AvukxX4BSyojgIlZK6v37UbZmrEocLTNxuX2YeCJ7
        n2+oUfI5cshpe4Hjo6qWssXta1POUOeINA==
X-Google-Smtp-Source: APXvYqyHcoeSlsTs9aNEo5nA1L+GwZMgC0vTxcAPFNV2waL9IDrcuLig4lUizXBOThw5vWP3FILFuw==
X-Received: by 2002:adf:f489:: with SMTP id l9mr53396096wro.337.1575050540533;
        Fri, 29 Nov 2019 10:02:20 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v3sm3256653wml.47.2019.11.29.10.02.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 10:02:20 -0800 (PST)
Message-ID: <5de15d2c.1c69fb81.5c51a.1e22@mx.google.com>
Date:   Fri, 29 Nov 2019 10:02:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.86-299-gcc82722f8f1b
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 137 boots: 0 failed,
 129 passed with 6 offline, 2 untried/unknown (v4.19.86-299-gcc82722f8f1b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 137 boots: 0 failed, 129 passed with 6 offline=
, 2 untried/unknown (v4.19.86-299-gcc82722f8f1b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.86-299-gcc82722f8f1b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.86-299-gcc82722f8f1b/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.86-299-gcc82722f8f1b
Git Commit: cc82722f8f1b05c10e62b80951b3950e453fcb88
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 78 unique boards, 24 SoC families, 15 builds out of 206

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
