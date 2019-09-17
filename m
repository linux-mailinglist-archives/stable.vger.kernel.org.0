Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C01CB4564
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 03:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391593AbfIQB4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 21:56:55 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51096 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389362AbfIQB4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 21:56:54 -0400
Received: by mail-wm1-f68.google.com with SMTP id 5so1296898wmg.0
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 18:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RZKtd30O1LTYL5szV60uTVOLJ46mOgLYXeL8SInJEFE=;
        b=xm4JwXMMkCTk6cIrdZwCYmRulLOSILiebuPCUsSo0WerY0fR3x/V1GztUKQ7UZx2N6
         Pp3oLuFO1ivZauPdUYI/gdjDjYAHvaMB/KEolzak/5fZaZj+Ha0YcBiav6V0H1jQPL2e
         FZwMcDu3URxtJWikrA65bM/w3GNu3BlpjIdwy8q2/vEpUJ40+L6/Y6B9Ywo/Lcnb41j6
         8iuOO6U76Q/am7N1WkrXjjtabDWlB/fjtFskrOkiI8M3BZjKr33YvumJOLr3HKqjin8K
         L6U6jBB2GBMvTNno166eM//ETvXsIrEHRZf4UEgAvCIJQm2D9M1bNmrqRNWIEGPxwAX8
         Ey9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RZKtd30O1LTYL5szV60uTVOLJ46mOgLYXeL8SInJEFE=;
        b=uDYWZ6wJu3yWrgPzwAzagOztk03xD6++LqHhD2g/9semz5uT2SEzONyEcidDJVW5CJ
         o8ZMAMUKsNxJTZL130VuXyrwgA1JNv2qGgoAa2wqFfJTvh9OPqQkH7zbZETEAn1AQlCF
         AW0niQyG7BUvkTMH9Fb1V559RRxxPvET5IJR36AJizwS1Cto3hZMze7Pr65G4FzNplmI
         T3wHbf57wnc6JGf+EgviwA85KaBWWI0D+pbVD2tgLmusxNHCvgsTrF15rfZoGHSg3vCp
         lVMXEZKa550j3olw4SmqzuNXjboGfLOJ997w4iYLbbLSFPxjrdvpGkZHGuYK7LwX9XnQ
         hsug==
X-Gm-Message-State: APjAAAV7SajW7x++zuaMXlQcM4juWYHlR8dN/5Mu5AbEc2ePTM3vyGbS
        16YRf7OglD5dqTArmWtO6AGZFccEt1csjQ==
X-Google-Smtp-Source: APXvYqyKfBUjI1krZhc+ipnyfyrIU8Ox6raElgtrBL2eF8NuXDcyfFFlj9tADRC1zpq0k1Oi+y+SiA==
X-Received: by 2002:a1c:f913:: with SMTP id x19mr1290330wmh.2.1568685412469;
        Mon, 16 Sep 2019 18:56:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h125sm1043190wmf.31.2019.09.16.18.56.51
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 18:56:52 -0700 (PDT)
Message-ID: <5d803d64.1c69fb81.96620.4939@mx.google.com>
Date:   Mon, 16 Sep 2019 18:56:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.15-49-g08e7f5e8f180
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 145 boots: 2 failed,
 133 passed with 10 offline (v5.2.15-49-g08e7f5e8f180)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 145 boots: 2 failed, 133 passed with 10 offline=
 (v5.2.15-49-g08e7f5e8f180)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.15-49-g08e7f5e8f180/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.15-49-g08e7f5e8f180/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.15-49-g08e7f5e8f180
Git Commit: 08e7f5e8f180bcd94e3cd96ffd6f0bb9df43ca13
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 85 unique boards, 28 SoC families, 17 builds out of 209

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            exynos5800-peach-pi: 1 failed lab

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

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
