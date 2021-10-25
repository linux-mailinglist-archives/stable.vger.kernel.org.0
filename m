Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFF843910C
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 10:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhJYIWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 04:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhJYIWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 04:22:21 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E9DC061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 01:19:59 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f4so4658085plt.3
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 01:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HCPUA5qi2Sn3Jio2sMZ1C/ZqKyE8s5HgUrd5YdAh8eg=;
        b=VZQ7f7W4Ff8vIvhqPStf00f2zeKPmkoYPWjoFcnCJsOzQ9H3gadJjnku7yFqI0iDiF
         8V8HifhaTrJfpQspiQnYVM5eUGJLgoRtTT7omsMH4MFRhCU0oZYJAXnmRcPZJtq4Jrzw
         e991xRg9TqZzivIeZx/xV6DbmQ/rnASZnVdhPvwbvhMslyAqpThgFkreDrpIfQ/M4Gd5
         QGx0YgwcfrYExiuiI7iNuVRuwDmx5KKlpTXu6eKrj0ATJrzAsNiE7hU4dMBHWHnCteoC
         YmKlZAUSeq5+7NgVgAoQmn0Hiq4+djoQ2i2z3kwFkPI7QGl696HU6wAde0VSCpT0UgEk
         nfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HCPUA5qi2Sn3Jio2sMZ1C/ZqKyE8s5HgUrd5YdAh8eg=;
        b=AM0B0FIgYUkbXQgdfZvyBRD65w4NdV1E+I9rCvfXJrw8OLEmDXy8j7oNUuH4kvab/f
         uDFj2s1GBVSTdDHjD9I1+gGYUX9e9bltNe94dSRgAkxHpkofuOaJYC2DjiCPsyLK6/XS
         HvbC+eyNimUxDktFgNzt+1cfEN5CWq/GbDUb0LkN5/yi9gWn+aLdylNWhNjOYwwoKGsp
         r9b7tXMmBF0BYp62XZOefCST24n8SCTN06g4bdDgB9o9JJo61RuATspfUDC/mx7oPzzF
         wwyX3Kg9kuYJKvzzQmDat9O8i3q456btvGanEletJiQJzwgLl7wCaWjiRdjsEW4mdc4s
         xRVg==
X-Gm-Message-State: AOAM533E21HJLFZ9BKQtR0ycFgC01pdQCXhcdOYpakl+mmFGcAaN2o4g
        jlOS+9zGKx2DvLtWX4uFfIqVxyXO5QrPfr6S
X-Google-Smtp-Source: ABdhPJwhNROXOmXZDMMTvQIRPCLpSLv4h6b3/3Zz/99gSpgl//Awg8hdo3E8rzN4ibrh/yionJdj9g==
X-Received: by 2002:a17:902:904b:b0:13f:b0c9:3c5d with SMTP id w11-20020a170902904b00b0013fb0c93c5dmr15757307plz.26.1635149998779;
        Mon, 25 Oct 2021 01:19:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f15sm20111333pfe.132.2021.10.25.01.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 01:19:58 -0700 (PDT)
Message-ID: <617668ae.1c69fb81.c91f6.2e50@mx.google.com>
Date:   Mon, 25 Oct 2021 01:19:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.287-46-g0c117bd9bd3a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 117 runs,
 1 regressions (v4.9.287-46-g0c117bd9bd3a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 117 runs, 1 regressions (v4.9.287-46-g0c117bd=
9bd3a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.287-46-g0c117bd9bd3a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.287-46-g0c117bd9bd3a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c117bd9bd3ae8622edb41884eebdf45ac94314d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617637e73e2b1adb4b3358dd

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.287-4=
6-g0c117bd9bd3a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.287-4=
6-g0c117bd9bd3a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617637e73e2b1ad=
b4b3358e0
        failing since 0 day (last pass: v4.9.287-42-g103268c38f6b, first fa=
il: v4.9.287-46-geb744111da99)
        2 lines

    2021-10-25T04:51:30.765933  [   20.509490] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-25T04:51:30.817835  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-10-25T04:51:30.827267  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
