Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1B6156A1B
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 13:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbgBIMe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 07:34:57 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46240 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727514AbgBIMe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 07:34:57 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so4105405wrl.13
        for <stable@vger.kernel.org>; Sun, 09 Feb 2020 04:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mRTepjLRxEa8oTrUZU3M/mo0IwV6isE67t4QPCsMu0Q=;
        b=JSlgzJOalyN2HTZwKIUB5oay5W2HWm+zfi/Rqo0rW+LDfGnk0+A8InNvT1I0n5uE2w
         nW7CG+PPoqqeg2lwz9XYV9f297uzqXWWm6JMWkKOUeQUquz6zUUIJadlgXoKC/sCIObX
         FfyDk8vrLqDE+im3oEkuIoR5eoQRvaf+QOGuA6+8rElhe5UWgND7PbY+z46IBE0FEQol
         FrkxRVhiTd1jFLvIFK277/4Q9h9RyAmmRGUIe2URU8UIC+AhlReRnwdXTiVhsiMHxxCu
         PNFd1cunZqlvsZl23yXIVRTF27s2fUbcBOZvDCqAbXTjHj5U3mz47lFEpWqIgiJG9tEY
         l2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mRTepjLRxEa8oTrUZU3M/mo0IwV6isE67t4QPCsMu0Q=;
        b=stl4XGuZQLKDOmNRTKUFrCs9D7pS92FYVm75l8mL4JOEwv6XwTKVufOiKJhE14sdHt
         +C7/r6RD5rZ1A7JRaceYzjkY+00VeFAkI8WDhOJX4LRB7hiXky8mBqteG+8dP16+2TPR
         amATSWLkCQa6UnLXq7UqGp8tFJQFGOStmDCx1vygGZ45VwUv4wrgnS7S4TfdmY90zuMK
         5jVDP/FZ0GuaVLaLvbqn5v8mZ63Am7i8aeumPl8sQSkKGSBROqN1UZFgxYOdvZg2SU5U
         IFqXF9hm5RjaqsuABEKeBoyPv2X2h3d1FEqPjICknVZzulyDv8bic/G1a2CndEdFEm8L
         8IgQ==
X-Gm-Message-State: APjAAAW3CAsAHrDGjvpv7QqSpx1Pml45/wfUdf8GTIoNHsqoe2AK5WeJ
        u4Ghg2qPcwIiEubv9Y/f3Vtsl6/u3gE=
X-Google-Smtp-Source: APXvYqwgskmSec4QNxX/7gbuwynqycNgLe7Gigm75pzLdaluPGsVBFLIuome0uekPpTWs15LUx2Vgg==
X-Received: by 2002:a5d:6709:: with SMTP id o9mr9106302wru.82.1581251693642;
        Sun, 09 Feb 2020 04:34:53 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f12sm10929826wmj.10.2020.02.09.04.34.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 04:34:53 -0800 (PST)
Message-ID: <5e3ffc6d.1c69fb81.49f8.e8b8@mx.google.com>
Date:   Sun, 09 Feb 2020 04:34:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.213-40-gfcc8ed94eb12
Subject: stable-rc/linux-4.9.y boot: 55 boots: 1 failed,
 50 passed with 4 offline (v4.9.213-40-gfcc8ed94eb12)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 55 boots: 1 failed, 50 passed with 4 offline (v=
4.9.213-40-gfcc8ed94eb12)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.213-40-gfcc8ed94eb12/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.213-40-gfcc8ed94eb12/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.213-40-gfcc8ed94eb12
Git Commit: fcc8ed94eb120dae3a8d80a074a2f9052e01334d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 15 SoC families, 14 builds out of 155

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.21=
3 - first fail: v4.9.213-37-g860ec95da9ad)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
