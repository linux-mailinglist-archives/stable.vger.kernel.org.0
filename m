Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E030A80ABD
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 13:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfHDL7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 07:59:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34842 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbfHDL7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Aug 2019 07:59:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id y4so81634256wrm.2
        for <stable@vger.kernel.org>; Sun, 04 Aug 2019 04:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2n0WQRkjMIrw4NdatIKbuiY1lO5FqcsyzIFTSjerhJo=;
        b=0rtNfpMOG+v/cn4Hu4M+Jsyoa6+EBaZjXjVcOP1bX8zV06MVZrMEB8gfzqNpD0hPCr
         CRbs+xUQg3OtoT4/4DZfu8UX+tfKyfgHYSSZZ1nUw/qK66IvBXJ/jtsHhB4hOQw/nsqw
         elIuvIPJp+iFQkwQpDMVwx8kqWP59Saob55ny7zTTECIQDvbAYURwcTH+Mwpx/G5reC5
         dwpeKuBp06twYCqzTQF2gm5//2Y4mqs9wiK2Pns4fDJCmztT90DlW2gHQMqSt+nowz0j
         8m95knMvUSYWbHYJM27ozZeeyZDbmwhVrp8gTF1OUD9r4lCZ1P2tQcx6Og2IEHxjC3aP
         RGhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2n0WQRkjMIrw4NdatIKbuiY1lO5FqcsyzIFTSjerhJo=;
        b=kQ+cTXPpLlMC57isJYdRTTXJLpzVCLrcW9R0lroEj7Azw5GLqtCltqDitsmi2ceKBz
         +X6t7Rvvgpil5slnzCZjrMisOVf1Ynl5vyZSKHKBA0RDbodFmuctqeQ6Fi0PhVIEZuEb
         6AQ2RQERiJfj6FmOnk1sRd5KS1lQFF3e+4KziuSu/1IvN3LseFozXLz+gPUc2mQhK1gW
         3YNu10KKV7bZpSwT8en5dTkgyfBcIbPNxtWWBKH1uWuVZUxaHMCPooMIYXxCF7ucTa76
         s0egAxqx6s6XT8mnFhc0spR8o8vNYYyTkAyMytDJIVxkvXFrmq4onu1ND8cirKZaouWR
         q1ww==
X-Gm-Message-State: APjAAAUAHj74GmZyHTVJALOb9fWAHCiHTeJvIbOxuEFpUdwmPihZSf2z
        G7fgBU1ANSacbgI2a/5hLaEuugCX
X-Google-Smtp-Source: APXvYqzwRI3BeuQI43OfnS5JDMWBjHFuXiDrm+oW/RR/oMDLukAM6M7il0ei0jwqfrUO/xwPfR6ebA==
X-Received: by 2002:adf:de8e:: with SMTP id w14mr37151749wrl.79.1564919977785;
        Sun, 04 Aug 2019 04:59:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j16sm30160901wrp.62.2019.08.04.04.59.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 04:59:36 -0700 (PDT)
Message-ID: <5d46c8a8.1c69fb81.d0c16.ac55@mx.google.com>
Date:   Sun, 04 Aug 2019 04:59:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.187
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.4.y boot: 44 boots: 1 failed,
 41 passed with 2 conflicts (v4.4.187)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 44 boots: 1 failed, 41 passed with 2 conflicts (v4=
.4.187)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.187/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.187/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.187
Git Commit: dc16a7e5f36d65b25a1b66ade14356773ed52875
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 18 unique boards, 10 SoC families, 9 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        qemu:
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
