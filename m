Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2FB4A3296
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 00:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346458AbiA2XUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 18:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238951AbiA2XUS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 18:20:18 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B04C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 15:20:18 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id z14-20020a17090ab10e00b001b6175d4040so8710841pjq.0
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 15:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KYW56i9PL1m3PlqyQHfZ8RrWLQ/jD+3FKmgRdsnUajE=;
        b=E5UanFK/bew3ilIZ3txi9Uurb9Y6lKsocgYnGpIWdvSYD4dGlPPlc7p4qt+PEIVCw5
         hvKVBbJSHEbyK3cCJPIMbolHsxZIwZKZQdBdfXCAY3nV4dHkozdCXVSJCT62AbJ5qoX0
         +kwHSCQGMRZWGVE1FqkrG5yGbop/SIJYtBZwZK+7BIWsK8EWRvkbzj6U3+6BLQlDmafH
         RiiWYgKhlB1yVl+jkAVI6YnsI2USPJ6mU9i/4mqKvsp5bkMqALlZYFuwR5t+pMU/WTjD
         tkCuDawW7mbitHfyn15ghaT0FekhDSKXKgQYrrS1ha03VKZl7Dzj0zqhKp/gCaiO0Jrs
         133w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KYW56i9PL1m3PlqyQHfZ8RrWLQ/jD+3FKmgRdsnUajE=;
        b=k6ynhA77az13lQ/V3Jt9IVe87nPYW0GZXZ2FM+eyUa3Lus3+Vy3KU7nJrRfLcmTtlA
         lrO8kHT3DrHq2pdkGU+HkIfRoaHSAmiS2+Jf5vfiriPesBKkCPBrD1NMSeOk1XxEcqNw
         5sGNqYDO7eYv1M51dv+T3XDQPKeB5pJcJFhdGvhdNJVpf9WNfBs0PjMaQbcZwrb1kS1V
         Cz4UD+RhG0ehaa0M3d12pjOdoC8fllyWsEsaEJZVpfLtz7gAhZI/JnvviChoygV8qm3a
         5L9IGx5H88YAGkhHR2L7teRPg+6QTeHjvoLkwGHkAAnfGw1DaYirEW4htfzVX5VMo8ie
         L3RQ==
X-Gm-Message-State: AOAM531FguI89q5ln643mblzRU55OZBbuAf8YHUKliHJGPQn8Vqya/iO
        N5EAyNQPfy7l3O1vhtTRpzOImLhETj2BKSsc
X-Google-Smtp-Source: ABdhPJzom0f0UgOq2H6UBquF1g4gggwbaVxizeAX9eBnkzBsvpE3xT8iZdPO/4XxExyHIdgF7sN/DQ==
X-Received: by 2002:a17:902:ea01:: with SMTP id s1mr3299218plg.111.1643498417396;
        Sat, 29 Jan 2022 15:20:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e12sm10473232pfl.8.2022.01.29.15.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 15:20:17 -0800 (PST)
Message-ID: <61f5cbb1.1c69fb81.a9b01.b08d@mx.google.com>
Date:   Sat, 29 Jan 2022 15:20:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.301-12-ga6fa385433c2
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 87 runs,
 1 regressions (v4.4.301-12-ga6fa385433c2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 87 runs, 1 regressions (v4.4.301-12-ga6fa3854=
33c2)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.301-12-ga6fa385433c2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.301-12-ga6fa385433c2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6fa385433c2cbfceb08395f8ba13aa590e2b3a1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f59127ec18997bd5abbd5b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.301-1=
2-ga6fa385433c2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.301-1=
2-ga6fa385433c2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f59127ec18997=
bd5abbd61
        failing since 2 days (last pass: v4.4.299-113-g0e155d64d107, first =
fail: v4.4.300-1-g5b4f04e1d4173)
        2 lines

    2022-01-29T19:10:10.883149  [   19.329956] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-29T19:10:10.927507  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/113
    2022-01-29T19:10:10.936060  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-29T19:10:10.952644  [   19.402557] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
