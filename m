Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0574D796C
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 03:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiCNCox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Mar 2022 22:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbiCNCou (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Mar 2022 22:44:50 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1151B5F99
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 19:43:42 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id mr24-20020a17090b239800b001bf0a375440so16078490pjb.4
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 19:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/rUDk1qicao6wh9t8+JYmuwM1yliRFiG1tXW6QlAoJo=;
        b=1H5HBOkXy0MApNisK0Mo0m6MePETChCLkGWixhfjUOAxRMbwLNpz+pge8zpFmvuD4v
         zfXzcLBOiBdDM93rr2E5mL/XEzlBdPqOl/DJNMgji7ry+sg9X4PVOZRSKKw0nBUmJKin
         sounKUnfVNzK4SmMmpMEJhGBMNY31nKSPt5JjS+i2HkQsveOyVKpyt1xrrPZ5gis3hwf
         UoIkw32vAl88cJZ2svqZqxC2pTCctjuK8WfGYycz9+nmpxHU3q83g2avsnGeBMiDZtbR
         gpwlG3MK4nOS6YVskJoSCrQmMKoRvtDjGeOMltXozf5pUZg5MpyYuj/+Kusj5XgQAQpn
         flkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/rUDk1qicao6wh9t8+JYmuwM1yliRFiG1tXW6QlAoJo=;
        b=smh5TyRN88TBp9ysYaPiWhau54SnHI2MQcRLzgPmsQOVcXAQybME3Tdc8nZrWUv37U
         OD9E61qRSDI8iEi4S6jrashO9svmOPcXVVR5yOvzrJFAFxtW47fB61ufPb7g5fF6SQoq
         Gw02NMXUf53wwtsa1tFa9oOTa7XnwgNju70IkENHgTW9yp6iNZoUZ5d1ziPCs76+lPcO
         SjOVmZHll4SZtBxnZ1KpOTan99hqIMKsSThiooUiY7IoRv+7P6BV8eIUZr0J6Q+761kn
         nAAGInmdzYo3h4Z7DJKtPmbbz3hAs2w4ht8hIulYTym8HPLf3bvSU51R3NHngLFGAQgy
         8oaw==
X-Gm-Message-State: AOAM532it6FTJABNxH7HOjAYCnQZC4KWd3lFNzJXSRRf9k7gkQX/AWLB
        FkQ7rmE2v1rtKDSwSwVxUxCNO67/P3vxW/m3D+A=
X-Google-Smtp-Source: ABdhPJyurFHqNDXZ+lJ5agE4f0wfy+uw5CVnW5J6hMswLV2J03inS42yoi1GzlqEHMGmipm3OhTv/A==
X-Received: by 2002:a17:90b:3a8f:b0:1bf:ccc:59bc with SMTP id om15-20020a17090b3a8f00b001bf0ccc59bcmr22865207pjb.234.1647225821414;
        Sun, 13 Mar 2022 19:43:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d16-20020a056a00245000b004f7728a4346sm13905752pfj.79.2022.03.13.19.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 19:43:41 -0700 (PDT)
Message-ID: <622eabdd.1c69fb81.c3867.368d@mx.google.com>
Date:   Sun, 13 Mar 2022 19:43:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.14
Subject: stable/linux-5.16.y baseline: 66 runs, 1 regressions (v5.16.14)
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

stable/linux-5.16.y baseline: 66 runs, 1 regressions (v5.16.14)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.16.y/kernel=
/v5.16.14/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.16.y
  Describe: v5.16.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3cfa7ce38ae6c2c8e57201e2978178c42051defb =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622e75b01eaae0fd60c6297a

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.16.y/v5.16.14/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.16.y/v5.16.14/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622e75b01eaae0fd60c629a0
        failing since 4 days (last pass: v5.16.10, first fail: v5.16.13)

    2022-03-13T22:52:06.982927  <8>[   32.517814] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-13T22:52:08.006040  /lava-5872537/1/../bin/lava-test-case   =

 =20
