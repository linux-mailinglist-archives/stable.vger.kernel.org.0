Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A30144A7C
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 04:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgAVDeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 22:34:21 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55592 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbgAVDeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 22:34:21 -0500
Received: by mail-wm1-f66.google.com with SMTP id q9so5298767wmj.5
        for <stable@vger.kernel.org>; Tue, 21 Jan 2020 19:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YbXi4Dgam7Jm3/BiZO4diXKomk/dBmAhW04BYVgCbS8=;
        b=X/JkPAiBR2KMp2dxY7CBTGXkfU1o+8J90aWdJts3ymvktMqGKJ5i8rWIoIkBlfwqVx
         1wMwjW0woFWYhpqJ54MI0FlLFqTekyGRvUJXULdCTD+uicSjaVK+UpFbiUJvB8D0Osv8
         h9IK2dRQznJellpb3WEs/jEVMycAoCbBVAhMk0V7yshNTsjssVzjxTBvaDcsjjx8molf
         X4Bfy/H1p8uYtN5L8ohWD6o+r8/zqj1MOm079GjnSXbKsXIFxCmZ6jlwSTUzKuk51AqN
         jEmAkni4yKs8LrdixD2jpcaJ1nKcSXHnG8coqi3Pt1MIMJeuZs16tzcyb4XqCqhWlr2L
         S2gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YbXi4Dgam7Jm3/BiZO4diXKomk/dBmAhW04BYVgCbS8=;
        b=b4zA1lN4AVqOwp3GRObeCbDZXakd7/OnBiOY1l2TfJuMN00rxmkb2iIecbw3cksOvA
         WOFJIMZVn+43VENG+RlAk7C9qy+vIFWSkAVLYZvKWC13X3LGJM1KnL4oOdwvADAWs5zL
         w9RH0fKgEC5TfHm45I+UZ70A80vsF/8rCxzYxKkCOGbN7dAidhHDI6GpT6bLFpWA21e7
         xgNt0K0bRAJnqAfsb1s/CbfQ+Nzt4VGBqWbOC7UR8JS1AlzDa9yUhARRCMIxWPdg6l9X
         clHXU1MTeXt2zqJUmKMRCUU9v0/91EcaNjRenw/DEOrVbLFT0YS5/Kkw1Y2FIsgLgg2o
         7nQQ==
X-Gm-Message-State: APjAAAWfcVseL3EWFCNuYfpd42eoPDnjnrlSmTZ6WaQsb3pgf59QRbcQ
        WmU9dVJ4WJ89DoLfopFnqaJw0NkDLGrshlVfZcc=
X-Google-Smtp-Source: APXvYqxx1MTcKb1+uYAANIgbM3f99uOtjJLwNESSdZRpjC3hIOlcgDzjpZLxHxF9Uqu9oxitzEoraw==
X-Received: by 2002:a05:600c:2406:: with SMTP id 6mr407747wmp.30.1579664059091;
        Tue, 21 Jan 2020 19:34:19 -0800 (PST)
Received: from [148.251.42.114] (static.114.42.251.148.clients.your-server.de. [148.251.42.114])
        by smtp.gmail.com with ESMTPSA id v83sm2049191wmg.16.2020.01.21.19.34.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 19:34:18 -0800 (PST)
Message-ID: <5e27c2ba.1c69fb81.4a2b7.7f16@mx.google.com>
Date:   Tue, 21 Jan 2020 19:34:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.210-70-ga43a787c971a
Subject: stable-rc/linux-4.4.y boot: 37 boots: 1 failed,
 36 passed (v4.4.210-70-ga43a787c971a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 37 boots: 1 failed, 36 passed (v4.4.210-70-ga43=
a787c971a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.210-70-ga43a787c971a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.210-70-ga43a787c971a/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.210-70-ga43a787c971a
Git Commit: a43a787c971af563b4ae7d2e96f5c35e04b37456
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 22 unique boards, 11 SoC families, 7 builds out of 182

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
