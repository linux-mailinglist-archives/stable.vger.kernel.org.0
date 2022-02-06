Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E164AAD8F
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 03:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiBFCty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 21:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiBFCtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 21:49:53 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8F4C043186
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 18:49:53 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so9919692pjb.5
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 18:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7tyZhVacRZce+vEC/4Dy0BuR99794IG/XEiBpngxJfA=;
        b=KSuBUWuSK4ECK7Vd+lRb/rYtWhEoWqOWJpZCTecBgji0AKm+bH7bable/J7+pLXr2/
         qHNFiW6FOMM4VrJLmWtM9qqgQe7/5ry0KpUwiszPsAu5Dk795Uh6QNopFIQ5+8uWIEWD
         ka9wIVjxxG8DzkOqaV0zjgH3L44HqFexAHjnst74uvG66xmcCPZnyrbVjCb89EhdXn9W
         t+2tyYM+dQYnMnUCTBqeanxUaTI3fQh5NtmK2tbmHsSKh1hpZ8kMRtJCswpODY7v6Xj8
         ozFo1KBbpuiQx+PYyj6hqvMo3tQa//4cCnER2sAjNJ4j9lcFmUjnvhx8rQsx/sJ9WAqD
         Fcuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7tyZhVacRZce+vEC/4Dy0BuR99794IG/XEiBpngxJfA=;
        b=qNw9vs1jndYXYPVgOEF1D1+4pSmPSb3pU3cJMOFYdqiprduPDkjf1+MNlWBluVmDGr
         PUCWbn/g/iI2xZ8Ig9v5Z7Pmu1hHxDtJOXIf6+6J8M1u0dEYbb35Ycs99ImCuwDw8OLI
         MbNfVGJAhKELIatbaxCC1317+w5jhzgIo1NiVZ2gh4bPDUE0N3tqq8HtnPBu8p/T7Mgw
         RB5Ws2xIRdg7zr1HzJFLMbfcrf+ZvuzcbVbzIf9YPpuxOaTaJQs4QPx22m+fHVdZt/YU
         3z8objr/o4x+OSW4JVZC2dUZMOAXtC3lwx7LRusMmFy1b8B5Bqc5GAQgL249sjr7m3vx
         no6g==
X-Gm-Message-State: AOAM5320S3Y8voRC51c7yyRFvCIOb4u1mHj/9xx+GnncrJ9LAh5ePmUh
        zZs0CZ6ZcQNkrI6keC53ZM7G94MSJ4/L/uOw
X-Google-Smtp-Source: ABdhPJwHQPMka9Esm3Lja2/sK/26aMnaGhJqy2FtayE6KiBK70n7iwSiAGDJvUM21NP4ZKZ6cf75HA==
X-Received: by 2002:a17:90a:6a0a:: with SMTP id t10mr6905197pjj.227.1644115792525;
        Sat, 05 Feb 2022 18:49:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e19sm4496838pjr.50.2022.02.05.18.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 18:49:52 -0800 (PST)
Message-ID: <61ff3750.1c69fb81.5f9d5.bb4a@mx.google.com>
Date:   Sat, 05 Feb 2022 18:49:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.227
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 203 runs, 2 regressions (v4.19.227)
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

stable-rc/linux-4.19.y baseline: 203 runs, 2 regressions (v4.19.227)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
panda             | arm  | lab-collabora | gcc-10   | omap2plus_defconfig |=
 1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig     |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.227/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.227
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f4b1bd6d9c2e2818ad1ef2483471c8b9a5c0a01c =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
panda             | arm  | lab-collabora | gcc-10   | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61f56e36e638256fd4abbd23

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
27/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
27/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f56e36e638256=
fd4abbd29
        failing since 3 days (last pass: v4.19.227, first fail: v4.19.227-4=
7-g0366c2cb37a1)
        2 lines

    2022-02-05T22:36:02.725056  <8>[   21.024108] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-05T22:36:02.769335  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/111
    2022-02-05T22:36:02.778799  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig     |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61f5b24463bc55bd2aabbd1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
27/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
27/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f5b24463bc55bd2aabb=
d1c
        new failure (last pass: v4.19.227-47-g86004a50cfe5) =

 =20
