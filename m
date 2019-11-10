Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02ADCF69C6
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 16:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfKJPf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 10:35:28 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35319 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfKJPf2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 10:35:28 -0500
Received: by mail-wr1-f67.google.com with SMTP id s5so888746wrw.2
        for <stable@vger.kernel.org>; Sun, 10 Nov 2019 07:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BPMVDpp3SBOJ3Z2dWnmhCL244d2+GR6k/okCqO84TQw=;
        b=QhQFYfRvBSXOYH1CA+29d+SOtTxUwmN8E7QDudbPewunWMy93qO33bg8OCYxqt2KK6
         uGgBgd6NjJLjf99TZYXawsHVBVyENHQN6tZuuu0YmYYNZ0pk+G5bgq8HHLh0hqAB+GJq
         vuLsSZbwTf5iu+UvhGsf3eZTwu8/k3HsOg9tZqBBqcy7pyTNv4rUT+Bs7RxqCBLaoRa4
         ijKtotX+8eCDV6JYdtrsIKDsDwtTsp7zCIRBf9LSRktYcx293qVyLy8PLXnErsrGp8F9
         dit61cJ05pDRw6CXpRq3f0YrJrHnN7RJ4vjm0het1cKnMnngxM0/f3p3m+ECBi+0hwIu
         jwdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BPMVDpp3SBOJ3Z2dWnmhCL244d2+GR6k/okCqO84TQw=;
        b=obkMsc2X3IozcSEvuiS6ZG12M39TAzeS2pgQ4ktWU1v6pw0WoN64r495aMuww90puC
         lpoQFd0SAoeFlf06J53210ehbXH9RxSBK/AR4gYHlShkT7B0rOEg2bXRp6dfNNGroibc
         jyD/6UBYw8MWNCxJKsubBmbMueEhVmqThII2UQY8hXAWJFoel/hpswzG2iHGubwEdNIX
         2nE/Gb+Antx/qa2AKQCPdejGcQR/Gd0MyLOAfOSvR7rc/N1U8X94gxK1kUguPOsaPK8l
         XHjvw0RAnkXCUaNNq6sPE7f3awxfGF4nGp5t18SmbOHPIwfJgStBlaE4qNegkURWAdbD
         kU4w==
X-Gm-Message-State: APjAAAWZdZU/2acjDv6Og73XjpmFKV9Vn3ndJi25oKvTCB4dA2zueH+O
        pQXhaT/Ntm2Zu8Cn7OOF1V/6xJ+K7pI=
X-Google-Smtp-Source: APXvYqxPeOxf1Evni8YkMCizq9rAkw/e/vf5MxRJD5sU1f5CqWDb2DaxofWy8dmC91LoxD2GWuLaPg==
X-Received: by 2002:adf:f3c5:: with SMTP id g5mr916590wrp.5.1573400124931;
        Sun, 10 Nov 2019 07:35:24 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t5sm11445757wro.76.2019.11.10.07.35.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 07:35:24 -0800 (PST)
Message-ID: <5dc82e3c.1c69fb81.6fae9.7c1a@mx.google.com>
Date:   Sun, 10 Nov 2019 07:35:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.200
Subject: stable/linux-4.4.y boot: 37 boots: 0 failed,
 35 passed with 2 conflicts (v4.4.200)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 37 boots: 0 failed, 35 passed with 2 conflicts (v4=
.4.200)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.200/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.200/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.200
Git Commit: 1b8629e7c9b52079a6471973a1e2e14012b885e9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 20 unique boards, 10 SoC families, 8 builds out of 190

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
