Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE09B1140E0
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 13:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbfLEMf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 07:35:26 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:39489 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729240AbfLEMf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 07:35:26 -0500
Received: by mail-wr1-f43.google.com with SMTP id y11so3360167wrt.6
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 04:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yRt4l0J3eV8sru1MmngBa+k10wFmSmc4g4A3wDk0CwY=;
        b=LH4AMbhy/5TS4sl3V8zu6V1iA4i4esjej4ZiXlwfcFGt6yvOuUPp8VXrJuhydJohYm
         GbEnjla+6S+DOcjIKjd3SPe4AWh9nlropVYKoWhbKu2Apzt6oHNyZ806QPWHPwdu+iWL
         s/9eVmRz+ccCfhAje3P9EaP8k3AjI/YILqPn1elWAI/NlNddpHqyd1BpdDuHAMIVv/sh
         j9B2uToqBQZvtLKT9hIYiAxq8ucjTVyYtUSuMR34gZEAqP1VnwLtiuC9ISK6LbbnHzeW
         D57kWEjz5qfYmUsDC2i3xyUDjewkEt0Gcd57JqmgeI/nt1QW9exjHyDI6vJeH0WwNWvx
         xEQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yRt4l0J3eV8sru1MmngBa+k10wFmSmc4g4A3wDk0CwY=;
        b=OlkICg4Mqn5nfwvfRVxSwluebKNLP7OSov+C9/1JURoAF2zW8+2A69kEGJDXRMx8pU
         zEkrHQKfA4Z+r84gTFmNH+IBmdeiPVuQsQ3FpPiUz6Z5OviUJaNpe1ByyGNDXg2I8Sbg
         as6u4fYM7bAlCY9Gj5WvMMCOgs8ActQvQbfZ77Mw+EcyAp77IVJ1GmKAA1BP/Pdd6RNd
         MTXfGhFLocNhg7F4wc6y+7eIQ47ZwTAgcb3BYfK6gL8GA3+XfjVqrHoh8InTVlDcUXSM
         gxXEeq2DhPsBj7ZZ+9muaiq8QHRjk+zSjl0qsc2S4Lb474RmSHAskc8vxO01vDhBORC9
         ZX9A==
X-Gm-Message-State: APjAAAXW16hp083bxLv5l5NUNOnYB072BdNrAuqYLlv8XfEI3hRD+Gue
        ETHM+4LPDh633R6XaEizGor2CNXjBOJUKw==
X-Google-Smtp-Source: APXvYqyRErkPmewVVcfsnR2+9X7t5YCu1tw4H3H11Q0YvRwgQwSwiTeAM5brryWqWZOPXmrtBSVCZg==
X-Received: by 2002:a5d:44cd:: with SMTP id z13mr9976129wrr.104.1575549323980;
        Thu, 05 Dec 2019 04:35:23 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l7sm12074359wrq.61.2019.12.05.04.35.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 04:35:23 -0800 (PST)
Message-ID: <5de8f98b.1c69fb81.cf0cd.e1c6@mx.google.com>
Date:   Thu, 05 Dec 2019 04:35:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.87-322-geef96ec68c97
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 144 boots: 0 failed,
 135 passed with 6 offline, 3 untried/unknown (v4.19.87-322-geef96ec68c97)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 144 boots: 0 failed, 135 passed with 6 offline=
, 3 untried/unknown (v4.19.87-322-geef96ec68c97)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.87-322-geef96ec68c97/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.87-322-geef96ec68c97/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.87-322-geef96ec68c97
Git Commit: eef96ec68c97233be25d31a1ce9e99164db7a245
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 80 unique boards, 23 SoC families, 17 builds out of 206

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
