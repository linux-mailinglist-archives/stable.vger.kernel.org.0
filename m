Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C22C4CC6D1
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 21:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiCCUL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 15:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiCCUL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 15:11:28 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA80144F79
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 12:10:42 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id mr24-20020a17090b239800b001bf0a375440so3429312pjb.4
        for <stable@vger.kernel.org>; Thu, 03 Mar 2022 12:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tcbqu3CeiCxRY2UkCR4gNTIN4YpLaZ3VEUJxLi8dxwc=;
        b=SNaaIdHynVIJjUr6GFZdEZ6cToofA516r2k1WpNWu6fPfoN3YJEax8qOYCwptXaCmU
         XS39HVOVJFclDf2Y9OkaIfZWNN4z9KHkJB9F8QYYMdBrnZ7xiHcyad22dHN+srPFxyWu
         fV/eaM3DDWjUPfPAMqhA+GpqSa+HKvINbg7QUQhTbHKJM3O5Hlde2fY8z9bqpdHtfZ6L
         Gpxgb/ipSIuybxu1wPjvsmAnemesfXR+7Rarada2c2VSKe4Pm016TuZHpQyRgG/FKGVX
         PtR/6XoYBOV/kBLy6Kf9K6VZEgEsCXcXktNGM82+SnkXM0NklkeOp/GPGu85TEMy9y2l
         A/Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tcbqu3CeiCxRY2UkCR4gNTIN4YpLaZ3VEUJxLi8dxwc=;
        b=dIzMHKsDB4gCE9HMtRo16L8L6HzCawp4lbPk+O1PF4so+fI+jd4CviAMMoz8hj48N2
         v0+77C1oBADkh3mm9CFtqMhOCgnXwVjEocbEjryGtmAmTrdriz9HeZGwuDwqoUSNojn3
         3KI0Rn9M7KP9n7DXZwDNouuqwWL88foDgoCaG5TES4n7cHEjKQ0ctD4yGLOP0vJJz0e9
         wSHmbwrW0ZAE/EDThRdcQRBF4MMj0O5gEsCHumvrJ/1UwwJ2/pqk3FqglhVr1JKpNdGr
         NPAKrjv7Ayp0RL7yobLRRfMfBW4y+8mQCmUMJh5Vp0jpJqJtBUevwZcq7k2ibwk5qZCe
         B9+Q==
X-Gm-Message-State: AOAM533mxZRPQQ4LWbw6TZ3NwK77pyTyZ6uhxIoxYdcFV8wrnamgqgmz
        nzk48KRHUoRQLEd2u+pfz4GZXaTldEzgRPjbLHQ=
X-Google-Smtp-Source: ABdhPJzIg3NwX9f2AFFPPyiSziwfyziYRcwLVbZpdVv/Y+sBpCqFDWHq75143CLbC0+XI+CM8fGhQQ==
X-Received: by 2002:a17:902:ecc5:b0:14f:f310:4ed0 with SMTP id a5-20020a170902ecc500b0014ff3104ed0mr38380908plh.129.1646338242070;
        Thu, 03 Mar 2022 12:10:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v24-20020a634818000000b0036407db4728sm2662897pga.26.2022.03.03.12.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 12:10:41 -0800 (PST)
Message-ID: <622120c1.1c69fb81.1dadb.6cfa@mx.google.com>
Date:   Thu, 03 Mar 2022 12:10:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.182-13-g0281def5f981
Subject: stable-rc/queue/5.4 baseline: 100 runs,
 2 regressions (v5.4.182-13-g0281def5f981)
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

stable-rc/queue/5.4 baseline: 100 runs, 2 regressions (v5.4.182-13-g0281def=
5f981)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.182-13-g0281def5f981/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.182-13-g0281def5f981
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0281def5f981d0e072f8db337fd7ae8730c688d3 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6220e7d9c0bed7f03ac6296a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-1=
3-g0281def5f981/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-1=
3-g0281def5f981/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6220e7d9c0bed7f03ac62=
96b
        failing since 77 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6220e7daf249d89b02c6297d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-1=
3-g0281def5f981/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-1=
3-g0281def5f981/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6220e7daf249d89b02c62=
97e
        failing since 77 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
