Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2BA5F9D93
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 13:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiJJL2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 07:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbiJJL2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 07:28:01 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2C66E8A5
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 04:27:59 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n7so10141539plp.1
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 04:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bnyCcZqTv+jl/XDG2yye6Wy7em83XxY7D1d2Om8C8Vo=;
        b=31joynfHS5icpySiM6bjhXQPF5FPA78EzfWsPcEdc7vfCHRZ/BlIOGrp0nJrV+QNyg
         kWJKv27rE2FH7FLlyNDkFTALoVZrnkAiLhTrmFjCCoGwg/l0EtO+k2/XRxHgg42KqgnY
         odN69Cv3/zVzCSdIu7Tn2RaEF6K7jBb9fdYRpO4Ya5w10CoG1N7VeAG5SJmTRsBd6DUz
         2mTeNnjFm+jVPgG39qV7SoiB7h2StpSUe3r2DylSXGDVRrfC7LbmP16WNA5KvI35GRd5
         f70nu9lqIQvO5hFAxrHncXQ8SNrPC2H9dw5G44CEdBvgZQhmP2FMxf/f4N1NwajgOOhy
         pD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bnyCcZqTv+jl/XDG2yye6Wy7em83XxY7D1d2Om8C8Vo=;
        b=WLoLg0fIDkGmNCA0zS5DWhREmik+oYUGo34WyiwCTzKRtAMJgoSAsLNnVZLlAbfzXR
         qEJdp6hVVNl8yi8841hx+yJjrF1EvomQDal0/XMrbJIWspDlAU8Jc6FvSaMVob9MMWqH
         ERwHTQ4/fR2biCa5MDVTq4CAJ4IZ2WabJy8XK6f9Wi1B6hKOYoF832L9f+A/3SeaqWUj
         473Noj+DB+NRdC7WCB2QaAZV+6EgpCSRUmFdnCrtT/hZJZIYOV5PbgNMJoJeaK+KluqD
         dr7FIR20Bs0d2ILtSPo2w1rm641wKYhK4uK0U2LDuzorO0BkhKMaWElS4tQ09HzK84l/
         0fVw==
X-Gm-Message-State: ACrzQf29CcCiPbIGpz29VJwCbtKr6ZqGvy9ZN15Iwg6GY3Rea+Tv9s1C
        YMHmIMIFHIhPgir5jFsOTUicsQTq/pzaYgtLock=
X-Google-Smtp-Source: AMsMyM51qCtW4xjTtD7oUuiviLNOKC7nW14FVOFPbnY2DJXGqxkzvuTzc8nd1+DeK4z6p84s+RTzgQ==
X-Received: by 2002:a17:903:2686:b0:17e:f177:3ec with SMTP id jf6-20020a170903268600b0017ef17703ecmr18753895plb.71.1665401278441;
        Mon, 10 Oct 2022 04:27:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e187-20020a621ec4000000b00562cfc80864sm5973930pfe.36.2022.10.10.04.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 04:27:58 -0700 (PDT)
Message-ID: <634401be.620a0220.86161.96ae@mx.google.com>
Date:   Mon, 10 Oct 2022 04:27:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.295-37-g30c76a7f0bd1e
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 99 runs,
 1 regressions (v4.14.295-37-g30c76a7f0bd1e)
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

stable-rc/linux-4.14.y baseline: 99 runs, 1 regressions (v4.14.295-37-g30c7=
6a7f0bd1e)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.295-37-g30c76a7f0bd1e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.295-37-g30c76a7f0bd1e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      30c76a7f0bd1e0cd712263293c973f5db619f86e =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6343d1103c82281557cab624

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
95-37-g30c76a7f0bd1e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-me=
son8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
95-37-g30c76a7f0bd1e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-me=
son8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343d1113c82281557cab=
625
        failing since 237 days (last pass: v4.14.266, first fail: v4.14.266=
-45-gce409501ca5f) =

 =20
