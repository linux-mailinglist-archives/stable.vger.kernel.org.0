Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4EE667A63
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 17:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjALQLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 11:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjALQLI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 11:11:08 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B33BC36
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 08:03:10 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id b9-20020a17090a7ac900b00226ef160dcaso19655724pjl.2
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 08:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qhhm2ltzFpm6BATW3BA0TWsWZqmkFObANH/+VmCj2vs=;
        b=l1Gq/jP2kMVb42uHNLNAxJ/veQENE6aCorki6XV799FLnef4JgUPGTciiWftujOlLv
         XprazuUJicfvw42hrxqCdO8q6LX1s92sCDjk0WjA8b3nnnDoOUEuyLRUhU7Y8aXApMjk
         IDJ30SdlpIB/K1lW249WXNfG0kGHyNnkOaaJ58GtvhsENBUc/j5tpAtDTjlrTGSt+Gzn
         hArP0rOhdsofCeH62RzfN5D+v5xqNz68PJe3zszmUIG8PkE96rmwDpkOd8FuiGjlu4iJ
         tZIwJCcqJX6ztJVdkXLaz/TOP4ziCWO4O3DQQv5mTr2YYGCwR511xRm1o347CUcfm2+I
         hxKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qhhm2ltzFpm6BATW3BA0TWsWZqmkFObANH/+VmCj2vs=;
        b=bV48+oRfoYjxntg2htRFavAmm72fMXJXhCxFByi8zzK2c4hqpcAPrhT2W9znlsOQxT
         d8OU9tfuPwGlDYEb6wP+3UBhkAyL1ABJ8Gejan2FePS0XgJ1p7RXY2YVstzIndWwdD5Q
         9V3G6Iy38msfeaVJFhPevVm82CC9fzAM63jFSJuXrhbUNXoBGPi3DlkRJVYXJcuv111x
         I3L7OOvnkR9mKEXlvkZ33yz0K5hSUM+++4ArFWjHMHrmuOle9V+WRH3ZOZQSB8BbqVIn
         YuWk5SowHQA4JYL8nKTdBUn4osRExlFeGGB7n8htA0qS77kmsiMHS3MLWNI9Ncjf7kyI
         ON1Q==
X-Gm-Message-State: AFqh2koJIVTAJmXwajPctK/lfQoaUcT2u4iuks/NEHJO+JvQrShTiWWx
        9mNU4h0u7k1oJerel67xxngU+Pz3iRUHEKz/OqbCOw==
X-Google-Smtp-Source: AMrXdXuKUO7XIlGE6qaI7GJEf+JNvSfixQzDa10EwUt5sD/vVyRKyIZ4Tat11Rr7jgpOzPGAxNSmyA==
X-Received: by 2002:a17:90a:8f02:b0:228:e97d:b3a1 with SMTP id g2-20020a17090a8f0200b00228e97db3a1mr6035508pjo.8.1673539390249;
        Thu, 12 Jan 2023 08:03:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d5-20020a17090a2a4500b0021e1c8ef788sm12805555pjg.51.2023.01.12.08.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 08:03:09 -0800 (PST)
Message-ID: <63c02f3d.170a0220.44373.4920@mx.google.com>
Date:   Thu, 12 Jan 2023 08:03:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.162
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 267 runs, 2 regressions (v5.10.162)
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

stable-rc/linux-5.10.y baseline: 267 runs, 2 regressions (v5.10.162)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =

r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.162/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.162
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0fe4548663f7dc2c3b549ef54ce9bb6d40a235be =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63b5837fc1634ca0c84eef60

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b5837fc1634ca0c84ee=
f61
        failing since 6 days (last pass: v5.10.161-561-g6081b6cc6ce7, first=
 fail: v5.10.161-575-g2bd054a0af64) =

 =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63bff64ee61dd4aab31d39ca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63bff64ee61dd4aab31d3=
9cb
        failing since 6 days (last pass: v5.10.161-561-g6081b6cc6ce7, first=
 fail: v5.10.161-575-g2bd054a0af64) =

 =20
