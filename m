Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23ED4E7C22
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiCYTk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 15:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbiCYTiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 15:38:22 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D5F23F3DE
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 12:20:12 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id p4-20020a17090ad30400b001c7ca87c05bso4374292pju.1
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 12:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jHptmn1EtIhGiYNpqVUzEo/9mowW6OZm1heAGMRILnc=;
        b=kNoiBXk6+qudWykDtllgEFH4cbPZuNrAYM7975Kmz5ID8fLrwy1+l6XCjVKrXqh5NI
         sOlEQC76MOIlJbnYx7sbv0nHAOZazibPx+ahq/SRqfAqm5sJfZCySclpp53JhFFaKDsv
         TmLW52EbleKS7lTTlkHDUTnnxXery6CguHrqiRNlMrpUyZBcGJ3vSTXho68EL7/T6WjA
         gvYTiNC4eMx8pIVwuLuhIm8YjR4TkbR1OoxVPHjZUTPgpLEbCNtq5UAeoyuuwT01YCrM
         KYwBuCKGPxVsydzFPpbQtSJdLxL3FQ/ALCJkY78V3ErIIEsqmsm6osdk7MLk3i6qph4w
         bhJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jHptmn1EtIhGiYNpqVUzEo/9mowW6OZm1heAGMRILnc=;
        b=Dq5zFYunzHneWZyqEj04R4wkirWDXtNt33eULkyiMrnGGoWBC5FJPcspuTRNBn0bbh
         2AG36q43K1XH6s/8dbbOBtnMy8ioxYXwSwmRUlGPaPdljBv4XfxHVSBWu6lFkHqiE7ZB
         wZU1FIROsZPtWAgGPhxyeZupouPs+VrVEl0EAjsx1+hbNszHtVgaYQw8AL0257u8OKpd
         n0LnwsMrtYRFx98GAgjux3x2Ie9Th+rcIN0DJrRfmd3sWGIWtEQmGjTqyWEXMfb2Ah3r
         LjamwycIrWNAPSyJisiRhgMxw0fhHehJ3dtG+qWrclA2EqmVXzXzEQZ3fxFm8RFzH0kC
         R+Kg==
X-Gm-Message-State: AOAM530uUn6eTbPjuLdLju6gw3B+ufqRsm2QrZfV1fojt2+N8cGbYae9
        8SWJZnflr9/lAJDfJ9ES3c+f2iwzc2U41Flwsww=
X-Google-Smtp-Source: ABdhPJyNpUIEmg1Y9iOBG8rPj/MLn6BknZaJNpTQ56fLvdZG8m8ZiZdDGe8yyNEUsDj/vVPQqH08wQ==
X-Received: by 2002:a17:902:ea09:b0:154:4af3:bb77 with SMTP id s9-20020a170902ea0900b001544af3bb77mr13149173plg.4.1648231661449;
        Fri, 25 Mar 2022 11:07:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f4-20020aa782c4000000b004f6f0334a51sm7024143pfn.126.2022.03.25.11.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 11:07:41 -0700 (PDT)
Message-ID: <623e04ed.1c69fb81.c7ec8.4ea4@mx.google.com>
Date:   Fri, 25 Mar 2022 11:07:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.236-18-g173c107c89e26
Subject: stable-rc/queue/4.19 baseline: 48 runs,
 1 regressions (v4.19.236-18-g173c107c89e26)
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

stable-rc/queue/4.19 baseline: 48 runs, 1 regressions (v4.19.236-18-g173c10=
7c89e26)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.236-18-g173c107c89e26/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.236-18-g173c107c89e26
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      173c107c89e26877c5d24008d7f639d530c078be =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623dd1950256fb6630772502

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.236=
-18-g173c107c89e26/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.236=
-18-g173c107c89e26/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623dd1950256fb6630772524
        failing since 19 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-03-25T14:28:10.316558  <8>[   35.973476] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-25T14:28:11.328502  /lava-5946908/1/../bin/lava-test-case   =

 =20
