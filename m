Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511504E33C3
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 00:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiCUXAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 19:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiCUW7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 18:59:08 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E4236A9FC
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 15:46:42 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id w8so13954865pll.10
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 15:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IVs7bY9jjuDys+71oSKU+6LhxjfbCOjbY95iFOlpsoo=;
        b=wFUsbV/AKLBhc5lvF/d+5k2YVhNuT1Uk7MDu9y/YsTTUb2Sws+VO47bSSNBDHeM0i8
         yeUgqr1WlJNJFAR/loG/yixOWiXsQ8dCPf1cq9gXjLqr8FMOAswbPBGNYt+3Z9eiu36x
         dcmAyPuTitY13cBad8X2YmD7sznO/EhcKHO16uVywIGrW204yjHZUlnxb+ovCqOC4oGF
         PbBXxbShQa2dgPzm3+RBbqsiKlyDy2vxVZ698sGo6gMhmGYxu0Q4m4F2p1ZG4gFdJeqC
         /OFf99dvre9EPfWZDVb7hibXCoNK4FxtGR1sG6PaRJ8mzthvxMEqq9ZzH7l/oqqayKP8
         2VCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IVs7bY9jjuDys+71oSKU+6LhxjfbCOjbY95iFOlpsoo=;
        b=E6yVSNm4Tc8U47Kc0NbAHwxG35fvbM4UK9x+g2heX6N9vyC7O8UEYDdO9LpBF1bWXo
         Fc7Wah592quB3bpIPvNGF/DBRW3pceOgQES1wneY9+EzAX+dyapqjawsNDdyTvqkLtq+
         8bJapCBawDoc67o+gsGo8LQ/LMXkrpwZvvzt1ml/dqPbh/ghJ+G1biUNQGu1IlwicRjd
         SBSfxQR0pdFlwlAd77jCj/QedGLT3qGLHbgJ4PPudXVUHQx0PVcc8qPAhWNmY2ckqAoO
         fHWnGKQhk3DNdXqBvi7h8pwoxKLETCr8U7ZsTJi8WckwJgSiVnCV9rPYq4IoBPw2pxpK
         3yeg==
X-Gm-Message-State: AOAM531XTpe8/ryLZiBYrIFeMqH0q/q+oHWPJZTNUhWuB0i5W32o8N6L
        pJ69vEbPtb+8cZYR6vvzqQz5/CiEDyjIqFNXluY=
X-Google-Smtp-Source: ABdhPJzXJLEqEWTLyDm2M+0VPFUrzQtW7gg6diZLVuVThQVDyZ5d8StBy7OL3p0H1d/eGJfrc6Fq6Q==
X-Received: by 2002:a17:903:40c6:b0:154:8512:7f8d with SMTP id t6-20020a17090340c600b0015485127f8dmr323839pld.24.1647902801682;
        Mon, 21 Mar 2022 15:46:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l2-20020a056a0016c200b004f7e3181a41sm21798438pfc.98.2022.03.21.15.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 15:46:41 -0700 (PDT)
Message-ID: <62390051.1c69fb81.1dad1.b369@mx.google.com>
Date:   Mon, 21 Mar 2022 15:46:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.272-22-g46bbabb66e08
Subject: stable-rc/queue/4.14 baseline: 63 runs,
 1 regressions (v4.14.272-22-g46bbabb66e08)
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

stable-rc/queue/4.14 baseline: 63 runs, 1 regressions (v4.14.272-22-g46bbab=
b66e08)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.272-22-g46bbabb66e08/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.272-22-g46bbabb66e08
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      46bbabb66e086deb562e8c208a132413a843139f =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6238cd80bfbcd8f2fc2172f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.272=
-22-g46bbabb66e08/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.272=
-22-g46bbabb66e08/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6238cd80bfbcd8f2fc217=
2f9
        failing since 36 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
