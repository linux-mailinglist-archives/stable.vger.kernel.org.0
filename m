Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4D65C5ED
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 01:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfGAXay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 19:30:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40909 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfGAXay (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 19:30:54 -0400
Received: by mail-wr1-f68.google.com with SMTP id p11so15602501wre.7
        for <stable@vger.kernel.org>; Mon, 01 Jul 2019 16:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9G4xGniaW2iHlV0p0V9OaoAvHVR6j8dBI9Xyftxvf8Y=;
        b=GLxqBQrmDm5iynyerrdxjl4zKzdUAuemNB4DhvpwiRs+mFzzFdGQp9NeyLKd050VXM
         T0c6zGTsNufDKtEhTWcp85BubgGtwklSblS6/EEnxBzmHd/2Rdo/Ovp7t0deUxcEhiyJ
         13xtgxjI1hyKEYR2YbXUXbh8gln67OCBnuEJi/j92lpRq6NF1BVTJrxRnIu32TC4m6aH
         lcBL2XZQwRkqiFFb1R5CwmFNNzsSBVDBR5DiDXImDlqkqUGSiMsy4DeN7vQJ5BivMJa+
         u7ze7pNnl2ywkpGilSoS4ePYK/5aNeBYjxic5qn4Fi7ELB3NmVEMlI4ccML2ffqo81jR
         nEvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9G4xGniaW2iHlV0p0V9OaoAvHVR6j8dBI9Xyftxvf8Y=;
        b=I5/zX4P/dErLEfRn0e6KwaNjkeUC7D2SaHtXlfg51nNv0vrX2PZ67wikfoco36oSM7
         ERoj7tcPZhObYvrmQfa8cF7eoEUNLDfzFzQSfNSWSndwqEorpxOoebs82RrwrV5bbPuT
         mBtNXOU+R0z4FcO9TWnbVZpTQcj8mSOSCdBGgPUcqxvC+xkUf5cfpAWe3ui7sewzO+NG
         O4rVXzPMkdK8IhJbjBv527s9oT5mVcMH4p2zEDBuQOiKfeYY6ptPAp13CtAALe2FmL9y
         B9xXG1YVEhLwf4lEW2nKQVDiVKAOcUEyWFtf1lzkMc1VBeqzqYIBEZtpaxeodIFpcCyJ
         6Ieg==
X-Gm-Message-State: APjAAAUVxNyPjSnp3CJ/N1aNEpztI1qge5WRb+kqOlAG60PjiyH+WFJX
        kFzGtDauOr4oNAXFTMvxHGC99jEnaKs=
X-Google-Smtp-Source: APXvYqzXUHPoGcPEk6oUxbe8HID3UCeUAAJruM1CHbPceGWJcHlVwI/ru8+iOJfy5O1xLm1aiUhJ9g==
X-Received: by 2002:adf:9487:: with SMTP id 7mr7204520wrr.114.1562023852213;
        Mon, 01 Jul 2019 16:30:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u205sm729356wmg.36.2019.07.01.16.30.51
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 16:30:51 -0700 (PDT)
Message-ID: <5d1a97ab.1c69fb81.17cfd.4a9f@mx.google.com>
Date:   Mon, 01 Jul 2019 16:30:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.184-40-g01f7af880852
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 99 boots: 3 failed,
 94 passed with 1 offline, 1 conflict (v4.4.184-40-g01f7af880852)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 99 boots: 3 failed, 94 passed with 1 offline, 1=
 conflict (v4.4.184-40-g01f7af880852)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.184-40-g01f7af880852/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.184-40-g01f7af880852/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.184-40-g01f7af880852
Git Commit: 01f7af8808524eea89b79d8e89f01a7a111ce355
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 21 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
