Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B60A1ACF76
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 17:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfIHPZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 11:25:44 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:42862 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfIHPZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 11:25:44 -0400
Received: by mail-wr1-f53.google.com with SMTP id q14so11155907wrm.9
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 08:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FuMy7diqX1/MjHiV6/J5+0hfL4JSCr8dWL+Jw2w5uwc=;
        b=CXZOxrVPVN+hiBi3Y4TE7gGYcElH3y28wERezfkz5exhFbU83+H7YE5lz6IpJeTzuQ
         hBw3qr1Gg0sI1drb5ZE3dS8JL/dZYufEJ8CIbfutgo83VoqHyuqoX8gyRrjkjRAGTwZX
         PcPIqYMsyUVQgjJmxugdH6Zb+cIlu0y9jiXuwVo/kDCuD36aE/fGgKfj+HtWP3i2OWJC
         TyIa1ctZdTyXfVZ++R63qaxJIYuEQh935Saxq6JURpXeitOWQxl5q0vpgnIxCtJeoDM/
         UnfxCnG+MeELSHcXY66q1KZwqpVLKisR5R49D1ouoyBWnLgGPrtZ3rnHTE4txs84QuHE
         1EHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FuMy7diqX1/MjHiV6/J5+0hfL4JSCr8dWL+Jw2w5uwc=;
        b=QKtZPnCFQmq4J8cqoAYify7j5ZAMKQ4nIaveIzCiu+Od8N6cHLDqTUtEXvua3jhrr9
         V+qOgty9nZ9KPJx41Ivmyay74K01wA7HBJ4WC6g9y4+1F3wW/D1i++gDgsoxB8YpCGtN
         sq7et70I4a4NIBL0zZT3LKg9SNKcgvYf1YSBdbtkF9K38z1ZawLN7x8ABe4alQyZKFq4
         86tqWnXYQbh+Qgjyx8jmFMM2P/msHIIX9Pw8rzB2MF6r2i6Ritzuk/tHB0hzykCLt2jb
         xd8E4QVIpNyegHvQyQdGEpDTg3JV5DNE4hHDpC3sgprqpTx+RtprsHc9KktZhA8cdV0d
         WO0g==
X-Gm-Message-State: APjAAAU9cMIRcrbpnNAkEDC9B8anTzpY1YzZEbqAHYdqHyb/1SIivbOG
        kmFKr8ppAjFMnNVlSBbIsORNXjAuSNg=
X-Google-Smtp-Source: APXvYqzy87ore8ywqvjgj0OkvPK+RHdL4vLndDi/4cug96wX2j37R1Nq+f5AbnvORbv9sif0+QOshQ==
X-Received: by 2002:adf:c504:: with SMTP id q4mr12391309wrf.266.1567956342213;
        Sun, 08 Sep 2019 08:25:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a192sm15186119wma.1.2019.09.08.08.25.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 08:25:41 -0700 (PDT)
Message-ID: <5d751d75.1c69fb81.6ec45.636e@mx.google.com>
Date:   Sun, 08 Sep 2019 08:25:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.70-59-g131247eaf9e6
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 138 boots: 0 failed,
 129 passed with 9 offline (v4.19.70-59-g131247eaf9e6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 138 boots: 0 failed, 129 passed with 9 offline=
 (v4.19.70-59-g131247eaf9e6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.70-59-g131247eaf9e6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.70-59-g131247eaf9e6/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.70-59-g131247eaf9e6
Git Commit: 131247eaf9e64624384b4e88053151a00840a285
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 25 SoC families, 15 builds out of 206

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
