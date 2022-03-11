Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110FF4D67ED
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 18:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349784AbiCKRpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 12:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346629AbiCKRpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 12:45:16 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6938711E3F8
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 09:44:11 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id n18so5569490plg.5
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 09:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xQewVKIhY2r0v+IHm0AF/AsV/VszfDdNiAbw9A3Tc8g=;
        b=R7fJWpI+lQlaMnm0sz7WZDOcW/aYqqgyFH8nNPjw34z9G7xXYmIrlLnYsVCC/hb7p3
         51Q1Nd90p9ueDY6LkES53YFOb+JjGasQ/k4+tN1NNvn4yP1XMQS3gCgEvoEiqunTcGL8
         BHoqUn0dfzzDkVMeYNPwNUs+nr6uLe8Rx8t331FKJGZmWertuqnLK96x9+BazmDQY0Ih
         g5vqjEWaSRMpiEKx5KmDAUg5W2zVilxHxNV2rd3wCcY76agQ9euscoLj5aDpa+7g3wtG
         T6uZK28F6TfHjGrpTTQwXDC7tp+tpWWzznUZA9D4O4qSCylI++QjOWc9i2xoK2opG6R3
         BfpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xQewVKIhY2r0v+IHm0AF/AsV/VszfDdNiAbw9A3Tc8g=;
        b=gx+VxTeyvMsKWD3e8LbMd75fnEYsFMAvwukBwhHJMIoaGtf67eU7Wh8QCW+1v5MeON
         ELS0uvEyXEg7SwCT7hPJi4PdEIC3UQvoCr+7TcgNl2UBEMXDl42AAnCDncoCcb74YCaj
         ClRYOJtfP986vyoGF79oBqWA3fjD4eAUNdDB8MJp8+TWmPRfub6l5VVGgb7nwANcLQYV
         yeEdt6z6nsnSgWDFE8oj6LHrc93Nm7SJS7gO8zSxBuTF/0Z3usZa3hNRBu9E6KHcGVEz
         tbSev7tce7AwDmPsur8I9t/1bU8LTvWtRwqj+CzTuPVeu6prFl07Lg6OciwIHKA/b6/m
         Mkpg==
X-Gm-Message-State: AOAM533idJl2Ebt+HHE2TQ8q7shN9rf9d4DkqaxvsWLakNE/hFALiVcd
        zBAJD6GFB8x9tZpZ8bBil4jlLQPKXYeQWNAeVtQ=
X-Google-Smtp-Source: ABdhPJxQH2w4fd3kaYrZnFkl1zFjmc480Ewloo15P05FebDG376Xs0PdH4cDvNybKMDnV0W/vX/Lbw==
X-Received: by 2002:a17:902:728d:b0:151:dcc8:9f86 with SMTP id d13-20020a170902728d00b00151dcc89f86mr10879143pll.76.1647020649256;
        Fri, 11 Mar 2022 09:44:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p10-20020a637f4a000000b00373a2760775sm9315476pgn.2.2022.03.11.09.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 09:44:08 -0800 (PST)
Message-ID: <622b8a68.1c69fb81.45847.7d76@mx.google.com>
Date:   Fri, 11 Mar 2022 09:44:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.270-31-g223a2e117a9e
Subject: stable-rc/queue/4.14 baseline: 48 runs,
 1 regressions (v4.14.270-31-g223a2e117a9e)
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

stable-rc/queue/4.14 baseline: 48 runs, 1 regressions (v4.14.270-31-g223a2e=
117a9e)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.270-31-g223a2e117a9e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.270-31-g223a2e117a9e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      223a2e117a9e692969ef5d2e3ff53f195d10afc8 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/622b53cf0101fc24fec62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.270=
-31-g223a2e117a9e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.270=
-31-g223a2e117a9e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622b53cf0101fc24fec62=
969
        failing since 26 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
