Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25186C161A
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbjCTPCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjCTPBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:01:31 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA4F2CC6E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:58:15 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id i15so3069775pfo.8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679324294;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=csARFu5OBVqRzWvI4CFWCvopXmEm9ceKbKetolJ4f60=;
        b=scav0ezO5SfObjAP8xm8784ES2VK8Ic3f/rrLyumLwWrS4J1auny7tR9rFlVZdTqp1
         gykrz/uBtoXzIWozsrQcbzuqHjkdPpMxmT+9qCSSliu+B0DyckbS818vIY0zCoR543ah
         lLj5jLDM/FyNAayPsUPHoF7cGOuHBN8xoLbqbn4paTtf3SW3PTwMiY61Uaw/Szh4f/CP
         6FXCdi1sgDMEwwvr5+THl6DyyChLzGJl0VxGCKc+HkUmUl1s9HIGccMr5heZte1iJED4
         7xEtd722ywVrmhL1qB+umNbRGih6BNnx83LZkAykZmwMQdWYydUwScOi4pbcWiLcZ6mU
         SWhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679324294;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=csARFu5OBVqRzWvI4CFWCvopXmEm9ceKbKetolJ4f60=;
        b=B936wRkiysCnhoXAbv9ybs7dLgjkZX05bgUT9bEFbuZAEb/u9+Ya0GOzmWvNR1C2lW
         ux+w0hoilrQt7tnZjgvcBF+LkL2JM8hLPx9MSZr2cqXb0BEG+myiV4lsOZoU4dSz1H9g
         mdJs5U50+0mquh7IU2QO/CHqpm4d6mX5D6xi8+qtGI3w7i8GFLicncWpG7qz3LhnUC8W
         HtPYO4enykHtkl2Kun44cSSItbEZAyzzXhAtmR/YMulPD5ORteQB+l24a2Vo9hIxNHwH
         aTgug3R+9AfOub17v125qDN/LxrCZRbc4brSY1i1/pF4a86t3Xhl1DOt13FTNszwGa4B
         3jqw==
X-Gm-Message-State: AO0yUKU6ELJoRO4rAdvkLYVzMHln045zpFv9CiiSVTW3Ux1YEoexAraF
        UHACoyHu0NriNqc8JpOsodpDZfeJ0PkpFs5o1RK4pg==
X-Google-Smtp-Source: AK7set8LjNLs+zzMK/G8jFw0Aff73BxHWy+Ew4tnxa94xWvl3E4I/spVgUvlG+zAFuBa7O3mIv3/eg==
X-Received: by 2002:a62:1dd6:0:b0:5a8:b07b:82dc with SMTP id d205-20020a621dd6000000b005a8b07b82dcmr14872519pfd.0.1679324294591;
        Mon, 20 Mar 2023 07:58:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y22-20020aa78556000000b00627eac32b11sm3675652pfn.192.2023.03.20.07.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 07:58:14 -0700 (PDT)
Message-ID: <64187486.a70a0220.40aba.563b@mx.google.com>
Date:   Mon, 20 Mar 2023 07:58:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.103-77-g02d2ad46f7eb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 126 runs,
 1 regressions (v5.15.103-77-g02d2ad46f7eb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 126 runs, 1 regressions (v5.15.103-77-g02d2a=
d46f7eb)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.103-77-g02d2ad46f7eb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.103-77-g02d2ad46f7eb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      02d2ad46f7eb9415418d09e629316da4754ffbe3 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/64183d9c3aa9f5f0358c866f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-77-g02d2ad46f7eb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-77-g02d2ad46f7eb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64183d9c3aa9f5f0358c8678
        failing since 62 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-20T11:03:44.922242  <8>[    9.942270] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-03-20T11:03:44.922463  + set +x
    2023-03-20T11:03:44.928780  <8>[    9.952837] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3428395_1.5.2.4.1>
    2023-03-20T11:03:45.036056  / # #
    2023-03-20T11:03:45.137537  export SHELL=3D/bin/sh
    2023-03-20T11:03:45.138077  #
    2023-03-20T11:03:45.243645  / # export SHELL=3D/bin/sh. /lava-3428395/e=
nvironment
    2023-03-20T11:03:45.244265  =

    2023-03-20T11:03:45.346114  / # . /lava-3428395/environment/lava-342839=
5/bin/lava-test-runner /lava-3428395/1
    2023-03-20T11:03:45.346683  <3>[   10.273594] Bluetooth: hci0: command =
0xfc18 tx timeout =

    ... (14 line(s) more)  =

 =20
