Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08475002CF
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 01:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbiDMXx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 19:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239219AbiDMXx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 19:53:58 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60745373C
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 16:51:35 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id h15-20020a17090a054f00b001cb7cd2b11dso3991590pjf.5
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 16:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IVhH0qXQnnm9/Ez/F6QNFTHjOEaXZB887wGO83mbuFk=;
        b=KdztL81dLTLECea7m0cs39Xu+epY+/eq17uXKe80G5bSaU/dJKOgvi6M40J7it/fnt
         w1y2eAFFxQN4IBJJULB6XT8hPkqtBFHq9KsjYPa1aqqBjb8n/Tg7YOPDWFZCxDrU7Ely
         uonsYTcHHoPPc3Tr1nW6lHfqebhPf9Sc1f0AkO1AlDQTzL8tNNWxh5NSp3CMbpeqVQhj
         E+YZj46ED/yCtf3b55NYgzouRt+IaNiG5yJw846Xvvd+TsGovYxMGPuXO3/MRtYvWVNo
         WjpNc86QBb8ew1A4gouEu4KxApM6wVyB0rhXGfuAplPSmhBajHnOQOm7Ki+NVIzoQoXf
         LJKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IVhH0qXQnnm9/Ez/F6QNFTHjOEaXZB887wGO83mbuFk=;
        b=ERaVjTJlhNZhxeLqrmfHnGBqK7Wv2B7yJ32U1XqpEsh6kQ7d4dlqeg64t7nBIkeqUT
         5zuZz6a4poJT6HY82VKzHafhDKJWTfl/4DnI1axTur7n8CjGR5xqZTvWXdhdG14WzlmQ
         uuXjtUWpPOlmTvFSs4ZaqvUpFoMPH6PFqnixc+51Do9ZlSBJabkgO4yHSotiHZ+WYnxs
         2sV1FJcIwNuWvyY6/iUw+1RG+934zY1H8moWAwekRWdIKz0lQW+oWLrd0TTGZxQXlY/N
         jDlA7V75rTxXCiGQmWVKo5u411cLCdUt91t2XsthkNT+X5c+B62zv4AuXOduyPXgzaCE
         XWDQ==
X-Gm-Message-State: AOAM530xd8JGIz5Z5s3SXZStMbz6HmSXA/tYB6eVG/U0Cbi5wpDDkBa2
        vBGnX6G1UqxVtARVvYWH/fjywnWbaVj5m3Wo
X-Google-Smtp-Source: ABdhPJzFuEygxu0QqmKz5BEDacdP24oc3meSD26njHGMivZL78IHS22E1mmksmPXLsAZoeFHqp/Hcg==
X-Received: by 2002:a17:902:ea0d:b0:158:5910:d683 with SMTP id s13-20020a170902ea0d00b001585910d683mr19338584plg.95.1649893895111;
        Wed, 13 Apr 2022 16:51:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v16-20020aa78090000000b0050583cb0adbsm176507pff.196.2022.04.13.16.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 16:51:34 -0700 (PDT)
Message-ID: <62576206.1c69fb81.5220b.0b10@mx.google.com>
Date:   Wed, 13 Apr 2022 16:51:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.111
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 94 runs, 1 regressions (v5.10.111)
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

stable-rc/linux-5.10.y baseline: 94 runs, 1 regressions (v5.10.111)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.111/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.111
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6c8e5cb264df8e9fbfe1309550c10bccddc922f0 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625733fcfea02c2639ae0680

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
11/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
11/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625733fcfea02c2639ae06a2
        failing since 36 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-04-13T20:35:00.912665  <8>[   33.376428] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-13T20:35:01.935525  /lava-6081785/1/../bin/lava-test-case
    2022-04-13T20:35:01.946603  <8>[   34.410207] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
