Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CE763F325
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 15:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiLAOvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 09:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiLAOvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 09:51:40 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BB6AC6EA
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 06:51:39 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 82so1904394pgc.0
        for <stable@vger.kernel.org>; Thu, 01 Dec 2022 06:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5xbqN+y2ZDfwZboIF41v6V6ztWXHGYSWYX3qAmKf8Bc=;
        b=OLO6//gEa4k6lb41JzXmVgnrxCfhyUolJsVuj9N1lMgB7Q/eeKDDfammagbW1SQG9y
         CJuYMiWbRoiFOu9cRqr+cPeMwiJNMY6xu/uY6w298cwU5rICHkoM+PVe/z/UjXFviek3
         gH72tWITA9TdWQ5ACsZMHOc4YTE/RfiGde6SCwIoPsnmWUCkfvnYs/KMheMfoy9RDTI7
         JnWZw3O7WHjFjFev0TbhafDpJvAHaoniY0zuAozBXKabzpuDlFPtEqcVmZC+R9SdM/DW
         bPD88uysGtbLWGyG7wQ6XYZM1ixnpjzwk7V0HXgodumtGcHsfbnjlK4Ot6pzVbSeXcYb
         fO7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5xbqN+y2ZDfwZboIF41v6V6ztWXHGYSWYX3qAmKf8Bc=;
        b=QUbyvKCrmHZFi9JuSyFWZbViBc/45tCACYctRNXXavVgIghV6bkCNuNdCc85rPU+vG
         7IkewkUH0i1Qqx3l7BMu9hvOd66gdptr8ureJ6Z6X7p07fV+Czf4cBDCRHpXN2aJeywx
         4LClZdRz64+vqoX8QraE9FMehJdY+/iCMccYHuQzCBzygN0xCAJPO+iHFNimPh90ufUe
         nG6zQ5kmGfowx1VZS3sRF/eD5Nfyd1iAQHKkyYjZMhLkUKY2pR5IvrtExe6WdiC6LANi
         xMd5ZX6e+78ybi9pU+6A9fkKOhqXFn2iNyFxrsd1BY8SwG8d+28paxJ8VfymbQl8YMt9
         JLvw==
X-Gm-Message-State: ANoB5pmmD2VvW7choyi9R6mQJJX/TBMzoQMthSFN8c004NxqVIiZvdqx
        NDQ3/tzbsJSFRDuTaPx6VcgEvLY4KnIoLXB2Elc=
X-Google-Smtp-Source: AA0mqf7+/7B2bapUGsqZl/uYPPMI+21GTyvqSO6h5Z+gPO4j+hrBpGM6QhjDrxbKWyjtIZhj5lSvPA==
X-Received: by 2002:a63:e506:0:b0:43c:2e57:9798 with SMTP id r6-20020a63e506000000b0043c2e579798mr43732548pgh.590.1669906298517;
        Thu, 01 Dec 2022 06:51:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l66-20020a622545000000b0057447bb0ddcsm3325955pfl.49.2022.12.01.06.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 06:51:38 -0800 (PST)
Message-ID: <6388bf7a.620a0220.4170.6f89@mx.google.com>
Date:   Thu, 01 Dec 2022 06:51:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.155-308-gbed9af26afc1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 130 runs,
 1 regressions (v5.10.155-308-gbed9af26afc1)
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

stable-rc/queue/5.10 baseline: 130 runs, 1 regressions (v5.10.155-308-gbed9=
af26afc1)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig | regressi=
ons
------------------+-------+---------------+----------+-----------+---------=
---
rk3399-rock-pi-4b | arm64 | lab-collabora | gcc-10   | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.155-308-gbed9af26afc1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.155-308-gbed9af26afc1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bed9af26afc13ff97345328aa9d4d14e323e628d =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig | regressi=
ons
------------------+-------+---------------+----------+-----------+---------=
---
rk3399-rock-pi-4b | arm64 | lab-collabora | gcc-10   | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63888efdef7c677ce92abcfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.155=
-308-gbed9af26afc1/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-roc=
k-pi-4b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.155=
-308-gbed9af26afc1/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-roc=
k-pi-4b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63888efdef7c677ce92ab=
cfb
        new failure (last pass: v5.10.155-296-g11298fd27eb9d) =

 =20
