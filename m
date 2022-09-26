Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDDD15E9E8E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbiIZKEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbiIZKDu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:03:50 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A1626134
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 03:03:49 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id t3so5792854ply.2
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 03:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=LgpQ/Wcr8OwF8JoIB87KMCucGxjji/zbS5iJnkPmpcc=;
        b=55qaY9L8aLyRXDm+ozJWMVNRUb6/PLaC/H0pc3oQzolg0mXWNjn/fcZacx2n8l7CIC
         GWdEVr+sIww/HRc6YgKsIwij0U8g+D/zhcIoBFFhcOHV6tmhyev36hN0CxYr32uMVGZY
         gicPDC/HNS53iLMC0lmbJlNJHBMiviXcH2K0q7rOIwhaktjIc1wxHcOv185LIfzbqe4y
         1LjCXsEWOQQMtxNoThLQQDZINWxzaB7I6geG/bRe2CPsaMj1mov5/FGvYYrJBfNWx28b
         Y89yWohe6rHxtD+td1OZv/l0ffJLdVHXRlKl82rssBiE7+4FpMGkEopmxgbA7Jrq7Y9b
         n7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=LgpQ/Wcr8OwF8JoIB87KMCucGxjji/zbS5iJnkPmpcc=;
        b=CK94Pm5waI8tLyiG6WT6G+6pLrgQtYddU1mRpnPj5gMoCTfbSXNLtsBnlogVg1plET
         cgdVP5iu/DfFEvaRERTjkaS+PkCUmNQZfJdA+odilyNsCRkRPwr3tkblt895e5jqHuuG
         PXXci0PbO8GFJLDo5txdbrpB7lAOhwxKb1+FyGhcpTQs70ohdzl3iHFTAcAtO4PF6A3O
         J9UKtTY8kro36VwyciwnzJtFeUUp+n61sbY6QWWtKAnvwmsLy2SXCaGrKuvxUw7XWZaG
         ehuvGHHXkf7p9KL0u9anWK0kwCnZ2NWB6+PSsBZVJvSJYaCA6RFVNNL2xJcONclaQylS
         oEpw==
X-Gm-Message-State: ACrzQf17JTY0L8A9TTmT89xxLVI4o+Jzq/ZFVoO//gEaOVi1/vTkTr4K
        lCaqYJVcBkdVia3Bomfx7fSToAqjC+xgesCD
X-Google-Smtp-Source: AMsMyM7WFudiBwR+GA1y6uEx3C4hVv1NNpgLZH3bSqcpDSyaCDvrlSko4pfH7YuJ4ZxMBV4kgfNR1g==
X-Received: by 2002:a17:902:7c07:b0:178:2984:450 with SMTP id x7-20020a1709027c0700b0017829840450mr21584611pll.43.1664186629149;
        Mon, 26 Sep 2022 03:03:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b00174fa8cbf31sm10977080ple.303.2022.09.26.03.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 03:03:48 -0700 (PDT)
Message-ID: <63317904.170a0220.84404.3f43@mx.google.com>
Date:   Mon, 26 Sep 2022 03:03:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.70-140-gbbefd963c9b9
Subject: stable-rc/queue/5.15 baseline: 134 runs,
 1 regressions (v5.15.70-140-gbbefd963c9b9)
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

stable-rc/queue/5.15 baseline: 134 runs, 1 regressions (v5.15.70-140-gbbefd=
963c9b9)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.70-140-gbbefd963c9b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.70-140-gbbefd963c9b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bbefd963c9b92fc31ed5c1fd719e0ce7d152deb7 =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6331469f1561febe1a355663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
140-gbbefd963c9b9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
140-gbbefd963c9b9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6331469f1561febe1a355=
664
        failing since 0 day (last pass: v5.15.70-117-g5ae36aa8ead6e, first =
fail: v5.15.70-133-gbad831d5b9cf) =

 =20
