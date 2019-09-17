Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E210B450E
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 03:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbfIQBEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 21:04:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45990 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730060AbfIQBEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 21:04:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id r5so1210096wrm.12
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 18:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cQ69EabX4V2cdGXLKX0M9oSdqTp1Lab4lD5UPFAePlY=;
        b=qfjjiDiiHByJ2TmAI0igSTgU94Kpv1agIbt3Rt4FXy20cGFrSgEoWR+MA+hEP3Oizr
         H/VVOp88EC+tiQg6w/6wMhUPVOqXj0bo5HQPQdi3yCma1QYivrfUN0Ddgoleiy+lUnNd
         xb56473JRlNTXW3vvGW3UVGD3mFJGizWr3LfBl4WTYV7IFc+Y+fizS9uaiMUlsxuXmuc
         DO8+UtiQwHCnvf2WkI3qn8ubxidcwq8pcm2hvBIu31pv0/npDFNfpEbH2HgkTrmmVFHs
         XGluZxBVbKO8XRFVF786l3211AZyu/z16KGGhiVcvG/wE+8O2oXRZyt97qhkO7BRrkP3
         T9hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cQ69EabX4V2cdGXLKX0M9oSdqTp1Lab4lD5UPFAePlY=;
        b=GIhTyLRZz1kVPm08gPxY15Plt8YGqkR2gf2XnxWbtJInbJ6616FIciXgcTphajKLCF
         LpBIK7eLpKDq44bGVXQUbg0ybYSEopISnPFrRHxebBMH+XlN1lRxE4UL9LjN8sX3cY72
         QELKv5+zmSTXsxADXLzuHIcSPmmVwREVbzDF1k7AiCpLhOZhn5w1vDyOLMxZmhINcys5
         Y3BaRyC+hS4Wwy47Di+Iu290SNfn+wes2WoY5mQAoZihSoRJpz/Yjo9LWTgEClLj8wyc
         bq+tPT6W/iTiro+IckR5/Q1r74rKbY50bBlVG+kMpHewFBy7eVMgcWTNv/XgC5d5nNu6
         WTFA==
X-Gm-Message-State: APjAAAXfC7yjhNgwVoHRci1YUy18eoshp3c4CoZqRVInjdIXZfOBKpyY
        r2SRK6PBcC6tqcovyCHSsY0qdqBrzH6mkw==
X-Google-Smtp-Source: APXvYqy5C4nzBPkxryizwb/SfvQ3z+I1XCUl0G1zorDe8LmtYUEEFNWb/uRzD1ZNxwBlhYh8C0cdtw==
X-Received: by 2002:a5d:40c4:: with SMTP id b4mr855490wrq.214.1568682286050;
        Mon, 16 Sep 2019 18:04:46 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m62sm652222wmm.35.2019.09.16.18.04.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 18:04:45 -0700 (PDT)
Message-ID: <5d80312d.1c69fb81.d4f99.2eee@mx.google.com>
Date:   Mon, 16 Sep 2019 18:04:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.73-27-g26ba31568b46
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 134 boots: 1 failed,
 125 passed with 8 offline (v4.19.73-27-g26ba31568b46)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 134 boots: 1 failed, 125 passed with 8 offline=
 (v4.19.73-27-g26ba31568b46)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.73-27-g26ba31568b46/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.73-27-g26ba31568b46/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.73-27-g26ba31568b46
Git Commit: 26ba31568b46f4c0bf86c1c5d006a2e7220a6799
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 25 SoC families, 15 builds out of 206

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

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
