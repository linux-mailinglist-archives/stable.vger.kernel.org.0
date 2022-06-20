Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA52B5526D4
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 00:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243558AbiFTWHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 18:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiFTWHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 18:07:19 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B131AD84
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 15:07:18 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id e63so9889544pgc.5
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 15:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s0xzutc9jMpaFYwDrzQgt9+xLDuh4bgPOu4br0Fb7RQ=;
        b=KX4WOH+gvAyposigclm1qD+p50pPagWjeb8pNyer3g1CP5L648nL1ZALRVHb2OE8de
         OhspiGckMk8CKtvZz/I7Vv4kiJeFNqK36gjraAtNyvHeuEgjH3u8/SvGBYSTrHEa04dx
         5ZmuYu3mJ2svpDR2eV4Kwljth4bMT0LABqKtfxxP8OCMLzf6MfVq3q2UnJ3Lw3154/Et
         XQhLlpOBlSVA/6nDZNw6LWuP9dwEaflI37ohyiKOmiNPhJBX/qSPGDVLZg/MZVn/z7od
         X376JX99TL1O8p1ibjP97VqsW5jR5DdRMtB4tjBFEg8bzplKsbpUXwHIQ2R7Gq0x9Tjj
         P02g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s0xzutc9jMpaFYwDrzQgt9+xLDuh4bgPOu4br0Fb7RQ=;
        b=gWuxCY7gEcVzC6c+s+8wyR+0EfBNvY/n+VOE9GJk2+qPbW1DikyLf/T9YwGde3ON+/
         SwNICI2eguij+LyrbVP8+hnfM4PHWac5NjXt/YMPrtyhRsRpSRdkrZv3e/Zfa+EGwE8O
         Aqsmhq2uF9S9LDWrx1h8vAnjDvrvdoXJZT/TZcTy7k3EMeI+1E2m0tPeGeQ3WDsAJDup
         FKN7YnUi/7UYUgYqhBDg8fVvi54WOcQkEu0xf847lcUobTag8UAZmsKdrvuKVb9rpQE+
         NWgk/pXZiPVy/1Mb/f3yz6UwDuXI/KZ2EjGRZ+J2Bk3zdnShUfb/Pl5pTBqFjodxPyZN
         j7YA==
X-Gm-Message-State: AJIora9BoqUNu4rsowgokXgunGH7pf/Wzg7MpyzXpTRY28z7pwoKUkvA
        CFv5jjormaF2jc7gp6qVK9+5MrZnie4cgaOtMTA=
X-Google-Smtp-Source: AGRyM1siEvjSyWDL2dPEYetBFIQFGO9ahv30xk2IjRiN8wqaR/EzgDRo01X21mIm69DGGeYgZNj56A==
X-Received: by 2002:a63:790c:0:b0:40c:3c04:e3d3 with SMTP id u12-20020a63790c000000b0040c3c04e3d3mr19972178pgc.44.1655762837646;
        Mon, 20 Jun 2022 15:07:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l74-20020a633e4d000000b0040c97f0057dsm4139763pga.17.2022.06.20.15.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 15:07:17 -0700 (PDT)
Message-ID: <62b0ef95.1c69fb81.274b1.5c8a@mx.google.com>
Date:   Mon, 20 Jun 2022 15:07:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.5-141-gd5c7fd7ba94c0
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 176 runs,
 1 regressions (v5.18.5-141-gd5c7fd7ba94c0)
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

stable-rc/queue/5.18 baseline: 176 runs, 1 regressions (v5.18.5-141-gd5c7fd=
7ba94c0)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.5-141-gd5c7fd7ba94c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.5-141-gd5c7fd7ba94c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d5c7fd7ba94c0449276f4c709cae7d73cb6d1611 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62b0c48bd0274f2e63a39bfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-1=
41-gd5c7fd7ba94c0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-1=
41-gd5c7fd7ba94c0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b0c48bd0274f2e63a39=
bfb
        new failure (last pass: v5.18.5-115-g6f49e54498800) =

 =20
