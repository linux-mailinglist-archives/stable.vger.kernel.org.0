Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DF95E8814
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 05:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbiIXDyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 23:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbiIXDyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 23:54:53 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C213417E1E
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 20:54:51 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id c7so1880241pgt.11
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 20:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=mZ4zHScYEl2S9xr+q6hzdXz+QEP9z93rsSuz8L8LQGI=;
        b=3St0GIQ6MnFKjT4yTX7BZufygaqUEtLT3em+MKTc4kIzB9utgnNRLrKQdiIhSiErUd
         LFR/8hB7D9VmTrYYM0IT150T4u/Amjb/bxboZWq8pan2BWYgoMX3kJVsdsCHCc2ftTpL
         Jea7dNturpXPZs0lk1fiBB3z+pDiF0p981NABkcfI9Xb2xiWix3rMGnUJwrsyxy04PfR
         pmi5eYAaBexegy7HsBJLGXjSaKTbWFkUqnuvK9faOVp2CUuknoZoz1T1EDoy1PR8n9my
         R7cmktQ3rD7nSOy1cF9Cl4KDAga4iIzY9Zb2EqfSu1Hbh8htk7sFsBfE2k+qT4wVGnVO
         m86Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=mZ4zHScYEl2S9xr+q6hzdXz+QEP9z93rsSuz8L8LQGI=;
        b=pD8tFzYPernlmSxxK1VIvBzcVyMqyZPxlzRuNNRx7Z9AykbqvV0lp2dWafZMzZ4QIQ
         sFug/O0Rf05RnNVfpgBxck3+0M57ibBjGIcDvXkzsRGigM67BCStHO2s5jTF4t1GH1kw
         Kg+rBbt7QD3TmpQ+T+c6OCU/oePzPH951DCxyx4WeNJNsZe/h6ZUY0gNM7UJiyzGgfI7
         XXJVEm4VAYbtKwTUQBJTufoY4HpuhoRWK+dza90WgPpXLvEK8ni1dU4eNGtl8Mt8zNim
         jqUNXwHP6TqYRhpDl3r8Rl7E/wdb72IX59fU03OcKM6ytryOJKXNYWTwpnYgMtNkryVE
         TlaQ==
X-Gm-Message-State: ACrzQf2ed92Goz6vMUvnZtsXwZdLL6ooO48yZf06ziuBATWeA/4aPe1j
        03T8eY3DleK42s+1KVx6SaOimPQTHDM4Nxt7VXU=
X-Google-Smtp-Source: AMsMyM4iNiMeKoTotic35mIdc27FEdHY0Yx/5lnGQw2a+5EtKONA6gGcSQYHT5ZJYRQH0iFdgkDXwg==
X-Received: by 2002:a62:17d1:0:b0:54d:87d5:249e with SMTP id 200-20020a6217d1000000b0054d87d5249emr12423649pfx.14.1663991691141;
        Fri, 23 Sep 2022 20:54:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p5-20020a170902780500b0016f975be2e7sm6782284pll.139.2022.09.23.20.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 20:54:50 -0700 (PDT)
Message-ID: <632e7f8a.170a0220.d6d6b.da29@mx.google.com>
Date:   Fri, 23 Sep 2022 20:54:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.70-41-g1024d01821c1c
Subject: stable-rc/queue/5.15 baseline: 141 runs,
 2 regressions (v5.15.70-41-g1024d01821c1c)
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

stable-rc/queue/5.15 baseline: 141 runs, 2 regressions (v5.15.70-41-g1024d0=
1821c1c)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =

panda     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.70-41-g1024d01821c1c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.70-41-g1024d01821c1c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1024d01821c1c95d87757806c5b79507ea3203e5 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/632e4f3e9204e5e6d0355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
41-g1024d01821c1c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
41-g1024d01821c1c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632e4f3e9204e5e6d0355=
65a
        failing since 2 days (last pass: v5.15.69-17-g7d846e6eef7f, first f=
ail: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
panda     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/632e4f6f5d0ca8c2bf355694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
41-g1024d01821c1c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
41-g1024d01821c1c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632e4f6f5d0ca8c2bf355=
695
        failing since 31 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20
