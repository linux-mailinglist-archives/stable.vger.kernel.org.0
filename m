Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C354C6E53
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 14:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbiB1NhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 08:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiB1NhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 08:37:20 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7411C75C0D
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 05:36:41 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id o26so10718905pgb.8
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 05:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p3jh2tVstbMSruhZUFqrATeIozy8JzXXVEBT/gzJZoQ=;
        b=A9zmydsyv0gflcKwpUtywil+J65v/RTcrmPt9vRnMh3vtasxpkdJ9smuroL+La6aqL
         s8KQDoOYGO2l2/eJM+Xn2wXz1lwR5j+Gow7NFnsc9TbZyYeCbVjQzwAvcJ+dwQfd7YoQ
         gM+R1DXa2xnbVlBMcZA55FY5AELvFJhsFSrmhtfeiR9yZtV54Fw26Kmyvw0OTFWrqXI0
         mLU57E0Arkh954BJZv9ybAxf39EEqMrbK82Tohv6BJYoIc/hqcvMVXg985M7gkHdrb6T
         m6Fz9UpluUoG81IwTcnFgfRaBZFhvKPu54Yx+peJMedX364NFytE82Jcp/bcRLfmQauA
         HEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p3jh2tVstbMSruhZUFqrATeIozy8JzXXVEBT/gzJZoQ=;
        b=g+SuFtYrtzuCAkckt3jmpQbEHY5EoTE0o6+BPRoTVd3DUT6f0TDqVNPt/IOz9+amxB
         nvafGipvLyRGXfGx7E/ReQPEPO+skrkzaxCxg8SQ0ucerB4eXjHwpICUK0WLF8jTJBP6
         9YjM41IVNxEwubjjITHvKUHJFKRZE935c3YvZ1HZ5jAKtVLZKfoWx8t3G6xx9g+TZNOT
         ah4DMbs6a3q27E1NeQtqTxeyeAWN6Qb3vHvn2LBBJHw6wpVsIj8BtsEfc3LS4w2KdY+N
         fFq3vtk8wTFxSpxx7IpCccnxyqNNVx6z3mhGFCVvIICf001U5nc6ko1zVO3Zedj3Tjg3
         mKCw==
X-Gm-Message-State: AOAM531KzNGqcOuQldGgSowiaBjTMhTHeV/2IcjZZGfAam/t/2LyTTi3
        k8QvVdk2268eOLUoxV6QR2jPrFYZsot8gRYX3OA=
X-Google-Smtp-Source: ABdhPJw/Yz/wsTDJ0h//yrndiGbH1zc7p6ppfslXs6sVIKVjWwWb8iTeAGexViN3Ypd4Xd+/fe5m9A==
X-Received: by 2002:a63:4205:0:b0:362:85c7:6440 with SMTP id p5-20020a634205000000b0036285c76440mr17332824pga.346.1646055400769;
        Mon, 28 Feb 2022 05:36:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nn10-20020a17090b38ca00b001bc3a60b324sm10528573pjb.46.2022.02.28.05.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 05:36:40 -0800 (PST)
Message-ID: <621ccfe8.1c69fb81.6a8a7.8bb7@mx.google.com>
Date:   Mon, 28 Feb 2022 05:36:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.231-29-g5c866ce84880
Subject: stable-rc/queue/4.19 baseline: 40 runs,
 1 regressions (v4.19.231-29-g5c866ce84880)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 40 runs, 1 regressions (v4.19.231-29-g5c866c=
e84880)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.231-29-g5c866ce84880/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.231-29-g5c866ce84880
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c866ce848807dfb3e20d5f47b7250b265226869 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/621c9bef6e8d0b7c1dc62986

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.231=
-29-g5c866ce84880/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.231=
-29-g5c866ce84880/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/621c9bef6e8d0b7=
c1dc62989
        failing since 2 days (last pass: v4.19.231-13-g32d897565472, first =
fail: v4.19.231-15-g1c0eaa17c526)
        2 lines

    2022-02-28T09:54:37.779455  <8>[   21.476623] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-28T09:54:37.828197  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/112
    2022-02-28T09:54:37.837202  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
