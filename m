Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80F2502B62
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 15:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344128AbiDOOAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 10:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236307AbiDOOAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 10:00:34 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64766BE9D6
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 06:58:06 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so8402737pjk.4
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 06:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7rpDPveM4jy95t+WnON3DIGesNNdmDlKs7ttFwq8ulE=;
        b=q9MysMNR0IG9Ol5YpngSqi3Wtbmqmo1kKeTxyqfZiD5LKh/kRAQhvzV4S139sLCimb
         2+JTjBonJRdPdsliKt+K3/Wblj0YoAr1EwABvtUdpKEEppjE2CTcXdZ+81gRrI06E+Hd
         LG1DWe8XMkakM3Zg1Um9YxQB4SNf0kEgUg7+bQlDKIfZfgDO/jlMneCdpvJSlk5sNamA
         WT5NLuszO1DjiIxiVYgldRxvYAMEYrFnoWDztzV3UpVcpJO6w9h+SW3pbFKLwQsrAhcG
         WIEgtnhNAkYKHMXV241pZvbZXQcjzKHIfNIJ3STNV3s+rV3D8rhVX6rGAal+OVPCMPeT
         56Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7rpDPveM4jy95t+WnON3DIGesNNdmDlKs7ttFwq8ulE=;
        b=EHh5lABg/t9iJL+HNxXsK21zG1RMHPe6U/ScvFFZa69X9IuQY1akq/rNbtKE2ACdEf
         oq6k3zpwAg1vulOaEgMT2fTRMeqXFTmsN+IoXjzDyoG3BSsSo2Gch89agrr4XCy2xFeY
         5JNOeBC1n2JmfnqrbJUwMXkzrymqf0Ykj9WTThDGWTreXbj41+nqEERKDjTodsdcB7JF
         N7FmcQiilnQ3jq9GG9ukRxNgW07xK6OiW27o0+ZGweBulgGWzC5VfzTbxRwZdJ/vARIr
         AsfPYOgJgu81zrW5FJvmZIGZHWSb+siuyWZIvmYApOFqEBDyIZ2OVP0RekkuHh/W2saA
         gLtg==
X-Gm-Message-State: AOAM531HlBxK3gIo86wvviKeZVxnvdif/0nJG5KZCNmPeTXeyRoPYFQM
        HtZrzQbyMrlQVps5bPV+0uwDgA74G4Gt6Lgd
X-Google-Smtp-Source: ABdhPJyPkaPeUZhLrQrUM+bWnPWVPR9fJe2GNWDDjYCNZuCIdFjq1f9EUZwOEEaLhh9kzPZjo9nokQ==
X-Received: by 2002:a17:902:ec81:b0:158:7eff:792f with SMTP id x1-20020a170902ec8100b001587eff792fmr19918883plg.154.1650031085817;
        Fri, 15 Apr 2022 06:58:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a00115000b004f6ff260c9esm2957914pfm.207.2022.04.15.06.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 06:58:05 -0700 (PDT)
Message-ID: <625979ed.1c69fb81.421af.7da3@mx.google.com>
Date:   Fri, 15 Apr 2022 06:58:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.17
X-Kernelci-Kernel: v5.17.3-9-g4f73362485c4f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.17 baseline: 74 runs,
 2 regressions (v5.17.3-9-g4f73362485c4f)
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

stable-rc/queue/5.17 baseline: 74 runs, 2 regressions (v5.17.3-9-g4f7336248=
5c4f)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1     =
     =

at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.3-9-g4f73362485c4f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.3-9-g4f73362485c4f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4f73362485c4fb25ddaac28b5691adcd6da59a97 =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/625942dfc1a43d2850ae06a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-9=
-g4f73362485c4f/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-9=
-g4f73362485c4f/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625942dfc1a43d2850ae0=
6a1
        failing since 0 day (last pass: v5.17.2-343-g74625fba2cc43, first f=
ail: v5.17.3-7-g214113ee8b920) =

 =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/625944bf7071cac126ae06a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-9=
-g4f73362485c4f/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-9=
-g4f73362485c4f/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625944bf7071cac126ae0=
6a1
        failing since 0 day (last pass: v5.17.2-339-g22fa848c25c53, first f=
ail: v5.17.3-7-g214113ee8b920) =

 =20
