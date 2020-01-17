Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 309F8140307
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 05:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgAQEfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 23:35:45 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:50895 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgAQEfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 23:35:45 -0500
Received: by mail-wm1-f48.google.com with SMTP id a5so6092605wmb.0
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 20:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vm1gt+XFKK8BZhnSlgSFslusp3SL2DzIE0J2AuvTFtI=;
        b=YiNF4BJHD45oEhZ3Tk4ZAuhjD4eMwKVxG56q4i2CL8cr6u8RMdd6o5G3/l3dd60ggp
         lFXDHvUn4rQ26MTEeF07cqDRedsAkaeJlAXF6dqkPsxhZrAG8rhZQORq65wgfS7t6l7a
         JIyIBZ3kuBnDvwiN2xrd7Z/pln2xIXJiz5FyMLRMCKpDvfd1HlCo9gtvEsBZtYuamOCu
         FJ3ovLeEwrBs1YWfIH22CAO0mInMKUJdSMjzE3/kZliHt/fLMJtCNGRMgs3pRRi1xMwM
         lXlMs09VU5rUVd4oP14PRvT7drYmOj8ziNiBFBcMIKESNGxAZQoSbe1MrabOtIS1jb35
         AXgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vm1gt+XFKK8BZhnSlgSFslusp3SL2DzIE0J2AuvTFtI=;
        b=Dlvdr7GtZJKM3GczdwfnLWx5H+LEMxdAH1oDbhLAoRVcKVnDooPtHqn2L7L+nRqddD
         kFd9730bsocHcdiiVUBYWUp1kUtAeX7HuQqD89GU2x9SLkEy+BvvTm/hXQYivOvOhh5s
         Cqnj5PZpWrwrhw+WbBkJCm/cemVM+pw/riMI3/ZktbhOKtEG5qLvVhCTk3WnSrf5gOiQ
         xtiejdZzwDegCGb9oFPWsi+8SSLU9AVPYx9+fL8GDNw2nTUmqsdnwPgTXdbLGW4C+GT5
         M+Rqz33bf9VEHYH9HOlmEg0GvTBCOJFa/eqaRxG06hlxgs2fWWhPcLFMPg4HQ5KGo3uu
         GyuA==
X-Gm-Message-State: APjAAAUaJQYiIrLh+hI8Jz58SWfSoJK24Ob9xQj8mPz8JHrRWtvmLHvI
        D1ypKINo4+QzKHg3HxTZnhcYcGjdrWJt0A==
X-Google-Smtp-Source: APXvYqxZw9UsVeUvIS1Mgaj98QYjKsgH87/tdgXy9UKdU+VrgAgIh53nb9JJ7Mb7PdZZY4ti9QsMqA==
X-Received: by 2002:a1c:a543:: with SMTP id o64mr2525349wme.73.1579235742893;
        Thu, 16 Jan 2020 20:35:42 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m10sm32295700wrx.19.2020.01.16.20.35.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 20:35:42 -0800 (PST)
Message-ID: <5e21399e.1c69fb81.ea23c.4dbb@mx.google.com>
Date:   Thu, 16 Jan 2020 20:35:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.210-40-g10cbf6496fe2
Subject: stable-rc/linux-4.4.y boot: 81 boots: 0 failed,
 76 passed with 5 offline (v4.4.210-40-g10cbf6496fe2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 81 boots: 0 failed, 76 passed with 5 offline (v=
4.4.210-40-g10cbf6496fe2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.210-40-g10cbf6496fe2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.210-40-g10cbf6496fe2/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.210-40-g10cbf6496fe2
Git Commit: 10cbf6496fe262d809f05cd252925a85dd2072fa
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 15 SoC families, 14 builds out of 181

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
