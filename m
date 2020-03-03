Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AADAF178505
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 22:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgCCVlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 16:41:53 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38864 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgCCVlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 16:41:53 -0500
Received: by mail-pj1-f67.google.com with SMTP id a16so1949800pju.3
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 13:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qsUoRrPfl92A5F8Q1+47WIaxZk6H01ZF1LfW0xAH+yM=;
        b=Q9PsRoir+kGLaTC10P4U0spWuWEFH5lhEozgCLTE2Mecytt+EJSUPs7it3CgLLvXvi
         VEcDoasmd/1w3nntxvftfKeHbB6P3wHmC2wqKLVO3jIF4IIS30/EhloA+6vHbyxISZXx
         jZu5ZObf3pzTB1xhSHBC59U5zTfKdUQPB6V2grnUGVccFYpM/IS6kuMFdwsv3xl6gv0n
         1Cl07Jny1dzFoDd+ZUCMB/n/8aP3cE9ePaFUGwF5KSXu/up1tU8N9hsY1uxzCFVBh1Ua
         ZkWCIYgR055pjODmme5zAVJiYzTjikgebOot2s+Utr8cZXJCHlG9ubwa/MC1eoKgKiIm
         9K2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qsUoRrPfl92A5F8Q1+47WIaxZk6H01ZF1LfW0xAH+yM=;
        b=pEUgdCxAp/txKr4U2/B/GKa8UV+SMUjx6CJNrFzAeA1BvDvoUwiq9IszRnQ8mR0dlQ
         Xdp1c5QPuLDV8uRh1VSBPaBA1lpUvkOVMJIkry+flmpYYIts3XhgMtyVVtDOC0H+L4yB
         Fs5IhI1IA6U4E0HkWbOTxI9w4/Qh770OQdJOM68eDfSCbiOGCiiPojzFEyucs/MUCLNR
         o2LgCqE6tk5WzBS95R4x4+nkqPVatFk+u0SU3zbQqWvrltvEESocgSGqsRe6F1Nb6KNa
         Zc+Ky+Yig5ngrJGpZtXtzsHqBMLNiTvCSPC1wNmPlBJ1RovL/5SMrF4UT+Iuk1mW+UkK
         6xGA==
X-Gm-Message-State: ANhLgQ163bN/zOxxP2ukkduQFZcb3PlD+W+1rVTxz6LelECK5Kq4wyu6
        wBfXM0Nl+IoyMQMDMSP3XZgrFMWZtZ4=
X-Google-Smtp-Source: ADFU+vtLFaZ1x3v7OQPrRb3Z4lUqM8KRVkI3bqKRVflEBNFBKzYRWj5Wtd8Ya9sXIpoQv8zWFOv+QQ==
X-Received: by 2002:a17:90b:1953:: with SMTP id nk19mr106704pjb.98.1583271710704;
        Tue, 03 Mar 2020 13:41:50 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k5sm9275554pfp.67.2020.03.03.13.41.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 13:41:50 -0800 (PST)
Message-ID: <5e5ecf1e.1c69fb81.859e5.83e9@mx.google.com>
Date:   Tue, 03 Mar 2020 13:41:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.215-40-g1fa7ed0f8748
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 27 boots: 1 failed,
 26 passed (v4.4.215-40-g1fa7ed0f8748)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 27 boots: 1 failed, 26 passed (v4.4.215-40-g1fa=
7ed0f8748)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.215-40-g1fa7ed0f8748/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.215-40-g1fa7ed0f8748/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.215-40-g1fa7ed0f8748
Git Commit: 1fa7ed0f8748196d68b94d8fc02854ad52f63ddc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 19 unique boards, 6 SoC families, 9 builds out of 190

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
