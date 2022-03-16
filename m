Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069D14DB1C4
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 14:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354428AbiCPNpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 09:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243808AbiCPNpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 09:45:16 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751A15DA5D
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 06:44:01 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id z16so3986857pfh.3
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 06:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lb0GrUwGTocOr/eqx34o6vGpQeDMdspl6F6guDte4X8=;
        b=fEBW6LtXNQ0i097fOfyp2lP4oITlVZl+T7sUIEHWePTUu7aLy9RG37fyO6ZlXDPrKJ
         lpT8Ee+YIXv6ZyfrHosmRVLBLv21otKWQxmldl2CP56tKzZvg7nXIgA9vE8VoYnhQVJc
         sZKtc32PHiVZR9Ro63kiVBhj7xMfcVSQCmwc/Dfch+ONcLJ91ZRPZ+ipiZYujD3HYNPc
         uGdn1SoxWJMTunBs4fMek3F/aVj23NdCv138tOgB7q5v13Nfbg9B622/46PiWms6zsWB
         bpZbwlYuzcDhBLRX8LBXheZ8sWyu7rqwPQrmosQayQthOxglhVlLeLfMb5L6dpaGI8Qe
         pexw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lb0GrUwGTocOr/eqx34o6vGpQeDMdspl6F6guDte4X8=;
        b=J4TGdOo+oz6KD/ztuDUTLb+2kP5k8Jd1+/Dzo8bwe3mKEWXGOALUHLoT9yka5q0vN5
         ujtQgKVzcxA/WWBvHdJ74AAv3a6Mo0LHtWgtwdxhjfWKYDspnN/70b8OZul+OHrAukkx
         iM0Qtz9z5O1aWeI5OOUhM5N5EtikZ8RuDXG6A6Ept5wBA0252jIh09xWW3EUL69XMaNS
         shxJxylVDigsp8sAYji23y7YeEI0JrPLMW10q0PIYKvLn+1oEInkZ8EtEyq/kANmC16D
         7NFm/Mqmf3m5egn7qPQsXUGMSIaQe5xAgzNqxIbipfXdPYKVs7vFByeMR5YJF052RDu6
         IjIw==
X-Gm-Message-State: AOAM530fa7gKEHK540U1fdEUldJYDF9N3Fcw/nfpIaZXTfRQTqm7hjnY
        kPUuFoPEV0PHDqZIKPhkis6Oy1KzN7uZvGwsevE=
X-Google-Smtp-Source: ABdhPJzWFu7CK0cn4rcXa6f/2ao9AqJ65hgYYLkPWvkIqrvniQyHkpK2cU2nZF2nqhdOkzySZQ9tTw==
X-Received: by 2002:a05:6a00:23cb:b0:4f7:872d:86eb with SMTP id g11-20020a056a0023cb00b004f7872d86ebmr28723786pfc.37.1647438239773;
        Wed, 16 Mar 2022 06:43:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gt3-20020a17090af2c300b001bfb198a8ffsm2632068pjb.2.2022.03.16.06.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 06:43:59 -0700 (PDT)
Message-ID: <6231e99f.1c69fb81.17540.5fe6@mx.google.com>
Date:   Wed, 16 Mar 2022 06:43:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.271-22-gae3818ac7d96
Subject: stable-rc/queue/4.14 baseline: 67 runs,
 1 regressions (v4.14.271-22-gae3818ac7d96)
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

stable-rc/queue/4.14 baseline: 67 runs, 1 regressions (v4.14.271-22-gae3818=
ac7d96)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.271-22-gae3818ac7d96/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.271-22-gae3818ac7d96
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae3818ac7d96bb99341b4c9d6afe0b7142dc425a =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6231b7c1c01155daf1c6298d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.271=
-22-gae3818ac7d96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.271=
-22-gae3818ac7d96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6231b7c1c01155daf1c62=
98e
        failing since 31 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
