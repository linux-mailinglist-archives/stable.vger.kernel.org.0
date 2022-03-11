Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12EE4D66CB
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 17:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbiCKQuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 11:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiCKQuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 11:50:03 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CC11CE98A
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 08:48:59 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p17so8116190plo.9
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 08:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yXK+8I8IOgQIbBpqjyd46SpCjIz6Ka0FnL3FqaM+XNU=;
        b=nqOX+a90QsGciyfNWYMm+ct5ANaIdB5pJqaCb0h7z/EPC0hQhEnQfFt8tC2fg2rH91
         AKDai7ipfIj+7p2Uqy3PN+7N+2+TtqnJLRMc9L05BS/Ckho5u/ayPYPcZ4a6Nlcjx9Fp
         cDOkJIYiFq5L7Pek5+9qNvq2uecSNmIyHxy2X3ocy7KsJpnnb43KWjA2Cb/l76S2o6bz
         5vjsvOfJcLHitF1ZiCGWSbmqf3NzEQjvLg1llDAq/QG1JZ3502tih61UR99WHn5FsLB3
         Ou4Wx4dd0qn8aj4eIlYpgI0uQN8w3nlOy5QG3QB+VoQtLgpOOrcUGmPDGhOLY5Ek9pPY
         d4PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yXK+8I8IOgQIbBpqjyd46SpCjIz6Ka0FnL3FqaM+XNU=;
        b=VCTrLpKlrNL7GvmASjbLMmgqJqHPiO8vI12ucrANIxeUcpDNPzCVwB511TFpx3TsiE
         Tuy3/XwgeW31SHoslQMQEugE4r5af0o6jgoFHJC9tYeiqTd0siqG33wy2htm1wQnxj58
         TdQc5tm9cqm8parK4ni899PTOI9wwfEbCoFB14gVY0bfMofA3asnD87xs5LQBBK3AHZp
         WJArBuICYFOljY5ozcGNp+9GJezw3wlxUgM0qxHBTmW0tHpKGfurYOtRenzYI4JDvmRA
         20C1X4vzDlgJfOF1mBvX0Iew7VrQGasNlYSDEK9zVwxRmt1F5h73pSWSbnRtOfNAuvr7
         kfmA==
X-Gm-Message-State: AOAM5312KvDizm8HKK5wpyxAL5ngxrKt88D3qwdB8Ce7689DBFv7cdpO
        GQlUTRMxbhOCAqzAQk00DSbsJdmWT+FOUeR6Qi8=
X-Google-Smtp-Source: ABdhPJwzUT9QbJky5grJqsmQT7Pj+q2EpNXJZgXhP/EgVJPzf+ynafHMYn4sHiSfZjfjoDXcvfjQ4w==
X-Received: by 2002:a17:902:830b:b0:153:4020:dce6 with SMTP id bd11-20020a170902830b00b001534020dce6mr1913530plb.119.1647017339046;
        Fri, 11 Mar 2022 08:48:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d4-20020aa78e44000000b004f6aaa184c9sm10719177pfr.71.2022.03.11.08.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 08:48:58 -0800 (PST)
Message-ID: <622b7d7a.1c69fb81.a4ab5.b467@mx.google.com>
Date:   Fri, 11 Mar 2022 08:48:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.13-53-gc4eb3b258961
Subject: stable-rc/queue/5.16 baseline: 72 runs,
 1 regressions (v5.16.13-53-gc4eb3b258961)
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

stable-rc/queue/5.16 baseline: 72 runs, 1 regressions (v5.16.13-53-gc4eb3b2=
58961)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.13-53-gc4eb3b258961/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.13-53-gc4eb3b258961
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c4eb3b25896197473a77146091972b835726d7b4 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622b48d1811e2fe674c629e5

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
53-gc4eb3b258961/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
53-gc4eb3b258961/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622b48d1811e2fe674c62a0b
        failing since 3 days (last pass: v5.16.12-85-g060a81f57a12, first f=
ail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-11T13:04:04.942595  /lava-5859457/1/../bin/lava-test-case
    2022-03-11T13:04:04.953062  <8>[   33.630663] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
