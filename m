Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F884DBE07
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 06:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiCQFRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 01:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiCQFRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 01:17:33 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21E2196111
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 22:02:11 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id t5so5907736pfg.4
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 22:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vryd5xqniIma4OWlW9iU21X43lWOTZC09N/091xV3EU=;
        b=q7tKb9/mNEdaPQ0XBkBw1Lawtm9uvAMSENB2n8QRa3EOuvFQ8M3Qcu/x7xr0haB9jA
         RNnnwM7aLgGrBD1KcF0RXE20VIEp0krWXwkKa8bIyH6Z2PCRWQWobu3w6YuJfkzFtQHF
         OxAf2orDbmulXBTF8sB38WAAtBT1GuYPYL5fqdeX3P2Hw2A3uBnDVVILPFKe8bs8YsmR
         aJNuTteA1qNnmWPF/N5rOiHuEE4BUSVM/87QgdLXs/hg3Y7rlSepTQOXgnAdv1x6pGB1
         +OFdaBZnlU1hzvKeZKsKh0aRxN+5QFXDYsrdxA7woBQizOOvk/uGWByPKUu6gUNbatVY
         wagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vryd5xqniIma4OWlW9iU21X43lWOTZC09N/091xV3EU=;
        b=H8nViSmV3qznJ0dyeX5vqdUcZcxnwBy1ifIhg6TL87LM0jAyV/4E0o7+sYrBOFsCJ7
         PkRpnFe9WKznIdWR0GgZBjKKY0JqyRdDuboYwRFKXaTC/YGshpjBUGr+VTwmohxGTLNm
         SNf1i2jrA2iHlJQsyiT8BFdAkxQ6gFg+P1y6au3e+hpHB5/db7AI4f0wcVtX5pyHVuQg
         ZEBiMfkYpiGP72NQxiQ5OrqtqcUoc8HnLMIaiQRSBgIRLRZV2DvAkTnDt59AECU1C4Us
         y0m//tG2Slg17yRyjsVD9ZZwRthrFwZ2jF2LKbspuy0KcBradz8O7avc/EP5dxCc50oU
         lK9g==
X-Gm-Message-State: AOAM530S/jSIDs9ez/qDhQoV36IxDUV4aSp1BaxnbpTGAXeEYJGKhjV7
        5TvgCItPa0XVxcr21TfoQQeghfkF/EBYiE9p3Zc=
X-Google-Smtp-Source: ABdhPJwwkGjHyWvJWYY8qwgscxFcQuaRstI7LwlrSTCWk5Mm8/bVU/agtd5YaoKY/yl0sd/t6b5zgQ==
X-Received: by 2002:a17:903:2406:b0:14d:6447:990c with SMTP id e6-20020a170903240600b0014d6447990cmr3226139plo.22.1647492612031;
        Wed, 16 Mar 2022 21:50:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mw7-20020a17090b4d0700b001b8baf6b6f5sm4389722pjb.50.2022.03.16.21.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 21:50:11 -0700 (PDT)
Message-ID: <6232be03.1c69fb81.4fdd0.bc16@mx.google.com>
Date:   Wed, 16 Mar 2022 21:50:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.106-22-gf8409dfe8326
Subject: stable-rc/queue/5.10 baseline: 87 runs,
 1 regressions (v5.10.106-22-gf8409dfe8326)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 87 runs, 1 regressions (v5.10.106-22-gf8409d=
fe8326)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.106-22-gf8409dfe8326/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.106-22-gf8409dfe8326
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f8409dfe8326f6188e219acfbfc131908dfb76d1 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623288520de6a5fc47c629af

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.106=
-22-gf8409dfe8326/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.106=
-22-gf8409dfe8326/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623288520de6a5fc47c629d5
        failing since 9 days (last pass: v5.10.103-56-ge5a40f18f4ce, first =
fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-17T01:00:48.648417  /lava-5894696/1/../bin/lava-test-case   =

 =20
