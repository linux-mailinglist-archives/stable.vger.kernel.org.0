Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7E921126
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 02:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfEQAFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 20:05:47 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:39465 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfEQAFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 20:05:46 -0400
Received: by mail-wm1-f47.google.com with SMTP id n25so4671020wmk.4
        for <stable@vger.kernel.org>; Thu, 16 May 2019 17:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Az+HoKZjIZtoG3gPZk2tsk0/BAnhZzzE/D5YEN4xBIw=;
        b=fyJGS2nCpSzTFJzB2rvWwUTdjAdJL4aAwkfD3ZU7eOhYC2903G9JD8gH0AXjKZQskt
         gbNOntgrAUtfhHNRhTPs+XRPdHVpuW9B0TBx0Sh0bR5GdBpihXAPu+TSDb1jlvIHcUaG
         r+bN7Zx3LQwlymk/uNWj5I7LfCkxOgpxsyxXlYi5Mg03kdgMOnA05cyTDnah7/H81AmU
         NKvoVqnLP1AuJAXFp+/quI8nIUslhDV6IPo3W9s2QjCtqgYxvqqL6FWJ7K4i4qfISDWM
         UVGYBuaJQ6WHZKl9B8SzecLe5+hFbX9GNyWHkEEf9ZptkvLGfwpZdAIkw9u2pV/bGYfO
         Aesw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Az+HoKZjIZtoG3gPZk2tsk0/BAnhZzzE/D5YEN4xBIw=;
        b=H2I4qL+k2nH++/EwMLfwNC5uvQ34kqeVQ8XTrGp8yRM7DcK/t/rmRLxnyvg02rJtG1
         tVD2ishSIQz5QC+zzHH+NodEFgrxTarKS9CgXU6dlifUsaXGQHPaUA05IqotSgzvkqGG
         X2/QIWvWfi/BISq+44sWoz2xETljpLXHK720Dsxl6S9A7W/Ab/rbb+WtkGMq/4pOACfD
         /OAcFN5JQDuAjKH8FhnbyfbCGH91m+gk1lffqqSqBksQM7emheUwwrgBVwT2yO+9X/CL
         51deISYeO5haLHTyWzNFhWSjGR0erPSbmV6HSjXUTxA+n2i6S3ARbt+cpnUsXMMKnIXk
         ldZQ==
X-Gm-Message-State: APjAAAVUqIDxKCNvyFwXZ8E/83LxUu9TuANyn+XXcdhhlAQk0/tNJk8R
        KNhkb65JoGDF28dihPeYtA+O7I62aCi2Hw==
X-Google-Smtp-Source: APXvYqxv07Gg0JjbrRzHFvQQjV5AXcz+tSb+wuviB0MCcG9gicc7/sWVM8iJEC4aMgfM3ahTca8Prw==
X-Received: by 2002:a1c:3dd6:: with SMTP id k205mr25009994wma.109.1558051545144;
        Thu, 16 May 2019 17:05:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q16sm7358247wmj.17.2019.05.16.17.05.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 17:05:44 -0700 (PDT)
Message-ID: <5cddfad8.1c69fb81.8b846.b6c1@mx.google.com>
Date:   Thu, 16 May 2019 17:05:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.119
Subject: stable-rc/linux-4.14.y boot: 122 boots: 1 failed,
 118 passed with 3 offline (v4.14.119)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 122 boots: 1 failed, 118 passed with 3 offline=
 (v4.14.119)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.119/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.119/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.119
Git Commit: 2af67d29b6fec54b86bcdb3e0a616640eeea5302
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 22 SoC families, 14 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

---
For more info write to <info@kernelci.org>
