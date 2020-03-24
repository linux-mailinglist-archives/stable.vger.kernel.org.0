Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39F0191AD7
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 21:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgCXUSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 16:18:52 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41197 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgCXUSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 16:18:52 -0400
Received: by mail-pf1-f195.google.com with SMTP id z65so9883513pfz.8
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 13:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=782DNnJoc05PGFV5DkcXmX4FJL0rGclSaK330laJdro=;
        b=p0rYItuwVSkxMMvHgdOkc23elcDYFBx41mN+bR657wWq/T5FYN/achNpU7j751AcM+
         ALn3SDPvFe/8ZyDsEiF81BRv2tIThLYgDAHOA79wMYPsrVHruwRFkk6JBLU7buaIGOZB
         mI5mYu6MaNwYsJK+tHNpPF3QIRNa81E9yI1LZ3AtJaPRgu2V+cHY4mFVaNkLFADIc/hi
         4VUl0VuyZKDtGgmMz6lgTQZXmR9XtFao93SlZK75x92kEHYop3JZh3GTg9ye0shla9Xg
         DLHZJlwfFTVGqLi2pZVSfGSpH7qhfDtviOY4VcYmgzndZ6DPtNL6UYs7M821F+SwuQU2
         Ub0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=782DNnJoc05PGFV5DkcXmX4FJL0rGclSaK330laJdro=;
        b=eP3hUr6YeDgqytb+dd769knVlHR4CkhIKcWOPFj83DF3oTfMndtX6ZijPumPvAvPif
         JL/36cpzBbnOB5YOp3DPh9ZyLxHSigRff9kOT/inVRP4AlVQjJ15whZYTKmZdMyd0Tkl
         nFooKQvIJm7xPHRY5WCndLhtXKC9NXbXuKvvIrtvUnJhcN/KGLOPSX/aUwl48ykDESM3
         zl1O/T+Y8ZxjjK8O6QYWwTf1l7YD02UIQaag/Wef+Yo5yE/+V502JihcDYyPQQcFNVzV
         j1ZTZH2D1N5hPv2zF3kF34xuC/D0QaROg4VvuFI1VQbL9jpaw/CM3WX72ThybIp7Zy/M
         YmJQ==
X-Gm-Message-State: ANhLgQ0EE775fraC5qfwyJvgkEqlENAvWU7DkZHYF2gKuof5ZKg19SKd
        i47X251L6wXYtePa4K3IdapQN/Y6bXc=
X-Google-Smtp-Source: ADFU+vtPtFy0r1Q4Bmxjhtb6NFo62jM2dIP6KS1aapV00bigg5YsH6bGG/AkpEMnsyi/tBgS5K68Ow==
X-Received: by 2002:a63:8148:: with SMTP id t69mr28401476pgd.187.1585081130608;
        Tue, 24 Mar 2020 13:18:50 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x24sm7789075pfn.140.2020.03.24.13.18.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 13:18:50 -0700 (PDT)
Message-ID: <5e7a6b2a.1c69fb81.8b0ca.1388@mx.google.com>
Date:   Tue, 24 Mar 2020 13:18:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.109-202-g69e7137de31c
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 143 boots: 2 failed,
 134 passed with 2 offline, 5 untried/unknown (v4.19.109-202-g69e7137de31c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 143 boots: 2 failed, 134 passed with 2 offline=
, 5 untried/unknown (v4.19.109-202-g69e7137de31c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.109-202-g69e7137de31c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.109-202-g69e7137de31c/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.109-202-g69e7137de31c
Git Commit: 69e7137de31c53890ed823aee0818a6a6563c445
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 82 unique boards, 22 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 45 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 11 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.109-192-gbae09bf=
235a5)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.19.109-192-gbae09bf2=
35a5)
          sun50i-a64-bananapi-m64:
              lab-clabbe: new failure (last pass: v4.19.109-192-gbae09bf235=
a5)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
