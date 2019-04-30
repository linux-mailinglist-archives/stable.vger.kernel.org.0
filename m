Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D624FDDD
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 18:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfD3Q3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 12:29:24 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:53420 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfD3Q3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 12:29:24 -0400
Received: by mail-wm1-f42.google.com with SMTP id 26so4542475wmj.3
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 09:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KrRivPyUqgkAQcgETJ7xJFOoigbSSnvVhE+Gx+6/oB8=;
        b=ym7q8xtOSnOW9lyJm8yzpwFqD4RrP9qh4GeU3WBnurAv20G13sabguiDzgn6bJ7vVh
         XqV9WOvWH79+eg2r2YwjS2G3JXRklCrHNFuao0UJ69X8fKqvrTLqWCk/tW2kq7DHNo9L
         fn50telb0qHIR0st7Wlt8IhFaFc6bzTEgeOP8z+6AQA+JDBJuygmTQxeK65/yFokXMuN
         SWhEEHO3iuyeMzhKClpcP73ObDAMCGg/MRCfrNkcAet32NOVozURFYDUJ5aXQe2N//4f
         pj25cyX/DOoWjdAdgqFvRm1OZBCj2UQtAhP7DQrKp9vk8SthHIVtBqCg4NA99vSBr1Rs
         BM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KrRivPyUqgkAQcgETJ7xJFOoigbSSnvVhE+Gx+6/oB8=;
        b=cZjl8V3QXatAxElAT5CdubF4inULIufg+pvetTQiQCqQJVgG/YjPXsVxiMsBe6BhUF
         gkbVfFfRqqySsCo1Le4rOA5UpZJGGfo2pJ749q0G7yu965kKHT9Ldzpxf10U9/84wR3d
         HXC8asP7ZAimJgzI2y/i14UMalaoxQv0LJkCSPH57OToOtB2DduKKrLZRPg1r9L3souY
         tiw8CEm85Piad1pT571csTW/cx+mr4AUfWZsmtZY/9QzDz5WgTK9ZMMAuNAchNb/VvhG
         zF0zSOtolqHcv7fAUaD5CdSfPSMhXyXyPqsoE6z8NeXeKD+5euu4w0QHOsZzyJS22Yq9
         jVmg==
X-Gm-Message-State: APjAAAV4PteSGsIgxlNsti+TOEZs22BEiMhCRqeG52pJtzyU4C3PcO7/
        LJ96d+5aSXRNhPdEggoJ/yIzbkMcjHHmNA==
X-Google-Smtp-Source: APXvYqyTNCz5pGjongIMUWaSDUD/tfzqDvQMTWyi0tsWrbu8qN2Yklrg4aMBRqLvYa4K2hgj10rZ7A==
X-Received: by 2002:a1c:c703:: with SMTP id x3mr3583301wmf.127.1556641762425;
        Tue, 30 Apr 2019 09:29:22 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x20sm18391704wrg.29.2019.04.30.09.29.21
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 09:29:21 -0700 (PDT)
Message-ID: <5cc877e1.1c69fb81.f5323.1e96@mx.google.com>
Date:   Tue, 30 Apr 2019 09:29:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v3.18.139-14-ga97501af756d
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-3.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-3.18.y boot: 50 boots: 2 failed,
 45 passed with 3 offline (v3.18.139-14-ga97501af756d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-3.18.y boot: 50 boots: 2 failed, 45 passed with 3 offline (=
v3.18.139-14-ga97501af756d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-3.18.y/kernel/v3.18.139-14-ga97501af756d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-3.18.=
y/kernel/v3.18.139-14-ga97501af756d/

Tree: stable-rc
Branch: linux-3.18.y
Git Describe: v3.18.139-14-ga97501af756d
Git Commit: a97501af756d37b4bbf97f0e8542283464901b06
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 12 SoC families, 13 builds out of 188

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-7:
            minnowboard-turbot-E3826: 1 failed lab
            x86-x5-z8350: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
