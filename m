Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D91A461135
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 10:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245026AbhK2JlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 04:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241100AbhK2JjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 04:39:25 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCA5C0619DC
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 01:21:26 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 137so8394929pgg.3
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 01:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jXgYH5JE/QYhk4u7zTnI1iuHOvvvFpEluWG6P+/vaAQ=;
        b=IRqj0m+q/+QEo81wfmyqAb96pvrTmjSGsmPBat8VSFDAgzFO6BXDTmKc1Ye0qDHjHq
         TBy77z67C08dWdBEAwvtTkEu3Rm4vLlAqbyBAKRSCj5Jjb9sjf8aEu+ozHJz+nuBbjKS
         JyN6OshTjzvESkpI1CiWu8C13hsRyDqRcYdb0NunyNxRjpFWsQDzLHh26MNVCB+rIwXq
         xXYDO+blwtzpKIaEV3l+1Dj6/LRHc5WyGpxNtsGJKfZx05sZbagdK8Wi2KyKPJprt2Du
         E6dQ+rCjVTu4LrCl7ZHQSlj8TKH2NlL4LrPPn2dSMK1BcAFmYx+93GuqPywTzHRRXKX7
         pGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jXgYH5JE/QYhk4u7zTnI1iuHOvvvFpEluWG6P+/vaAQ=;
        b=2cIX7bmpDYDk5k91Ei/NrTX8sfqOqKuObDb4lw0CFCbVWDZhDuvUCXFVCO17V99DlH
         Ss6BVqZR5IqFwD5G8VN7G1EkqX/Z1m7BGVS/JNsqQJvOgWQoc4IOKE1n0kntqWb8W1Dn
         uogOSzK6AxU5TUP18khpoa8cYosFlWuj8CDzN8r/kWLrfVHm11Op+7lvOWbzfCs02jKN
         oLVCfSqBUm1URE/p3rE+yNA2ovGMFnIb526Q2OMc5dVMFvukZcM8LW3IxsbBuxQjdTbm
         oTQbLSzhJ3nqqptzrEQNOzWR7kxgftTEiRqBKJWum77E6DkBtYcDQAyKJpTeLFPxqY5G
         YeIw==
X-Gm-Message-State: AOAM533HRhfnF0U5mIv30XloqSIfjGpAw2TQ+AwoAEDfuexW2U0c96TW
        B8TY9Aw4/JhPVT9TwpQdKmWADokPnKfsx7In
X-Google-Smtp-Source: ABdhPJzTvEOJUxBhp4fWER9yIni4qZEsykexd03GQf8+Uvuz9jwoTuqX2REte5mciBVNblZ6VDRWMQ==
X-Received: by 2002:a65:5908:: with SMTP id f8mr18294924pgu.122.1638177686335;
        Mon, 29 Nov 2021 01:21:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s15sm13020938pjs.51.2021.11.29.01.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 01:21:26 -0800 (PST)
Message-ID: <61a49b96.1c69fb81.53640.2df4@mx.google.com>
Date:   Mon, 29 Nov 2021 01:21:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-17-gbaf746486d1e8
Subject: stable-rc/queue/4.4 baseline: 104 runs,
 1 regressions (v4.4.293-17-gbaf746486d1e8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 104 runs, 1 regressions (v4.4.293-17-gbaf7464=
86d1e8)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-17-gbaf746486d1e8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-17-gbaf746486d1e8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      baf746486d1e89c99c547218c2d20454cfa54192 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a464be9fc6a7f2c118f6e7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-1=
7-gbaf746486d1e8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-1=
7-gbaf746486d1e8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a464be9fc6a7f=
2c118f6ed
        failing since 3 days (last pass: v4.4.292-160-geb7fba21283a, first =
fail: v4.4.292-160-g4d766382518e6)
        2 lines

    2021-11-29T05:27:04.178119  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2021-11-29T05:27:04.187999  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
