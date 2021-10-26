Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516D143AA94
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 05:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhJZDC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 23:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhJZDCX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 23:02:23 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6283C061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 20:00:00 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id m21so12645814pgu.13
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 20:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3cccqcb1Q5q6ILUVO35cQIYWdsuLSsu51gbp4ivZoPA=;
        b=MeY7XbFvLpCL7FTOW1WTj9DsP/+qI9PH9bgZRnWT0M1vAhDaK78XVepsJqHOsavH5O
         1UAjniEQW95Vpc1CeSmfUEgW2LBWKiWo6LF//zMKRFiDa05vIOmSSniWIfCuuEntvP36
         8UtjjMVilHPgTUjJd+Fg4mtEsMVArQGjA7CUVxYp0KLlI1UQIofrn4tG6E+53+vztuY8
         xYVN87ovs3MTBq8oGhb5VKuHXKlzpQZYRzXm0Fl0REUVSxlJonbK1pNs2BfzhNaIe7O7
         HGdzKn7rdABuDHYuhVoYXuPlg5q370YCMIaeKM+8xURSWaNiUQ+4kcGZuBoJmvSCWzso
         v/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3cccqcb1Q5q6ILUVO35cQIYWdsuLSsu51gbp4ivZoPA=;
        b=rdJQjdSqdc8NVZFcIhBCrRMZ92uKcnPlTaJLXtv1vWO33SDoeucI1OgySM5LfoX7E0
         GhR5n82jiQVu0jjF7bbJ7RjAPx4DPqfvxeBWnCS6NP2Bd7rShMo4e33L3W9fbFTMUzPz
         2ml1JFUb4is1tWdwh/kz2ljJaAs5bPPj8dasQEZmRy1socnBnnvX+E7HM6zjeqogVf4p
         9wTYE8CG1isLfoQe4e0RQ+APXPUG6RGMUzWBcJeK2eGD5Pu/HGWc1Q/hkA/j7Y7AMAAr
         jWwdCA1RLo3YTvIW5YITuOStttCosNOR3PJ7Yy+lE3MvbhGcltcrl7Q6tSvlN/goqoK8
         mxwQ==
X-Gm-Message-State: AOAM532dY+XWUrSipuhzbixYYvfyQuUr3Ub8y2SxTVM3D3fbT6RvCFa9
        C1Dq1icOQUd59b8dvvGERghxCL1mX1pfgoIb
X-Google-Smtp-Source: ABdhPJzKO+dFHungpaYG/jzoj9tsddeIgWdYPNRtiUuYW4Ak52wztZ83HEA9daAgpKG2cjieNQRYCQ==
X-Received: by 2002:aa7:9ad8:0:b0:44d:24d0:3ddf with SMTP id x24-20020aa79ad8000000b0044d24d03ddfmr22853251pfp.29.1635217200054;
        Mon, 25 Oct 2021 20:00:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e1sm18335358pgi.43.2021.10.25.19.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 19:59:59 -0700 (PDT)
Message-ID: <61776f2f.1c69fb81.a7a78.1324@mx.google.com>
Date:   Mon, 25 Oct 2021 19:59:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.213-38-ge9434cadcff7
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 96 runs,
 1 regressions (v4.19.213-38-ge9434cadcff7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 96 runs, 1 regressions (v4.19.213-38-ge943=
4cadcff7)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.213-38-ge9434cadcff7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.213-38-ge9434cadcff7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e9434cadcff7c1dce4bcc8c599149f87f266e486 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61773c25380ebfaee8335901

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
13-38-ge9434cadcff7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
13-38-ge9434cadcff7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61773c25380ebfa=
ee8335904
        new failure (last pass: v4.19.213-34-g375756b16342)
        2 lines

    2021-10-25T23:21:55.893495  <8>[   21.120788] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-25T23:21:55.937989  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2021-10-25T23:21:55.948570  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
