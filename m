Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018554885C9
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 21:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbiAHUFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 15:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbiAHUE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jan 2022 15:04:59 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F58C06173F
        for <stable@vger.kernel.org>; Sat,  8 Jan 2022 12:04:59 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id x15so8600001plg.1
        for <stable@vger.kernel.org>; Sat, 08 Jan 2022 12:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gQSgPEFUjljE8H4fZWWLE+xsXU27PfFDjJtTt5snoH4=;
        b=fb5vQxKljzb/CUou55fllvS46i/4t5G01Fmp2E6od/wspOEofD8U5WmA8n7qpVsEgy
         hCHogto1IWAz0teqIeCY2rpt3oqueEnBsCldoiXHg7RuaNZWZG+A2fbAYvdoxoDFjpAl
         XF3icu7sk58T/rfZqQsxdDveOSuFG1hY8pQxGYJry6MFAy86vWXYdlxqB2T4dPfELkl8
         IwTCD4ep4JiJmuJzwvpwODBs1zONtHADEx2JDeW/TGTH4n19f6BseCYCAA8W/+LddSM5
         viprfIbYxEXc4xBg1W7lh9NKabuw576enFN0tdwtuWSekUGxIgVEynsbFEYdhjQu21qV
         Y18g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gQSgPEFUjljE8H4fZWWLE+xsXU27PfFDjJtTt5snoH4=;
        b=N6jbIqWqRFdUtULXtOWDsJ8JPvmZMzngb2JL003mpfOkMMAkSqRmgkamnsbfVeZD69
         wv8nE5/RXZ8hMeS8mkc1orvsoecceZbFFvrKPFVKI+oVwMQLOMQuFCdYKoX9yveakpWQ
         j4BLWHT7oyKr58RUfaZoL5ckXI6TpYDPdXS92qqChpiC1pfYMpGoacuNsQUeH/qPbP1N
         HmbLKWxJI5ujj7MFejTLRt7NVEbZyFRmm5/qR9SuHyzC/h5uL6WIv4B4mkuno53R9hmZ
         WaQnsBQtJBp5QegNHNDPxYMhowY+AjtkAr5vTtN1rXYIGAOB4OSLI0+yLsFexqoiDZOz
         JbWw==
X-Gm-Message-State: AOAM533gTI8bFhZG+KuPCZqAdLa1fYFvyltbu406FMXd92u4amLhWmDT
        PQqW610M1m3B28dQQTcLxz9RdP4qPCKMAPp9
X-Google-Smtp-Source: ABdhPJyhcZJMk+fMXUbR6JzdLCcmNuXNiXK/G3Y+4Fbyi+e3uyQK5I9UrE5iY4iXN71zvnjxmEqGlg==
X-Received: by 2002:a17:90b:350b:: with SMTP id ls11mr21764409pjb.134.1641672299211;
        Sat, 08 Jan 2022 12:04:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d14sm2653774pfl.132.2022.01.08.12.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:04:58 -0800 (PST)
Message-ID: <61d9ee6a.1c69fb81.84d4a.6537@mx.google.com>
Date:   Sat, 08 Jan 2022 12:04:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.298-6-g4b4bab5f86d5
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 115 runs,
 1 regressions (v4.4.298-6-g4b4bab5f86d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 115 runs, 1 regressions (v4.4.298-6-g4b4bab5f=
86d5)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.298-6-g4b4bab5f86d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.298-6-g4b4bab5f86d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4b4bab5f86d58b7138ac6a508ea6174af11d2ae4 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d9bc624ab3277e5aef674f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-6=
-g4b4bab5f86d5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-6=
-g4b4bab5f86d5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d9bc624ab3277=
e5aef6752
        failing since 18 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-08T16:31:10.707781  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2022-01-08T16:31:10.716953  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
