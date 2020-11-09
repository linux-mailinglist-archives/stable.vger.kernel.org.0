Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C692AB028
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 05:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgKIEZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 23:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728038AbgKIEY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Nov 2020 23:24:59 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9026C0613CF
        for <stable@vger.kernel.org>; Sun,  8 Nov 2020 20:24:59 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id x23so4083319plr.6
        for <stable@vger.kernel.org>; Sun, 08 Nov 2020 20:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/7WKKPDm82l8K2avBimFp1GyWLTGkNVd/CpUaw0RceM=;
        b=c1rgHnzInAxENfRhRZxH9wpKFAzCgCYWbgrCZpoAuZQujdk0E9ss7+n7cHoNQSKXsq
         BpeqXrBSxKdRuH5HCIqs5KCAolPMGq+87DAKfrTMtac7eS+I2Ik6Ue4SgVsA0A+wK2uy
         plH1JpsyEgro8H3HRBRqtX4HJiTAQaKqCbg6JLh54sDsNLPNBNyu0SGJGycqLBDke9oc
         fXmEFjrYn6UCUO8AUfsTSRSO0wDK7QRM2IPG0eyJkL2umlEo4DwdCYcg50/a/TewXpgT
         KtC2SHMR+UMqiXk18rg+0J2A+3lb+itmQiKzxGDt1G28tDTBi57GqcJ5I4ippQ+53sBg
         i6Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/7WKKPDm82l8K2avBimFp1GyWLTGkNVd/CpUaw0RceM=;
        b=PBf3POFvngj15RxjCbsHq+nY82rCUP7A0s5SMmmI+czVPnN0Wz3lI9jQP8w2ma6BR6
         zl443GYuGCkNT/rrzOyHesBqCkhIV/SgVQlvI05HcreM1JmVa8TA7zAV1IwELdKUKmSi
         9SRJT/GDd3jba8t/bK3tIs4aqMYzCs5yMNR/OjOqxiOTy/r3O5OI23vZfXJddRZ7hMrI
         ouMmsaviEFqpQA6rjhEv7yMLYZnCWN+z+OvsEm2NAkW13ula2cqXb229ze9phJjTuTYv
         yH2cFH1NuHO44/KGRCNx0WlIHsCV7cH3Z8MCgal+wMg6xy+gHC2Spd/9bqZfoJs6yrik
         fKcA==
X-Gm-Message-State: AOAM533J32dTcpYHePZesJS8cZO8abNlWe3yg9fAY4euNnMCb/DRlyqJ
        TjoawbyfaiaaWA68PewHQ1j287d6oDbDoA==
X-Google-Smtp-Source: ABdhPJyaBQeEt9fhxa5LvMFESXmLlBuREF0P/PA+6HVnrgu22MWUi+Q6RddjYSjHolxt7mzp0RQrRw==
X-Received: by 2002:a17:902:b492:b029:d4:d88c:d1a7 with SMTP id y18-20020a170902b492b02900d4d88cd1a7mr11144635plr.15.1604895897605;
        Sun, 08 Nov 2020 20:24:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z7sm3487543pfr.140.2020.11.08.20.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 20:24:56 -0800 (PST)
Message-ID: <5fa8c498.1c69fb81.38131.9310@mx.google.com>
Date:   Sun, 08 Nov 2020 20:24:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.241-108-gf4c7cbef2823c
Subject: stable-rc/queue/4.9 baseline: 144 runs,
 1 regressions (v4.9.241-108-gf4c7cbef2823c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 144 runs, 1 regressions (v4.9.241-108-gf4c7cb=
ef2823c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-108-gf4c7cbef2823c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-108-gf4c7cbef2823c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f4c7cbef2823c3eba90828c60b89bce86630fee2 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fa893c5406d63b2c3db885b

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
08-gf4c7cbef2823c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
08-gf4c7cbef2823c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa893c5406d63b=
2c3db8860
        failing since 0 day (last pass: v4.9.241-98-gbb5ddb48abfd8, first f=
ail: v4.9.241-101-ge8d0a6534ab3)
        2 lines

    2020-11-09 00:56:33.386000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
