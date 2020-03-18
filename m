Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9044F189B7B
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 12:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgCRL76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 07:59:58 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38564 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgCRL76 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Mar 2020 07:59:58 -0400
Received: by mail-pl1-f195.google.com with SMTP id w3so11096473plz.5
        for <stable@vger.kernel.org>; Wed, 18 Mar 2020 04:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CYq4WiqcvuVd5I4ZhOGjvp8wmpqHVQKNXjSG7CdezZc=;
        b=2JI/LiSlD2aH9hLv3Y5NnU72gEYfdBaUI75BDVImw6jK5h7NH/1WAo4FXwmpnKwCiX
         FBivB4xMAcuHq/EhSIkT9zdmUzUzQeZ9r3abM7i/8Sj2jZX5GzN8aLpBHMWzWErCO6Zv
         7zx3ygO0GF3/gec1MfX1mZRNJr1py33iB+/sIcTTAEuZNUNTklnydzfwyBa1ztNWIBeV
         LLy5cJD1Gmab6lmatHXJCTQoXSYkTxASlwZtrjMT6O2DzMYO4bNlHxtAX3GIzutgwPSl
         KIqELe46uYzE7D5qpbMyyvMamgKOSxFPE6MKcaXXEcrW1bjp9R/QaOsGbrlL7rtyL/H4
         SKOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CYq4WiqcvuVd5I4ZhOGjvp8wmpqHVQKNXjSG7CdezZc=;
        b=DVyJDG3ahRs8zcmmYcQ1qbRXsplp651UXxoh+z0g2Vm2+NSpMRj/zjUuq0LBGjcZ0u
         XcGk2sbjsHJkkyCYApFZA9pUcg1cxQ6BE05q67iG2Ys3K7b6A89rwRiaTHGCu7B60UmG
         EKFzPOQ8akgR2SIbqGGSsNRV9hiUOQqbJKMekI+/NADAKqS4HnHmgB/Q29srh26T3t1d
         dZX/bG5YhsGHfxhfLLzC6iDTiQ1CstdA1Zz8BBYxfXcIxZf7EmDZLdn9nkFgerTA5hxK
         nleC+fXZwM5pFpk+vdCDR3lPqVTM8h39beeEbbcWvnXxQL5VWcZX5uqPeg1SiaPvqbJs
         Xzxw==
X-Gm-Message-State: ANhLgQ21TsxbmCnz7h/svLKrzecfvr8FdQL/U+4eC1ppqZpclFDJSDxp
        clqepYsA+zwcDQHljZu/mqw9wovDn5w=
X-Google-Smtp-Source: ADFU+vtj9m18VSQfP2CymCNkJCTPR+2NLix+MYTdHaml1KqnmDy3PxWUr99O6+f2tXQXRBPPRKDtHg==
X-Received: by 2002:a17:90a:730b:: with SMTP id m11mr4348777pjk.195.1584532796951;
        Wed, 18 Mar 2020 04:59:56 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d6sm2452794pjz.39.2020.03.18.04.59.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 04:59:56 -0700 (PDT)
Message-ID: <5e720d3c.1c69fb81.62c81.93ed@mx.google.com>
Date:   Wed, 18 Mar 2020 04:59:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.111
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 94 boots: 1 failed,
 88 passed with 5 untried/unknown (v4.19.111)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 94 boots: 1 failed, 88 passed with 5 untried/unkn=
own (v4.19.111)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.111/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.111/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.111
Git Commit: 93556fb211fa7f1e18f869bdce0c225c25594942
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 55 unique boards, 16 SoC families, 18 builds out of 206

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.110)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-collabora: failing since 1 day (last pass: v4.19.109 - fi=
rst fail: v4.19.110)
              lab-baylibre: failing since 1 day (last pass: v4.19.109 - fir=
st fail: v4.19.110)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
