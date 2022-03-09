Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE6E4D2750
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 05:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiCIBQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 20:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiCIBQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 20:16:23 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F57175826
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 17:06:02 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id t5so884769pfg.4
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 17:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8xnE4XcC2bo4psRN3O4rMpq/54Uc3JZzjKJYFo0Daik=;
        b=u65QQxCP106uRqxrhFqzoOPcMANyPLQfGU425ngKMfWC8bcfp3QZehVfThj+rLox5W
         VuOWEEt26fmJjmlWrqGhse/pOpd3rQdCbrxoTazHrgEYDARq/7vLX4SFXgUBC0Vr7z1J
         2bK+j7sIhSD5E13YTe4qq/AaqUKgc538xvUeUFfPK8SjwUfi01iWBwdMkE0IIiciP6Ex
         XaQapCnzHWanj4Qhd6vyk8o26O3E7+kM/DIC3DXve+DJfmRAYZKw5uc4l9PQXguJ7VPQ
         LD5Svv1cyEPh3zFygkISeQh8/7b9G2hHc58HFkto4cga7ujjN3CEogwrnB7vUL+3NWGH
         eLsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8xnE4XcC2bo4psRN3O4rMpq/54Uc3JZzjKJYFo0Daik=;
        b=2Mzyw/FuFqsmPCxSLbGUt/8R9VDF0Bw7hkR4Y3CmhtZMdNMZi398q1WSx6ZguYM8xS
         APh/sFC7dc5oFI+t56o4TTORT7X0qCCOHjFyHSPUiP+Bw6gp9mRYpT7ff/I3ThN4PD+v
         aeRGLBPzOL3e5VtISzNuuMu0RCgNpp/mDaGyg2Z/q4Q5G0+Fpjf+WCtUYOqxDtAryfXp
         jDy6xXZHTFRorgDecT8Qz2yZl0d33cbiMV+PxTmO+EYDyZU9Gcf2a6bcUUR52x/YsykM
         UhjK78jpe5X80fGOUicOCqddxD4iBIZvFmtPBT/kLOYUz2KENowvKWnSD5CSz0Ztg+FQ
         5J4g==
X-Gm-Message-State: AOAM532VZRGXsgWLcVYcP6TlycL16USEhyGayFf00wpdaXxPa/2Sflru
        S7+0MhFPyYVkpVTitI4gWFivE3fgHkcMaX68TUw=
X-Google-Smtp-Source: ABdhPJyR54RjU8cdF96bSYJaQBCIsCDf45eCZiCGrFGhPBLyJ9o0jH0MJdZpIGJfnSeoxrEgu47Whw==
X-Received: by 2002:a63:1d56:0:b0:380:437a:be68 with SMTP id d22-20020a631d56000000b00380437abe68mr10896348pgm.208.1646787961600;
        Tue, 08 Mar 2022 17:06:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g10-20020a056a001a0a00b004f7454e4f63sm298359pfv.189.2022.03.08.17.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 17:06:01 -0800 (PST)
Message-ID: <6227fd79.1c69fb81.e9421.14a7@mx.google.com>
Date:   Tue, 08 Mar 2022 17:06:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.270
Subject: stable/linux-4.14.y baseline: 67 runs, 1 regressions (v4.14.270)
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

stable/linux-4.14.y baseline: 67 runs, 1 regressions (v4.14.270)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.270/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.270
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c9fcc1545c3bb19f4e04b1c82bf5c2856fef39bd =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6227cb0433410dd994c62978

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.270/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.270/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6227cb0433410dd994c62=
979
        failing since 20 days (last pass: v4.14.266, first fail: v4.14.267) =

 =20
