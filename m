Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13AA25792A8
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 07:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbiGSFss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 01:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236833AbiGSFsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 01:48:47 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216382F003
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 22:48:46 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id d7-20020a17090a564700b001f209736b89so126545pji.0
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 22:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GyYhk0E/df4qlJw9cakDeuhJXOYU65WeH2iCVxbZt3E=;
        b=73SMBMT111SQFAVKNNIC4A+IWUb/aV2PLsKTC5oUhHslQ6ayYuEQW1wgP7s6ceduxN
         PqczE0FrdXm3KHHnqJSQH6J2W0qCzQ6jZS2+vm+wZLJFR5LaZ8SL5iJmoeXcLKjeVGCT
         GUoscPPVJg//jIedS6YG0NgbMnrpZsx925ZF7rlpi+hrPWSoNzcBUNiByGsc7CcdUr2I
         w9sDB68d64ju/lBjA5/39/GXhwL/GEnN97RUT4ekTI7w+gLVwu1VjJX7MOrKR+aLZddQ
         sKKTldsRFivVGrpBlcOtWPVjz/MM45YXmL0m1Zx2P8D+iF8uXkChelybRrM/3RMlTTTr
         gJhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GyYhk0E/df4qlJw9cakDeuhJXOYU65WeH2iCVxbZt3E=;
        b=5VeqcCj7pJpbaK9y+HhZ0sxIkzozZ1InghleDO46PSnzaeD7emDdpBrz7ly4AbpZO7
         QD9xuqI2Uioh9NzqIsuwj9z1X8wX4OJgjY1yR+7GNuLOYeNfnHWML0Qjbp/H3UA2OYDX
         E3ZyZX5y9vrQ19V99/MWeO4jBn9q70emIokUhtwm9BRfpwPbXQxPupcKkSWJc0nVv4iW
         bkW10RsDt8lYiULpgTCQkODsu9CxTV/LQX+dzxR+iTfAzg9vBrPooByvK4HbyZ9O7Elw
         NXmXkKX+6HpMIVvvxSs3qoR7DBug6UWR56TbImsuhXj17Vam4FryL37qfhW5fiBY1GJR
         R+rA==
X-Gm-Message-State: AJIora97zFg25XXN4HIfHg+tzTlZ9Vhkm2xr+uIuTvZLjN6AHJh2h7g+
        VQNaB5ER8gIfoBuEcsUa9/5mbHq1SzgZMjKE
X-Google-Smtp-Source: AGRyM1v8XOvKlLFtlRi3GbKhmo9eqVpDfefDe8jQUmLsgF76Etl5V0ajjaczUun5gwSEEcpeHUlg3Q==
X-Received: by 2002:a17:90b:4f86:b0:1f0:98d1:764a with SMTP id qe6-20020a17090b4f8600b001f098d1764amr34755035pjb.242.1658209725428;
        Mon, 18 Jul 2022 22:48:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n8-20020a170902e54800b0016b81679c1fsm10652933plf.216.2022.07.18.22.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 22:48:45 -0700 (PDT)
Message-ID: <62d645bd.1c69fb81.52964.fc45@mx.google.com>
Date:   Mon, 18 Jul 2022 22:48:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.12-232-g19fd4a416ec3
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.18.y baseline: 83 runs,
 1 regressions (v5.18.12-232-g19fd4a416ec3)
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

stable-rc/linux-5.18.y baseline: 83 runs, 1 regressions (v5.18.12-232-g19fd=
4a416ec3)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.12-232-g19fd4a416ec3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.12-232-g19fd4a416ec3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      19fd4a416ec344f739d224a7dd49bffede8c9c95 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6255e1b44b8c009a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
2-232-g19fd4a416ec3/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
2-232-g19fd4a416ec3/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6255e1b44b8c009a39=
bce
        failing since 17 days (last pass: v5.18.8, first fail: v5.18.8-7-g2=
c9a64b3a872) =

 =20
