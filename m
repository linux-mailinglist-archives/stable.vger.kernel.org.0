Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBA26CCD97
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 00:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjC1Wkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 18:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjC1Wki (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 18:40:38 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE9D30E9
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:40:04 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id le6so13111528plb.12
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680043204;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1DkxZIp7tdY+4GrF615iZ8c1iSkcVmqsTlux0gtZkcA=;
        b=KFCcpBtZ7g2QtCA/jR/lPCCYYd5uqceSLESyp9KfFRppHRdtKshPD47+oekaRiqgzx
         htRW9z11sl1HvoZNG7rpPwE49g9272BK9nmIEabAkpDszMhBLE/Ki+u6hrkF2zzXJ8G5
         ushhQXKGxeUuL8a5Nnt/ylIZD/7/7Es50kfbYGINq8meSEbAhX1GO1adTcO70xTdLD6t
         PLZQY7YQ5RsJol5Qs7NcYuimnhSyywS60alz6pZptBDkFbsqFDwkT2oZ5C5Ty/E4t5DK
         IgUEyzxu+qDWsUYALevCMAgT+jxGjP2YFAKmJU3UfeD1071BXBr4hLIlu5fTMeUkrhla
         0v0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680043204;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1DkxZIp7tdY+4GrF615iZ8c1iSkcVmqsTlux0gtZkcA=;
        b=r9nAbQGKD5MTnMxtLELdfAzpUE2GsNmF2UgcpkGKTMqIVjWXToIYZ4iwrDDWR4W5c5
         HIqPMxrD6hMKLNnpEbosBBXuPrUZILLcJKLd/E89LDKAsI6HtKgpnSQHvIEnRIfKT5xr
         J9ulhGQkkWTrsJGWnQmDXksgV5eONO6T58YBEsxCMgGMzGrXGjzXaSMLKpMyx3rElGeC
         Er7T4+1QSyFJJR0Eug2vh7I4t4ExPIFR8+mlUQB3SByNtGZZrC4vXWAkQf3xSMjFtnL3
         AjbqeW9vLluKN2XWEuKZKrWe3FNvBec8d0On87eWCNM2NfFuqYGzkszJIORqDoQjoWUr
         lq4Q==
X-Gm-Message-State: AAQBX9cHnegcw5qbPpJDsGZAY5lPhuxzati2K11CNJ76PLUlUcSLH7mI
        9f8hQFWnCmp/6100KGl2ZklkvxVgyB0LoWTgQXbFbw==
X-Google-Smtp-Source: AKy350YKJf7b4zcQnu5+39JDp+PErMWST1h69+SgAaAgbkqnmTiP5GUEIpjArNYKu6StriTK7nLTDQ==
X-Received: by 2002:a17:903:41cd:b0:1a1:b65a:2072 with SMTP id u13-20020a17090341cd00b001a1b65a2072mr21704400ple.59.1680043204073;
        Tue, 28 Mar 2023 15:40:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jo18-20020a170903055200b0019acd3151d0sm21635194plb.114.2023.03.28.15.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 15:40:03 -0700 (PDT)
Message-ID: <64236cc3.170a0220.1cec8.819e@mx.google.com>
Date:   Tue, 28 Mar 2023 15:40:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.279-50-ge74af48c09d5
Subject: stable-rc/queue/4.19 baseline: 78 runs,
 1 regressions (v4.19.279-50-ge74af48c09d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 78 runs, 1 regressions (v4.19.279-50-ge74af4=
8c09d5)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.279-50-ge74af48c09d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.279-50-ge74af48c09d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e74af48c09d5a8c1e3bc74b28cf2ac9d2180b9fd =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6423302000cade3d7562f808

  Results:     42 PASS, 9 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-50-ge74af48c09d5/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-50-ge74af48c09d5/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6423302000cade3d7562f839
        failing since 1 day (last pass: v4.19.279-25-g8270940878fa3, first =
fail: v4.19.279-25-gc95d797f10041)

    2023-03-28T18:20:40.466770  + set +x
    2023-03-28T18:20:40.471974  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 240963_1.5.2=
.4.1>
    2023-03-28T18:20:40.585300  / # #
    2023-03-28T18:20:40.688092  export SHELL=3D/bin/sh
    2023-03-28T18:20:40.688879  #
    2023-03-28T18:20:40.790837  / # export SHELL=3D/bin/sh. /lava-240963/en=
vironment
    2023-03-28T18:20:40.791597  =

    2023-03-28T18:20:40.893568  / # . /lava-240963/environment/lava-240963/=
bin/lava-test-runner /lava-240963/1
    2023-03-28T18:20:40.894922  =

    2023-03-28T18:20:40.901496  / # /lava-240963/bin/lava-test-runner /lava=
-240963/1 =

    ... (12 line(s) more)  =

 =20
