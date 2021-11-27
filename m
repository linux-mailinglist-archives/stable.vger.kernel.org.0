Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF6945F77B
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 01:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343856AbhK0Ajx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 19:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343793AbhK0Ahw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 19:37:52 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7A2C061746
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 16:34:39 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so9042901pjb.4
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 16:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kXVRfnN1ovIcNWLbOw/9uTGTbvTbKmxUW4CAldiyMEM=;
        b=K3amqg1wUflY9KDMk5HN4DBHMH6VQ0m3aNI9T4ZZ2AnwjZZauIMarXJuVv2slkX8Hx
         DJOtTJZFi5qv86vAsdIgzRLImY3C+HRhhjgcFF2AfsAnV2J0AsL5NrEayqUt5EmTXbsf
         46i3HZUq/DPVYHPOLsIrIfDLyqfFTXLCEF87ANtWBmiVd6Eu5Uax1Onzg/su2simbZgH
         0aUaOQ9pUwNSlL3VcjJ3O16SfDfsO2tpJCUrEbHXTv7+UlwIdagDcwF5TqzdPpyUYhDy
         QMEftRBo5IEsL55u5dgVLE7Si7RFC7HbfRYP1ATLn+hgTotjzSDPK/9ovhkmd1qza4IL
         JdyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kXVRfnN1ovIcNWLbOw/9uTGTbvTbKmxUW4CAldiyMEM=;
        b=r4GEeVCAWYb+dyFiEyHSk3L9RP9s1U83S9fLeXG26bN1VKlWnNjq8R9bveMSGClHOt
         7BvASovaXF1JRAF5rzEpPWtkrfrhbujKCLPP+KASZEzFZ5XEpgjT4iZWJjCNPNvTo4Bt
         lNqtIEa5GmgUBlpZeuHbDCtIMi5/EzaBvFwubdtVV0OBuKckeScxVcM7jn8yK7KqZ1b0
         8zu3RF28Y4Tf8SiK2/h2XabTtuYBpYMcKWSEgzWFo6ojwfOGkC6kUatqjJmUM/BS+Gpu
         6AGwJ1eLR0K/3tPxidJpKD6xO9XJAbUEshvV0/H42F5cpPJ/iZMNeoPQeIaZNMP6xK8E
         hGXQ==
X-Gm-Message-State: AOAM531cWyAXrgaYbts9DFPtwz3NJM0RBoCszbBQFZU+NshbfKOy7cuv
        ykngU7MO6a4OtSD9sTpCGFPEBukaG3tf1CB8
X-Google-Smtp-Source: ABdhPJzltwOsb2J8/JDGfHROei9TkYGJTxSW2KQRGnSgoNZGricqhdXjwFw8IqAeA+BVdJiqB/i4pg==
X-Received: by 2002:a17:902:9694:b0:143:6f27:29ad with SMTP id n20-20020a170902969400b001436f2729admr42370723plp.46.1637973278716;
        Fri, 26 Nov 2021 16:34:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o16sm8874383pfu.72.2021.11.26.16.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 16:34:38 -0800 (PST)
Message-ID: <61a17d1e.1c69fb81.a7177.915e@mx.google.com>
Date:   Fri, 26 Nov 2021 16:34:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.255-248-gebf35daa9b37
Subject: stable-rc/queue/4.14 baseline: 117 runs,
 1 regressions (v4.14.255-248-gebf35daa9b37)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 117 runs, 1 regressions (v4.14.255-248-gebf3=
5daa9b37)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-248-gebf35daa9b37/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-248-gebf35daa9b37
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ebf35daa9b374b20bbcf7ef7f5dae8c8c6daecad =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a148fd6e4ae4df3118f6ef

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-248-gebf35daa9b37/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-248-gebf35daa9b37/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a148fe6e4ae4d=
f3118f6f5
        failing since 1 day (last pass: v4.14.255-248-g646bcac5a19c, first =
fail: v4.14.255-250-g0b1b1688e7ac)
        2 lines

    2021-11-26T20:51:56.183571  [   19.936462] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-26T20:51:56.223534  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/95
    2021-11-26T20:51:56.232676  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
