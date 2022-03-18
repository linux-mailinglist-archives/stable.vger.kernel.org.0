Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1094DE465
	for <lists+stable@lfdr.de>; Sat, 19 Mar 2022 00:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241439AbiCRXD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 19:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234425AbiCRXD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 19:03:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884E730DC4C
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 16:02:37 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id bx5so8533084pjb.3
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 16:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tAao4zP5uqCxAqt8yNF3m9YnnZrO1mPNf0Li8uW1LSY=;
        b=5e+XsLnHW5/Vjfxx1/CNvzke1obrxFX28L12s/zQBn/0xGCMo1QJiMeYpBNITojn2D
         vS9Euy0zjvDXLkbaNWVAFtcHEjyM3yywg85WU/60cMVz1ZzkkIC7Ol2s/4S93wbOaRL6
         zDKcpGBkvI0ys626tJljoPDbYCIi6/PLuiub8SbsqX7Lr1grzRLZdOpD7tHIvrH0Wy++
         yC9zKgAPdkcMO+tAKfrfztvIJN+RYzcMVDFlEyDI9IeJ+9iYQNeSV2/XhVjhtGojhyHw
         ITCWD0ptuT8RAMvzNZh/vl2gHGPtwG9mUqqPdxxjclVvHtx6TzZFrhifKBvRDoZsnH6V
         oDZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tAao4zP5uqCxAqt8yNF3m9YnnZrO1mPNf0Li8uW1LSY=;
        b=BB9CeEDMAVgLjQZAtCSjBkKLdNh/7cjcPM4Q0Io6K2H8N7YKYkTsZn6HulKCsb99oL
         WKw/J4dsh3xbQDuW4U4Tu41K8sV+7/9Y8Ckkujh1slwOv1C1D4CY08k1p0hQqLe/z1zl
         gDufMKhnywbSDBPcf/fKyZAJMlgDBSutx4lLVzmGMxl4rVMW9qZtyMs6A5F8CHg38ssY
         TVLVj+Ss7wn1C3ul7ypTwKkuwlQNkUK7bcDDVr2Hdoj+WwgMBHdqBu39yGBo/Lsei1py
         oD7WkjuRwlvbZvLtdqCfXUWg4U9mVSnQF/6eH90IyvA1SAY7AA1c25kv2tL/D6yRXOgJ
         QmhQ==
X-Gm-Message-State: AOAM530kGCUcnxUDF35l8Mvwrf3wT25O9qHUtTvfQV/PhosD8Up9ktLN
        cW0tYjkJJfhFdpEv2/+UAtBEMjYfcla3ij3kJtg=
X-Google-Smtp-Source: ABdhPJzuY3aQwKATUskAw/A8W8iGQ+Az98N0Z1l0huNKeNPpKBYnseL+EpeqpnbsJykT0hSqfN9qsg==
X-Received: by 2002:a17:90a:db12:b0:1be:eb72:a63b with SMTP id g18-20020a17090adb1200b001beeb72a63bmr24558155pjv.94.1647644556840;
        Fri, 18 Mar 2022 16:02:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e16-20020aa78c50000000b004f76c255e92sm10038545pfd.101.2022.03.18.16.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 16:02:36 -0700 (PDT)
Message-ID: <62350f8c.1c69fb81.49d07.c358@mx.google.com>
Date:   Fri, 18 Mar 2022 16:02:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.272-13-g7a5a577ee1579
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 55 runs,
 1 regressions (v4.14.272-13-g7a5a577ee1579)
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

stable-rc/queue/4.14 baseline: 55 runs, 1 regressions (v4.14.272-13-g7a5a57=
7ee1579)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.272-13-g7a5a577ee1579/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.272-13-g7a5a577ee1579
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7a5a577ee157914c0492337dfe488c3ba326d544 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6234d793a97b33726cf8006c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.272=
-13-g7a5a577ee1579/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.272=
-13-g7a5a577ee1579/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6234d793a97b33726cf80=
06d
        failing since 33 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
