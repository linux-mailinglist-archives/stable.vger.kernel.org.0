Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D988BC9E5
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 16:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436898AbfIXOLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 10:11:41 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:36812 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436752AbfIXOLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 10:11:41 -0400
Received: by mail-wm1-f44.google.com with SMTP id m18so235095wmc.1
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 07:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B/nawU7kEIyFelqakv2Jpx2bQHp1pxmQoQThIOa3hxU=;
        b=boz/c2kzDNJhENavMJ9K3YuyLi64fiJ7QaRybHo+b7asFNLOTAksQKwp2S3LFYP0kT
         3En0pnEatsWst+QvTpoias9OsEsiFxXtGbTOOd5A7CUe6U35uK8J437kOBGio3zUE7vT
         czy4dKiiKMaGkEBfxyIXp54V8n8s3AxwzYxpL7eGGp6th+MTA/MARrHN15ze62GhOVUC
         zmIUsCzExA2RcUhemJfIYXKYgFXMgkKsVd59AqEBkZH3OfLDfiekpddh36SqL95Vw2+q
         pTGZWMcqmjtgLGyr6O0lzKgJvF7ebqg/HgNuIeWU2dAly21XAV13ZYOF76t1RZ10iziS
         vycA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B/nawU7kEIyFelqakv2Jpx2bQHp1pxmQoQThIOa3hxU=;
        b=rIxOsI3X3F/k0Mtsz4TPHDActxcp3Xp4reoJZcSnirMrVTWNT1HQM7wmFlHWVs2FMn
         pMzWWKpSbkJOAJk+Yfj+RKX03m06uPQwKH11T70Zp2P7IinjEm9Qlo130fM5CxKgepQT
         F4KLQ4lfK6InoJYdQnJj2nPn4MwaA+EH0P1vzEcsC3RaTe7LwEPxN8aovAyHXs16GO3b
         eME9NVKiBLq32GeLV5qcprTG/8tXQUyQS/wNQszyhIrTMHh14T5klIl1QsQ19TKSPB8V
         s0JiRehSCg7yGfL/soos9gdV3LwsSyd52YR12QQPIrawwQ7jyXLv4DPbbs2m3U4+Bu9v
         5j8w==
X-Gm-Message-State: APjAAAXTXDEXl7BsHIxD/ED1As/bIIhgEwLjtYhnYW/o6cRDArBmHajv
        inYvuHwZra+p69GCdnFve0GXH8yojaVsEQ==
X-Google-Smtp-Source: APXvYqy1oqxsAXFWKJI00kSniIkrWmWTe+Xuf1vlvE3sBjzMf2gmnYsqy7EBCKqA0V38w2BBjDQPtA==
X-Received: by 2002:a05:600c:d4:: with SMTP id u20mr265720wmm.66.1569334299479;
        Tue, 24 Sep 2019 07:11:39 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u68sm190901wmu.12.2019.09.24.07.11.38
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 07:11:38 -0700 (PDT)
Message-ID: <5d8a241a.1c69fb81.ab175.0f47@mx.google.com>
Date:   Tue, 24 Sep 2019 07:11:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.146-10-g1e77fe160add
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 124 boots: 0 failed,
 114 passed with 10 offline (v4.14.146-10-g1e77fe160add)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 124 boots: 0 failed, 114 passed with 10 offlin=
e (v4.14.146-10-g1e77fe160add)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.146-10-g1e77fe160add/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.146-10-g1e77fe160add/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.146-10-g1e77fe160add
Git Commit: 1e77fe160adda73e2ded0a5dabc888b7eef79beb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 22 SoC families, 14 builds out of 201

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
            sun7i-a20-bananapi: 1 offline lab

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
