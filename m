Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259BE4CE079
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 23:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiCDW4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 17:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiCDW4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 17:56:15 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A563922FD94
        for <stable@vger.kernel.org>; Fri,  4 Mar 2022 14:55:25 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id t187so4384899pgb.1
        for <stable@vger.kernel.org>; Fri, 04 Mar 2022 14:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d7IYT69W69D6ZemvHrpvS0qSLOUttNKa1eJ+Bn18aoo=;
        b=X0SQ8UNL1xXNZlFiO3g4naU9fvVDmaEylZElR87Gs8ouUxBJbR0W01DwJwZ3JyY2KY
         XeD6IXsqE7JFVQx3KfmTYiUKcAjYnyfY4lIG88XFTSezgRR7hRwmLEA6gdhgPhIwNpTd
         eYVq8fgt4rB+z6N2AjcYecsoIR931DM6pHm/IjyOgzDVsYS7tTE2l8snNONsPjR8uyWs
         pGuyMmDXDfl98lkjJDx8n0PkmLrtSbiJLKH9M2WEKIQ73Q6rpZITUbWEbTpdfNbzQaak
         2i8hK+wZLS4BmQWHyb0wTM72+KC6Rq6gWrr+PUhANVa4oWiTjO7QavQVcDl861/DSsl6
         icjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d7IYT69W69D6ZemvHrpvS0qSLOUttNKa1eJ+Bn18aoo=;
        b=pKuJl1VbLQv5YmUM1locKl5xAYM2WeEAYoXrHNqzllmUPfkXTZBVoQkEhCZkZEMIIT
         u/Vt3d3FLf7exqtoQn3nelOxEtNrJBjf8+Ns2DIzp58j+ZrN30BKLvb4wTBUOO0vxdgJ
         0EWibWTteH50Tvn+pfKA0WWVaWQWMGZarTUvBL3OU+ixDOGzRyEcu7C0OXGotK1qsOv2
         DY0ENm6RtSCiLh/wcrUS3pPBPRpkoHGYBgfcuNgQdoWpI1Kmr4Z8GZJfZH6RYiOBgilv
         p4TYWiFAgE4pfsJB3+HpPcvXGJqjIuAttNOsThJbLXFC1wxyWAD4bdCXJrB5cLnykkQf
         pDng==
X-Gm-Message-State: AOAM530zX+kZo0BAFMkVQYtMSBkZ7Bwzt0FJ/50sKr8qa/DSTMieAY7K
        bvIwa6WbXLB1WmbWyQbsD//+cj/Fcbc0RtTniDk=
X-Google-Smtp-Source: ABdhPJx3/0gT8/yTi6piXfSMMMfbSbzBYG5ny2ibQ7AIyDh29HqNmtcWILTLU2oQaleFE9+ygdyvRA==
X-Received: by 2002:a63:28d:0:b0:365:8e16:5c19 with SMTP id 135-20020a63028d000000b003658e165c19mr507182pgc.579.1646434524870;
        Fri, 04 Mar 2022 14:55:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i6-20020a639d06000000b0037e47a2eca0sm2049908pgd.40.2022.03.04.14.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 14:55:24 -0800 (PST)
Message-ID: <622298dc.1c69fb81.374bc.51cb@mx.google.com>
Date:   Fri, 04 Mar 2022 14:55:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.269-12-gfbf41359100f
Subject: stable-rc/queue/4.14 baseline: 51 runs,
 1 regressions (v4.14.269-12-gfbf41359100f)
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

stable-rc/queue/4.14 baseline: 51 runs, 1 regressions (v4.14.269-12-gfbf413=
59100f)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.269-12-gfbf41359100f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.269-12-gfbf41359100f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fbf41359100fae49bb585711d4dd9d50948d306d =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6222640a4d620743fcc629aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.269=
-12-gfbf41359100f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.269=
-12-gfbf41359100f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6222640a4d620743fcc62=
9ab
        failing since 19 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
