Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463F54C2162
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 02:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiBXBy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 20:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiBXByz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 20:54:55 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01C443EC7
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 17:54:26 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 132so458674pga.5
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 17:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IV73Osbq4fwL/7GaMOTElP3moLjGEgJIVBPF99yRWHw=;
        b=7fBGHFhUKHIYelwd9SIvjfGnhyRkyxVs+jzKth3SKfhbIDbH8un+PbNL9idS8t8uEu
         mheOeOtId0w+sJ3MsPOIV4PKqmrSHEdWKaBBJ3M1KXttXEjfRqJy+5jOwfLCjxsNiewj
         QRGm4XO1O1fULibWJCj3dkZku23pjH4al/2euh0yrEbKw9AnhAcM4xUc2ACH/z0h9nsi
         NIWrYrF4yU8qZ/ELAWRQMuShKSCap3syWM1txt4+Gjig2v/xix7MOT3C///UkrRkhUg4
         H2ui4ONMqKjSe4kTsW9RykkqcLfqAVU7YJu94wcL5KP2DQuRmUH9vnd7VuOS6ihwUtaP
         wKGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IV73Osbq4fwL/7GaMOTElP3moLjGEgJIVBPF99yRWHw=;
        b=pqv6kL+/YqVsEjZl0Q641ajxLL9douwWmtZzxY4DZHVTKIZOn16JhLHc2OiAjpSN3x
         KLuBUYd6sITY9JiXra0uyqXPsOW+GeoNe7l1xQMmbKiaf1dUBnG7iQZMEeAh8fE4VFvc
         8PCoMSivuEHkpUhM0oqfHrpesvFFKaFxb0+jp2MeJJjUS+5FXc/sNS+aErSLcBhF5ePi
         9GSScJfj782ErJOM4F+Cr5RpdBafN6h34qmtbY43L5+lX3hfaMR8+bANXN82QKu0XxXe
         OWD+x9Gw0Q8DUsnKDQL/v+o3h0zYaud65sG06IW+6SN7vwGMJr6nSLq0E8XjT89gbkkN
         0LVg==
X-Gm-Message-State: AOAM532NHmz/m19s2ZM2ObpcezFqAsLjIn/xxNVflj4YYqgO0188G1ma
        ycTMZ65yFHu+wD4z5biYrKrD39Y+Q1QKtPT2cKk=
X-Google-Smtp-Source: ABdhPJxsqPdz9INMlymOFfU3C0mSxrRfWNFUJI24hZw1hhserHSmXTrOooSPmHNgyHu9bc1Al/0DSA==
X-Received: by 2002:a63:a17:0:b0:364:9963:851f with SMTP id 23-20020a630a17000000b003649963851fmr511125pgk.402.1645667661507;
        Wed, 23 Feb 2022 17:54:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b10sm683027pjo.55.2022.02.23.17.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 17:54:21 -0800 (PST)
Message-ID: <6216e54d.1c69fb81.c9d26.2fd1@mx.google.com>
Date:   Wed, 23 Feb 2022 17:54:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.268
Subject: stable-rc/linux-4.14.y baseline: 75 runs, 2 regressions (v4.14.268)
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

stable-rc/linux-4.14.y baseline: 75 runs, 2 regressions (v4.14.268)

Regressions Summary
-------------------

platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
meson8b-odroidc1 | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  | =
1          =

panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.268/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.268
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa33f9094f36943ea32f7fbe323293b62e96151d =



Test Regressions
---------------- =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
meson8b-odroidc1 | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  | =
1          =


  Details:     https://kernelci.org/test/plan/id/6216b0bd1871fde1f4c629c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
68/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
68/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6216b0bd1871fde1f4c62=
9ca
        failing since 9 days (last pass: v4.14.266, first fail: v4.14.266-4=
5-gce409501ca5f) =

 =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6216af9c8b49e53230c62993

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
68/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
68/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6216af9d8b49e53=
230c62996
        failing since 13 days (last pass: v4.14.264-70-g1d3edcc1650d, first=
 fail: v4.14.264-74-g11dfe0b41849)
        2 lines

    2022-02-23T22:05:00.739434  [   20.178222] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-23T22:05:00.781348  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2022-02-23T22:05:00.790377  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
