Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2F51565CD
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgBHSO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:14:56 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41800 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbgBHSO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:14:56 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so2638493wrw.8
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 10:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eUr7eaY5g9x8Lnia6JLHZY21hOUNK+Vvs7QVKnvvT1U=;
        b=Kfpg21aFhmdQHOoXNMvBdBD3NAqDCPdzBs7Am5iygSyjaSbeca+mn6ZkR3l+/E72Su
         88g1JXgcS6DoKX219AX5PqDKPhzmR9xn9we91NtmwLARYG3HggbdcCGdTdye2xUDJYbw
         3Ajq30wcBtoGEqg1fougIVQ+R4XP4wGFIT0GTOphmTQMt4HUSsDLG7EYu3aiOy5483W7
         eqZChsm0pNFf531l8KX0DzzGAHgp/Qzi8xv/2dGa5qs8AIt5MnqfdWGyUGUVnWRw3iwh
         knyQZriaiXzm8rth/CiEVJ918Sglu6sshrQd2v34wa2uu129YspwTO2WPi1Tzf6LFydW
         g4UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eUr7eaY5g9x8Lnia6JLHZY21hOUNK+Vvs7QVKnvvT1U=;
        b=clvLS4Oq8Ez2ff9iywVpYl/jx2D8dIc/G2InOIP3kCfxXBNLwrkqLB93RJ8bNTL7Ee
         wvw2uA2cink40VyGUj51lnbfMDhhO2GMO1yTyCp98FJxj+cgb69+Pt74RxSjbvHZAnYq
         bY5sWavIMBwdO7HCox9NqJCZsXKNTL7ycGKhumKom/hkzlTie8LOSdq6EJx/BFdr5I3e
         6CnEVytQdsO1tP33LHLgdzWuVxlGGv5FNl06em0ssggzRfdpx3/vvzakNP/n4vQlpJm/
         p5xYzLg+gWOahHrsH9yOR5TStwtaY0bDqzIm3QIJWu2mpxUyjWn54CWnSDYkM4UOypSz
         dYRA==
X-Gm-Message-State: APjAAAUCB1g6vkPQyZLgLCHKuvTn83qHXb1Fv/nGdCQMwDK05ASR1iAB
        aoWwqQDVmaYWmd18aUk9Bz85jtWrORc=
X-Google-Smtp-Source: APXvYqwSq5ImVC0CxTnBvbaN3CCN90Q9Sl/C0YJ1QIOOYa3qFuJDTsuc+PEetx5pmNQFVVr0UBMsfA==
X-Received: by 2002:adf:93c1:: with SMTP id 59mr6427850wrp.399.1581185695070;
        Sat, 08 Feb 2020 10:14:55 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b67sm8341176wmc.38.2020.02.08.10.14.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 10:14:54 -0800 (PST)
Message-ID: <5e3efa9e.1c69fb81.8b227.3639@mx.google.com>
Date:   Sat, 08 Feb 2020 10:14:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.213-37-g0c8606b6eeb4
Subject: stable-rc/linux-4.9.y boot: 23 boots: 2 failed,
 20 passed with 1 offline (v4.9.213-37-g0c8606b6eeb4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 23 boots: 2 failed, 20 passed with 1 offline (v=
4.9.213-37-g0c8606b6eeb4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.213-37-g0c8606b6eeb4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.213-37-g0c8606b6eeb4/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.213-37-g0c8606b6eeb4
Git Commit: 0c8606b6eeb4dc7c89397463dbcb7f3527896156
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 22 unique boards, 10 SoC families, 10 builds out of 148

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.9.213-37-g860ec95da9=
ad)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm:

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

---
For more info write to <info@kernelci.org>
