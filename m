Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C306446F9B5
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 04:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbhLJD7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 22:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbhLJD7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 22:59:00 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731BCC061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 19:55:26 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id j11so6960957pgs.2
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 19:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SwbcNHNjN2TaxdcEEPHR5EmBWTDoDY89XVyUuNwssrc=;
        b=0I3AQL5TTwAxQ5mfAbweJyuylvA6jIeEknqShr3/gILyNytns00K5eyxruI/eBp0sh
         qVe4iSy7S+Bshq05xoFRYTLGzHmbF5V6UoceOanRweZ+GK2F3L8PJ5vKAL4IbdB4g2Ok
         1UqfiDES2AjO7gzZwnFoJ3eEk8V1kTDWPkrqnFaB/0Y2Nwr63/GFVYzXI4iJmRtOlwAF
         8JXKlKd+2g0P83ZC11ZyMzrqpJ5e9Blb7rax8LYtPINZf6eokW7mVhNWoZ6LSmrESbZ+
         3HXhOXCFEGx/sFE1dhRiRABb3kxfRz08MKMKZ55J1OpMJPUk/X8XA6MhV0wCY6ZAW2gJ
         bduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SwbcNHNjN2TaxdcEEPHR5EmBWTDoDY89XVyUuNwssrc=;
        b=wo8nM9VlqKHvikAaX+DbcpLxiFTUkDMj19U7kM3LqSXLBBnDoRcN+EyvBsmA3SGENy
         14ksKtbO9ChUBBsLM/08IZDl3fnBmwI8TZ81RcAy4/II1xPFn2y9CEoulVGBzE0IqOUm
         mo9cCqs3EykWi8Uk0WsysG/cJJWGd6ZJcQxU52l/7NVVm4zSYSxJMTg3kUIjmY0ReIrK
         uwIER1yOiINzE9uFHLsHBxo1uUC5mvBDIIl5euvMpAgeBpysj4wrxoUxM9ialHjGUrqx
         uRqsZAr08ZB4kw78x7ciU5SReib6sD1uSVV4hpronZVzoW3jS1o/St2tQwcUkM5gKmqw
         Us1w==
X-Gm-Message-State: AOAM533mZtcbhbeCPYyeNj907qAybSxm6PFWf/D6oZlK+VIMBKIxh8kR
        HFnjxIudCcyOnvWbugltdnQTFivYUF+lM/PwRs8=
X-Google-Smtp-Source: ABdhPJxY6BUOY2JxToC/tBAzyok53eaFoLd435WpgjMOwhpQJod5cJCaCC/GO67BfCQdyBrcrW9Psg==
X-Received: by 2002:a63:4745:: with SMTP id w5mr37162578pgk.320.1639108525853;
        Thu, 09 Dec 2021 19:55:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mp12sm11122484pjb.39.2021.12.09.19.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 19:55:25 -0800 (PST)
Message-ID: <61b2cfad.1c69fb81.dd23d.127c@mx.google.com>
Date:   Thu, 09 Dec 2021 19:55:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.291-70-gd8115b0fbf8b
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 151 runs,
 2 regressions (v4.9.291-70-gd8115b0fbf8b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 151 runs, 2 regressions (v4.9.291-70-gd8115b0=
fbf8b)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-70-gd8115b0fbf8b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-70-gd8115b0fbf8b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d8115b0fbf8b2e4abe8add994ace123aaeb93e69 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b29809211f8f5513397122

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-7=
0-gd8115b0fbf8b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-7=
0-gd8115b0fbf8b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b29809211f8f5513397=
123
        new failure (last pass: v4.9.291-62-g816c00541db9) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61b294fc37ba12c04c397128

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-7=
0-gd8115b0fbf8b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-7=
0-gd8115b0fbf8b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b294fc37ba12c=
04c39712b
        failing since 1 day (last pass: v4.9.291-62-ge868da10b6a5, first fa=
il: v4.9.291-62-g816c00541db9)
        2 lines

    2021-12-09T23:44:41.262186  [   20.357391] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-09T23:44:41.304717  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2021-12-09T23:44:41.313777  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
