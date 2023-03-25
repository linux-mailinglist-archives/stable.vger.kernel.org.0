Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51BBE6C8BE3
	for <lists+stable@lfdr.de>; Sat, 25 Mar 2023 07:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjCYGuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Mar 2023 02:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjCYGuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Mar 2023 02:50:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5155249D7
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 23:50:34 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso3629977pjb.3
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 23:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679727033;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+Wtajx2xs7vQj6ovDoevFGLLw3rQbZsuYHtks1p7K68=;
        b=w1Bj+c98PED77WhXFyLa9b8Ssiok/f7D3z2lgZ2bs8rzsC4xESV4usGLg2UhJOIiZA
         nttYBYYTAakEzSaMCm57+waHFJMIYo2zzdkB8UVMxMlR4QJZxb62yH/XJaUnWJ8wNGtL
         UaxgsXxEeIRURr54fNYnzrXBvvwZIsQUjY9uSLLMdaQ/tUca44/UModHNq7WEF20OCZU
         nmDUWxHIQ7yBttPh+/CotQnkorJYVNdaZ4OaB9YRpHQ78Zvb0Tg72pdU6pNar5I7cxBn
         WTbbiJPZiq346kp1nyoe/1QnXiH4MACpXdv6ysN76+KW44sTqhsL9mIi1idLxqQIdNtp
         EzOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679727033;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Wtajx2xs7vQj6ovDoevFGLLw3rQbZsuYHtks1p7K68=;
        b=Aib/VYY7CF5U+XkcNkzbflB9k4Tl62BP+v2qSK8gS+Sgdy2IJR3jLdlMp+JnKufUqn
         8SDX1W4bcAmzFXMUHzTqi4GVa/NZFUMjX2cx9IIYOmHeDxmUx+Lfx09buUQU0c1+yuES
         X0T4WbM6328qAIErhZQ7zP06Ved/d3yrBj221ZOJNgunSoASwzifKdWCHeH+G6h83uhN
         glS4qAbIELqwPKujLygI/ndSuG4eXXWFrxIzDwL6hOXcJTghXgApkbkLQD4x2pzg7Xe0
         WgPRLTNpNzeozTS1bAc4OxIPvLwoyYHF272OQo/MPchbLeCqpcceQYyZig9t4BTAfPQo
         LpJA==
X-Gm-Message-State: AO0yUKXAAp3Fb87BeQWL0iXBUC9r5b0Lw4/mctnC/8OfPkbIeiknC2n+
        Xe6JfZET5JDfLhNpRCntQN1E6KNp9t9aWH/GTyrvFQ==
X-Google-Smtp-Source: AK7set/8hktb/YbzbTEhnS5Ki1GbjBGbnwmy1nXLOqjT7LfysH4dnPj572fnPQ6/Yea8PHTTGgyU/A==
X-Received: by 2002:a05:6a20:1e41:b0:db:52da:367a with SMTP id cy1-20020a056a201e4100b000db52da367amr5934903pzb.33.1679727033592;
        Fri, 24 Mar 2023 23:50:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t10-20020a63f34a000000b0050f6530959bsm11209357pgj.64.2023.03.24.23.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 23:50:33 -0700 (PDT)
Message-ID: <641e99b9.630a0220.59fc.4cc8@mx.google.com>
Date:   Fri, 24 Mar 2023 23:50:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.21-13-ga5e08ed20312
Subject: stable-rc/queue/6.1 baseline: 162 runs,
 1 regressions (v6.1.21-13-ga5e08ed20312)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 162 runs, 1 regressions (v6.1.21-13-ga5e08ed2=
0312)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.21-13-ga5e08ed20312/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.21-13-ga5e08ed20312
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a5e08ed20312c02df8382e4259153c8752740db8 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641e616632cfba25569c9506

  Results:     18 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-13=
-ga5e08ed20312/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-13=
-ga5e08ed20312/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.tpm-chip-is-online: https://kernelci.org/test/case/id/6=
41e616632cfba25569c9519
        new failure (last pass: v6.1.21-10-g0866b93e23cb1)

    2023-03-25T02:49:46.322123  /usr/bin/tpm2_getcap

    2023-03-25T02:49:56.540875  /lava-9770071/1/../bin/lava-test-case

    2023-03-25T02:49:56.548462  <8>[   19.998812] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dtpm-chip-is-online RESULT=3Dfail>
   =

 =20
