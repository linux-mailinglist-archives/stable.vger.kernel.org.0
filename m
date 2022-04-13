Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BF550029D
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 01:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237878AbiDMXeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 19:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236369AbiDMXd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 19:33:58 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05BA25283
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 16:31:35 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q19so3192046pgm.6
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 16:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GbQXSifXKKiNbucWgaPjnpcfhyowBOusqmgt9WfhHXY=;
        b=kFSeWdhQ6n1VkC4qMi1Nn7hiGr8GL+gyOtiqmGg8qbcT43i1uRbH9cWdpsklizhNGE
         wGi4WKGY19QL5ASG9cDV4vzoBaadAVfgPKisPJrfMIaygBJKgNaZpouTxxErS0V1JV76
         udI4buvn7qZZRZVRVm1zH7igOI/FMaj2ZXqC34JabsJjidiOiHiUG4E45AeHFFNk5rRz
         +XmXzA3FSEkM2s029cHeJSDYg3ChcrzX36d9/dmpedmQfsNQU7SwKlPNQ20ni91OHyU8
         TGOz5wXSQHqAR2zHNvTKT6GaPcPxmMywBMaEoi/Xw8wahEmtyL2AJzAdGqJgXqq8PQwQ
         C5LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GbQXSifXKKiNbucWgaPjnpcfhyowBOusqmgt9WfhHXY=;
        b=mQFVcX1nARIOI70VN/4MqvGfKsk5J4vdsR5kU9gJB9kkGIZe4T+Dr4w2cETYMyuslY
         bMSAAMKAXPouQuXAcZsv9VB37lMqJ7+P4vflDeaWTlC5N/L1vs+BUf0pCHHwLQnMwirs
         C7r6ounGgdxcvEnBBhrMyDucmOKqDarxPRC6EAZaZKx0GzeZ3Ud/wluOMjbwJrW28PsB
         4rCW7638SS33y+1Kg14p0Tc56ERalx136g7pT5eyGZ8t7zXDECzNK/zI5MQqoqlZ3J02
         VoX1c4IuJ8H1F1RN8fDjR3XfUib7t6QAbO3lo+hNHSh4oCsQ1ScsK4Tz3lBeKoTEZTkz
         Yx8w==
X-Gm-Message-State: AOAM530adB+M4FAQ9DnRJhrB0We2aVHUUofoNdbz6jVEeTJbjFQdCmkI
        ATRLYTT4GThFfAuqVbOqRiRhw1E+Xb/9sC0z
X-Google-Smtp-Source: ABdhPJzqSyEQftrxlg73Mne66xvRJ6bl00mGJCeH+EAFlNGWVOoKNfCw6qW38Y5AIceycjk06XiKgA==
X-Received: by 2002:a63:5525:0:b0:39d:40ed:5e3c with SMTP id j37-20020a635525000000b0039d40ed5e3cmr16308pgb.20.1649892694837;
        Wed, 13 Apr 2022 16:31:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w4-20020a056a0014c400b004fb0c7b3813sm158606pfu.134.2022.04.13.16.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 16:31:34 -0700 (PDT)
Message-ID: <62575d56.1c69fb81.33b07.0a2c@mx.google.com>
Date:   Wed, 13 Apr 2022 16:31:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.34
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 127 runs, 1 regressions (v5.15.34)
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

stable/linux-5.15.y baseline: 127 runs, 1 regressions (v5.15.34)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.34/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.34
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1b86fc15ba6d04e393d6e65753f2013963d407f3 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62572cb6d2e3a2f6bcae069d

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.34/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.34/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62572cb6d2e3a2f6bcae06bf
        failing since 35 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-04-13T20:03:50.087925  <8>[   59.767792] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-13T20:03:51.111418  /lava-6081451/1/../bin/lava-test-case
    2022-04-13T20:03:51.121096  <8>[   60.801168] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
