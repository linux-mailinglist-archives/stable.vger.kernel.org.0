Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F108348B421
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 18:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242666AbiAKRhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 12:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242236AbiAKRhK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 12:37:10 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663E0C06173F
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 09:37:10 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so183413pjp.0
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 09:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E5tnn9gxyvgr60US9B58ajqGpXqHYcUIoifZpP2/TbA=;
        b=1LWjzNUhiGg2sGh42X+s0z8mLbXzM1hRAp6bG0TSz3RGJs/wsYWR1DJHYGB8vLN+nK
         wxezmhihYtFw0odQpKwoiuNQzsjDBnbGlM+BdkizstmvBwmyNSjBOr+PEJJ8vDq+tEhs
         nqJU1xoqT/BOoVaDsVcIubkKh5vC2+L7QaxTDHB+EkDfVfVbGZ7Xt3oUuuVWM7zXfyG3
         MTOj9H3V3wsBqegX59KvMJ3wdgFFpzISa+O7rfMWF30wQsw2RqsYsSL/4FQ+4yv2nXhq
         S0sLSoWQF1LmPzFHVjGwa3ID1rrtxBg192EuN8pnyBAIewtoDBbIMgjwZcJwwlYty3qX
         FfyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E5tnn9gxyvgr60US9B58ajqGpXqHYcUIoifZpP2/TbA=;
        b=KPaEzrsYOEAIejDXQB7LZITQ6E14HXdguBRmJLmzpxG4bU1fY8GTVaEHKRudu9pTDY
         LFHyV0HsYBWIFHv840MfRwmzonDesSu2al2Q26dHYxT1sRYzOf6V3w0DO0FmRtLaGlgZ
         zGQTvmu+znJnP2s+dgQcMW3dXeIpPmG7iv7QCQS2pP6BTiZIIChrYR17O3GD8S/HnjKI
         2o/dUT8iV9+T2l4p5mDEjuB8/PPwjxmP1pYd9SuYukOkrWsTfKEFtMfd/67xRYg1/vug
         r5Dx4nCcFyJBTnLcXDZdl8XDTcy61CBzH58UUcL/oKYA2JfCMKulUqeO3SS8NhjieJW4
         vCtQ==
X-Gm-Message-State: AOAM532/XB7O99fLG3X16Zhn7Sq3syumm8Tb6D98hGNXzDMoJy1BXwfg
        2jggHBBDROfXqRMFd7CfXUQL0558t+Zfm+Ed
X-Google-Smtp-Source: ABdhPJwdYfQ4r1yUk+ekFW+8Ak/C7HmZswd3ef4y6BCwAFMngurrcT8UUl7Uf8wkiGSKiFS/eLXCqA==
X-Received: by 2002:a63:7d10:: with SMTP id y16mr4866060pgc.423.1641922629798;
        Tue, 11 Jan 2022 09:37:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v12sm1284pgl.90.2022.01.11.09.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:37:09 -0800 (PST)
Message-ID: <61ddc045.1c69fb81.866e7.000e@mx.google.com>
Date:   Tue, 11 Jan 2022 09:37:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.299
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y baseline: 92 runs, 1 regressions (v4.4.299)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 92 runs, 1 regressions (v4.4.299)

Regressions Summary
-------------------

platform         | arch   | lab     | compiler | defconfig        | regress=
ions
-----------------+--------+---------+----------+------------------+--------=
----
qemu_x86_64-uefi | x86_64 | lab-cip | gcc-10   | x86_64_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.299/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.299
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b0ee52316847cf279a1028334117985a5d633c0c =



Test Regressions
---------------- =



platform         | arch   | lab     | compiler | defconfig        | regress=
ions
-----------------+--------+---------+----------+------------------+--------=
----
qemu_x86_64-uefi | x86_64 | lab-cip | gcc-10   | x86_64_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61dd9171acbf4db883ef6771

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.299/x8=
6_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.299/x8=
6_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dd9171acbf4db883ef6=
772
        new failure (last pass: v4.4.298) =

 =20
