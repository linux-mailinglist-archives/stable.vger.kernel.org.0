Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6DBC53D3D7
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 01:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348428AbiFCXXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 19:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbiFCXXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 19:23:19 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAFF1D0EA
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 16:23:16 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso8199914pjg.0
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 16:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8RF33PcAhHcChWh9Gv/KsHnjKCQLyRVEOK+AwGH37dQ=;
        b=g6PFm8LLVn3Z0USMb65ITNKpNRxkQP4N0IQLxJ71uk1sk2t8d89modBkAAHxgngUVe
         Pkp5mXvJPWDyFLWgTtJwYZs2shPZVvL40kmxgn9Sxr0M19LATXmC/bEkgWxfLmyYyjEv
         eQuXWQ8ANr1+p1N+sjzOQmji6mMNIFnwDOhyKduXQ9GkzSEeGOh34PnKPEqCYNLyNx34
         CsVs5IzOwsmLffx8+CiWf5weEZOR+bA7Sqz2XlA4QEl3XoYpR+a7iUhK6W11HLjx3zH4
         GacHiPlvbdVOj+srxU8DJim3YycTrxet9WSf0PMXHhpkckQ/gzY5ZUidx8TJ2oeJcz76
         4iHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8RF33PcAhHcChWh9Gv/KsHnjKCQLyRVEOK+AwGH37dQ=;
        b=J8cMBJbcTO+M7seIejAPWH1Kb9jp9jfAX2VP2w01wYSvtCaVrs0C/AwrVCLDa2TTDX
         bO/c6xvmYxPdOH5uwVCFhMy3v9VzDXpPQrJWPltLjLe5YIjmv1mdO9bol8kcB8gT13n7
         tSJYg9MzxNsNN83rNf8/iPpX1MtfDFbnXrssXz42b+MlP5jSbIs86/gPdKT3C4N/uC2r
         8/etvS7m9VzufrK+oIuphBVFRF9KNXkYmtmjHosfyJtyjU4FRuLcKPb3ESb7AOngXT56
         b/e0wo1K6gicJlLiigLnyqDTC5x4262Va+OGeieKytmxjzCCMQfYMGV7HdKtHJ3DCtAf
         GWog==
X-Gm-Message-State: AOAM533Pdnz3ICU6H+KSCaX7XPQwOTDMBzqsoAG7rxY0Es8HVT+lecX9
        tpShvSP62SWAohUfcH3YAIaXgtPoQxqr3IMQ
X-Google-Smtp-Source: ABdhPJw1yODpG7rr3gNUJy53M/MtC7cCa0Prb19tivOynnFHucWR4tZUfT2E08cgarJDyvxXiG5Z2A==
X-Received: by 2002:a17:902:f545:b0:163:d698:7f19 with SMTP id h5-20020a170902f54500b00163d6987f19mr12426656plf.119.1654298595820;
        Fri, 03 Jun 2022 16:23:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j12-20020a17090a840c00b001dfffd861cbsm8194293pjn.21.2022.06.03.16.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 16:23:15 -0700 (PDT)
Message-ID: <629a97e3.1c69fb81.bdaad.3a43@mx.google.com>
Date:   Fri, 03 Jun 2022 16:23:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18-115-g89d85a0fba390
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 156 runs,
 1 regressions (v5.18-115-g89d85a0fba390)
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

stable-rc/queue/5.18 baseline: 156 runs, 1 regressions (v5.18-115-g89d85a0f=
ba390)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18-115-g89d85a0fba390/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18-115-g89d85a0fba390
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      89d85a0fba3907521a483992a12077ccce787172 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/629a63f48b62e84681a39c12

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18-115=
-g89d85a0fba390/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18-115=
-g89d85a0fba390/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a63f48b62e84681a39=
c13
        failing since 4 days (last pass: v5.18-1-g7350d3c1f391, first fail:=
 v5.18-47-gb47941e220af) =

 =20
