Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E3AFE19
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 18:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbfD3Qqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 12:46:40 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:37187 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfD3Qqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 12:46:40 -0400
Received: by mail-wm1-f43.google.com with SMTP id y5so4610275wma.2
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 09:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Mn4S8rnxAWXrqwzwzVKs0U8dS7gV9+cUXMTKHHNHoTQ=;
        b=JurblEZsWRRseHO1PNcrk7eUza289xcrHlVSrF4gp/uyWoY1qpatKgQvnKNa28fxBr
         U2uDNz4PMD8ev8pEm8GGr2+4D+9GdUkNZkbhTomJJMVinuJNYla+Oy4d8sbWNIiRh5yx
         E61bs9oD4uVV3QM0yTQLf/v/2QNpTJkuNuPZRFQemPGGa+B2eY4PtJHrgFBL8gEuzxd/
         GGtO5fb9w0Hyf/S3yCm3c1zgsoTnNAW8TezZxaGBjWdc97XoOYG4sIeJSBYxWl51eh1n
         6XJfBfXxFVGfpnwhUZWdP2YsAbvhvm+sDB7/pwShITFcCHC3RglOgPXYY1xiJdJVGtXu
         9fcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Mn4S8rnxAWXrqwzwzVKs0U8dS7gV9+cUXMTKHHNHoTQ=;
        b=DUB6Cw+7aebBXsITK6I9EOgez6upCwndUv/r0EqwEtqDHT72m0I8tk+9XS7n+0UcSi
         Q0F4jDkeF3niBrgxsv6Bk325ca45P909QHiS+48z7lmEE6DEuyEK6c1wfaNYxl1+h9YP
         J0s5Byx6M8vAqfYH+4mwO7kDMyJOUGrD7+pecfD6gpycoltbPCG2hiPxcorKrA4iZEg3
         tGcqfDoKL67OteaaqdJE5gZJQO85ivgk+G+QbvU28uzbVpE0V3u58ZPWoNe08ujrIAtJ
         xmi3jCmcNdVCtv022V6s1F7kM7Yh4/XQJbqjG8Y+6Udv4em3K3cMILa0dSThiPbwVM90
         uViA==
X-Gm-Message-State: APjAAAVMGZDap6VdhJWQkimItoXBoBmJ7wfSLxYvMtRzY/YI5kUewpb5
        SDVgnxfWqKuK/IdsViEFs2/qD9z4ZT9rtQ==
X-Google-Smtp-Source: APXvYqwsb1SmdI6dB3baCtQPtJvI/KveIMacwnzRWc2+vuRQHys+FZfgM6RDYzAhllA3z2zbh0dKIg==
X-Received: by 2002:a1c:701a:: with SMTP id l26mr3799008wmc.50.1556642797530;
        Tue, 30 Apr 2019 09:46:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t27sm7484310wrb.27.2019.04.30.09.46.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 09:46:36 -0700 (PDT)
Message-ID: <5cc87bec.1c69fb81.70876.8c8d@mx.google.com>
Date:   Tue, 30 Apr 2019 09:46:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0.10-90-g852cce372723
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.0.y boot: 128 boots: 6 failed,
 118 passed with 2 offline, 1 untried/unknown,
 1 conflict (v5.0.10-90-g852cce372723)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 128 boots: 6 failed, 118 passed with 2 offline,=
 1 untried/unknown, 1 conflict (v5.0.10-90-g852cce372723)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.10-90-g852cce372723/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.10-90-g852cce372723/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.10-90-g852cce372723
Git Commit: 852cce372723872dc1e9f40fef3bcfd2b3215420
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 24 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-7:
          hip07-d05:
              lab-collabora: new failure (last pass: v5.0.10-72-g49e23c831c=
03)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            bcm4708-smartrg-sr400ac: 1 failed lab
            bcm72521-bcm97252sffe: 1 failed lab
            bcm7445-bcm97445c: 1 failed lab
            sun4i-a10-cubieboard: 1 failed lab
            sun7i-a20-cubietruck: 1 failed lab

arm64:
    defconfig:
        gcc-7:
            hip07-d05: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        exynos5800-peach-pi:
            lab-baylibre-seattle: FAIL (gcc-7)
            lab-collabora: PASS (gcc-7)

---
For more info write to <info@kernelci.org>
