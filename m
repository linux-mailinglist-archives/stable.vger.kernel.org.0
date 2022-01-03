Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADAC4838D2
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 23:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiACWnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 17:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiACWnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 17:43:50 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3641C061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 14:43:50 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id m1so30565654pfk.8
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 14:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9lcD5UK6xFW/pl4S89lBi47GIzdm73WX/oj8arrYE6s=;
        b=yB/KNPters6oUsXHRaL+lA2xZEM1GZ+4b9zXdQFEPkdI7im8Is436ZdzvL+skV8bZh
         O4o8uHz8VmgKwBf6PuXAwPJcovro1odQPyPqA32XKlYAFiyZ0K2vTVr/r31qFui6R5e6
         Uz/tHk7QmUeb1DAHqvhgc7drxWWHnBE2ccqIdgp6x/pRlVdUCVjaemzvdAZ7qwNhIU7E
         j3pvXVpkcnUfWcVS1gHvCw/5fbulMWZ41F4YfpfEAPakxiuoyu50YBRDia2lX9SRqGBj
         Dmq4wrS8YO/HqKX5UdLxF0qoeKw0npNnfO+7+68y/EvLZpXM/DSlJRPEr7LDJiKavRKn
         q8dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9lcD5UK6xFW/pl4S89lBi47GIzdm73WX/oj8arrYE6s=;
        b=FB6An0XsW5uaroLucT1LNpabqAH5ypSjHN+GZb0p00xYKeBSxbx46HIhDVzQ9UZFqQ
         Im/l+BoFua3Mwy7bkhCXKUI9oucooGl1NQQComvtUQRRtMZOlG2dsK9KpXOeT1qAVY10
         5xCXQMpMRTRr0TzDxQh2YnQ8kQl1xM2gL7ggb5D69Ghhp/klalxJuqpwKBgqrg/InEL9
         md/enhPnHCDO1CvZuGstQugKcH4rCiA+GVBvESBo8gNVTCyzTZ6FOfoxyZi30CK3ddFP
         ZPG+4xav+30XLyzvF3Jaahe4vQf+rkbiibnipApsDAl2YoRw4TM7P0l+z/g2OcUn1QAP
         xj1Q==
X-Gm-Message-State: AOAM530gug8syQnxu26xIWEM1CDH+ZbgvscEK9AVwS89PM5pksvTHwgj
        uuw1gRwAekMCe2+tZyX+9dSEfytHCxisczP4
X-Google-Smtp-Source: ABdhPJysKycQpgEEXYlODnWfVAu27GlTB6in8+JWxk0C2MFHlC9EYlRUTGjW/WclKnrncp223nsABA==
X-Received: by 2002:a05:6a00:2493:b0:4bb:7b30:ead with SMTP id c19-20020a056a00249300b004bb7b300eadmr48610118pfv.78.1641249830165;
        Mon, 03 Jan 2022 14:43:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u6sm39944655pja.32.2022.01.03.14.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 14:43:49 -0800 (PST)
Message-ID: <61d37c25.1c69fb81.9d848.b1a3@mx.google.com>
Date:   Mon, 03 Jan 2022 14:43:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.295-14-gc154c6cb3efd
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 110 runs,
 1 regressions (v4.9.295-14-gc154c6cb3efd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 110 runs, 1 regressions (v4.9.295-14-gc154c=
6cb3efd)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.295-14-gc154c6cb3efd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.295-14-gc154c6cb3efd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c154c6cb3efdb71f32e51470e61b791083fab40c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d3485bc4e671057aef6768

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.295=
-14-gc154c6cb3efd/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.295=
-14-gc154c6cb3efd/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d3485bc4e6710=
57aef676b
        failing since 0 day (last pass: v4.9.295, first fail: v4.9.295-14-g=
584e15b1cb05)
        2 lines

    2022-01-03T19:02:32.943226  [   20.539123] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-03T19:02:32.994545  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2022-01-03T19:02:33.003886  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
