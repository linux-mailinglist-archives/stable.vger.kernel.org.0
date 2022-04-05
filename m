Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F574F47D1
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244478AbiDEVVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453540AbiDEP5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 11:57:00 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E232113E40A
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 08:01:11 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id c15-20020a17090a8d0f00b001c9c81d9648so2924490pjo.2
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 08:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oPUE/0am+IaSVHU+KhM6fPh0OfWuWo5BH5DTqftFQZ0=;
        b=s9IybJXIP2vgkos8Ae41At2AGZWZlH/UKXWEuj1GkBPcEf666oVoiTxlet81ZPNKOt
         AwMCnq0HOmqvyTAcUb05wEV/gRkvutMXEn2M5zU+X1AAzcShVwl2SQbCaxhhzyzHH64j
         qONKfFpxG1+fBA7JPcPQlRJe9l/4eoGoXJKh7bqIR1IlwDXur5XGyiuarUcKRkyBND/t
         niaj1T6W0GFoAv082SSuFAgIqH+YuEOzZ+kHwnwBOfjEFCpiDzCBX+MtJgOjp5tdb3ah
         CUdhPB/PfOeROt8nW8RvCkp9f415tAZSi6p+2xe7R5zYeQKduITUHJHMnq52mb0Uq5gM
         ql4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oPUE/0am+IaSVHU+KhM6fPh0OfWuWo5BH5DTqftFQZ0=;
        b=hhXov0PGX+VhH3+DK7Xs6eG/qJC0Nk7rjmLJ1kFhnzEp8r90KCD9vXEPf0eItbJUL8
         TZezJXAViS3Y4AWnnAXezTLXdCZy3+/11qxTpLVue9cQ0tsQPGR4gFUpmN/ninBR01z0
         YD/uKuFEWxIyZ4/pd8BUXqt8qGrK59USCsbwriuV34MfEV2gqBzgpkE7xVMpj/EstmA5
         /ew85urA8m/QdQqG1UvFp0wjkGW8MgDvJa4GPOcmi1wnf0zlj9fofjlyG/g46U+07ERy
         JDS8mS5jOcDfcKMpVoNsGSI77sg0nXabEpX4EIKUxOfR9TyE7y9hRh67rc0XLJNtbswN
         x52g==
X-Gm-Message-State: AOAM530IsSYKZdHcDCSkI1O8lJbCWftt09jtvkXuZcRAg6I5M3mHuEz6
        NIbeDGOcw88w4hYXuTfc89A5+OQAWouje1p5NYo=
X-Google-Smtp-Source: ABdhPJyBLUhUisDe1QSEqxvufnNz3zHHsM8YVaG2qZiqkVVw5lRoTvhsuBN+yVbNetRNx2Rxear04A==
X-Received: by 2002:a17:902:e547:b0:156:bde6:bd85 with SMTP id n7-20020a170902e54700b00156bde6bd85mr3868059plf.108.1649170871060;
        Tue, 05 Apr 2022 08:01:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y63-20020a638a42000000b0039870096849sm13546833pgd.63.2022.04.05.08.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 08:01:10 -0700 (PDT)
Message-ID: <624c59b6.1c69fb81.c22c5.3267@mx.google.com>
Date:   Tue, 05 Apr 2022 08:01:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.275-208-g30d7e10f520ae
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 40 runs,
 1 regressions (v4.14.275-208-g30d7e10f520ae)
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

stable-rc/linux-4.14.y baseline: 40 runs, 1 regressions (v4.14.275-208-g30d=
7e10f520ae)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.275-208-g30d7e10f520ae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.275-208-g30d7e10f520ae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      30d7e10f520ae6666a7f386fbc91f62c5287ef8d =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/624c4d7fcb906aa486ae06d9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75-208-g30d7e10f520ae/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-m=
eson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75-208-g30d7e10f520ae/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-m=
eson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624c4d7fcb906aa486ae0=
6da
        failing since 50 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
