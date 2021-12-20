Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1477647A796
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 11:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhLTKPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 05:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbhLTKPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 05:15:00 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFE2C061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 02:15:00 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id o14so7706133plg.5
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 02:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RHzrdvl7jrojAF1939ylwQQcaMRCB0VbLVoOa7wfrnw=;
        b=nMDpqyoFKGncGrB30FBndr+KdqefwGK0dBHZOSJL9peCoAuz4/irj5H5jLQCglqfaO
         dULXGidL1Kk1udK14Hn+/2qxm6fc/7LZZMq+SG/DPkmFlwlbWVaGbXSw93M/Fb0cMMQc
         BYsTfCfXV9lAU8JRaVlqzO++Zmjg7EwNzusseoxj072m51gsZk0FAHMquGj4QgHdGElP
         eeuGkwsyphaia6SnHYcMdh51DMy1OeDg1HirxhgVTFiHd3ORCAkVKk9pIeoshFe0mAhS
         UOUgkg91/3F0sXoYA5enQpDrE1+UapaOtxrCuqJfwC1Zd2adknO7/AtIluWlQrr21ZFi
         HT/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RHzrdvl7jrojAF1939ylwQQcaMRCB0VbLVoOa7wfrnw=;
        b=XLFjXS/BAsnIFKQXDmWEpHOe+PO52ILOOYUYuilMNnkz86yQpHHk6KvIUTkjLO6o9y
         U/TRSMxR06raZviGa3oETj6t5ykaBsbhunAMvIb4n+35X+ahAPehxPmjNjUhv/k1Ffdx
         WsvDGadX0MFHgofAWLizxHvcqlCyMLqxt1ivajHTfq963rt3C55cpTN6wlZkX+0Duv7b
         3R/uVl4hvi1atFsinoF2Mxs8t453HRMm3y5AleQLGswkqIlYzbAJRWh7xGyhoSre2/Om
         jovk5MyjoOLcvaDxdBB2kmMeTbv76PzU579BKmYo6FKGY3pHnbQTTwc0eOY2rFb3GyBs
         cTWQ==
X-Gm-Message-State: AOAM530fjqeqa3hWLuiM+HS+KKYVQM1t5KtYNQ7rrV+Ay5beMArwVLS7
        L2xQUCl54XWXq271Z9KRyqnJBydOUnmMWMTY
X-Google-Smtp-Source: ABdhPJyKVTLJ+gOiH7+JVTDa+p7ACjPgmICE/412Z+dZ3hMn4f411vKDh39lqVMyiEI4Llv8j8Gy8g==
X-Received: by 2002:a17:90b:4a05:: with SMTP id kk5mr19247331pjb.142.1639995299769;
        Mon, 20 Dec 2021 02:14:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oo13sm18337369pjb.25.2021.12.20.02.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 02:14:59 -0800 (PST)
Message-ID: <61c057a3.1c69fb81.33eb3.0fad@mx.google.com>
Date:   Mon, 20 Dec 2021 02:14:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295-12-gd8298cd08f0d
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 118 runs,
 2 regressions (v4.4.295-12-gd8298cd08f0d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 118 runs, 2 regressions (v4.4.295-12-gd8298cd=
08f0d)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.295-12-gd8298cd08f0d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.295-12-gd8298cd08f0d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d8298cd08f0de279cd1522587dfb6047c7de00dc =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/61c01f39efb3ef8a4b397127

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-1=
2-gd8298cd08f0d/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-1=
2-gd8298cd08f0d/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c01f39efb3ef8a4b397=
128
        failing since 1 day (last pass: v4.4.295-9-g7d306649b59e, first fai=
l: v4.4.295-11-ga3118690cea0) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61c020a8c947ae45df397122

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-1=
2-gd8298cd08f0d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-1=
2-gd8298cd08f0d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c020a8c947ae45df397=
123
        new failure (last pass: v4.4.295-11-g16c28781820e) =

 =20
