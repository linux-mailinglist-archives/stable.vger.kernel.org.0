Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5ED64DE5
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 23:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfGJVHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 17:07:16 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:44716 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfGJVHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 17:07:16 -0400
Received: by mail-wr1-f51.google.com with SMTP id p17so3892887wrf.11
        for <stable@vger.kernel.org>; Wed, 10 Jul 2019 14:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1SlUuRBWLDbgO80IEd5GMtdMSPBIFL7fVVnkLr9J4Ns=;
        b=c1JKf8AGbfN9O9IKOxuB1mhXBDVVdSbN7P5MzZoywlXQ6+1pCkL069HRz39L3pqouo
         tKOhduo15ZrDh55gZdLEAjQ7HPmGbhPTWemliLsxt4PQZzJhCh64Wc8uwm1ZfRS4yDo6
         X1YYYw3NV5Uk/7iN8XT/cXYrP25/1JLtZtN8nXUxA6AvDbClkoEe3u07uvEDa6PawyL6
         O1gKNIBXkDxUKLuVnsQl0E6NNVoYJ7quJciSIVVQq6pZMYR/ymUgECfXzdyuX2xUB33U
         OM1jeIV81azwtyhvA/5C00Z9xKzHKNPOuR5c0WmcWoa6qc9bivH9FgzvOfPUxUnoWOJt
         +AjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1SlUuRBWLDbgO80IEd5GMtdMSPBIFL7fVVnkLr9J4Ns=;
        b=lUZIX52zMA2x+2e7UEPEVf5h2K3gIE6WyxdeCfddXiM3uK/YJutfsEGk/J4NlddHZy
         TpHSPQOdoAboJx6NNupcVv76k0u4xZoc/OB6C2qZz3xH2GXisVBnQ/FNHGu0svJIqlQB
         ZkKwlpAk7lWPHwmNhjhBzG2MajWaqrdoKyqPOHDRHdT8xIIFqh8vY2cWjKuAmHVB04hI
         /F4OtEABjJbBTfBrnb/yz9COfXHwUbly7dDPSOqJ1VJEOGkGbdo9Ecy0De2hx+IwaKQS
         qpAB9UT4923EAiooesaJZkP17c4pPMicsLF+BtfYVh9twMDRuPvcyQK+Wi2uRFsV6zzJ
         rPuA==
X-Gm-Message-State: APjAAAVqUH0p5lFRlo6kZZD25MDuCNuJJgvlGofcukQ/E/gFakKZpjoz
        qb+aIx0WAGMHFyHx3Dit3VA5s4+FAwmHHQ==
X-Google-Smtp-Source: APXvYqwFigA65CQiS+nVMqPQZnLC9Xt4kRf+qqtLnd6HmO2pLqa47mBmQWbH/DedDT2plNx7A6MoZw==
X-Received: by 2002:adf:f84f:: with SMTP id d15mr32665267wrq.53.1562792834591;
        Wed, 10 Jul 2019 14:07:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o11sm3526849wmh.37.2019.07.10.14.07.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 14:07:14 -0700 (PDT)
Message-ID: <5d265382.1c69fb81.3d170.52b6@mx.google.com>
Date:   Wed, 10 Jul 2019 14:07:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.58
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 119 boots: 2 failed,
 117 passed (v4.19.58)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 119 boots: 2 failed, 117 passed (v4.19.58)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.58/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.58/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.58
Git Commit: 7a6bfa08b938d33ba0a2b80d4f717d4f0dbf9170
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 26 SoC families, 16 builds out of 206

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
