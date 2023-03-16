Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E396BC237
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 01:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbjCPALk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 20:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbjCPALk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 20:11:40 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E0E125B0
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 17:11:39 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so4005838pjb.0
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 17:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678925498;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PfRjLqpC94VuBvjEupk0JNx2Gc6bRkXE/CFUOaj1kdA=;
        b=afWIpSJ7/p8hSUV5nBZ5LfvOGY9i5WrSmbnT51edof5gO5SPmP03XTOwTnqJxkuErK
         d0HTjYnAQbnbp/m+sVt1TVdYz3D00XiY7fMc+BZoc/T/PH9UADNUbc/9q0QxwjPXTAw/
         zXzRJcTOkZ62it0ZnKOtkWEZx9hzLBv7CFtlb+EAelxesryoVJof4qTtQ7ALg0isf/9/
         6ukVnubvjCtBhJMIe6BhuNAu/NS5Ab+t4SwqxJcPh9tugOucAz/jq8Jj9UsTzK+BNbHj
         C6NgN2xZBhM6sZUvbXInVHuO3DRzQ5sv4EEB1WxiMeC591hfH89HHY8c/KXadtIFXWEM
         JtWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678925498;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PfRjLqpC94VuBvjEupk0JNx2Gc6bRkXE/CFUOaj1kdA=;
        b=HHMZO9X/o0oMTmr4XGbZPcbaAtTPCX/Sxh/F/i0WMN43xcfbFW2UlNdaTcxabicVYk
         IboJ1i0su+Fdyx7+RKxoSFMgND8B+CpihJAzUCGcZqP4O5/IihJIb9fd2+8Xpe+Nj+Lq
         junzKmkknHVPBKXaGbTLbziK4RbtCC2UeE8LIdD3cIdC4J6htENy9AatsWM/rhCuvDfc
         SsELoCFQLXn91uOxD5YlgAwDyEcHWnm3n1Vevho8RXV8xFyydAUyqTv1cFPrkX2zNgCv
         Pllgp2McD1X+wOlsKH/0R+KO1ESieIoS2JAtikwqnhi5BI6cBLH5Z7S8Dj5h7S7lN9HK
         JweQ==
X-Gm-Message-State: AO0yUKVt3Qq+EHasmy5Wtso3hbhvWIk7qbJ6Fb3b3ptqdy96BtjByI0+
        cKbF1QScHqVekFk96cOuz413IDDDaj4Jsca2BAy/Nl3Q
X-Google-Smtp-Source: AK7set+vz0pFk2H5fyRYLFZY9soHlKy5xAq/vvQBPuUU+bah/1foNY/R4jaE5hDb0pbWKIy+jOrOcw==
X-Received: by 2002:a17:902:f547:b0:19c:a9b8:4349 with SMTP id h7-20020a170902f54700b0019ca9b84349mr1547763plf.32.1678925498357;
        Wed, 15 Mar 2023 17:11:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p15-20020a1709027ecf00b0019cad2de863sm4135340plb.176.2023.03.15.17.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 17:11:38 -0700 (PDT)
Message-ID: <64125eba.170a0220.3eab1.9d99@mx.google.com>
Date:   Wed, 15 Mar 2023 17:11:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.101-148-gc883df2742eb4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 188 runs,
 1 regressions (v5.15.101-148-gc883df2742eb4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 188 runs, 1 regressions (v5.15.101-148-gc883=
df2742eb4)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.101-148-gc883df2742eb4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.101-148-gc883df2742eb4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c883df2742eb4d4dde158c4f80f1ff8e82b731e8 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/64122858f2b303e4668c865d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.101=
-148-gc883df2742eb4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.101=
-148-gc883df2742eb4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64122858f2b303e4668c8666
        failing since 57 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-15T20:19:23.765529  + set +x<8>[   10.025506] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3414733_1.5.2.4.1>
    2023-03-15T20:19:23.765842  =

    2023-03-15T20:19:23.872621  / # #
    2023-03-15T20:19:23.974335  export SHELL=3D/bin/sh
    2023-03-15T20:19:23.974779  #
    2023-03-15T20:19:24.076034  / # export SHELL=3D/bin/sh. /lava-3414733/e=
nvironment
    2023-03-15T20:19:24.076468  =

    2023-03-15T20:19:24.177784  / # . /lava-3414733/environment/lava-341473=
3/bin/lava-test-runner /lava-3414733/1
    2023-03-15T20:19:24.178314  =

    2023-03-15T20:19:24.183381  / # /lava-3414733/bin/lava-test-runner /lav=
a-3414733/1 =

    ... (12 line(s) more)  =

 =20
