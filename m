Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8085003BA
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 03:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239459AbiDNBpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 21:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiDNBpc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 21:45:32 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC3920F78
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 18:43:08 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q12so3416801pgj.13
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 18:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AJvMMHDyjgvedgMkAkXcabpvDkTSTi34CrU4UkO5OMY=;
        b=Bb0phkNYbDJblvgM226K/NDVqzO9t06FleFEyjrPYOCcajCPaJiZTS4Dz/CUlqdHM/
         C7OPU4WUSJhC61s3KBIg1Xx56CSKZ8p0lDUsjyjNTXEG2N4eytEmoFqo71y/4/Jm0wMD
         qyNdPKODhfB3UMAc2Zw27jgF8NyIuk6+ALulUh8/NYxIiFtRCpBJhME/B8QbFhayUT+w
         9NIAL1ZaJNuswJChiTOzKwI/GAhKYwH3Ygtip8Ou666/N8xbdLJnQN9xY8Jhmuc8qf6t
         mzKE5LS0B0A3QaDOiqmTGx8+mSDsUF3CZq6HgBvmspfdfAb2VhsruFXETb3L3Mql4S2i
         r37Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AJvMMHDyjgvedgMkAkXcabpvDkTSTi34CrU4UkO5OMY=;
        b=rIh2H/9IUc6M2+Pbtvp+UT8LRccuiFHkz+roHIepGbKnP2jFHbLabpwFaFqFmvx3Mu
         urgxdGOayuyk+4SbfP+MdtQP4+XjiCsW0XAXFU+M4i8dMCKjYB9n/XUfG7BkOEVZGlDx
         8nHvEEPtgAT/RfLQzzjBxnLs618CXGYSCX4xwpspELuJFcic8C1sQAq1GRwNpKXaIj8C
         KZpsgoFkWbxZl4b9bGLbAiXLphp2Lrbyyl7NdqNaTiuuIUrUOglUmNEUIOV/vigYL9wO
         pmOsxHvrvA1Y/9+LqfMpTrw0fMtTflrT22DObatHj33Cd0m/Z7GzSP1IpToHK2dOpP8I
         jjqg==
X-Gm-Message-State: AOAM532/+1sym0nqg5u/foiHp2xhs0g+C+BcZkENopgiMz08USxmY/+6
        /ITdY+BFePLMVJL2+QD3DAG16jA9JwmfCPn9
X-Google-Smtp-Source: ABdhPJyxcjhgJ51OOrziHvK/4qWy9vvoKlgPnJ8jpxss0UpoKh9e4Vb6Krm9jXipLpGpzudxJz+rBQ==
X-Received: by 2002:a05:6a00:8c6:b0:4fe:10df:1cfe with SMTP id s6-20020a056a0008c600b004fe10df1cfemr1587639pfu.18.1649900588210;
        Wed, 13 Apr 2022 18:43:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s35-20020a056a001c6300b00505ff320d97sm344169pfw.91.2022.04.13.18.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 18:43:07 -0700 (PDT)
Message-ID: <62577c2b.1c69fb81.d33de.1709@mx.google.com>
Date:   Wed, 13 Apr 2022 18:43:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.19-285-gab4ada9ce2ccc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.16 baseline: 103 runs,
 1 regressions (v5.16.19-285-gab4ada9ce2ccc)
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

stable-rc/queue/5.16 baseline: 103 runs, 1 regressions (v5.16.19-285-gab4ad=
a9ce2ccc)

Regressions Summary
-------------------

platform          | arch | lab          | compiler | defconfig           | =
regressions
------------------+------+--------------+----------+---------------------+-=
-----------
am57xx-beagle-x15 | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.19-285-gab4ada9ce2ccc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.19-285-gab4ada9ce2ccc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab4ada9ce2ccc00bf9a7a3bb2585aeafeba9d648 =



Test Regressions
---------------- =



platform          | arch | lab          | compiler | defconfig           | =
regressions
------------------+------+--------------+----------+---------------------+-=
-----------
am57xx-beagle-x15 | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62574b976319e0aa8cae06af

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.19-=
285-gab4ada9ce2ccc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-am5=
7xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.19-=
285-gab4ada9ce2ccc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-am5=
7xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62574b976319e0aa8cae0=
6b0
        new failure (last pass: v5.16.19-285-gf7a13b187d03) =

 =20
