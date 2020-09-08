Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34CD261B14
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731388AbgIHSna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731439AbgIHSl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 14:41:56 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBEAC061573
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 11:41:55 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id v196so27722pfc.1
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 11:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8/o5soZ7o9bqDcn04fT3uJJ/ZVF808ndx4Ydeni3H2Q=;
        b=Vi7cfHaRL75fTsnlw2xtzF7DtjKd7bh+lw1vUKIaM0Jv7v46AQ86qV0xKzuHQB+Lz/
         sJSwc6/AMC98jM0e2Rroy7ALmPIKKAM0BfYKCX7yrA80k/BSIBCdYGgAcwQSTjq/Mx76
         K68D15hKub9F5NFcLGvwSu09WqcULj+jbY0PN8c0ewlam+A5RqV7PbIZAmlQdbY86BfS
         h9n8sM4IIqVstSwCdkTOuPFOxL3d1s1YpGEFO4p2zrJbP0a/ZoAE7B52rgRK2GUFslEY
         DtVCGakxaBVFGmdFB5NhTfYMCj72Yh+MjKjlwRycnZU/rGoHyVGKKZB1eaJS3f6ouQ0j
         +cNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8/o5soZ7o9bqDcn04fT3uJJ/ZVF808ndx4Ydeni3H2Q=;
        b=PdWhMCnIJq1DrLpGzABoznage6hupX+YdRArpvmb6jQ3vpCc7+ymKXsZwOtHf5PO3R
         dQT+E1A5lYsHvIJ99MMBTJRwAp4bQpQi1bKBM7veGHmjeMO9SCPTI/PFvBZqlwVwSn7f
         d9JaCRPxXJ9zFW9A8A6SodqgsoBYxhs1g84pMrbZwCdrPfaDqMNotS4IuUDLTAJ5M2xU
         41xzaTZfSKen0XRWZXElnVZPFho7tYK7HhLGkjZgoVJLxDzY8hbB8Q3YKIOiNbAHS70p
         TslcJz/MQfoRJN1Kd3W/9F5eIomKa3SqjtGJzrujOAH3JkhK3+qFcN8LqMru1AkNycZt
         I0mQ==
X-Gm-Message-State: AOAM533+PhuqfKWa7AGEmiavBDZh7pQJfIuirbAg9q6eZwwyjJ38aKV1
        KlbnmDYVhELcJDUz8TiJvMsJXiKJyqf/BA==
X-Google-Smtp-Source: ABdhPJxbdRG167OaA1ji+s6dRlJAVcs2N3LIvDxxV/oXHpa4b+10vzNqaZ/HHh462NkY8RDFFXnCMA==
X-Received: by 2002:a17:902:c392:: with SMTP id g18mr29106plg.41.1599590514985;
        Tue, 08 Sep 2020 11:41:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mp3sm28920pjb.33.2020.09.08.11.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 11:41:54 -0700 (PDT)
Message-ID: <5f57d072.1c69fb81.2e28d.01d0@mx.google.com>
Date:   Tue, 08 Sep 2020 11:41:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.143-84-gfd8cc14f0938
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 144 runs,
 1 regressions (v4.19.143-84-gfd8cc14f0938)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 144 runs, 1 regressions (v4.19.143-84-gfd8=
cc14f0938)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.143-84-gfd8cc14f0938/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.143-84-gfd8cc14f0938
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd8cc14f093883e2aabf8aa5353a398057a2bbda =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f579c55c7dac68546d35370

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
43-84-gfd8cc14f0938/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
43-84-gfd8cc14f0938/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f579c55c7dac68546d35=
371
      failing since 49 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
