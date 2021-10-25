Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19A1439068
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 09:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhJYHfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 03:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhJYHfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 03:35:05 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DB9C061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 00:32:44 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 187so9873869pfc.10
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 00:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9UprFEljqmj4FuJ+12E0lsixLsiCc6jPHwwK8LGMUb8=;
        b=E0F6awwj6S2jwTaHIjaXL/ulkhhVbzoBzONJjcmXsrN2ZJjkyvfj9O+I4VE/MGdZjt
         VOE0NlxG8q5tEZcmakhOoQpClycuXQb6YmlW8rFMBkUtSqkPYf99BBjnS7JB+DwUtqdI
         GRe3lGFGJ5yJQfucr/bCV63yigYzUTxAY5gAhvQ8Y9xkiKh8yZuvsjMINfJDfh9iY9jK
         rPi3YvlJg439ahC5oSohTvcK1Y0C7aG96RPAKWPqLdsc3FIqGy9L53lx/Aze4B3VnIC2
         m7l/7GxH01LMl6deZIyonOp2Z7GWyKA8vKNk2HZiR6cV874IggD8xg8msuz8Md+x3c5C
         DR9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9UprFEljqmj4FuJ+12E0lsixLsiCc6jPHwwK8LGMUb8=;
        b=WnZ4VmW3BZ0dbxo9m2lOnmRxAal3iPBJL7H0SaLwbYA7dUKekx72FIenmf7OMdafTh
         28iUt/UPCm/TC+oenGTIBOyfzqmI1mcIff2p326RafovPviq5W7vrjKTPLk1PhY7znqH
         GYeSovmmMrrAldAz4g8BzXpm5RUqJREWtnn4/kqnlIJSnz7OoE5yaeKt8mnZzmx4ZODi
         A9KTxN2soNKFZMWZjmERZ6VpKSrmAYadiBC7Iz5LKDlxQJTEQztAjHNu29t85znOIGWU
         gzzaqaqDKtRjEwx/7jjmFjDHG4Rgz7XKeu7sNw5+5ysiUVmcmoVpAzmE2qhjLopgRTnp
         tEfw==
X-Gm-Message-State: AOAM530HWy8udK6gB1wBnOFknwn8esULfZUXxi1E+FqWbLYHOb4HE3aU
        54Hf+91mN9awTlw3Dh2AR5rXIIMSrdeDlF2o
X-Google-Smtp-Source: ABdhPJw6SJFSFHUXCNWqlQctkEYWLRDCJ8j8YtKUrgz1n3FuT8xGiJK9roboGV/PliEG/b7zDvYPtA==
X-Received: by 2002:a05:6a00:2351:b0:47b:d092:d2e4 with SMTP id j17-20020a056a00235100b0047bd092d2e4mr14306412pfj.76.1635147163507;
        Mon, 25 Oct 2021 00:32:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t14sm14843746pga.62.2021.10.25.00.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 00:32:43 -0700 (PDT)
Message-ID: <61765d9b.1c69fb81.8ade0.73b2@mx.google.com>
Date:   Mon, 25 Oct 2021 00:32:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.252-25-gccbeb83ae52e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 112 runs,
 1 regressions (v4.14.252-25-gccbeb83ae52e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 112 runs, 1 regressions (v4.14.252-25-gccbeb=
83ae52e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.252-25-gccbeb83ae52e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.252-25-gccbeb83ae52e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ccbeb83ae52e7d507d29287425be67d1140eb722 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61762b9ea5b37af8ff3358fe

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.252=
-25-gccbeb83ae52e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.252=
-25-gccbeb83ae52e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61762b9ea5b37af=
8ff335901
        new failure (last pass: v4.14.252-25-gf33303f6d54f)
        2 lines

    2021-10-25T03:59:09.034812  [   20.256378] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-25T03:59:09.078757  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-10-25T03:59:09.088063  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
