Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8474D2733
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 05:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbiCIDAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 22:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbiCIDAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 22:00:06 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB29136847
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 18:59:09 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id c16-20020a17090aa61000b001befad2bfaaso1098502pjq.1
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 18:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rlwlaGYBAFWFXaGfOJQ38oRP+NYh7snvNptodNpBp/g=;
        b=F1eZHkQI6nwhlW1C5gOTymm04JOXYX8m3/7mz5pTRGqa9O0rJfw60dRXbVbfPxMKEw
         siOUsWLp8CfrembbD91nk/U4yoM1NwU148anc56pWfvQbyAfGar4ROHRsDn9FUod6wg2
         9CcfMx0LTkFNMaWzgwMQjHRVoS66zJYJd2J/+o6iLXxTAuH1AEp8BiVizPxAyP22X3b4
         ox8Rj8XiKLgWOAZjnvXg6TM6mMoP4B0dk3KnZ/8A1zvpByowbT1JFS5H5+HeVXxEdSIr
         qBqyjdch/h9Nf/XvDgqm1r4WXucZfsezfxht76ulUzyvrS8UyVpS+KGCjoamyBYDQEsv
         zX1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rlwlaGYBAFWFXaGfOJQ38oRP+NYh7snvNptodNpBp/g=;
        b=nlXgJrm1YBevTYPgLvPZ1BCepsm9cUV7CbWL++8xLiQcqMRqy+kk74339PIGjuig9j
         gkouIdeSp/6qJ6Is5q3j6/aics0/monJYBHlgkErJSDqMK8s+7ppv4rLhj4yEbAKIgvC
         BWQBaSm0x8ShBx34QjxJx1ui6MOYOjUKQlEbq3o8r6DfG70Zf8xxA8IeHYD8GXVOFimw
         UeNNyUGuaoSMzxdG4cRHqSK5fn9kJb05NG+MpWoeahB8vnlwR5wdRGoiCW8xhrf5r4hP
         XCGdREErKzsya1bkrXtq+7Jhm80TCipMe48EOIKdyOz3+n0vfWz/+FCcV2MsTX+ebMvu
         A8aw==
X-Gm-Message-State: AOAM5339s54oGeniXvYqgYnacR0ULFyQ4Ubh4IDI9uzFLaL1ABDY3CFW
        VYB6MCi24ohtISS2HN2maPbtjiQLpl6wHsKhGRs=
X-Google-Smtp-Source: ABdhPJwYvEeELoGYdZ1Dt/WxDyne+UQNc5gM0j2regL/zc4E4PaZIdBkWcuspq9cd5PxHwwyhLC/2g==
X-Received: by 2002:a17:902:f682:b0:151:9769:351c with SMTP id l2-20020a170902f68200b001519769351cmr20934176plg.157.1646794748775;
        Tue, 08 Mar 2022 18:59:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l5-20020a056a0016c500b004f140564a00sm499391pfc.203.2022.03.08.18.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 18:59:08 -0800 (PST)
Message-ID: <622817fc.1c69fb81.45aa2.225d@mx.google.com>
Date:   Tue, 08 Mar 2022 18:59:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.13
Subject: stable/linux-5.16.y baseline: 89 runs, 1 regressions (v5.16.13)
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

stable/linux-5.16.y baseline: 89 runs, 1 regressions (v5.16.13)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.16.y/kernel=
/v5.16.13/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.16.y
  Describe: v5.16.13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6273c309621c9dd61c9c3f6d63f5d56ee2d89c73 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6227e95abf91c6be01c6297d

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.16.y/v5.16.13/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.16.y/v5.16.13/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6227e95abf91c6be01c629a1
        new failure (last pass: v5.16.10)

    2022-03-08T23:39:49.115799  /lava-5841388/1/../bin/lava-test-case
    2022-03-08T23:39:49.127177  <8>[   33.545207] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
