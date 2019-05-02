Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 518C9124B7
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 00:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfEBWqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 18:46:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53050 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfEBWqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 18:46:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id j13so4960237wmh.2
        for <stable@vger.kernel.org>; Thu, 02 May 2019 15:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=2xX1DTWDMMg4NiNeilKXOGy/BGadjxHNrX+2mYxFkMo=;
        b=twO8KFQIFxs4OxXm2U8wzP/vEdqkIPCn6+KgrvFnGRHqArF5Ez7cSbJOPoNPCqUlvD
         VIqFnOdPHpFFvGxuZifxbGFZM+TMgQhpREFL2w4Auh6Svd9fopo8BTatFKxTVyWIdQFu
         x4pGiKgeRFi66cJGRoK6HH6BINmWFjiWS5v56bOlc1Hu0g7ixoMquMmD6K3Og2fquUKL
         zRYumOfaqslLchUfexmz4H1C6s/dTiaaNRIoVn8ZiNQARHZ+F4kYol8KlvxkiV1DwWgu
         5m+xSyb0n8ril6/GcIg8GlcL4hZnS8Xbnc8Zfrs46H8lQZnI5gMnLbX1GxmKV3n8sEEm
         8c8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=2xX1DTWDMMg4NiNeilKXOGy/BGadjxHNrX+2mYxFkMo=;
        b=T8SJ1dQuZieOHzvgly69f5eM/YvD1o7eHZ41yncQZntU4OnlZC+3ybZ+5xBv1KdpJj
         8nN68Lc3+MnZgm6Ne2DuwGtCfxWNeLSCR6CWnnsDFJEAHNJWATmruhAvnIcpPa0+jqNT
         PLhGqclZ5huZAjPZ8hnDuihTi68F+1nyeMVR6w4cwWnvzYdBcHhv/VB8Pzl4bhIjR2oX
         l4lKJwN8dchurMiZMCY77a1gJbwduXoi+aP9/swBu1vbIiiR8whCIRXiN81Awq8E882r
         dngWBHOVH1TzlWWFK2+PNHOjNN4RyNe3S3EjCJ1QXlB7mFlor/F7qeVB6S4kUk/cIsIW
         Fb4Q==
X-Gm-Message-State: APjAAAWulurX4Tlz57noUTnt9juB8uUW6ow71j8//zTbNHiAAwUzobRm
        R7gVZahEzvgfsgbZTbUSWNvOhg==
X-Google-Smtp-Source: APXvYqw+OfEEyB3xfAI37oaK29RA9mDOKTLFw5nj3JKGiort/AyaMdl7y16Gqto4M+I0KVjNmb6jKg==
X-Received: by 2002:a1c:a509:: with SMTP id o9mr4232367wme.6.1556837190231;
        Thu, 02 May 2019 15:46:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t27sm1017030wrb.27.2019.05.02.15.46.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 15:46:29 -0700 (PDT)
Message-ID: <5ccb7345.1c69fb81.f4fd8.64b5@mx.google.com>
Date:   Thu, 02 May 2019 15:46:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.38-73-gdb2d00a74567
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/72] 4.19.39-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 123 boots: 1 failed, 119 passed with 3 offline=
 (v4.19.38-73-gdb2d00a74567)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.38-73-gdb2d00a74567/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.38-73-gdb2d00a74567/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.38-73-gdb2d00a74567
Git Commit: db2d00a74567be6e93472fcc4bfa8ada96cc6397
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 24 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-7:
          stih410-b2120:
              lab-baylibre-seattle: new failure (last pass: v4.19.38)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
