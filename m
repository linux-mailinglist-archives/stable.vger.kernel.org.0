Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4937C48DD76
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 19:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbiAMSIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 13:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiAMSIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 13:08:19 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79156C061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 10:08:19 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id s1so542190pga.5
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 10:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eUuA8mcnpslhddlNpGx7f92s3jgRRHWgbOU/AT9+dj0=;
        b=2xzPRdxNuAcJuV8j1uiSjASKBIbPA6SfB6/1iIKdzAblYECR9Zlo4Nww6hYrAD4nsv
         aPOX61h+8XEBl0dEVeMR3CGFVhFUCzeNy4D7B2aZ0TtwKP/H/btRt7/f1RUMQTwvDSsg
         M4JnypB/mA+emUhw+9HkS1tnDRvszgm9BeI/XyXRnSDj1qZZRJb34zD52G1xRgVMB4RQ
         a/xKWBtTMBGR9f/dkvrw+vm7TkYdvo4t+bncltiz3vMZIs1YRwaLZRKjNo1SJfLXmS8v
         ALVyRFXleAeCsqxX5wnOA+z1asKXWrq8e9k2lo3CfDt5V7AgyOybA9jqRlimeOH9CnPx
         jMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eUuA8mcnpslhddlNpGx7f92s3jgRRHWgbOU/AT9+dj0=;
        b=X1rj5dZ4HWNzZSj88EPQ61i8+0C/t8D9ITPZeQwhJOsU73KW51N+Sbtyq0H35STILn
         Vm/yhjCgV+YHd0QmVkI3TPqt1MKLFuJ3TWoVQ81IS7gIXlfWFlcuTUX9dt1G+Jldl1WK
         Zw9816zQyeTSOgVinUEvTiRJyU1MMsbOqa7G3qX6jdggOq5pXbTtuNqmtHxK+xugDesr
         fnIgHwKdJnQAC4K9+04PES4K6a5yoqpIqavSnQe7V2iOIon+Wp92ocS0iF3RMx+1o4nD
         l2GMGRCtcJE13lvW9xjm2mepow8aIPJPkmmYuckYEY94UnhVLBLC56KNFbhUoNHKErDI
         HknA==
X-Gm-Message-State: AOAM532okiR+x61fGh5olU8Sw/yD6I6+KRu94Tb9EmDqbms7P4P0muz0
        1WA2kj7L6PXr4hZR6Z0SPAXSpmVUfGKl7kPvZAM=
X-Google-Smtp-Source: ABdhPJyjFRFBeFiIbOLUpLqFQPFuBegvRzatmm08nWRAy04inOoqwTDMXokFkj7KGRJNWP2jQ+Z5rg==
X-Received: by 2002:aa7:8043:0:b0:4bc:1e18:466e with SMTP id y3-20020aa78043000000b004bc1e18466emr5328751pfm.49.1642097298850;
        Thu, 13 Jan 2022 10:08:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v15sm3616822pfu.203.2022.01.13.10.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 10:08:18 -0800 (PST)
Message-ID: <61e06a92.1c69fb81.4b27f.9db6@mx.google.com>
Date:   Thu, 13 Jan 2022 10:08:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.262-3-g9dfb0f001a6f
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 156 runs,
 1 regressions (v4.14.262-3-g9dfb0f001a6f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 156 runs, 1 regressions (v4.14.262-3-g9dfb0f=
001a6f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.262-3-g9dfb0f001a6f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.262-3-g9dfb0f001a6f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9dfb0f001a6f5c09fc8cc77e2ee9835ac1dfd589 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e037919bd7aa1b12ef6747

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-3-g9dfb0f001a6f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-3-g9dfb0f001a6f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e037919bd7aa1=
b12ef674c
        failing since 10 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first =
fail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-13T14:30:21.284211  [   19.969757] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-13T14:30:21.328684  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2022-01-13T14:30:21.338112  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
