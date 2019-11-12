Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83FD8F9008
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 13:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfKLMzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 07:55:19 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:54454 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfKLMzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 07:55:19 -0500
Received: by mail-wm1-f41.google.com with SMTP id z26so3021245wmi.4
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 04:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=POHQQivOEtmm3ya5fLOC/uZHcGlztWu0asRR/+VKjhM=;
        b=P3Zj4WyDpUsiFo5QPG5NdpvgZcSrGwxGIeVjtFZbjoSSJd3mB1/uYzZmARvcUSdjZ8
         udvaWW0IqOpNqldV3r2QuhJWeej9cUTJ61KZe2hv0i/VnDGwHO0BG2haM0X6Hb+OgQ2f
         +NUnC+7I2UHM5KyO+ajRLA8UsmMi6dXL72yDLuhnjkomMEaftviv1q9uRoo1fBy1t5al
         Fyok7P43Hak9aka/KCyPBAG9OzNdf3D55qCSJzHOxywgE6RelUqfAde9uI0FujZUrjGh
         4G1uU4dWfxRixlHMYOC7kcr6MWA6MGBwMf+O48zMcTAYKzi7Ji1PFXRqrzyNfGu0xqyS
         IYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=POHQQivOEtmm3ya5fLOC/uZHcGlztWu0asRR/+VKjhM=;
        b=PIAz5TTTrFikksxOy0qM3zZDcvpFsxad2jB5BgFjzBG8uiYFGJBp121sB16raU6ElU
         8dDsertH+ox4odrVg8Z/8vDCLMno4W2u88RJZHV6/qG+DxHdHqe+Y2eZtx/JqHVNg2ax
         HKTDLz0iC7tlqQFA3Nhf4DYrE4aHqcamHH4MXiDIjitIDllrARaY+U2sI7TqrSTe3han
         SUDcvKOygB5E6ciAarpxyKocNDINujlMh7xTAygVDObI6s27X4hQugdocQUc2uUEY2nd
         XZxa5y3gvGYKPEKuX6SgaGBdMGZkKBCLNvIHtk7/RzBV5Kw3mKUGvKyWTOgKe8dY9+P/
         2Z6A==
X-Gm-Message-State: APjAAAWaHnr/jrxU64SmXOW9IvC5SQq2lFZV8DxaDB2dRaPl6uWk8qTG
        PmIa30Q1SjJdCz48pno7gpQk2+bOcf7+Ww==
X-Google-Smtp-Source: APXvYqzmRiSbrKGE9FO0f9P+iqy2Wd4YfRd/89iHM30TvtSEHrFPNjzsrQLhQuOVlnn+zxzQay9Meg==
X-Received: by 2002:a7b:c308:: with SMTP id k8mr3640188wmj.32.1573563317113;
        Tue, 12 Nov 2019 04:55:17 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b8sm17754414wrt.39.2019.11.12.04.55.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 04:55:16 -0800 (PST)
Message-ID: <5dcaabb4.1c69fb81.d8022.5b95@mx.google.com>
Date:   Tue, 12 Nov 2019 04:55:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.200-65-ga3a12cc6ffc1
Subject: stable-rc/linux-4.9.y boot: 93 boots: 0 failed,
 86 passed with 7 offline (v4.9.200-65-ga3a12cc6ffc1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 93 boots: 0 failed, 86 passed with 7 offline (v=
4.9.200-65-ga3a12cc6ffc1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.200-65-ga3a12cc6ffc1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.200-65-ga3a12cc6ffc1/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.200-65-ga3a12cc6ffc1
Git Commit: a3a12cc6ffc178797f76cc8e4424477336e09efb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 20 SoC families, 14 builds out of 197

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
