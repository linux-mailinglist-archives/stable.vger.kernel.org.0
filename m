Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D7DBF217
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 13:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbfIZLtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 07:49:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36393 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfIZLtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Sep 2019 07:49:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id y19so2409004wrd.3
        for <stable@vger.kernel.org>; Thu, 26 Sep 2019 04:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CzcKgp6Y4e5axoFT4WuP6BW7rdLdvOMC+n/0DP3KKS4=;
        b=rCWq0jYRmpuqlu5tXyPqKwV9D7QClSp4uVsn0H9p+F0w5Mx872b6eC+z8BmfxhoTTV
         rVR6k+pA1GMoeOGuWMzAch/EMn255Rokat5CgvrMUh8r/W9WqXm4IL2iN4RtfDkwvIAo
         iszf7VaBYw06DqBUnS6hNSpwP+kmYDMq3PKFrgEaDLSYXubErg2TrMGqfHUfuoz8B8GG
         h55tMcolBY94qKylXgqVsQstKYVhYThq7OPpaJs8i6nz10cLxNrFobUZzJkBLFwRGzRm
         lNIOUlqS37AxnCjJQ0DIl4kNXbbDIGIGbjKwVL1zbrqExnBYDxl+GYAFAja4HSkqAPfB
         acVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CzcKgp6Y4e5axoFT4WuP6BW7rdLdvOMC+n/0DP3KKS4=;
        b=ImrrVcYV9iKGvZHTs74QNmPNNjlkdbJAhQgAbd26NYVkH8VIM+0GncQ/viLO7yAHjR
         HEqsomhEsXJO6DWQs30I885eszjcb2dTCTbUmKBB4TotbWmO/mtBT9dAgAe2qkpUe/jV
         gM426lDbcMxAcZK97ysPhL3rVucG/KqYUGavEih2hKFLvmi8+CdcC8vYTbqgVE0Xo/o4
         LRnjIkA6THa+g8vMkgPidQE3Te/rAUfma8mNpVWsQd/qR9cuCviJcCN3fW35lV+tvujk
         acEofReKSRaBJXrMbFBygq8kEfDh0BAf1nA8ewCla4O4DyW7zYtw5zSsfJv63aSFktvK
         x77g==
X-Gm-Message-State: APjAAAWOWdKpZPRupzkJm2a2enQvxRTJPN1xFSL0DS5qtE+aoXt7QuoY
        pLosD+/zAB/Ni+HnGgFB00D08pjdW4NzJw==
X-Google-Smtp-Source: APXvYqxqDrDnWIRA8QUlEG5MYsNn6ksZOj9JixkRNR1eOFeuqOGG+lg05pS7sGr6XowYEs4J2VlWNw==
X-Received: by 2002:adf:bb0a:: with SMTP id r10mr2744813wrg.13.1569498582983;
        Thu, 26 Sep 2019 04:49:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e9sm13093271wme.3.2019.09.26.04.49.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 04:49:42 -0700 (PDT)
Message-ID: <5d8ca5d6.1c69fb81.64de9.a764@mx.google.com>
Date:   Thu, 26 Sep 2019 04:49:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.17-30-g5b2060e36773
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 143 boots: 1 failed,
 133 passed with 9 offline (v5.2.17-30-g5b2060e36773)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 143 boots: 1 failed, 133 passed with 9 offline =
(v5.2.17-30-g5b2060e36773)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.17-30-g5b2060e36773/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.17-30-g5b2060e36773/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.17-30-g5b2060e36773
Git Commit: 5b2060e3677310bed166fcde4369192f33a508c1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 27 SoC families, 18 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

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
