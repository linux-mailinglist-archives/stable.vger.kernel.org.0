Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5229C67BD7
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 21:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbfGMTmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 15:42:55 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52937 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727936AbfGMTmz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 15:42:55 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so11635101wms.2
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 12:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=whtXfYuFihA48uDjyuNEFjGmGtLHNRT+RPrVUzCkrZk=;
        b=WV6uAu0wdSDaEgorhDFV13UAbcIVvUybP+smoSGOpEt5JzT+SBii5RllkDS+UL65IE
         k08p3KFGHoNxiLszFBYzvADVEYGPti5Vt1iZ9AUm1UoglXasd9hasgy3Zf0+Z1hQ0VKo
         aBUKLV5rrGduxNeOdQ8GSX8GiCGQ8UQIhON/rNil3wHYnsdxBMlZvw3yR5iK5Kq7ZqPB
         Ztp49Jjw+0ciWMdUj6CQLEwg9QrgJg3Ig/E9OkiJWgDIpc/BCTImfE9canuiqj9YHnoZ
         28PcI7mvnge5HNeLKVbne/E5eVOdiAzsHYHEGZA8lFUvWFGmo+8ziGD7QN5cUK/O5rNB
         UG8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=whtXfYuFihA48uDjyuNEFjGmGtLHNRT+RPrVUzCkrZk=;
        b=hZduXLyqIfUh4dIGRsZxAL/9jMxkoJeQo06hTQmMiSS/h1VOxej+XozhBa9IdRsUvr
         wf5DwrxOTUb17xl/wyuo931zcAcngFvMAy8ErOgNSOLfLyuxblKty/pGpId/T+mpqZ3n
         7IJtWaExJuJN2CIW4lo6p4GT8xdd3ieKArvJc8lY9Apm7tB5QN3lDeDGM/hDNsmVYtv8
         kchl4fu48roUnKhghEGn3Cq53VrrH3vFSrSDE+/9S5s4hNHpw3DfKmsAlx/bsV88kSV0
         LXllaYk3L/hCPpDoBcH9cXWlCQV5pZvkA87MGTm1kLNM3QB4dPdzp3jyjTAhMGCxh6aj
         j1bg==
X-Gm-Message-State: APjAAAWQ4oShJ1XPjvDfz5VOaMjQOOtmlCDfDs9SxP3Z8uuXSCiiTAAT
        ZHlyJfF7r4EkKvkddcS8GFFmwuBPo1o=
X-Google-Smtp-Source: APXvYqxuDaDXzbZWpIcMVmRZVQR/7ncXLHYmYk90N2JeX6FeGTAB9so+bW/LZu0AINLOt66GNYqeMQ==
X-Received: by 2002:a1c:630a:: with SMTP id x10mr16358615wmb.113.1563046973182;
        Sat, 13 Jul 2019 12:42:53 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s10sm10702895wrt.49.2019.07.13.12.42.51
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jul 2019 12:42:51 -0700 (PDT)
Message-ID: <5d2a343b.1c69fb81.2cd4d.ce09@mx.google.com>
Date:   Sat, 13 Jul 2019 12:42:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.133-57-g728f3eef5bdd
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 119 boots: 5 failed,
 113 passed with 1 offline (v4.14.133-57-g728f3eef5bdd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 119 boots: 5 failed, 113 passed with 1 offline=
 (v4.14.133-57-g728f3eef5bdd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.133-57-g728f3eef5bdd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.133-57-g728f3eef5bdd/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.133-57-g728f3eef5bdd
Git Commit: 728f3eef5bdde0f9516277b4c4519fa5436e7e5d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 26 SoC families, 16 builds out of 201

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab
            rk3399-firefly: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
