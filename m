Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D65BE135D2A
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 16:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732630AbgAIPqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 10:46:47 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36294 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731203AbgAIPqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 10:46:47 -0500
Received: by mail-wr1-f67.google.com with SMTP id z3so7923436wru.3
        for <stable@vger.kernel.org>; Thu, 09 Jan 2020 07:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=29JIkZLKvuzVT8Io6LOyAnZVAnSc6F8r8VlXDpCw6SA=;
        b=AbaboI5UqxULcT9DWrzAqNqJvHHLIZKyRTe1vpBeXcxUlIwIZ7OHRB2jMrjFgwi5VP
         kfPJ8FNFHg7fYLVo7Li5Dn1tuLy060I+0/DXe30wFSFYT521pyev6Fo2NXEiloO0bVeO
         kuLaKe6VufVP06f8uIasN4zR10+o/NPHiybIuJPGfN/Fg0olEOBdZtIEMDmtzvS1nodW
         TDI4xk/HlTO9Frp70nAQsjbVC6eowhtfWv+gHwJxlFSpGcR5AQJS5oCvaDrcfmDIlnzo
         xnK3LXstxPdmNW3cuXFwKCCS1bqgG1RgoaggwzwE9e+EAIrfQCbyaIox3w6KAqgVJU0b
         zaLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=29JIkZLKvuzVT8Io6LOyAnZVAnSc6F8r8VlXDpCw6SA=;
        b=C3qNmvpTNJmuh90yNW2bxfqJwQ/5tPzO/lVmJr1DNzCnqKfyGtu/1I2Q0hMtMHRyTp
         bJpiovl+emtn7sFmw2eawGT/JjKQfqgSp5LykrbFExWVRxE1i1CRBBGKFrJBqA/kKTtb
         9ubagh2AVqE9YYKC6BXV8fKoeNI4IbFVNTXn7gSziRMcSCOfCIFzWXKggPy/VfUfEb9h
         On8xwXJI+MA/VHo7i0ToUmDQiht6HZNwU9TM/07K3LV7wRCEfHYeF+XiWLIv+DIOQzvd
         zXE0d9EfpVrNNoHW1U3wbYvHq3USUJrvqCSKIAkWTQHNEm8uHPM8LQXwpDisUPGUXx/j
         qd0g==
X-Gm-Message-State: APjAAAVPPpBtLMyx7Dp9xsyIcZAF6DvqpiC46ZBEq6ZuuuigPzb0/5CZ
        BbW94udtcUfzTDRKWq9NXlazXfS+6CCG3A==
X-Google-Smtp-Source: APXvYqzra/xkI2e9j78E262DTmToEZB/3m9qPeEBl8cauTBadkjRsR6Lu5I+GfyDLeadJ+hsk1QelA==
X-Received: by 2002:adf:a109:: with SMTP id o9mr12484477wro.189.1578584804998;
        Thu, 09 Jan 2020 07:46:44 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x132sm3942393wmg.0.2020.01.09.07.46.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 07:46:44 -0800 (PST)
Message-ID: <5e174ae4.1c69fb81.55841.dd6e@mx.google.com>
Date:   Thu, 09 Jan 2020 07:46:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.94
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 84 boots: 1 failed,
 82 passed with 1 untried/unknown (v4.19.94)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 84 boots: 1 failed, 82 passed with 1 untried/u=
nknown (v4.19.94)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.94/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.94/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.94
Git Commit: cb1f9a169a0e197f93816ace48a6520e8640809d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 16 SoC families, 15 builds out of 206

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
