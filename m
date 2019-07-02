Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3A8D5D2EF
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 17:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfGBPbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 11:31:14 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45298 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfGBPbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 11:31:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so18293330wre.12
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 08:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WWE5bHOw1Gq51lfvLp+0B08xrxTgYhFoofF71iGJ9FM=;
        b=r/4UrFUO0qzzrYyhGVcJfjrWRZc6O3cSIlBWJrU8GIEiSEUjIPcgjmZGtF8pug8r3S
         ILCEUgJPQfdwVbbFEw0V0jBVfMdRcaZ0+h4bX5LGoNn8KErxoI8uKqG7luZVIFNtdFUu
         /lUjFsqVNWMQdaCT0SJlzj9gbvT718kSYjb3mbHriHq1mv+3pnO2PuowMXz4BcTfXQM6
         6DJ2uziC1nodAoQBqOPwyBJnazwWPMibc8hyhP4JQ2r7lfoE+mWfLQmDJiJLLbeNIl+5
         2D7E20uEXFB4b0saz8jRMAzmYMFLNV+5vPF/4hc3KluIQ5zaH7mwwHMNEKz9BBwE/g1P
         +39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WWE5bHOw1Gq51lfvLp+0B08xrxTgYhFoofF71iGJ9FM=;
        b=m0C1a3zFJTHWS88UhLqsC2oaxdeXYBqGNekOA8uTUDHWMKdfuA2EKoVvHkcZti7erj
         imhdsyz8ajnSKfFIPUjt/ThuUCGjG1vDVwxfoo5ZXAbijB2rhqf8wVo8rWoFp/PC/Yvn
         CKZmM44k6lFulRQqnv8EzgxneAvaguoMrgOGTu8uTLBineOHHvG3Z5aCgUBL+pIvsVe7
         DcW2t2gB1T704iAuanvwtwubPO88V4kDIwU8QBcbK1E+g1kyO8bEDmgqArK0BWINHHlH
         M8J03Acz+c1eUcTdvrt68UeQ+ZCtV8BuuUKVh3S52T/VuwWR3RpRIO23LiVpAaBofYq0
         ienw==
X-Gm-Message-State: APjAAAW8qpIjnNzDNDoyLcDgNeCE2+2CsNbCQ/gPIkl0wu8PNo1uqX9E
        QcX/4Ta5PxRywXHWeERkcWEgFaaJ0YwQXg==
X-Google-Smtp-Source: APXvYqxKi+3L+weX7AmCRP/3CY/cepcPPYKD2Qtej8yknQfoMj+YN9KWiAPoTqTD9le6z+WmJjI8Pw==
X-Received: by 2002:adf:fb8d:: with SMTP id a13mr24217731wrr.273.1562081471542;
        Tue, 02 Jul 2019 08:31:11 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s10sm3890542wmf.8.2019.07.02.08.31.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:31:10 -0700 (PDT)
Message-ID: <5d1b78be.1c69fb81.ceec.803d@mx.google.com>
Date:   Tue, 02 Jul 2019 08:31:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.184-47-gc83cb33c7680
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 96 boots: 3 failed,
 91 passed with 1 offline, 1 conflict (v4.4.184-47-gc83cb33c7680)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 96 boots: 3 failed, 91 passed with 1 offline, 1=
 conflict (v4.4.184-47-gc83cb33c7680)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.184-47-gc83cb33c7680/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.184-47-gc83cb33c7680/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.184-47-gc83cb33c7680
Git Commit: c83cb33c7680a459427d388601e2de866383b3c3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

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
