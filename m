Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 373C783D85
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 00:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfHFWrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 18:47:49 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40673 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfHFWrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 18:47:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so89376987wrl.7
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 15:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2OtBhyxZz51uzLQ8AFKV+B896C5yQilEcFJLalpFQrM=;
        b=P6AH/U9Dj8Ker2Si03xHMKot5qa24PDPewih6whLkmWs1qWMGJHMDDOyRgYe9klJbM
         IioGatVXvVStbkXb1ye0pv6No2iti4cic8BnjRuiz5P4rnPntfzDaGtRuvde8RMZQGpE
         gLo5Ob8sou1aHHdVcZdVJq3VPChr/e298Vyby/uiACQxEtY2f0y8ydvPHANLlNmS05xd
         RZij7xi2RwoeGQiH2mDdY7Dc4q2Vaj+6aq3zKDW0942Rs7dIWLfFICHrxHsLjxSe27fL
         oCCpXHw87IJhbrGxkiPnwfi4RQvMEm8R+u1IWT/dH0LazSeytYgaP3pkksM5fbcnqBl2
         7ssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2OtBhyxZz51uzLQ8AFKV+B896C5yQilEcFJLalpFQrM=;
        b=sHMjp2waoKE/316Hw0IjbEKy2QfC2Z++nhe2qB87Eh3We5G5krD+ex4OYNwjnyDQH6
         a9cCHHfQ26yd9BBLdkdzBU+fSoTDGUA+6e36+gQma5JEqt7EI02/p3uVgUPeGmSR4/kO
         NVU/oJYvWFlDuiPd9k5FatGfdI7TfF3WkV+mZrr2VR3AFMRV+73iGKZ7se0H3WvW+mKE
         4t6J10pggZpCrOxkBpK5LPVTWK5WntyoYKHiCxgFRZQdDhcih0uClSiAs/8CqL1JFB4b
         qGQm+3kugCLdNPCTZ7QvAWdtmKeOtfj9MNsAcp8s13I14YIdd82P0ohntkoODif+XmBX
         sVrg==
X-Gm-Message-State: APjAAAXlvqvOtxwmIdQ5iTlkYuRPdmLu802G4QJy9wc5e9gVfVcYDd0+
        F+qTQbFgH0Fvvbvp5tYlSKKIprB3+7f1IA==
X-Google-Smtp-Source: APXvYqzafgWnSuyOrbeQGbDtjVv1bshr87HXfHvzIieBJEzLB0O+YZaUQNPVTrt4VQfdK54w0G2z0A==
X-Received: by 2002:a5d:4108:: with SMTP id l8mr6460029wrp.113.1565131666799;
        Tue, 06 Aug 2019 15:47:46 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i24sm7258299wrc.45.2019.08.06.15.47.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 15:47:46 -0700 (PDT)
Message-ID: <5d4a0392.1c69fb81.d9648.4228@mx.google.com>
Date:   Tue, 06 Aug 2019 15:47:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.137
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.14.y boot: 46 boots: 1 failed, 45 passed (v4.14.137)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 46 boots: 1 failed, 45 passed (v4.14.137)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.137/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.137/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.137
Git Commit: b19ffe6e7205c0b0d26b750673873f3f9f61da35
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 24 unique boards, 15 SoC families, 10 builds out of 201

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

---
For more info write to <info@kernelci.org>
