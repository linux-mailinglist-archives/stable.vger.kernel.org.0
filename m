Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8DB528C6C
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 19:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238493AbiEPR5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 13:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiEPR5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 13:57:08 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F06248C1
        for <stable@vger.kernel.org>; Mon, 16 May 2022 10:57:03 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so34427pjq.2
        for <stable@vger.kernel.org>; Mon, 16 May 2022 10:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s8Szgr5hkgsjlLeFEAHh2fpZvkAn26KOC98Petpc+bQ=;
        b=uotSM31fJ91cIxo5LaPjBFF6JN2e0vBAY9tjTDRNW90b8tfWMcH5Jp3td0w3LnKZi5
         V+eu4IGHq6DQqOGwHdFoy95oS8S959M6QOcg2ZSEMk2xkdKQyVfCAMGE//KtFn6E3oZc
         UkLpoF22VT24bMrC9q338LuVDSRbMsPUcc1+iWuJg4+64CMRf71TQ37VRyT01x5SNWMt
         zmY7sXTlHAmmE0DJvVeShMDXt6T/RvU95cg7e/beUprWV2ircF0FRIBZ3qbyk5lfQ7Vc
         v+a0J2NKtaAG5fJgiGwli5fISkPGzd79E7mQN5dP9vTh0mVUnO3eg4DmjBklI4weI6ah
         6IIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s8Szgr5hkgsjlLeFEAHh2fpZvkAn26KOC98Petpc+bQ=;
        b=sSMoz/FjjncpjXT/+50kbljzNCJmJmM+WMZtqYRgkGLBmBoLBtDQJvSFwGDPphRZyT
         tmtXmsTA+aMhIxhRXGtG8rSBn6pwE7uC9I6kUMV4DUBO19Sf9D1JRCaPovxe8yXrSBbb
         fcm7QVS6mVPiu9Vd4Kx5HBSzTaoigJ4kLSEKlvYiKvYEBi1xf7iHA89NRO8GEzmzJ7r9
         8iiuhebf20e8XB42loRKjHSDwswzeZWSfCzDEqoW24gGvCQOm+ZKE4xHXJ6aOOd8de9B
         HSHrWlux3oRi4xJ6zf48+FOInfegC2bz7H7d1i6Axf7C5oUHyshsKGhgRiUKR/9cupJ+
         3tZA==
X-Gm-Message-State: AOAM530IomqkSsfjeIt5J4EO6lJguqu/sZZ6xtdkSLhnfnX0OBQ0TKYg
        oBJDfYZVC1ZiXQSN8fV5hypHNc6ltpyR2omIDIs=
X-Google-Smtp-Source: ABdhPJwVjZoiLdceACt8+GNjVKMQJAML3u/qZGUpL0rsbCrbHLH8KUGow/x4DIwordtd2wDlqzhRig==
X-Received: by 2002:a17:902:768a:b0:159:71e:971e with SMTP id m10-20020a170902768a00b00159071e971emr18686516pll.163.1652723823191;
        Mon, 16 May 2022 10:57:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q34-20020a635c22000000b003c14af50603sm7016015pgb.27.2022.05.16.10.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 10:57:02 -0700 (PDT)
Message-ID: <6282906e.1c69fb81.5ac81.1190@mx.google.com>
Date:   Mon, 16 May 2022 10:57:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.40
Subject: stable-rc/linux-5.15.y baseline: 152 runs, 1 regressions (v5.15.40)
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

stable-rc/linux-5.15.y baseline: 152 runs, 1 regressions (v5.15.40)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.40/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae766496dbd448eea2af4b3be8e2b2172ce38a79 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62825fe7ea2a66ed188f5744

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62825fe7ea2a66ed188f5766
        failing since 69 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-05-16T14:29:20.589300  /lava-6390654/1/../bin/lava-test-case
    2022-05-16T14:29:20.600129  <8>[   33.826417] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
