Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69AB5575884
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 02:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240955AbiGOAI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 20:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiGOAI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 20:08:26 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3FD735B6
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 17:08:25 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so4585103pjf.2
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 17:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GknQUQqHO9WfGFRnFIBmrcEqky48xkXnFwELjSAwyYk=;
        b=sjAJRTgqm6leULqjDrJY/f1YPKSuaI4c6/HzC0Vb0dy9Io/Vx3JdGxEXOdTqg1pEZY
         x/GiQgR0OiA8ApuZByrnRDVaiF2DgPqkVKPWQte9jxB4CrUj0cTvaRUKuWWE72bGAO1E
         hn8hUvRwKPsE+hKG1+BUyqxI1Q4la2CJOtlq7hwYbXixPkXEyNYmIkZ9IPUXoo4YTUVC
         KQ+4/L3hdeiDBV/hJD5n1nx/U3kUNkmfVye2S4VoL8QUR133TZwLJOhWjUwN3QZb5Gp6
         QX4GLcjcIOf3jD65Wi+kSRHfifE1Wocpe6r4cFlJQ/9wuTfUQif2DScDaL3AU7Fe7pXP
         Nc1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GknQUQqHO9WfGFRnFIBmrcEqky48xkXnFwELjSAwyYk=;
        b=yZP64wx0Rxi9h4INjOY4zLQsiPejcmfOrup+8g7K44UQl3n6/T9ZafXT9FxsBX1cYN
         WaBTRwE3TEyEA1yJ2DGUsp5B4odDswBH2ZpR5JjyFhwc+xQMfUeObTZBfevLLItB0hkO
         Hgp18k9Mr8cf41JflvThDlM7P4k/5eUmIZvKHI5Vn5Q4vHDu27B5BJPshjZ7kZ5gfUvU
         MKsOuWJzSdQ9/51t9Nx+1KCRYuYCQejJGzL8Tmas4JJH4iTz8mGmbY9WAx79CjIpSxSt
         o+CDCm1pLOYOw1ea3XMHegYl8SHhiGYrKxa+8v9590MNhA7W8rpB2cjoYqbgv0OaNilP
         jhZQ==
X-Gm-Message-State: AJIora83A0GfDWWWk6hh7ozCjPaP4KxGt9vmfRelXuPTD/9fisp1n/Os
        PPErGxyUsKW44soCV8k54j6UKJh6K/et2gK2lUg=
X-Google-Smtp-Source: AGRyM1udZ7q2nH92OKdkWjtDPZhRxpEqA6MZBKqKXAnMBz38vCHPrQL6ULw4ylDwHWG3IT1Bi/vAvw==
X-Received: by 2002:a17:90a:7784:b0:1ef:c0fe:968c with SMTP id v4-20020a17090a778400b001efc0fe968cmr18555508pjk.26.1657843704715;
        Thu, 14 Jul 2022 17:08:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nb4-20020a17090b35c400b001efeb4c813csm2109229pjb.13.2022.07.14.17.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 17:07:54 -0700 (PDT)
Message-ID: <62d0afda.1c69fb81.96cc9.3599@mx.google.com>
Date:   Thu, 14 Jul 2022 17:07:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.54-80-g107b7d3eba74
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 138 runs,
 4 regressions (v5.15.54-80-g107b7d3eba74)
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

stable-rc/queue/5.15 baseline: 138 runs, 4 regressions (v5.15.54-80-g107b7d=
3eba74)

Regressions Summary
-------------------

platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.54-80-g107b7d3eba74/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.54-80-g107b7d3eba74
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      107b7d3eba74a1d5e5a0a5d3da82041cebe4b7b9 =



Test Regressions
---------------- =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/62d07612c30c9f9f6fa39bd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g107b7d3eba74/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g107b7d3eba74/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d07612c30c9f9f6fa39=
bda
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62d0767779558de94da39be3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g107b7d3eba74/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g107b7d3eba74/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d0767779558de94da39=
be4
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/62d08eff6dfacae5a5a39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g107b7d3eba74/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g107b7d3eba74/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d08eff6dfacae5a5a39=
bdc
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62d090198264755255a39bde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g107b7d3eba74/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
80-g107b7d3eba74/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d090198264755255a39=
bdf
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =20
