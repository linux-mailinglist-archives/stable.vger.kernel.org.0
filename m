Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62D82FEA3
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 19:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfD3RQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 13:16:10 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:38614 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfD3RQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 13:16:10 -0400
Received: by mail-wr1-f52.google.com with SMTP id k16so21944566wrn.5
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 10:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vbu+duPQ3Gidqyd1HzI106GHPJ30aNP6V5EEGGBDfZA=;
        b=gt2KjbGTO24N4JWvCidyK9MMLFo7/dowkYbnonUMNRcpvPde5ztCcP98p+XsFTXkfQ
         QZBymglKYoPL6p60H75pN1cAKum/HnoKZuMXYrguJgJu+d/BLQMzAmgHp2LK1SIatpTK
         g6LpdIV7OUGKKg0OHclMHbidAW+Uc1+19cYiVMrU/e4Tu5iN3O7OXjGOX3T3CrCOcCuW
         HZQ62gwOLgL1l6joPXN+3s0sCLYK9hVZIZFql0y8/k4ceEvSPE1cu3qH70sflBjrhbv9
         Brgud5oNakEwnB8kEZDrld+ICqQUoVUcw+lQSRNmMHqjQKMoHg6WHcNfhJKcFDQsPcsd
         wWHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vbu+duPQ3Gidqyd1HzI106GHPJ30aNP6V5EEGGBDfZA=;
        b=savjQ08ml4B7y5SoxVEIkMpLGUGsXfBaE5ZedW2nWp4byTWuy1v22n3vy5vlckSdEx
         j/vViFG9YGgjKYpJnVjsuLTqJvsFZ80Ym9O/XGSNIU7oaeMgcSis14I81q3QEQd5ahB8
         nRZ+EOtBVS2EJoIgwyoOks5Ufr73ajZencLjMIux3GbVSALkyvFl4yaD6zoJ7z1pU0M3
         goBbiFhxMo8jnK0Sh3hDKXiCcLHnCZxqhSkcjh0ne68LSfHhRUCYkwmrIG18CiVIqI3c
         VNm+xcV5LNBe2K8zG9G3TPMFkPatd58G7Dt7mMtFcZ5ZoH8etP7XgHjpgoS1arHqV43N
         qblg==
X-Gm-Message-State: APjAAAXfwQB5Wz8++Zrp8wi5VS2BnNMi/mzc8XmDOyMz+xPLcFKcXrtT
        DlzhQ++I+B5GTpY7CcXtU3tF0Wfk7H2Ctg==
X-Google-Smtp-Source: APXvYqyR2oCmEGuTl0o3DkJ6FfP/TKxlGC7MXP8sOoQSXFgweAl1me3bM4nyahllRniwq8RUlOamCw==
X-Received: by 2002:a5d:684c:: with SMTP id o12mr10143303wrw.308.1556644568116;
        Tue, 30 Apr 2019 10:16:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s22sm10122891wrb.44.2019.04.30.10.16.07
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 10:16:07 -0700 (PDT)
Message-ID: <5cc882d7.1c69fb81.dd762.70e7@mx.google.com>
Date:   Tue, 30 Apr 2019 10:16:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.37-101-gf0b5b3d18a2f
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 122 boots: 0 failed,
 121 passed with 1 offline (v4.19.37-101-gf0b5b3d18a2f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 122 boots: 0 failed, 121 passed with 1 offline=
 (v4.19.37-101-gf0b5b3d18a2f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.37-101-gf0b5b3d18a2f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.37-101-gf0b5b3d18a2f/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.37-101-gf0b5b3d18a2f
Git Commit: f0b5b3d18a2fd4e0a223ff2ef04d4d1f435d19f2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
