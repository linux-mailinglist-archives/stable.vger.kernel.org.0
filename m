Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B0D49CE1D
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 16:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236188AbiAZPYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 10:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236175AbiAZPYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 10:24:08 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E23C06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 07:24:07 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so83873pjb.1
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 07:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gICj5n62j2uElTZesyU7fSFYCpNuZbYsq5kW0pCGS1U=;
        b=UpSW9sLtIQSeBHP4rBjjmTZG9LG7mS/lzv4apfvzYOvrCMiNQi1myl56eCXzcY79Gt
         fNldVETJQAQlqHi5EibZ2p26ckLax789+0LLHiK5/TT2AdvlxI/mdgrh4FsGl13lyQTX
         GjTi/z+e2zT70aEU22zWJ7CG5UKxX05/wWZs94XGfIyJ9iGGVBBupfC6FRDEzH07Airq
         AF9NNaWGj7hCoVG/sLZhtRm9EcE2d4Euq3zT+4v3P3ZbJVpdVwB8iXnlc8wDxKvlveoZ
         8cpbms7+49fF0FEmtqQ6R7MUXGiFb5oJv75ZiTgDOw1hnXdSd8y5PKy/6CbiB6JrJXxq
         qkQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gICj5n62j2uElTZesyU7fSFYCpNuZbYsq5kW0pCGS1U=;
        b=xh2VhVLH6OB7dHCnPlP5F1y7Ua1SLuxeuIWg/E8r62gkzJFfTB5fPlu0l9WE3CFG1A
         KPlTL/1JJNJ/7v5SQa61vPnX6H4eJbKjivccgoTgCuIGDkhbtzY2E5hULsm6IPri+ZS4
         f5jsJrlCg8mc2jGj7PTOo5X3JKkG3Dfip+OInehsmdNoqYdJwym5Eon/H6p/xXw+R5ES
         4rlMQGYl8RzvwJU+jb2S4eMXo2VEgM1E0nHDEu4/PfJaaeiJ7jWULd8uFpzFdy8Rf2+F
         VnYwTW6nlfqOXT6iR3LRDQCEo1SEL1jyezPl0HaON6yfrWyeWF901QwIZF75xMRD8lD8
         JeYA==
X-Gm-Message-State: AOAM531dmnXu5jGCHLk1hhWPd0c8zJVv0LAGYWyk6ofxU4ro2PlEcINf
        t9k2piwFYkYV6T1dHFpyEOf6IMY8VuB6fK64
X-Google-Smtp-Source: ABdhPJx67VRO0kod7PTcaPsVTFHk5TQgUeDgVf2Hwnr9dKTYWLil4JsWemAZCcOpPd6UwsPl4jPsYA==
X-Received: by 2002:a17:902:8604:b0:149:1a90:db8c with SMTP id f4-20020a170902860400b001491a90db8cmr24107350plo.62.1643210647363;
        Wed, 26 Jan 2022 07:24:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z124sm2306690pfb.166.2022.01.26.07.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 07:24:07 -0800 (PST)
Message-ID: <61f16797.1c69fb81.10611.677f@mx.google.com>
Date:   Wed, 26 Jan 2022 07:24:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.299-113-g0e155d64d107
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 122 runs,
 2 regressions (v4.4.299-113-g0e155d64d107)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 122 runs, 2 regressions (v4.4.299-113-g0e155d=
64d107)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.299-113-g0e155d64d107/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-113-g0e155d64d107
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0e155d64d1078ffe230aedeab4b33dee8984a126 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:     https://kernelci.org/test/plan/id/61f13000419565bde9abbd44

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-1=
13-g0e155d64d107/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-1=
13-g0e155d64d107/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61f13000419565bd=
e9abbd4a
        new failure (last pass: v4.4.299-113-g69586d700c98)
        1 lines

    2022-01-26T11:26:38.162244  / #
    2022-01-26T11:26:38.162893   #
    2022-01-26T11:26:38.266320  / # #
    2022-01-26T11:26:38.266864  =

    2022-01-26T11:26:38.368158  / # #export SHELL=3D/bin/sh
    2022-01-26T11:26:38.368477  =

    2022-01-26T11:26:38.469598  / # export SHELL=3D/bin/sh. /lava-1451579/e=
nvironment
    2022-01-26T11:26:38.469929  =

    2022-01-26T11:26:38.571073  / # . /lava-1451579/environment/lava-145157=
9/bin/lava-test-runner /lava-1451579/0
    2022-01-26T11:26:38.571952   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f13000419565b=
de9abbd4c
        new failure (last pass: v4.4.299-113-g69586d700c98)
        29 lines

    2022-01-26T11:26:39.033780  [   49.487884] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-26T11:26:39.097262  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2022-01-26T11:26:39.103243  kern  :emerg : Process udevd (pid: 109, sta=
ck limit =3D 0xcb964218)
    2022-01-26T11:26:39.107672  kern  :emerg : Stack: (0xcb965cf8 to 0xcb96=
6000)
    2022-01-26T11:26:39.115789  kern  :emerg : 5ce0:                       =
                                bf02bdc4 60000013
    2022-01-26T11:26:39.128999  kern  :emerg : 5d00: bf02bdc8 c06a3d14 0000=
0001 00[   49.580017] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D29>   =

 =20
