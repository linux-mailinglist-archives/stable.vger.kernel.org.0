Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A2F280426
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 18:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732274AbgJAQm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 12:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732048AbgJAQm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Oct 2020 12:42:56 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512B5C0613D0
        for <stable@vger.kernel.org>; Thu,  1 Oct 2020 09:42:56 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x22so5040669pfo.12
        for <stable@vger.kernel.org>; Thu, 01 Oct 2020 09:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1h65nmf/XB52vFoYkYzaBmr+J89EGtYDlNOD8bD1kto=;
        b=0QwY+eqB8Iqr3YM4IXJhvdERXsC323IvQhZysCXbkhqY0Ef/z1noqNAqp2ezYNFXLQ
         vGFijvooMDlhWBQW2Bw7osLwj86jrKKcNYd5RarvI7LVCfyhALiNUGU889lRbnZUvvI3
         JsWnc6rxpkCC9YStrdpwiivVdTKfQflhApxi1Nlgv0U4Uy2baRDxeZtSz1Hni5YV6Ll+
         eesSyxsRlxFCzDFGDpslcKpd2hDVijFWiL7PvvenmB2bqxST/iHJO/vYymavcwSK9uaR
         9jECNwItvQErEpvqTmFXQ3LiIaG1FFx/9L1jy+s1mqrGZb2B4dWtRPEYLoii6/S6Y+K2
         4idQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1h65nmf/XB52vFoYkYzaBmr+J89EGtYDlNOD8bD1kto=;
        b=I3jIsuniW3lMeV3Ykwrlvjq8f0B5izW/uKqEuG6y8C+YuV6M+mljh78iCM62Z6fNWn
         zqnrdzXo/yt5/jjMN+5H8C8a/HW0vCn4xY6H7p8npUUmYasaNE6w/03iUj3r244LIX3o
         K9TUEK0w89m2xTDz7w//4JxdZQgOnWGhJd3ClDcb5ibUb6pP1PPbBYx/uS4R5LP8De1O
         HihXm9j2CvcSZ8j0ffTZAmQ1zL/+XhWbYlfya5Ar/NBKMYCeaNg5xLnO87EXTG+sNzBB
         fKbcu+N8XzPp7wmLvOUxH59aUWlByo0gye9gZ5YwnZgrfKfPzXootLMy5MXgHDWkDNQi
         27ig==
X-Gm-Message-State: AOAM530XsfQlN0VWhdTLeb4ObLCBd7KJTj3n5ePjioFkVV64/yOMc9NZ
        0XSUutkl/QPSC1IWtaFrx0KWfsdEnp3IFQ==
X-Google-Smtp-Source: ABdhPJx2KIBKPfNDNO53bGSI8akJTWQ4b8MdYocNAT3OSOh3aPLXDtdXmM/6CMcTAgYxxo4UyBxY1Q==
X-Received: by 2002:a62:8c88:0:b029:13e:d13d:a08b with SMTP id m130-20020a628c880000b029013ed13da08bmr3611657pfd.34.1601570575138;
        Thu, 01 Oct 2020 09:42:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l13sm6281237pgq.33.2020.10.01.09.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 09:42:54 -0700 (PDT)
Message-ID: <5f76070e.1c69fb81.e714b.c9fd@mx.google.com>
Date:   Thu, 01 Oct 2020 09:42:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.149
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 147 runs, 2 regressions (v4.19.149)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 147 runs, 2 regressions (v4.19.149)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
hsdk     | arc  | lab-baylibre  | gcc-8    | hsdk_defconfig      | 0/1    =

panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.149/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.149
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b09c34517e1ac4018e3bb75ed5c8610a8a1f486b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
hsdk     | arc  | lab-baylibre  | gcc-8    | hsdk_defconfig      | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f75d22c972d47b969877183

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.149/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.149/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f75d22c972d47b969877=
184
      failing since 77 days (last pass: v4.19.124, first fail: v4.19.133)  =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f75d4ea43bd0f6d82877182

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.149/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.149/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f75d4ea43bd0f6=
d82877189
      new failure (last pass: v4.19.148)
      2 lines

    2020-10-01 13:08:53.879000  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
      =20
