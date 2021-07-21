Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD513D0DDA
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 13:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238575AbhGUKxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 06:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239643AbhGUKZc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 06:25:32 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5AFC0613DC
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 04:04:36 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gx2so1425664pjb.5
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 04:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bHBVF1WpyuNWar1FP+FOKcHwMazg2EV+1a3F1h1g8wg=;
        b=YbdCy73hcKraNHydYz/G9qYoPYSTDsGOW2HB/t8cMFBSv7T5p5NUxRe72WKNX8kP8L
         HzX8L8xAOz6c9joSoEhEiNfrTsBZb0+B/jVjOZr9qr4T1hb83T55tWmCJIcjxdpUjW9Y
         eLqYhJ1n7IV8WuZfT8h+wo7ySg3OkZVu7rzpOvszth5CvY+nqZgyDkNKua/01cmxnljQ
         5OQEbgv71PakHaaWVohp/9nJv94KCLSuKmLVVwJEsWM8OvOV7xDUAc8Go0mEkybLxgu6
         tcYavkaeAGs2D2SqjZyQIctZL6HpHb0U1W0ErTVYCasYYUy9nVGor8CqbQ9tbJcYYif6
         35gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bHBVF1WpyuNWar1FP+FOKcHwMazg2EV+1a3F1h1g8wg=;
        b=LIKzy6AZfPAMij3pm484fsJThjJswJ0+r9t1BY5W1Oy2ss3T41YbUlaluGClR4mN+b
         K5ct9gzVAhJU1rH2oYdsl9IFQ3iy5+oKMOVJyfhtWs3TCxi+iHJIswk1Z4Il4H+nvACS
         sVUYNGTb0UHHrjtXiiJFTnLbWSfi9K1TRD7hRkIc6RlV535gs/t8Nv5R9uzTZqDaspAF
         IxuVuZMrd6NMfNPRAPzB14i7F20MQe8SDzIBQqf+qrRVk246iB0vKh0wkb9E1kxRlGML
         OnNg/ZNPDuv4qISiIUMSG6ZKp+GZpXm0D4+oa4A5uSKd95cIy49ngQEsXZTb8Y1uOW75
         k1KA==
X-Gm-Message-State: AOAM530buAe8FgxcpQI2P0Jfg36ZzP4TFHoENItT2b3KUl9PYvtRasWl
        5zeMMQxBDpFfqv24hODtcaMzR5hynjgBUtHb
X-Google-Smtp-Source: ABdhPJwjNou0clH9qUwzuqZtDUZeiOuM3mr7BWaJ+MZbtMHIHvvrfY3Zuu+ya+Yru3u+DiCsyGCdog==
X-Received: by 2002:a17:90a:9ab:: with SMTP id 40mr3233529pjo.9.1626865475699;
        Wed, 21 Jul 2021 04:04:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r15sm22331862pje.12.2021.07.21.04.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 04:04:35 -0700 (PDT)
Message-ID: <60f7ff43.1c69fb81.2aaae.36d6@mx.google.com>
Date:   Wed, 21 Jul 2021 04:04:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.51-239-gcf38e62a0dbb7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 80 runs,
 2 regressions (v5.10.51-239-gcf38e62a0dbb7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 80 runs, 2 regressions (v5.10.51-239-gcf38=
e62a0dbb7)

Regressions Summary
-------------------

platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =

d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.51-239-gcf38e62a0dbb7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.51-239-gcf38e62a0dbb7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cf38e62a0dbb761f5733ccb0906c619421631e57 =



Test Regressions
---------------- =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:     https://kernelci.org/test/plan/id/60f7c4d617ec80f77785c259

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-239-gcf38e62a0dbb7/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-239-gcf38e62a0dbb7/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7c4d617ec80f77785c=
25a
        failing since 9 days (last pass: v5.10.49, first fail: v5.10.49-581=
-g85a3429452df0) =

 =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =


  Details:     https://kernelci.org/test/plan/id/60f7c7ba26dbb1839e85c276

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-239-gcf38e62a0dbb7/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
1-239-gcf38e62a0dbb7/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7c7ba26dbb1839e85c=
277
        failing since 9 days (last pass: v5.10.49, first fail: v5.10.49-581=
-g85a3429452df0) =

 =20
