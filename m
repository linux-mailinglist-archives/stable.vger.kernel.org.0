Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A548045DC7D
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 15:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237397AbhKYOmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 09:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354109AbhKYOlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 09:41:25 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561D1C06173E
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 06:38:14 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id v23so5300209pjr.5
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 06:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7Y2B4h7Cz/JqhaZ+4nTg2J5De5mbDaJgAPOp0pbF5bA=;
        b=4gr6jGWbS9MHU0hcS5MflFzyALKwtUjvOvDSAfDo68bwMk1n9Qfz8txicArGSMICDY
         2uVfiOmX8wb59fsv9nHAt/sRe/bcUA2XX3kgrC6Kk79RLd1DwbXNF91lVGyj3Kce3Ww0
         BuVLWYY/JmBi9mcIlRZpeW6p9uFQFCLtMPD3dpv013FvWyogaZnlZRttN90P9o6WNh2J
         ZNwKZFGvs1wsBG7K+Xqjbt3u2xuxNgjzEh+XpS+Gk0PgPcZKcNBJ/AGy8HJ7YGaM8DGq
         OckHg3T9i0+VqNu4mpiKRQVrlZJCXp6cmw7iI5abKzKlE+R9L6iOGOquIdweB7Q4jAh6
         vl9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7Y2B4h7Cz/JqhaZ+4nTg2J5De5mbDaJgAPOp0pbF5bA=;
        b=zDlwpnwYTUsI3+hvfCsxnQ4O2+scbFe36F2IvRLN+NgKIuas9TFp9EEIqVQ4SlH33f
         behdRDtvNcU7LQS+Mgf296KvLeD1WSkafDzZ/bFu0c8zdmI/BRvIxKswV1+JEWqZfqqu
         NSD6gN3OTyc6R4nqUI/6BMOr2s90G1ZIHufsgQ74ogI63NKKoa1QMTB0bYDUQDJwzFIv
         y9pdFPOmy9cVHSIEyvAp3aAp+1P6i8SZO0b0KOUbdUp0yFp040Qn9U7xxh8v9qYtvSA/
         1rxuLw4E4WwO54dKq+gP9fTkLrzMYhwxG3Sefw8W2VjuqtEsYGXLyPapy5NaRHb1js3h
         V/Tw==
X-Gm-Message-State: AOAM530TrM/ntX/8g4jk3bnEFxjBuy3vLWF6eGXhf/E400ajHnOGvXoy
        EIW/1IwVJGTwR53DrOvaq24nKYwE9YE6iKNHZl0=
X-Google-Smtp-Source: ABdhPJwiZGLpWrjA53yM/VXy5I3UBkb0LPjqQA81QQWkNGcwv3vMKsj6wScJyYthJrpyQlr308mQEA==
X-Received: by 2002:a17:903:286:b0:142:4abc:88b8 with SMTP id j6-20020a170903028600b001424abc88b8mr30380423plr.25.1637851093770;
        Thu, 25 Nov 2021 06:38:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d10sm3781733pfl.139.2021.11.25.06.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 06:38:13 -0800 (PST)
Message-ID: <619f9fd5.1c69fb81.b1a1e.9ce0@mx.google.com>
Date:   Thu, 25 Nov 2021 06:38:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.217-320-ge8717633e0ba
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 144 runs,
 1 regressions (v4.19.217-320-ge8717633e0ba)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 144 runs, 1 regressions (v4.19.217-320-ge871=
7633e0ba)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-320-ge8717633e0ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-320-ge8717633e0ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e8717633e0baa300c689fcd4dfb8bc17ef42661b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619f6817cc6fbf12c4f2efd0

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-320-ge8717633e0ba/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-320-ge8717633e0ba/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619f6817cc6fbf1=
2c4f2efd3
        new failure (last pass: v4.19.217-320-gdc7db2be81d5)
        2 lines

    2021-11-25T10:40:08.187036  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-11-25T10:40:08.198795  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-25T10:40:08.210980  <8>[   21.218749] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
