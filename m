Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10750192ACD
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 15:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgCYOJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 10:09:07 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44859 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbgCYOJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 10:09:07 -0400
Received: by mail-pl1-f193.google.com with SMTP id h11so829190plr.11
        for <stable@vger.kernel.org>; Wed, 25 Mar 2020 07:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Iv8+FrryUY+TTrhwuVmfxExuy2wedAK1qgjNgJhYe64=;
        b=URI2vPtvKyN+91vPTt7p0/RiIGAoVj7Ui0+P0ALCoB3Sq6fSYBs4acHkl50k1/xgaU
         dn1aswYUgXJnuXblzoCFEFZLPfBuzzegHMwx64SMeFjxzlQZWAQFaubfyx4pDZs0F88T
         cc5S0ssz6BOUvlX0lBpKFyVQhg76ydnTn4EWbaXlHPE/5PrAcs7nK289VtuL/Fb0x8g+
         gcytB+xkZC1LUmOMc9w+ICPxK0V3SQg/0nbGsExQtnHp1Co1t4pxT3Nd4j79h3f0mj1P
         gCgG/TSYzZDm8uBWAQA67nA+uAahN4UsPkU2DPW5Q58I1ur0xDo/cEkzcZXZ3O1FosA1
         Udjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Iv8+FrryUY+TTrhwuVmfxExuy2wedAK1qgjNgJhYe64=;
        b=fi7E0QeH8b4XoAdDvWTej6jQzC7zdlzTOHkQxrXyYHLmcZknynVi3BeKuVEZH3N3BW
         vqEZuZh0B889ni2pvwl75xCLy1t/VcBcf7/89zYIpMdOZfYGiMFrH1B7w1W0pIEGLWGY
         aNXy/A/OwwOWYj5miQMS92mHaLKLQDW4fqvxqLpvonzV1BzMn51QHFh0ySFUuqVW9ewA
         eoRaOPW8G5oWyq9wIzrvHHUnHKK1FCKm8ueS16Y2Jmkjp3NLphj4DTvt+rsq4rwJj/fc
         ssnC8q7DqkW4ehpY2f4jFjgK0H/xrKWWv8Dgqn2Dx1TCSiYxAkb0Jrv8cKRqCB/CEkQ5
         9bHw==
X-Gm-Message-State: ANhLgQ3x7lpR7Psyp+pWW9nG9r+KbKWFHB6m9+k0FmyvX8Ry//er8t8K
        743XBV1WFhfmXHFSV2MgfFntrQDsceM=
X-Google-Smtp-Source: ADFU+vvAmNwyy9RVWpKgFXYATlx8U3Zgi8cXw+Sj3GqEAmQBboLtNU+y/ZUwpQNYTTvI2Gct+Nj0cA==
X-Received: by 2002:a17:90a:aa0c:: with SMTP id k12mr4004123pjq.193.1585145345549;
        Wed, 25 Mar 2020 07:09:05 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fa16sm1567899pjb.39.2020.03.25.07.09.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 07:09:04 -0700 (PDT)
Message-ID: <5e7b6600.1c69fb81.fb4a.638e@mx.google.com>
Date:   Wed, 25 Mar 2020 07:09:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.113
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 91 boots: 1 failed,
 84 passed with 6 untried/unknown (v4.19.113)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 91 boots: 1 failed, 84 passed with 6 untried/unkn=
own (v4.19.113)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.113/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.113/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.113
Git Commit: 54b4fa6d39551639cb10664f6ac78b01993a1d7e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 54 unique boards, 17 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.19.112)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.112)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-baylibre: failing since 8 days (last pass: v4.19.109 - fi=
rst fail: v4.19.110)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
