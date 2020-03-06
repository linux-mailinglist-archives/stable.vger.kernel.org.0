Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6A317B7B6
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 08:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgCFHsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 02:48:01 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42641 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgCFHsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 02:48:01 -0500
Received: by mail-pf1-f194.google.com with SMTP id f5so702998pfk.9
        for <stable@vger.kernel.org>; Thu, 05 Mar 2020 23:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aUviFH2//P42mFJTFcCBcOSPq7YfZSBvicLXCS5Ztno=;
        b=NBCEs3ShJMvSs7va4dJmagW8euuh6V82LWaNZxqthTYdCH7TyCMQc9MNdJerpOSVW0
         1XiEmvctXK619lhciWe4+Wkximi69QXprDruwGoq6UFgFjklsNrnrhH5K807Pvy6UBhf
         dsldzTEF/TUGbWRmMIlv/YOx56sUTaowo8AlaTMBaYIRIKi1NFrQ9XtMRCjckpDQdvCJ
         6tam9He6tjHlx5AJhopr5B7xsKDJGIY+f2EkRhC2t3Tl5Eltrdo/Z6xJook1rHemfBc1
         rfpClvdrlC8M9wnalW/dI4otoAUGV9miwD31iDn+vLxHIGHy/Kqz1gSvxsq8kmU9OjdX
         wtNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aUviFH2//P42mFJTFcCBcOSPq7YfZSBvicLXCS5Ztno=;
        b=ZYTYHAnjkTP7E0zh1wVL9KHdu+q5iQv9tCRho0iVW3nFS+11iXdHhWYoIqTiOzsxqq
         1N/aLoQwYCAUHLSWSuiLIaHgg+N8VBisrNcA27IEZDudts4RB+qygZgVKqlUcpveJaeq
         87X3zukVkdPb7a5LcM94CncWi6QfsnVQvbPY5FyobK79tiQEA3ZR5HQxEzHPQ3/PUl7d
         1ejpRuirOS0a+KRxnQCZxXj19JjBwJGqAwfom8jBGuBBJQMjgACN2uqOLFn+Nom5rDpS
         j24zxKO6z3L8js7w9Yfw7ALNHdJj6WJQ3Gry79JLbLwJMabTvj75mBxEMSNkln81qPSn
         OwcQ==
X-Gm-Message-State: ANhLgQ1ipGpSiX1ueftd5NfaHbp/XlAspWVJD3zEQJNJrKt1LJeHrbVs
        pYEFEWJVWbGhVfVxWc1E1anjoK/DiVA=
X-Google-Smtp-Source: ADFU+vsQY0iB+KeDYXjpIRNlXHZBgC+K6iZZl1mTiWu5NIoI+SPMZSPwvJy28n3EZpIGC/ZjcEH6IA==
X-Received: by 2002:a63:1e06:: with SMTP id e6mr2185270pge.134.1583480879655;
        Thu, 05 Mar 2020 23:47:59 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m9sm1318646pga.92.2020.03.05.23.47.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 23:47:59 -0800 (PST)
Message-ID: <5e62002f.1c69fb81.45747.3f11@mx.google.com>
Date:   Thu, 05 Mar 2020 23:47:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.108
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 56 boots: 1 failed,
 54 passed with 1 untried/unknown (v4.19.108)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 56 boots: 1 failed, 54 passed with 1 untried/unkn=
own (v4.19.108)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.108/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.108/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.108
Git Commit: 7472c4028e2357202949f99ad94c5a5a34f95666
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 45 unique boards, 16 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.107)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
