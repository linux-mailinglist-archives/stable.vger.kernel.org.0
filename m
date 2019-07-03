Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A636A5E8A3
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 18:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfGCQUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 12:20:23 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:53797 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCQUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 12:20:23 -0400
Received: by mail-wm1-f53.google.com with SMTP id x15so2828980wmj.3
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 09:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=moQmDo73aGjSsDFtKe1evo2KjKdckq3e/b7vUIDdn9I=;
        b=QfVzkilfyvBJLjWzM1gyGoA9/2rnXkdnY+mEVHUw7XIPBUCEpXol9pKau1o6OL+tgV
         Ni7hMm7w4TwxPUNviDj4iaULtkK1Wpcdn88Q/JNl8XJc0Wd25kzFQDuXew426hvKW0QO
         03GlQg0Xmcwx2FhE1uVQEp+MbMgeUsvWCRA3iUX2qfBi6+/oo7LZ8ATkiyZODOoGvaMC
         Kan7/MhOPg+exEgZwo1UQYzBAUReMzFSAsKd8SY6nyaUsQ81A9ak7ptlJch2OFIoNIrv
         NV1wGiJXwAXf1VewuqmzgwDlzwOVQdF61NEqDSp9y6fQWujchwTpCZtOOV9MEhtEPgEj
         fHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=moQmDo73aGjSsDFtKe1evo2KjKdckq3e/b7vUIDdn9I=;
        b=Uiy+0RJYPlvLX+fMdzUUtig6D2MQDSup3K4XjxZP0MsEHej/pFwpmFe9XjySp4wCdq
         GJOpL8p6VKbVKCBuJHLdaA4jx+/DLtQ5adisgcZhMnw5xWnzg9euTMZhaCh9DQxBQpuZ
         bpoJhsaBc64VP5i+ZnIr2WEbgxff0nxejNLibjbhcejKFySWFYyBy3YUUT8PFIBWfKPy
         UIzYXcFDIEhrihYwZE+1pIVmgWGT0CEfM6ZB/1Ema5qINPbZIlkhZP3Sl1zDHiUvJIqn
         uqX/DaHKE2sFVH/F52hXlnR22nhJ4StYlrWoa7A4VeTkJLX7Ezrj6N/Ivk9laTrEi3w7
         k0sg==
X-Gm-Message-State: APjAAAVV5iB3spKEmsg6DVwT8JbpfJAGkbYqRkODvcxRMcQ6mH1HFigc
        /PRqDbEpZ/058NLCigWrAfIrCJt9sEU=
X-Google-Smtp-Source: APXvYqw4lqzt4eCc7lQEWXd+MkGdgJDtjPUoaDAvqAX5GYgYkzS/41IC/R5d3oSwWO+eq6pDUROG6g==
X-Received: by 2002:a05:600c:2210:: with SMTP id z16mr8800069wml.29.1562170821503;
        Wed, 03 Jul 2019 09:20:21 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w23sm3200229wmi.45.2019.07.03.09.20.20
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 09:20:20 -0700 (PDT)
Message-ID: <5d1cd5c4.1c69fb81.5316d.28d1@mx.google.com>
Date:   Wed, 03 Jul 2019 09:20:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.16
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 133 boots: 4 failed, 129 passed (v5.1.16)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 133 boots: 4 failed, 129 passed (v5.1.16)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.16/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.16/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.16
Git Commit: 8584aaf1c3262ca17d1e4a614ede9179ef462bb0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 26 SoC families, 16 builds out of 209

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
