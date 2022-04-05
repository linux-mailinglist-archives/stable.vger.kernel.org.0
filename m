Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B524F47EA
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347580AbiDEVXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443810AbiDEPkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 11:40:19 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90D733E96
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 06:59:55 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x31so12148674pfh.9
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 06:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QuaS+gKiUCS73GqNCV6Jog2wIQT/XvwhsSoTzwAs+Ww=;
        b=4APYu5wXv1zqHn0Li2AKWfzTNRt2oxgFSKrZaTXaFi7V/Jg9LnOAFYt66RMO0co4f1
         Hsu0GHetr0j0rSWiO8RdOaR+puFB9kt1eVE+S7KG5qAX6/l6tIyks7JW8FCUJjJJDlT4
         8Hogmgaw4cDKaTVXb7uVS2KUNc35FcAFtyYUErYSZ6AkZQDAWZbreSmA87jovV2sVadG
         MqfZkga2PwcjQUlBxn3ycoUQ5MuaBPbMN3kPEE+pnErhpB3Q/8OSfJmfHz5AbC1k0y+A
         T75dSGZW//inCYhRH5cHErYg3tbeLcVLMWzk7EYzv1GycDZkd7/NeRawy1gvcghszjL8
         guvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QuaS+gKiUCS73GqNCV6Jog2wIQT/XvwhsSoTzwAs+Ww=;
        b=m2A0qjL6QSDkXzUjjyr8YmgyBAgX75CYiAE3OJhaB5Ru2u1ziTHVFDX0JqZC3JVbz9
         h46ZHBjOzYwMNctNAd+fyXTYhKNsc9PGdeDGskON2QWeyWgEmg+owYthfBQgt5zsASg5
         EL58AZiRtN2FrCRBDKa2/z8WWkXpuF5PpWi7eN4w6C7whwrNNF89sph6BLgBdPvPqp+P
         l2vYQVIVPz6iV8RjkrCijXQr9Nom8oMTZzcmMw5UTpezQRhPYNYQ6Qh5L/cKW35hL4L2
         Z8Ntmwt3tx7XSyCU3S2rp5n+aCXJGjtThSG2Yj+NcKFQ7hImT1ubPVSh3A1siA5N9mST
         u7Uw==
X-Gm-Message-State: AOAM530ZX9M/okoMjaCCERGIuEVUSo7oyUZpdDn7kJNPcXEVyblQ8m1w
        5Du1OTxKpM0/8TRr+BSlmVSip+pUEi2IRetl1mI=
X-Google-Smtp-Source: ABdhPJwCSb+FEY/DUryPXI/o0GEtrv4SVfKv98xSz+MacXfJRVil2ow40iXhF13qkdG5B5vvx+2Qzw==
X-Received: by 2002:a05:6a00:f93:b0:4fa:dab4:6e2a with SMTP id ct19-20020a056a000f9300b004fadab46e2amr3971550pfb.15.1649167195308;
        Tue, 05 Apr 2022 06:59:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u15-20020a056a00098f00b004faa58d44eesm17358493pfg.145.2022.04.05.06.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:59:54 -0700 (PDT)
Message-ID: <624c4b5a.1c69fb81.bd9c5.c208@mx.google.com>
Date:   Tue, 05 Apr 2022 06:59:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-207-g825eaff5c065
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 40 runs,
 1 regressions (v4.14.275-207-g825eaff5c065)
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

stable-rc/queue/4.14 baseline: 40 runs, 1 regressions (v4.14.275-207-g825ea=
ff5c065)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.275-207-g825eaff5c065/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-207-g825eaff5c065
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      825eaff5c0654e7b933266e964dd0b3efade75d1 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/624c48952973df25bfae0680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-207-g825eaff5c065/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-207-g825eaff5c065/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624c48952973df25bfae0=
681
        failing since 51 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
