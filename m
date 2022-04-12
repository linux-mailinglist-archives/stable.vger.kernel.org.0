Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7987E4FDE7B
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 13:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbiDLLyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 07:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349501AbiDLLu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 07:50:56 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F64C5C675
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 03:36:34 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q142so16835114pgq.9
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 03:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M2chSjQ9Xw0RE9fKr05ICm7b9wyPiUrfmGOccTg/R4g=;
        b=DoRa5trm9MKhprke60yAJgvfg5qjK4o90ChlB2DAb6q7BebKst48U5NRpqjOP0d0oN
         ngeGEl740DXgJikjPkIHaS/2wmYQQKk9HkZXAoGNDUFgBhISTqd8gEGuhyXoIMgX8eOc
         CrqNdKQihrV7qxX5EmYXpiiNs+JyBEat+C8IExfD8DD+wjI5YNitfDjftRkMzo82Ty7y
         1qRZuR5/jW7+c+55VyzPFjUILleQmDQhGgO+NEhxFxY5ve7Ja16W/8dyZGBUvmYN55S4
         ZEBH5BfI7Pa3BEZgEJ1MiDUUWPpS+jTZ7LFfdZA6KcoEeV/RPIsp0mi05c+E58sK457I
         4+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M2chSjQ9Xw0RE9fKr05ICm7b9wyPiUrfmGOccTg/R4g=;
        b=7MWZq2mCN+7FEAHodcBgNquBsQBmW2i3URM6TJ/h19sGOQw75n2u14A5mULafukypP
         RGbz5SqdhtBnBU6jSSmnAl32vKQc4ZTr848Wu+DkLlv3l0urGhlVD1o3g1d4yenu5S4/
         xjZCdoz9P6Xd7zT106OviKiBSVlQNifnBEWK5+gBJGJjf/aUSywuBUz6+dneCPYxmARo
         hWicN02tSINumLWtKfUB2uc/yd8Yeo/sFQdjL21SVac/L+RTTefsRMBiJ8iFLF9xTOqL
         eAIFSU4J1mGq2nWP9uMJDPt3Pg5/iht1jVtbhxBhGYQMZ/0M+6oQM++vmOHObxbdAxdJ
         2ELQ==
X-Gm-Message-State: AOAM533e7w6blkd1nao4bgeMA0oFzZ3vN4vWBw3FCI2LjCrUhgcg6uOJ
        jYAIVt4Lp2ygG6tcus3xVJAo/jN48/C8/ApR
X-Google-Smtp-Source: ABdhPJyneAqxDvAulYWMVIzafQ4098jY0V9psElZfmyM9jGFPu7LHruk2M4s3qnnkc93JeX1NbGKHg==
X-Received: by 2002:a62:6d47:0:b0:4fe:15fa:301d with SMTP id i68-20020a626d47000000b004fe15fa301dmr37436902pfc.29.1649759793761;
        Tue, 12 Apr 2022 03:36:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c7-20020a17090ab28700b001ca9514df81sm2429589pjr.45.2022.04.12.03.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:36:33 -0700 (PDT)
Message-ID: <62555631.1c69fb81.18800.6a1a@mx.google.com>
Date:   Tue, 12 Apr 2022 03:36:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.33-277-g059c7c9bf722c
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 128 runs,
 2 regressions (v5.15.33-277-g059c7c9bf722c)
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

stable-rc/linux-5.15.y baseline: 128 runs, 2 regressions (v5.15.33-277-g059=
c7c9bf722c)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =

rk3399-gru-kevin   | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.33-277-g059c7c9bf722c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.33-277-g059c7c9bf722c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      059c7c9bf722c0f354be85ad3b5450db8c3a09c0 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62552344746d48c437ae06aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
3-277-g059c7c9bf722c/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pi=
tx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
3-277-g059c7c9bf722c/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pi=
tx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62552344746d48c437ae0=
6ab
        new failure (last pass: v5.15.33) =

 =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
rk3399-gru-kevin   | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6255246f21425877b0ae06d5

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
3-277-g059c7c9bf722c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
3-277-g059c7c9bf722c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6255246f21425877b0ae06f7
        failing since 35 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-04-12T07:03:57.049122  /lava-6070815/1/../bin/lava-test-case
    2022-04-12T07:03:57.060154  <8>[   33.491446] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
