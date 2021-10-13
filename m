Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6232042B35F
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 05:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbhJMD05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 23:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237143AbhJMD0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 23:26:54 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E6EC061746
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 20:24:51 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q10-20020a17090a1b0a00b001a076a59640so2882776pjq.0
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 20:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kwkdT8r17z9ivXHxzDCMoto6AW7QdBWIOF35wmalTho=;
        b=JMfbOdWwx70Ho8CTQp9z81KqtcdT3fzfVPu47hvIF0FQe//WJKji/ndvUaQ5FD9pYB
         M/38SvwyFyp0z/9deIsyPiH6JGLkwWdlUhKwW32c7aBUkOnpsFdWwM0vjGdrZHg/9/Ne
         D3SW2B52O7bQJjVXPAFMd/p7K6XJb6rAUsX67hkCy0lhXwEC1Rk/RemQnxAvDrgGPg+r
         05Jtxo9621tuciVuu+ot4fSBdR9J6xXGDvpGMtuyZLiOGqa+KG3goLNXzHQOse2SSlDR
         L+rfREIQz2NVzg3jaao3o8m75VusD3qH58mNrgwOsglbZ3Hsv6vs5JA9mcyxstzfiakE
         Psww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kwkdT8r17z9ivXHxzDCMoto6AW7QdBWIOF35wmalTho=;
        b=SHvRCpWVhsg/k0YPdMVXP8sZgZqWhIp5VKlN+EWBnXULC9PfmEEWby/pThpGY18Q3l
         eNnK6O/NIobMT/3xrxWiia+37PoT4A3Smf6O/yovaYYVqBR2OHmoiBtwAVq+HQLD3sV5
         dDNx8TBWU2AbQOlLMEkI/1n1l3137SimIl63DPuWe79wdw/br7iPYEt0hjjl3MobpQTz
         KFt9fJm1cCfo/BNtjldlakpVcfOTJG9e0GAD/hTSitru5i3t0DetIEoyUVKW/MUmKgxa
         DZvHSWQevlWjQwC9z0A64MuCbzj39cKPPvynpsfni3RNOuODBEjdmP7UgS669BIwNvDr
         C1nA==
X-Gm-Message-State: AOAM531xIalHd3+V8N/v01gO1DuITkGaSAV5PUPXFefuB5ygWrOJZflv
        eyOxNOdW55rJGi8ZDrUGh0cuhaY9zBrSXMIo
X-Google-Smtp-Source: ABdhPJyGD1t+WK+lpOxUm6RYZ8IFVUdgvmrEzmdse+LEQpR68HYMleERJSqq7353SNSQehPqPsQrOg==
X-Received: by 2002:a17:90a:12:: with SMTP id 18mr10540820pja.104.1634095491084;
        Tue, 12 Oct 2021 20:24:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w185sm11811477pfd.113.2021.10.12.20.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 20:24:50 -0700 (PDT)
Message-ID: <61665182.1c69fb81.3fa9.2359@mx.google.com>
Date:   Tue, 12 Oct 2021 20:24:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.11-152-gb521e3a08ae9
Subject: stable-rc/linux-5.14.y baseline: 105 runs,
 2 regressions (v5.14.11-152-gb521e3a08ae9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 105 runs, 2 regressions (v5.14.11-152-gb52=
1e3a08ae9)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.11-152-gb521e3a08ae9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.11-152-gb521e3a08ae9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b521e3a08ae9f352db8075c839a1b99c6497f4bb =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61661683f2c066166108fad1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1-152-gb521e3a08ae9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1-152-gb521e3a08ae9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61661683f2c066166108f=
ad2
        failing since 4 days (last pass: v5.14.10, first fail: v5.14.10-49-=
g24e85a19693f) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6166143ebb4e6892a408fab1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1-152-gb521e3a08ae9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1-152-gb521e3a08ae9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6166143ebb4e6892a408f=
ab2
        failing since 5 days (last pass: v5.14.9-173-gd1d4d31a257c, first f=
ail: v5.14.10) =

 =20
