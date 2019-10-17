Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA05DA459
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 05:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732869AbfJQD3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 23:29:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42558 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733006AbfJQD3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 23:29:07 -0400
Received: by mail-wr1-f66.google.com with SMTP id n14so530146wrw.9
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 20:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x7sywAMmhOwm7d9SUR/EPwY0lQTPQIDYPLwh+RzL5lw=;
        b=Gzw27ZUijG19kjyaiUKERV1lnh//CvVCl7KyH7/X4jEakllb3bgso+Hwq3389s/DkF
         b274P6vKoRRdvB30yIBnKAZhAtrwwUwnZorDUMpVebqYoZYgEziWuiJmHM3rzp2H6YyJ
         v3w0N+mEP1aFC9sJzyjiZHy9fUH2d2CoeJ5BpI+y46uPJFpr053Ak73MT+e2vDqyf2GL
         zNDB+MsXix3OBF5kmH+rHDJUflP4mja4OiCWaDL5ZARbasU8x3xDWsTJxJm7BupoVtJs
         vmb5pXpGOMOFpYTjZnoWnWI4U16MyyXrq0PQH9fCfXFaBfDQ8cVeHgv8OPcCseWAgh86
         m6Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x7sywAMmhOwm7d9SUR/EPwY0lQTPQIDYPLwh+RzL5lw=;
        b=dc71akKsjtaDYLDC2yH4tVB4T2JLLLFQAl1SteobjUHztjXQqD+FV5pzbFTYFC9j0E
         07m6yrflMFTh6bYoLRUVTCCVgvLdB57lD1H45VMC+4iJnqy+/BuxE5+mXdCNeVdRfR4O
         her0kr9FySBWugDu3UMNZIcwuZ/Wbs4gBIDXJaI4MI5vyZTMeSJxiIlxBe0TaTNdNkRh
         047LiY99Do3xxQx6bJOP6bEBHJuA982y8KwweFysgBdSLOWYaCEtp8iAWwBvFPSFUzXW
         YZ5j5RdwR4XPSc+8U0gbjWo11uSBL+dMmEdToRbhqXcQUMmzVDTDdaq6bFnax1u+VvPE
         +JBQ==
X-Gm-Message-State: APjAAAXBEghdHtsA5VAwzYh6mnP9fmaKzRJWnsY/Wx9f1AuXNcSDBWRw
        1ckAZ5D1rgtg9n8ikAgbSFAgdCq30Ok=
X-Google-Smtp-Source: APXvYqy9nQaYjOOKqYoKJZpOJKISiEqattz+bkea3QKv3CycibE6odGIcca7Srln3lPah1HUZvNVkQ==
X-Received: by 2002:adf:f704:: with SMTP id r4mr899336wrp.30.1571282945873;
        Wed, 16 Oct 2019 20:29:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d11sm758662wrf.80.2019.10.16.20.29.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 20:29:05 -0700 (PDT)
Message-ID: <5da7e001.1c69fb81.bfbac.3191@mx.google.com>
Date:   Wed, 16 Oct 2019 20:29:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.196-93-g5749cdc967d4
Subject: stable-rc/linux-4.9.y boot: 81 boots: 1 failed,
 74 passed with 6 offline (v4.9.196-93-g5749cdc967d4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 81 boots: 1 failed, 74 passed with 6 offline (v=
4.9.196-93-g5749cdc967d4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.196-93-g5749cdc967d4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.196-93-g5749cdc967d4/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.196-93-g5749cdc967d4
Git Commit: 5749cdc967d4817de5000f6054619fb41b4f4333
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 19 SoC families, 14 builds out of 197

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            juno-r2: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
