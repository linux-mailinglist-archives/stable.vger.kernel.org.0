Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF9645E309
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 23:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243435AbhKYWnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 17:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbhKYWlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 17:41:49 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26037C061746
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 14:38:37 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id b68so7066358pfg.11
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 14:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7mWxHZ964BPuNNAfhOgfr6e35MX58Z33QqMEM4/XLg0=;
        b=bOpDbCeMQ4JB9Qe8x9QD4LRcxRNXBdwIEpBRJTf5yyT5t2Tv4IvITpRv/Wj/MLiZii
         GAq/ZtSkCFRPZhPY8+kuQbVyPmKBFzH04H3aT08LVJIziKQ9XW0Hw+32niDc9xo1Idak
         af8rK/SABeozkhdBH7gDu+j/Ja5+E/1kv81Bh1LqA0GP36XaK//G1mf9ke69tfpZ1Ifz
         NL3kwtSonEer9MP5LIgWhJPEvksJlO4vuJXLQUueaYLBv+VfUVshCDDbWU3fCaKHjdAV
         rEjcdUr2B/Ng42tr1rnsdC4eJeGK7zcn8I17/GcD2eoQDWkHxyAuvvo0gCDrxJv35Cni
         HPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7mWxHZ964BPuNNAfhOgfr6e35MX58Z33QqMEM4/XLg0=;
        b=tNo1pW3WgQyrNd0GPMVLn+EbOhwVnR+uwLIrGzk0p5TbfjhqmEjzgfqa3z+8HDdMEX
         FDkKzv4tqEyuVa6dAaX3yzKuudhtsw791OZS+94j5oCfXjVlCs9Q4JD17YGwAL7Mn7RG
         Qy0VX4VV8TxU8Ws8LMwAeZyzcgh8P2JO/iseo4LAfslt7p6XqwXOmzLLEfgmVqL0Y4y4
         UIRvyIbESt5gE2OlAuEr9zJ5BGlSQoxEK7hnO062HqoMh7OUHBQQ2lScDszwey4WKDJP
         gvk/g3PvASmxtwC9+Y9+9Qw8dpQGokLY5u/up6yZqUqXO1j/x1X/CZwHKbfEup4PGU2W
         lUXA==
X-Gm-Message-State: AOAM531N8OJahC3zrwlqy3IKecYLEJ97cU49LgCGNuydeFNfX6DU2ZlG
        ZlqHatWEPWpx7UjINbfrBiTXH3JfHukHn1Uy3gU=
X-Google-Smtp-Source: ABdhPJyFlXHif3CElHv8OsMKTNMOvNksyd7lbOdHjEW5/tzkGWMOJdMO3JLHQiyrbXdoaYC2craGew==
X-Received: by 2002:a63:5119:: with SMTP id f25mr7754337pgb.11.1637879916487;
        Thu, 25 Nov 2021 14:38:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t3sm5203242pfg.94.2021.11.25.14.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 14:38:36 -0800 (PST)
Message-ID: <61a0106c.1c69fb81.4dbca.db20@mx.google.com>
Date:   Thu, 25 Nov 2021 14:38:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255-248-g5ea12c7b1168
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 69 runs,
 1 regressions (v4.14.255-248-g5ea12c7b1168)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 69 runs, 1 regressions (v4.14.255-248-g5ea12=
c7b1168)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-248-g5ea12c7b1168/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-248-g5ea12c7b1168
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ea12c7b116863d0d104a13647184f035ae00ee6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619fd811af8cfab9edf2efba

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-248-g5ea12c7b1168/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-248-g5ea12c7b1168/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619fd811af8cfab=
9edf2efbd
        failing since 0 day (last pass: v4.14.255-248-g646bcac5a19c, first =
fail: v4.14.255-250-g0b1b1688e7ac)
        2 lines

    2021-11-25T18:37:51.237342  [   20.063537] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-25T18:37:51.278312  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2021-11-25T18:37:51.287505  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-25T18:37:51.300689  [   20.130401] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
