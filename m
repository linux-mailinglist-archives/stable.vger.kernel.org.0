Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94D34F1AE2
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379297AbiDDVTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380221AbiDDTP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 15:15:58 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2DEC1F
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 12:14:02 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q19so9129676pgm.6
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 12:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c4u3LisD0YovsKFLAfe9eAFbMPT4YBYO/cPLaZ3rQW0=;
        b=eMxvz+n4nmz9wmi0NcktOcE0xY83HriQLYCOehqNDADgaub420qeTF8ewhXaWO1JKp
         QnzU+CVwmdmWJA7wJCRx+iH5POJutZH+Y6OgOa17GOp9OU0xTY5b2vxrcvjbkJktezzC
         qvaAHQCSie3K5p4/UVE3glpcaA+xRfXkUDcxlaQAX/kiXk1Ak+JVvbU/qWiqSLP2/9nl
         t0z08CY5MFg0bwfTZ0XnkabbnFum3zDqk18tJJW03vSBDmXrX5wKWylnxHAeIEfLq9Dg
         81QAJF2sRF+MiP/h8zA1upgRXlDxdMyKnpLKchKsnk8EFX8ueVH3QZFJAEk1Vb4WMEC9
         EUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c4u3LisD0YovsKFLAfe9eAFbMPT4YBYO/cPLaZ3rQW0=;
        b=cYiha6VcOMKf1X1N6PfA+DBnqM/bX7jFE5oKNmqyVNHhFQPikLr+HlTM4xloAn/WRJ
         STNoTQ5zA7j96r+EI/ajDeBuqv5VBA3bU5Z/KL2zmuwG+LExN3znca2otH1uP/oypBft
         NzhYsfW9eKAjJdfekjepORGjOt5D06+IFtBfEP3itG0R4FOiJJTcyqfJ1pbB54ocuUPJ
         BpBb6ElucY4ocApsj20if/mXW1jY1LMOT6Ui577IG7GNo1+nCuMqionz9cBbrjKE4xey
         lZIqri6pSivIV85EzA7ZQFq7E0a5mIqJz8/NhlHkt6oTW8msnX0+6ira05dA42AiChhR
         nhbQ==
X-Gm-Message-State: AOAM5334AZk99325vNXpSklcRYvnuzxPK8WIJBbASYB25TiTgKOk5M7i
        iWjk6ib/Kjh8f6oEHSScXTSXzgEZaPQPmBev+3E=
X-Google-Smtp-Source: ABdhPJwZvurgwkitll/f30NFv5Qa3nIk6BH5D21IjewbkNOZiwLtEl4yRmMNUrSI3xTWJCldAWWg1g==
X-Received: by 2002:a63:5d4d:0:b0:398:fd64:3793 with SMTP id o13-20020a635d4d000000b00398fd643793mr1085351pgm.597.1649099640932;
        Mon, 04 Apr 2022 12:14:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g5-20020a056a0023c500b004fae15ab86dsm12637779pfc.52.2022.04.04.12.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 12:13:59 -0700 (PDT)
Message-ID: <624b4377.1c69fb81.d3a61.07e1@mx.google.com>
Date:   Mon, 04 Apr 2022 12:13:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.109-593-gd189d4a7b878
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 52 runs,
 1 regressions (v5.10.109-593-gd189d4a7b878)
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

stable-rc/linux-5.10.y baseline: 52 runs, 1 regressions (v5.10.109-593-gd18=
9d4a7b878)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.109-593-gd189d4a7b878/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.109-593-gd189d4a7b878
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d189d4a7b878ffe1fbb94de895104afbb8b669c1 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624b17bc493aabd1e2ae06a1

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
09-593-gd189d4a7b878/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
09-593-gd189d4a7b878/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624b17bd493aabd1e2ae06c3
        failing since 27 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-04-04T16:07:12.620236  /lava-6017851/1/../bin/lava-test-case
    2022-04-04T16:07:12.630733  <8>[   34.053886] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
