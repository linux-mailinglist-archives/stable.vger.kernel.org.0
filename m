Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39159D9964
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 20:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbfJPSoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 14:44:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34721 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728538AbfJPSoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 14:44:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id j11so29258090wrp.1
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 11:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RHFnMIuFQIhVo36qTLC9lPxbsRoAS4GtHlHzDcAeUuc=;
        b=r7s+qHuYgHI9VtinyVZTCr62JLRTcBr9POT+tTO0oKqY+/xiACW8M+CYeKvog/vKUC
         ql5/xtfIXhE8UTU+cTPuJy+DcfXW0ItbUeFKrDYfES6nw7xmnrdwiasSifWZ9a/hlO+C
         dXg8ZUL5uYFL5YWHkRvh7gNDfvfnHIGmo1Zu6XtUkybYsblJFiUmmyheq5DX+iP5HDZy
         ilKa/VNJRKAshL416i0UL8A1aeNN4HN0oheKokysfoHeUJwZN0R04xf8F2IfZq2MA/88
         kOcokrdM2HtVUKPEKoaOXseEAMySfV3OTHiEjQLB799SntnN+52CsmA9JCCdTwDwJYWP
         Egew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RHFnMIuFQIhVo36qTLC9lPxbsRoAS4GtHlHzDcAeUuc=;
        b=EqyROJNGF4WrNJmCFQzP5BK4RT1jHIaGVao/J6scraj3HzcQcug8jo8KYrxgZLM3G6
         IVntY54xzWOEHXaraZNZ8uGZBu+tN4EGsAHlZsKbkB7KTvl1lKyw4/wHPFsym+1Tvjea
         ME7HLu7C88VwEnxrhhNBvjqr8cE5r1ui9CpyJmfoRV49nDfG7LmRwxV0snUNSaBaR2m9
         rd8kVCtcaskr7c/0EMjkBq3Ma+EuSCQaX1TkMw42QaRJSnB+85+jXv3bSQTX0/acVFq1
         lRbnhouMFVroobKPPjesvEE+hIDua1t1j4rElRmtciuzDMkgVL5oFLHA9kV7VigLPxJP
         qc8A==
X-Gm-Message-State: APjAAAXk63Z6bqDKtpAUqA1bpEL/EOvbrMMGuSqVknkij/yfYDChwkb/
        lgpfLPdF9OJAPLy2KNS37+0PqtUublQ=
X-Google-Smtp-Source: APXvYqwi1V9jv9CS2u+0nPRepHME3P30tpxcPPNHKhfLhHe1X9vwx4P8cWzegkxfrEOox78kizAHVg==
X-Received: by 2002:a5d:5552:: with SMTP id g18mr4210927wrw.79.1571251492150;
        Wed, 16 Oct 2019 11:44:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x5sm44233939wrg.69.2019.10.16.11.44.50
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 11:44:50 -0700 (PDT)
Message-ID: <5da76522.1c69fb81.b7af.2261@mx.google.com>
Date:   Wed, 16 Oct 2019 11:44:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.196-81-gfa8daef11af9
Subject: stable-rc/linux-4.4.y boot: 77 boots: 2 failed,
 69 passed with 6 offline (v4.4.196-81-gfa8daef11af9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 77 boots: 2 failed, 69 passed with 6 offline (v=
4.4.196-81-gfa8daef11af9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.196-81-gfa8daef11af9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.196-81-gfa8daef11af9/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.196-81-gfa8daef11af9
Git Commit: fa8daef11af9b155cb6989b149d878358480f54c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 17 SoC families, 13 builds out of 190

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
