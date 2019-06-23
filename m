Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B0D4FB60
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 13:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfFWLxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 07:53:16 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:32963 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfFWLxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 07:53:16 -0400
Received: by mail-wr1-f49.google.com with SMTP id n9so10920573wru.0
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 04:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mhvev5p2Wsit2YXVeMKt2UGgSFAfZVL4QEEXp5MsuHM=;
        b=dLr79+MlxGmicqiByjDfKJ6M6/Bk9fZD4korRussRwzCQA2ZkQSchOuPCQGP+UuyZG
         lz/fWbnTR2wtkhM0Dc/2ZGl/o+cEtIpTkeNpZNVYVeu/21BtAYgQWTmDWcoAHMB7Xo/a
         9q6j1h1DnL3fL7al361WZ1VjdQiOV5O/XzPnuJcTuBX/ujiP78D9udmdeSfPnaKtigk7
         M2FDk/Jqevb2Qr1hXJ2C1MiRJJwDkJ2Jlfa6/EwPiK83rG6OK+AMeqYuoUmDT+MPmHaq
         NvcVOHUgi/vtSTsTdHdrTy5UpHSK/1JOCqUp5YQb2Qc8YqCGmTx1eztf0m0jDlK0p7CO
         aQMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mhvev5p2Wsit2YXVeMKt2UGgSFAfZVL4QEEXp5MsuHM=;
        b=QSkseVIolef+v371Oc2HRCI53xoM4REXyWefq/yaZCGahOxqf4Dq3vO4TBQ60I1rag
         YHoWHli4HAAwAfm7tfNhaF58FR6+F/3Iw0pSwruyQ465JJEOaxPxIznTkeuKjMioD3DR
         exlp4tCIjDHfVtmFLKwnZJ7WLuCvRMyGgBNRb8u3ndUL8T7rESFrCwOD3lrXTHBR92PZ
         Cj4IaRr5LTk2BzCNwihq22DWxD2HkinPc6tJehn/Zhpl0wPiXDoqdGLUhvqNptOucobG
         vWP4es639Rk39rN8Pnh2ytncM/YsrQRuqanfJKQV1c7RKos9ISdEKZbIOrf/5DaU0EN3
         Bcew==
X-Gm-Message-State: APjAAAWgJDOGxOY/gpdNDPj73K6NaMBIDQpPiZcZmg01lq99X5XkatLF
        0p03GfbmQEnvb6Z1C9SGnADk818DCOg=
X-Google-Smtp-Source: APXvYqxKlOplOL65ytzgqe5kHdRuJmqkUedllhw2Ba3tqP9h/Yp85Q4Jtx4KIVMQCOsTtaHGdmCrcA==
X-Received: by 2002:a5d:4a8d:: with SMTP id o13mr8566640wrq.350.1561290793666;
        Sun, 23 Jun 2019 04:53:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a2sm11826022wmj.9.2019.06.23.04.53.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 04:53:13 -0700 (PDT)
Message-ID: <5d0f6829.1c69fb81.49713.1df8@mx.google.com>
Date:   Sun, 23 Jun 2019 04:53:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.55-12-g6091c94bdf41
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 120 boots: 0 failed,
 113 passed with 7 offline (v4.19.55-12-g6091c94bdf41)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 120 boots: 0 failed, 113 passed with 7 offline=
 (v4.19.55-12-g6091c94bdf41)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.55-12-g6091c94bdf41/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.55-12-g6091c94bdf41/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.55-12-g6091c94bdf41
Git Commit: 6091c94bdf41ef32603b3b0af013d2d5d0f2d8e0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 24 SoC families, 15 builds out of 206

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
