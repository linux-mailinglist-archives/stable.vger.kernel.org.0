Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 841CA195ED
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 02:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfEJAA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 20:00:59 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:46936 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbfEJAA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 20:00:58 -0400
Received: by mail-wr1-f48.google.com with SMTP id r7so4698971wrr.13
        for <stable@vger.kernel.org>; Thu, 09 May 2019 17:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x/CXGRp80IRiXeAmAwY4ABp5f377aFe0bLcL5F214gE=;
        b=MRRofAjZFYnaIpoOtASUYvVx3kesdLvsD1nsFpy6CvWlA2XxD7r01rohAdXPbK6TyL
         CBGma3ORM/Exr/uYjEAeKrG6YJkB/yKjrY+D1l0vL/kb+H0UoZRqxH0Qip2SLSjir5oU
         eExp/DsTZFtIv/Np72EEH68ck20Cj7I52qSCiBK4q3avLexbQfhmJ0AMBab3pEgzjkpL
         v0mPzWsl5CfkMte71sWoG/UADzS60dRYUgSDHiPz5czVcZHVsesnAjdvetphuddNAutg
         94tNgpj/K+eQQ5hM+I25upUz50Vrhg9GFw0eBQiDTP2zDJV5/t2PLFIBSZXPbDt5TsMa
         3JYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x/CXGRp80IRiXeAmAwY4ABp5f377aFe0bLcL5F214gE=;
        b=hMu7rNxPxTtbIDnCwsbOLfFgOzWWKM5hjw17pk4i3yHM3adFSOqJamii+nnr4lsQ07
         hYzbYgUpJiZJBnfqCvC5fyKYNqyP1v7RQ2eqWuJeH1mvzWYLiP569KhUXaIoMkRbe2b4
         8u58V2tuEofOqbiLU4aEiJ0oni39zQ50LYh7NE2cln73LdFQ+Qnpegv2I6vGdy4OhCW9
         OFxGSkUWp2bymjrLk4PcbaP34waoACd36LSEYz/9ZorEAlgqpg8OFTelmuxh0Ym7HgkX
         fvq8b57pvzhzEB0z7Vd4isf8MZO82rHmZs2UChZc/S80mfsTrWpL4acChP85n2A6zVRy
         p1CA==
X-Gm-Message-State: APjAAAX11G5/jr/TfjtlMsZBNH99jqzeQVIlGKNYYQh58KM/WJ2nkLRV
        IjQZmmx9pfDQsDwlMAcdmLZiwb96nXi0oA==
X-Google-Smtp-Source: APXvYqygerwA4926KxSGyZ/KcATNNkdDOoi0d8S/CeLNc63ZE7YZqZ+lnh+AZUWqbW4W2B90yYiORQ==
X-Received: by 2002:adf:eb89:: with SMTP id t9mr736368wrn.109.1557446456750;
        Thu, 09 May 2019 17:00:56 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s11sm10202177wrb.71.2019.05.09.17.00.55
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 17:00:56 -0700 (PDT)
Message-ID: <5cd4bf38.1c69fb81.fd5b1.1766@mx.google.com>
Date:   Thu, 09 May 2019 17:00:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.41-67-g82fd2fd59cff
Subject: stable-rc/linux-4.19.y boot: 135 boots: 1 failed,
 132 passed with 2 conflicts (v4.19.41-67-g82fd2fd59cff)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 135 boots: 1 failed, 132 passed with 2 conflic=
ts (v4.19.41-67-g82fd2fd59cff)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.41-67-g82fd2fd59cff/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.41-67-g82fd2fd59cff/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.41-67-g82fd2fd59cff
Git Commit: 82fd2fd59cffa3045f205da555c0defe8bb35912
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 25 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.19.40-100-gf=
897c76a347c - first fail: v4.19.41)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-collabora: new failure (last pass: v4.19.41-56-g487b15502=
665)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
