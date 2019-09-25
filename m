Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 526C5BD622
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 03:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392412AbfIYBix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 21:38:53 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:43198 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389977AbfIYBix (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 21:38:53 -0400
Received: by mail-wr1-f41.google.com with SMTP id q17so4253221wrx.10
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 18:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NOIXpXvTpUj58P79LwfhCiCzJogECgIYqn/HTVk5Qoc=;
        b=OkjCwUWnzG4JD4jHCv7iHP0v/Vqk3SdnrflCM6zSZtuOplvb201BcVxyD2wdfPtkfp
         2YuE7f6PmVFXP9QkFrzJ5GIPG27Q54GKwy8LHdyLcdJ5PxdHbODMAe+g6TDWVD4E6fcO
         Iyxqmjy2xEXTzuOWGln4n7SnjeL0DKHbgSmH9mQn8LtIEp+vksYhVvVKSiLUyecWmdXD
         ysuw++GrmXDWVnzv7KQUlYSrJb0+InSGBzWKE/qO3A15PWPSgqrzf2RbBKTrV2komE+Z
         lB9woDEkbq27KzA7FMlngY/858NTodmcn81pGv4UGW1O8OdCYH4Sm9knudfRuwZHyY+j
         mGig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NOIXpXvTpUj58P79LwfhCiCzJogECgIYqn/HTVk5Qoc=;
        b=tw2GXofPBugT/JS6GyH09WGU/lwj8mdZrrdjf0HYt/UNPjJvZ2e+iQbLKUxVUna6y0
         3a+j+1ms81+/ofVmmhqo/5mWwEi42ajWfnfhAEaag0cv4kOd1dr5gRwU0vDWc9camO1N
         e86qH55Qo4HvluKBsDe7sS/Ayx5YBk3CvvBSiILi+csjwZ/cYhNrJKp6qcQP+k5CYAds
         RMwob/Ho6ZC7rhe6/sjV2aCmiQclP2HOUU6ff90qNHN4aZrVac36yidLXHQgnqtb9sz7
         EJL3IQiGuMbhw3Gdj+3AanD1+8cpteLftzVkS/d49hG7ymgUeuD8Ouz9qwwBcmZnoRy6
         YVIg==
X-Gm-Message-State: APjAAAVZqfP2iKQM0VqJ6Na83Kq336XhzzM5dd/X8BpJpvgNnacqrM7M
        LI2IXpkrhdDpj9hxicczyTwPKLQmA2sZqA==
X-Google-Smtp-Source: APXvYqzc8pq6zygfuta/iKgIatxsrzpJZxKNcfVCG94sERliVbpEYHx1P7Y/pPDzybMHPhEi1biTgw==
X-Received: by 2002:adf:804d:: with SMTP id 71mr5812606wrk.3.1569375529196;
        Tue, 24 Sep 2019 18:38:49 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w4sm4428092wrv.66.2019.09.24.18.38.48
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 18:38:48 -0700 (PDT)
Message-ID: <5d8ac528.1c69fb81.e5f87.6174@mx.google.com>
Date:   Tue, 24 Sep 2019 18:38:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.194-10-gb85025f46dda
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 100 boots: 3 failed,
 88 passed with 9 offline (v4.4.194-10-gb85025f46dda)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 100 boots: 3 failed, 88 passed with 9 offline (=
v4.4.194-10-gb85025f46dda)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.194-10-gb85025f46dda/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.194-10-gb85025f46dda/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.194-10-gb85025f46dda
Git Commit: b85025f46ddac376da82be90d1c93804c71075a4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 18 SoC families, 14 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

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
