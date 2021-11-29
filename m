Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937F2460EB8
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 07:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343505AbhK2GYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 01:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbhK2GWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 01:22:38 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30462C061746
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 22:19:21 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id s37so5369750pga.9
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 22:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=I5x8sUTaEEuX66SVzsSBj+Z42O0lYb2plKpQl/uArmo=;
        b=Y7LUEH2apGvb36tlvrV5/GeN3YHgKDmBEdgQcu1+25shdb1aF5YPMZRlbLUOjz8PNf
         XmWWiapEOl1+ZZD1Cud6S9ACvU4u3hWXleeqa8jDkX9QzYT8mqgJ8s01QoA+WFQ5dAWM
         C2MSwf2OAUeDMSi0IfrzIGWkcEqw5GAxEasxAffGX+lGYZ7ePkiG6gyQ9HW/PnuA5KKg
         3woKDsHr9brrKXFJW68ASmyxVaqeSefSEzQ1JwUNvngGrlpJwkrGOMW/uGT9juHbA96C
         S6XonB9nk5ZqODNE2iAG71qusZnG+1iAQOkwe5SJmw8X/k3vo80pqjr31umbXTzNB3/9
         /NhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=I5x8sUTaEEuX66SVzsSBj+Z42O0lYb2plKpQl/uArmo=;
        b=rq8Vv678SxgsLOvMGmiNmNzc2XhI7fwB7p4SvmIdX3SvcVjrLwDvr9LpkrLSvhtAcM
         /m07YQNd5G6K7oCpJm1IEelnnlshBwpNkPRLjosFaZYW2RVyGy/Uweb42CtrCXAdY9/n
         8x/cnjw5xh8mg0pyPAqAOVRXMk2eoKFs3KvEvczJWcZvEkFhjVofdz3GIx2qoulYOk/y
         qJlA4nN7S5Hu7nA2vWpqYRJTFNOHRXaA6h446wn4DS1G2fcCFjXmlnHeDvkVTypIdogO
         7sm1wXEyzLwt5aegWR37aRii2BF2JwDbcaYOdJClPZXeVkPYSIkUgkI0LOyKH0Z93ddx
         kiZQ==
X-Gm-Message-State: AOAM531xjsab4CcMTfWtl79GFcKMa62vKsy259I7hommBI9CMW77jwNW
        Z04zmXlsnt/GS8qhnMMoLPbt2OiABW+1rcPt
X-Google-Smtp-Source: ABdhPJxK5vX+4wJkeaNpscgLcVzQGPCwFBPO+SQ4kohWh0Uvfb+z9dsxYO7LMPEk0cU3O/wfH4HFtw==
X-Received: by 2002:a63:5119:: with SMTP id f25mr23568534pgb.11.1638166760625;
        Sun, 28 Nov 2021 22:19:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s16sm15711022pfu.109.2021.11.28.22.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 22:19:20 -0800 (PST)
Message-ID: <61a470e8.1c69fb81.a39d.b39e@mx.google.com>
Date:   Sun, 28 Nov 2021 22:19:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.218-54-g88fd43d770ff1
Subject: stable-rc/queue/4.19 baseline: 144 runs,
 1 regressions (v4.19.218-54-g88fd43d770ff1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 144 runs, 1 regressions (v4.19.218-54-g88fd4=
3d770ff1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.218-54-g88fd43d770ff1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.218-54-g88fd43d770ff1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      88fd43d770ff12deb64b2cfc7d9bd41d4571ce26 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a4381897ac6cbbac18f6cd

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-54-g88fd43d770ff1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-54-g88fd43d770ff1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a4381897ac6cb=
bac18f6d3
        failing since 3 days (last pass: v4.19.217-320-gdc7db2be81d5, first=
 fail: v4.19.217-320-ge8717633e0ba)
        2 lines

    2021-11-29T02:16:37.516194  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2021-11-29T02:16:37.525991  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
