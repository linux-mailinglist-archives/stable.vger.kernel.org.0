Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B166044CE0B
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 00:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhKJXzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 18:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234270AbhKJXzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 18:55:41 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014A1C061766
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 15:52:53 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e65so3603981pgc.5
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 15:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kE+jj+SOMWpde+3gZcAS8VkC8exMQUx/KHJX+ErsmSA=;
        b=jXY/xqdCTKU2qoUQivNXmqGXJCUob7Rb+KxdTM3Vtd89MLfdKohH/GRI0uy+R/0MOA
         uV3KGXmQAChqx3U+IgEVxr28RkmqSuQPHmRFE3Jg/BgSV/SUvqQ0+PaacgHNh3GC6UFo
         RKs/ZJqwUxUuSIMSPztJXkQ2QrlOaTgPSOOxpMGawoGSIP06VzlHfRbjCFbvuDCDV/Rh
         V3185F4Rzgo6rSWnHuuK/HoOdtZkVHjyHJM4JBK827m208y6vQThxfRj2HgS3/DXjfvw
         XOz9SzeK4ND1g3FelWUUbaC7nujm1MUbw6sMPxMjMLx20YYwzlvStU70oGEiQ3A+1orJ
         +s5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kE+jj+SOMWpde+3gZcAS8VkC8exMQUx/KHJX+ErsmSA=;
        b=zTCyIKqUF+376/Q6rDpd1crwXVUBzK6glkLcL8muGqShXbFfGaNDNEhEJiXb2DGloC
         WxWeTZFDvaQaBQaGz2kqmJzHsH/u/HNSB0dswn3eDHXpuYMtVym6V83o2mf/Mt8XRbV8
         IJakwCyKJwZKHPR9sDVblwhsOMxkcUhkCKCcccjtduJTgYN+3TGTsGpQ1zc5jA+nV1WJ
         UC8byfQX2dFdc5Ucx0nBHl+IyOrM64gX+CBmtKW4gYecAK24yk0HoPdkfGPFAUPUv7KW
         VUmVGuVWyKuAZ3kvgCXj6xzwfVHapbBodZ0SIK4zFyiZvxTFgIGozYYlubxzI0Vy0y8s
         av4w==
X-Gm-Message-State: AOAM531DsVkA01noI/v8ktFfh8I4g9ZZpDRy3T4MbMYi9Z6xVYmBv9UV
        +NdC+S03WHqI2EAOJv+t9OTcYDBETUKWUNclKe4=
X-Google-Smtp-Source: ABdhPJwazFdLgBpWdvPTMqfPRcrfYS3ht2+3tkfYh5YiU25ASJW8C/nsrTP7v2wMku3KuNcd2c9uxw==
X-Received: by 2002:a05:6a00:8cd:b0:47b:b9e8:7c2e with SMTP id s13-20020a056a0008cd00b0047bb9e87c2emr2814647pfu.61.1636588372265;
        Wed, 10 Nov 2021 15:52:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s7sm735026pfu.139.2021.11.10.15.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 15:52:52 -0800 (PST)
Message-ID: <618c5b54.1c69fb81.5cf18.30dc@mx.google.com>
Date:   Wed, 10 Nov 2021 15:52:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.158-18-g1422b7f3f43d
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 173 runs,
 1 regressions (v5.4.158-18-g1422b7f3f43d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 173 runs, 1 regressions (v5.4.158-18-g1422b=
7f3f43d)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
sun7i-a20-cubieboard2 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.158-18-g1422b7f3f43d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.158-18-g1422b7f3f43d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1422b7f3f43d27856aa1eaf04eac12fc7e565f66 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
sun7i-a20-cubieboard2 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/618c21b5f2f622b04033592a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.158=
-18-g1422b7f3f43d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun7i=
-a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.158=
-18-g1422b7f3f43d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun7i=
-a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618c21b5f2f622b040335=
92b
        new failure (last pass: v5.4.158) =

 =20
