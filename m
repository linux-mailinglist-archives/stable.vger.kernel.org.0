Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67FA585E06
	for <lists+stable@lfdr.de>; Sun, 31 Jul 2022 10:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiGaIHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 04:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGaIHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 04:07:19 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAF6F1F
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 01:07:18 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id m2so1186666pls.4
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 01:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ddzhLzxjjIpxOcjdGHnMmpWacu3eCAamDDRO7bxUUbU=;
        b=T/6YLlbBofBIK1lmRgPCNiV70v/JnhDPa5ZVmEupnjc3gFijJu11WP3djaJpHExnPv
         uAmEcINQrGeE+J9AxsHVPBYExqa6aZEpHSfAdZYjXF8F6sBId4meitkMgyB+f7Hm5QC8
         11SCfss2fNOxceiIK8GxroSxHFSbO4MPKQAWzjj28wNQysIhf8iT8YTbmcRKVdWiY3In
         UGeGd+zR0GbrNtAdoFTyNbBua4YU2FjIHTBx7SFOX4Cady/7kXzPabsNZbQX0SISEdsO
         W3zzIXShvMB62dCG1j6zIXXMT1fZctaUPNe+wSB3L90yi87yxFSEFpJIxoTL4TbQke0f
         QEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ddzhLzxjjIpxOcjdGHnMmpWacu3eCAamDDRO7bxUUbU=;
        b=OJUpM/9rP23ohjI5iOOQSbKCWYBLBSj0YBOH0661fPE6GdLUoTpTrm1u7ZPBxlM8kE
         c+JMWNNYQ1yJmKgeNqCOSHglJOBISwdq9SZjWWpVqlZuw6e6mhxCzAcXx8iglhYf3CuN
         GV/RhiwFX1phScw7//imaGaXoVOPTUUR6YLLArGm2PSHQypeM00fsx+I838xTWc+kAm9
         xu+yGMZ7H/pTxBcjK0F4W5hWHrnLiR+n3vwdsUwX/11kBOSsKYbT2nvWsv841FEf7B+p
         rObJU2RYLo72g6kVpA0rkipTZo2CTU5zEcC6SFhAYsfSOKnrxzoqViYsD8tcVdlvaK2Z
         DZ7w==
X-Gm-Message-State: ACgBeo3dHvvYLI037SmuhgxGTGwK88v8pPRs4mC0urOsDzxu7RE3OD1y
        2ToJ5c2OAgu81J0hfaMqPKPvwgvsO/n8HMje
X-Google-Smtp-Source: AA6agR65ZmCwKvdtw7WURCPl1ogeG/SASLbxRDZsyjAgtMdetGFvGdSvcO7PxVl8qHyxWnCdCXFvcg==
X-Received: by 2002:a17:903:32d1:b0:16e:dfed:b4e4 with SMTP id i17-20020a17090332d100b0016edfedb4e4mr2508057plr.54.1659254837879;
        Sun, 31 Jul 2022 01:07:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e16-20020a17090301d000b0016ccbc9db0fsm6997292plh.5.2022.07.31.01.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 01:07:17 -0700 (PDT)
Message-ID: <62e63835.170a0220.5ca42.a9c4@mx.google.com>
Date:   Sun, 31 Jul 2022 01:07:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.57-236-ge17300de5f59
Subject: stable-rc/queue/5.15 baseline: 107 runs,
 1 regressions (v5.15.57-236-ge17300de5f59)
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

stable-rc/queue/5.15 baseline: 107 runs, 1 regressions (v5.15.57-236-ge1730=
0de5f59)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.57-236-ge17300de5f59/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.57-236-ge17300de5f59
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e17300de5f5957f5309c8ba93f4cb335fd86c03e =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62e5ff860ce2197f46daf08e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.57-=
236-ge17300de5f59/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.57-=
236-ge17300de5f59/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e5ff860ce2197f46daf=
08f
        new failure (last pass: v5.15.57-235-gd784f6af6f4fd) =

 =20
