Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6539E508A87
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 16:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379431AbiDTOTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 10:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380121AbiDTOSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 10:18:34 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A7C43AD7
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 07:12:56 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id i24so2038890pfa.7
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 07:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MYyAyNjIN3Gj8K4rA5adoJ4cQGq+2Pqvsb1Bd6V1E5U=;
        b=IkMahUgewmINcdrrWPuNpu6uU3cCihAllgxqiNYaIxy6MyI8WulCHdD0BHNPHSxhv0
         bOUB6+79iYazO7dOoFl68s6uNoqfIxh8L/HqMRjl8T5ba+0kOQ3xs1XtJMxUpHFCzZ5N
         khdLtEPLxPqDVFtrmkUU5/XgtfFcPrEpScPkOTTta2PGxf7FleYMWKvsbhmVZ1JhR9nQ
         AcEfNOkLlm5Ee1uD7igzO9eTbbrjciI7glfw8VHKAUSPUc7xuG/yfG/U9WcMdd2MvW0d
         amoUj6Az/BzJQ/DFclrd4UCK/Yot5MYt0d/QjHKX3A7971koBKInrTtYF76URlbvoeGh
         k6Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MYyAyNjIN3Gj8K4rA5adoJ4cQGq+2Pqvsb1Bd6V1E5U=;
        b=JUBX+LaibyjkWAga0eMt0MWDxxkFB69m2OYRixbaZrw0v99mCifb6h/d3RQindTL7g
         yBI1OO5FwG18R/+lmDO4HxgkabE+MlcnHpJ/rl1R7VsqAhR+qpVeTlttU5VzXyt3100D
         /vjA/ZcfVLhVutro0E2fOhJmmY+TVrrApjPuEiDSeqTht3kaMjpYxqzjiMD2DKhl+gTu
         E9jV33OCrYnrqXteYGUzCieMhgHquIOiQ5qfc1/PQM7nqqfLD5hcOZO26eln+zRCwHTZ
         PYjjWttifqJgeYZ8aGRBug7bK1YRGePJhvY2n9u86ytdCqNh77JbZGNqA5E4QQgFgmcz
         mmFg==
X-Gm-Message-State: AOAM530jOAHkzY0hncUkoaIYZMc+/biIwJg2xFScf0NlU2JSqwBqjVyD
        8CHsqzLqN8hmF/vbbjNe6tzM+SrL1SPTqJGi
X-Google-Smtp-Source: ABdhPJws/FcLJMqNTxfidEVTe65ud0cgawkWN10MwV/oUdbKjYoG++HsIEs2ha/YIEEArqPtBpPr1Q==
X-Received: by 2002:a65:6045:0:b0:399:3a5e:e25a with SMTP id a5-20020a656045000000b003993a5ee25amr18917573pgp.139.1650463976219;
        Wed, 20 Apr 2022 07:12:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m10-20020a17090a414a00b001cb776494a5sm7543pjg.0.2022.04.20.07.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 07:12:55 -0700 (PDT)
Message-ID: <626014e7.1c69fb81.db5b6.0055@mx.google.com>
Date:   Wed, 20 Apr 2022 07:12:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.35
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 82 runs, 1 regressions (v5.15.35)
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

stable-rc/linux-5.15.y baseline: 82 runs, 1 regressions (v5.15.35)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.35/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.35
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      81d8d30c35edf29c5c70186ccb14dac4a5ca38a8 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625fe6bb5809e606a4ae06d2

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625fe6bb5809e606a4ae06f4
        failing since 43 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-04-20T10:55:43.105419  /lava-6130328/1/../bin/lava-test-case
    2022-04-20T10:55:43.115897  <8>[   33.591941] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
