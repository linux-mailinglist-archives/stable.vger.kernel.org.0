Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB65C6A3453
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 23:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjBZWBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 17:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBZWBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 17:01:38 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD701165C
        for <stable@vger.kernel.org>; Sun, 26 Feb 2023 14:01:35 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id cp7-20020a17090afb8700b0023756229427so8224671pjb.1
        for <stable@vger.kernel.org>; Sun, 26 Feb 2023 14:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rHCNVvYRAFvxt3q1S8Xln/f4D8b4A+QLybwrSmdQ6SE=;
        b=zPKfkZKms0oW4bBDRqqqxhv0BYCuqk+vWbviTzhE5RTAOPk0FmcxMDnwJ8JCofADyx
         YmmB9Lyho/bywYj9g2dJQeqAayUtwBWnvKx6vXeliGC8e6JDSiu54pbw/bhj895G4hOB
         bDzwXzu1WjWV6FT1N1h9W3T3WAIrcjWxrT9rBpMbY0NkEJv8GPzuwgROlQ7+AWAroM5K
         cI6d0ZsHM1VvF0j9awzYO9yoEntObjvVp2xFoz+esigv89Xt5R/al2cLVrDkm0lUNp/D
         hCkv25MBiJkM74MJavCFokeQFUT9vqGDo39gqIW7odo+gyblwAMsX72aC93dAb/FpNfC
         9rcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rHCNVvYRAFvxt3q1S8Xln/f4D8b4A+QLybwrSmdQ6SE=;
        b=GUN3nJI0lfW6+Z0hyrUSs71Z3dIVBjBK6lexWsPjK2rdg7cxN6kFKNbAxeQmQtYqHc
         vqdJ6uzkY2jCBOJeXQ4OgwlgzvuR3zuhj0GY2Uw1khOpp5BMvBKwk3uJrlHEP9Y0IEae
         x9mZh9jkEMjaj2R04z38UYhu1ZwWmRGsiFV4o3wc/rqfz2rJN1eeoc/6tLqzAO776wXV
         8LN1qCzZHwly9Oh3rDS31RuTpvM4KRaz6dGeZARmHLz0gt4z7vpsxdrdgGaotsoVVIvB
         LblZnZ/pR/eLBdvJIp5AMgs4kWM2vda4Gerbpyi3ogVlABNU+63dPEiu8lkXwSFZtsu/
         E4Rg==
X-Gm-Message-State: AO0yUKUCO0jdjdoZA+u8/d1LZYuu6U+IwgrsO0K/xFtGMEj7pQd+WHGL
        6L3yq3s8vAcGrV4EH8IwrJuHPMwyuYe9Fz67Zhvoag==
X-Google-Smtp-Source: AK7set/8j3gZ5pdzpRWwHmqUuiKeQesXHx16UFi6wokrZwcCx7HZCjKCMzUR8KCIPycF3ZgvXosZRw==
X-Received: by 2002:a17:902:f690:b0:19a:80e6:2a1d with SMTP id l16-20020a170902f69000b0019a80e62a1dmr27190096plg.41.1677448894749;
        Sun, 26 Feb 2023 14:01:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p7-20020a1709028a8700b00198ef93d556sm3103247plo.147.2023.02.26.14.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 14:01:34 -0800 (PST)
Message-ID: <63fbd6be.170a0220.e8f0e.4962@mx.google.com>
Date:   Sun, 26 Feb 2023 14:01:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.96-12-g74c11c575b17a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 168 runs,
 16 regressions (v5.15.96-12-g74c11c575b17a)
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

stable-rc/queue/5.15 baseline: 168 runs, 16 regressions (v5.15.96-12-g74c11=
c575b17a)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
odroid-xu3             | arm    | lab-collabora | gcc-10   | exynos_defconf=
ig             | 1          =

qemu_i386-uefi         | i386   | lab-baylibre  | gcc-10   | i386_defconfig=
               | 1          =

qemu_i386-uefi         | i386   | lab-broonie   | gcc-10   | i386_defconfig=
               | 1          =

qemu_i386-uefi         | i386   | lab-collabora | gcc-10   | i386_defconfig=
               | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.96-12-g74c11c575b17a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.96-12-g74c11c575b17a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      74c11c575b17a19c51e7f84f9dadbbd4be1ac706 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
odroid-xu3             | arm    | lab-collabora | gcc-10   | exynos_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb9fa270186df5508c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb9fa270186df5508c8=
655
        new failure (last pass: v5.15.95-37-gda3256d1340e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-baylibre  | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63fba397bbd4d73dff8c8680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fba397bbd4d73dff8c8=
681
        failing since 12 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-broonie   | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63fba3490313dc98318c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fba3490313dc98318c8=
633
        failing since 12 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-collabora | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63fba3520313dc98318c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i3=
86-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i3=
86-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fba3520313dc98318c8=
639
        failing since 12 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fba2e396269da36e8c8688

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fba2e396269da36e8c8=
689
        failing since 12 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fba3d346c7a2939a8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fba3d346c7a2939a8c8=
630
        failing since 12 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-gf3091fc0051b) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fba2e59786d51c7a8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fba2e59786d51c7a8c8=
631
        failing since 12 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fba3fd91d7e5bb068c865c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fba3fd91d7e5bb068c8=
65d
        failing since 12 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-gf3091fc0051b) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fba2cb886a7878c88c8662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fba2cb886a7878c88c8=
663
        failing since 12 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fba3bbbbd4d73dff8c879b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fba3bbbbd4d73dff8c8=
79c
        failing since 12 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-gf3091fc0051b) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fba2e41c78e230c98c8650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fba2e41c78e230c98c8=
651
        failing since 12 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fba3abbbd4d73dff8c868d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fba3abbbd4d73dff8c8=
68e
        failing since 12 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-gf3091fc0051b) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fba2e6858c9e8bb98c8676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fba2e6858c9e8bb98c8=
677
        failing since 12 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fba3c1bfa4de9fc98c864c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fba3c1bfa4de9fc98c8=
64d
        failing since 12 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-gf3091fc0051b) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fba2c6ef17ec82118c8678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fba2c6ef17ec82118c8=
679
        failing since 12 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fba3a2bbd4d73dff8c8687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.96-=
12-g74c11c575b17a/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fba3a2bbd4d73dff8c8=
688
        failing since 12 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-gf3091fc0051b) =

 =20
