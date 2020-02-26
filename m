Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FF716F5CA
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 03:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgBZCuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 21:50:22 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41118 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728989AbgBZCuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 21:50:22 -0500
Received: by mail-pl1-f193.google.com with SMTP id t14so657025plr.8
        for <stable@vger.kernel.org>; Tue, 25 Feb 2020 18:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RahB/YPvNKcKHZNrVz8htSgIpKfS5kdNOf3TeYUSeWA=;
        b=BKMvAhZxN5a87szHm16Pc3R94s34MRtDULY2/YrE+izY7IUNTgtS8kwkd+3FLE1t6z
         LtOLZj0vgxFMa1FzwZHfATYQGoMg/WLQ9KuPkciDsYg2PB75WatoMhxmTbU5XV+HyKxL
         yroB76GrnU5t/P3UToOakx0Y/mh9s+ib/XFVkLpcB0L4Uln4IuHcl7cogH8bLKGj2uy8
         f/auzzmWxk4e8WLLB1ExjOwAatvUQ72vhSp6yhVS4xIOvOi9XI4lc/Ar4qbL5IbLCcQZ
         vw5jXRMAxclgIzVPTw6JTB357sameMexiUUh9Mb3zOHLfBSOlrxboOewcezm2wMN7xpT
         Wk6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RahB/YPvNKcKHZNrVz8htSgIpKfS5kdNOf3TeYUSeWA=;
        b=rVDHRD58FPMg7s9Ytanlt32URDnlcnSwxRd6Uehm7UonRDzEE7MoRjUebiAL3dSyYX
         FuwV81T0f8jWP2EV2oQYtkG/v67QLA5KtMt3UNUkYiA20uKAh3RTtYl0lfGH2esMivot
         GEV50QgGBTO/Bua7lltLWfVF/VCLXH7pj205kdjZHIfYnCniwRZ8fAGB991R9dShpJeQ
         IjU093FN8QdABPnfEYhk8lQdlYMvNStkHlkZv1PpoPjGLfT2BzT8cacNkvi+ZyyYD8vR
         Z8iVhk2odkDMchl2t/CUQ9eEdVFVjkuvP5W0S1zzxK668oID0rlDy9acyrjxwFWesPKv
         dtPQ==
X-Gm-Message-State: APjAAAUy3on93X7Ay9FHxCoLyxjzJPwSY/M+59t9dX/xkivA0LESDvhp
        iqmGZeZy1qTY/KN681ib5mxJt7ozH1U=
X-Google-Smtp-Source: APXvYqxrFoaOnl7vVEYJs3TuQR9ADYFJniNLMTi4yslnEm8nZ2CYRFVr9ZlRwwDencw5AQ7CHAKk/w==
X-Received: by 2002:a17:90a:330f:: with SMTP id m15mr2461871pjb.24.1582685420698;
        Tue, 25 Feb 2020 18:50:20 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u12sm371190pgr.3.2020.02.25.18.50.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 18:50:19 -0800 (PST)
Message-ID: <5e55dceb.1c69fb81.7f287.2336@mx.google.com>
Date:   Tue, 25 Feb 2020 18:50:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.106
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 58 boots: 2 failed, 56 passed (v4.19.106)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 58 boots: 2 failed, 56 passed (v4.19.106)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.106/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.106/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.106
Git Commit: f25804f389846835535db255e7ba80eeed967ed7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 44 unique boards, 15 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.19.105)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
