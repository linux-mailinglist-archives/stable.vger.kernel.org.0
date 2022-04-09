Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147674FA82B
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 15:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbiDINXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 09:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239678AbiDINXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 09:23:16 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DD311C1D
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 06:21:09 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id t4so10170490pgc.1
        for <stable@vger.kernel.org>; Sat, 09 Apr 2022 06:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OLh8iiKWZxLcRlpnFwclyRJuBdyzOKkpONi1wYjolCY=;
        b=e0zV6sSR/QFiKKMN3DiCFDOB3BPpNLufiEhNbM+/mfkZkMMfhdx1bfYr9VEjeoageD
         BCnguVTvvBaAzXJOMTdGaaDUxNKeCk2wq9Hg8/Bv+DY0lv2DE/FZSRqZwr6kdT/2fbKZ
         1PmSMP9nTL5I0csKX5qMWfje8L4w5UvJXBekxw9/9U4FPKJVqh/RdMQeCosh5T2DDypN
         vE5p1bnwREACDfw7Tv0uIDNBmtgMUhiRuLAy7CePSuDDcqk2IcN5oeqmKuJ5M9VsvNUw
         J57XQUF1dGgOMInDHs7As1C3FZpD/15RT6huprQOdIken+55t836H0eMx4csS5HYB/KG
         GLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OLh8iiKWZxLcRlpnFwclyRJuBdyzOKkpONi1wYjolCY=;
        b=A+yAshNQ/BA00LTdAsM1bas79jFCX+CbKU9DJZz3Wkm0HVpJzYy+KSDxlg1K1ueyZt
         EcYaSq2J7YD89JKTITfBZ6FsPJP55hlU6nP4Np8ucgu5zFOdm9cci9h/qifgYmE/Z8UZ
         6GrV1fgWNA/RM14Rq6isnkByvDartuYGbtraL9/9qgbei98PW/LtA1esjMpRvdkxfH5L
         bxd3d3BtVdWzP7ABOODuhBvGRtd3So/hlVKEIWGbbKLKOPzlIL/q8pLvZ31NM/6Es5N4
         tkgU2yHm/wUnU/bmlOuiQDdgSC778T6XqAcnkUvfE7/7sE0fZ290ju9S9vKa0SkC0HJI
         X75g==
X-Gm-Message-State: AOAM531eDiAX6XDFZlgu9ErkvqxsK4To90xECHo8m4OYakKHQ5SANtPw
        dpVHiVXjMRAk1eTtpupgIbUfk6M8Omyyl8LR
X-Google-Smtp-Source: ABdhPJz24MvkV7MzysLOB5VDk2O8MEGw4URteS8jQgb1Smx1L8KMQBjjOfJiWMgNg/b2yTDxuQp/iA==
X-Received: by 2002:a63:1141:0:b0:39c:b664:c508 with SMTP id 1-20020a631141000000b0039cb664c508mr13701179pgr.49.1649510468652;
        Sat, 09 Apr 2022 06:21:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b188-20020a6334c5000000b003995aef61c2sm13724816pga.86.2022.04.09.06.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 06:21:08 -0700 (PDT)
Message-ID: <62518844.1c69fb81.37d1.56c5@mx.google.com>
Date:   Sat, 09 Apr 2022 06:21:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.110
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 121 runs, 1 regressions (v5.10.110)
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

stable/linux-5.10.y baseline: 121 runs, 1 regressions (v5.10.110)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.110/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.110
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3238bffaf9928c10173d88415f6815f6df3e7771 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6251562917bddbab63ae0698

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.110/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.110/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6251562917bddbab63ae06ba
        failing since 31 days (last pass: v5.10.102, first fail: v5.10.104)

    2022-04-09T09:47:11.581367  <8>[   32.953250] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-09T09:47:12.610709  /lava-6055011/1/../bin/lava-test-case   =

 =20
