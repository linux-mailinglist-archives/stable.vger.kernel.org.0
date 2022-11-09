Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8394E622E0F
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 15:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbiKIOgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 09:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiKIOga (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 09:36:30 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD55C1E
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 06:36:30 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id y13so16855975pfp.7
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 06:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ozHpWOpaMGmGWKZfgSopp+moEhwW8SVtYtsMUl+61B4=;
        b=RHZGFoB9zR+adI1rW6/5B1R+B2UPAFAZcIyZCrbL8YADhfhUk8C5d2ureO0I4qyVut
         oK+Fo4LUYrb1gKmZbmwMYE0BqwXBfBQNvw6DLFDzVPnqv4DWLPsXz2G69EqxS72SfVGT
         gc4slZAdcbTd7FQRR5IasMmWrWvYfES9ovJkTxM5tdLRPqp/OT8FZSDLx3OGbI4pXrUa
         CGE1VMl+kvHo2oh+qGCJ2JYWcwGM8hs7/m2ydd4FSBYcy+Hp6ZKawLgt6Vs/goYYorJP
         hNTTerYUSd/tQcf/Jbjh+6KBUs7QNhu+qWCyw1j6fxg4STII6gmAHxOEVtcZHEPCy6wa
         KdEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ozHpWOpaMGmGWKZfgSopp+moEhwW8SVtYtsMUl+61B4=;
        b=xwUUzTPLkEcyxrN7R8pWnRtTg7vuovTDD/NP/1+JxN7pqboEOdC+HNcNVgie2HSYDm
         eGenL3llt32IPGurGPwkeZ8N0E7/3nGggOwtVX+LLB/UOFuGW+Z3cl0GEhHV2/TUhKcG
         Lwe9OQDdg/Hna1zXxvIPHCR7cj3gkhAO7cq/7OwQy3tdPA58rlNZ8Se9y3Oi8xFLNUdq
         fds3r1Jwc2xT97zvdJthlmLBd5zPA2KjF6SIGcHMTOYAS+UAjEVxV10Y8GlJRfPTrzep
         zGHVfxjqndMuAV6bxHHbHfGF6lzERoT+czl8iICELO9NwWrph1rhUJtePWkLnCFxvZqB
         NoPA==
X-Gm-Message-State: ACrzQf1jzdYPDqGQdngRqvXTGtSRr7G3TWckoVTImVMJJkTN03HU5x74
        P68RLvjthZ5NCZbDf4atfSh+8d9E0dX6TQ==
X-Google-Smtp-Source: AMsMyM7jG8krD51Ljjq0VAbyBdU++9NDr/52wut54+AH2XYoEEOmdl6w8h6Isxa5vpk9izaZbs/Ybw==
X-Received: by 2002:a62:190d:0:b0:56d:5b06:c88b with SMTP id 13-20020a62190d000000b0056d5b06c88bmr28653902pfz.78.1668004589455;
        Wed, 09 Nov 2022 06:36:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u10-20020a170902e5ca00b0017f64ab80e5sm9180638plf.179.2022.11.09.06.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 06:36:29 -0800 (PST)
Message-ID: <636bbaed.170a0220.6572d.fc2f@mx.google.com>
Date:   Wed, 09 Nov 2022 06:36:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.77-144-ga3cc23b5c123
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 143 runs,
 3 regressions (v5.15.77-144-ga3cc23b5c123)
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

stable-rc/queue/5.15 baseline: 143 runs, 3 regressions (v5.15.77-144-ga3cc2=
3b5c123)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig        =
   | regressions
------------------------+-------+------------+----------+------------------=
---+------------
imx7ulp-evk             | arm   | lab-nxp    | gcc-10   | imx_v6_v7_defconf=
ig | 1          =

imx7ulp-evk             | arm   | lab-nxp    | gcc-10   | multi_v7_defconfi=
g  | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.77-144-ga3cc23b5c123/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.77-144-ga3cc23b5c123
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a3cc23b5c1233419ac9fba449531c41e7df2ceaa =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig        =
   | regressions
------------------------+-------+------------+----------+------------------=
---+------------
imx7ulp-evk             | arm   | lab-nxp    | gcc-10   | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/636b84b98d3b433ac3e7dbe1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.77-=
144-ga3cc23b5c123/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.77-=
144-ga3cc23b5c123/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636b84b98d3b433ac3e7d=
be2
        failing since 44 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform                | arch  | lab        | compiler | defconfig        =
   | regressions
------------------------+-------+------------+----------+------------------=
---+------------
imx7ulp-evk             | arm   | lab-nxp    | gcc-10   | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/636b8635e291ecd13ae7dbb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.77-=
144-ga3cc23b5c123/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.77-=
144-ga3cc23b5c123/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636b8635e291ecd13ae7d=
bb4
        failing since 44 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =



platform                | arch  | lab        | compiler | defconfig        =
   | regressions
------------------------+-------+------------+----------+------------------=
---+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/636b843602d8a5c86be7db9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.77-=
144-ga3cc23b5c123/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.77-=
144-ga3cc23b5c123/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636b843602d8a5c86be7d=
b9e
        new failure (last pass: v5.15.77-144-g06c96c8d6c7c) =

 =20
