Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AB6147012
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 18:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgAWRwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 12:52:16 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51562 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgAWRwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 12:52:16 -0500
Received: by mail-wm1-f65.google.com with SMTP id t23so3495499wmi.1
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 09:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=L2qY28I6ErxkS+tuWTHZecIT8UI5oz5SkvFQiaDSz+0=;
        b=Hl/sM34hc2JMg5CWQd+YY23lFOkU0qy9vKN/HxG1Yky9gBBJa6nWYPVCObZV2EJqgW
         vwlvmX/cbiuRbV9H9XUtG2JTKmPrbxId0RL+qEqRt1ceZi8xazFlk50XaDZ7q717hHHn
         wgS4oyAHLKdVyx9mQJhDnRVEzYoK79yEOxcqe8kXTU1b/yUF672OhRvU9OURG86aeFAh
         KZT0grp40zeKAciQNLXLNDLVXeDeeJueSdNJofHkB9VMRRMVxCD/Rcxkr+7NpdWFR8y3
         X6GEJoQ6iMLDgRfnuTpufcOlLyzwVs920VaQAAAQmpipCSh9jzFOd9J9ubT1j+a1Khx5
         wLRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=L2qY28I6ErxkS+tuWTHZecIT8UI5oz5SkvFQiaDSz+0=;
        b=QfL9qydJfzQsh/b3B0EKeMLzdpGgXUiuCNfMaZlNi0Adtqt5EyH8QRhUmOTq8urgnk
         mDP5ex2dE8Z8kdSf07hoBpusIGOTScnGdT3i7RwMU4JMsWHONs8NPafBLCAZBreEO/X/
         aqZnf3MOOtti/o+AMRjqkh2XgnZDiQDmhOHb4CeZPB1Hx2tdRfdJaosjqR/RDobdMkib
         q7U3bn9rOr8NOadXz4vBz6ev+RJx9vuyyBp3KMvm28yDoC2+Q7JodHS1bzvXSJpL7wg7
         xxh1gYd9asDPDyF1jSx3adCPG7u0Pl223zlIMZp5J7n0/ZPMmO9AhiS9IZ4Jgj4crmN+
         R+UA==
X-Gm-Message-State: APjAAAXxrcj1gGITIoAaanPeZnzPP1mL6yd7vxQrR/gs+qPrNv0zjQqf
        6CayEbNg6/g8GQtLdifVDfKO31WgqKI2sg==
X-Google-Smtp-Source: APXvYqyE74voPb1/j+jrU5V9SrH3gc+20KroHCQmzM+JgevoFt5gXg3poYU5TEYuk/BizMUCyL6QDA==
X-Received: by 2002:a1c:491:: with SMTP id 139mr5354852wme.117.1579801934022;
        Thu, 23 Jan 2020 09:52:14 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b21sm3747065wmd.37.2020.01.23.09.52.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 09:52:13 -0800 (PST)
Message-ID: <5e29dd4d.1c69fb81.69c3a.fd8c@mx.google.com>
Date:   Thu, 23 Jan 2020 09:52:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.211
Subject: stable-rc/linux-4.4.y boot: 82 boots: 1 failed,
 75 passed with 5 offline, 1 untried/unknown (v4.4.211)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 82 boots: 1 failed, 75 passed with 5 offline, 1=
 untried/unknown (v4.4.211)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.211/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.211/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.211
Git Commit: 4a070f3c06a103066c3155bd1ed3100aebea1a78
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 17 SoC families, 14 builds out of 174

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
