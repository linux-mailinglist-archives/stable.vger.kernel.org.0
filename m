Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F3244F0BF
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 03:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbhKMCFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 21:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235415AbhKMCFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 21:05:50 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C562C061766
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 18:02:59 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id y5so9931540pfb.4
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 18:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zR9kLKd2pi/Ct8sxuTvBqNwVdvPi5QWYN7lXDP7mi0g=;
        b=V5P6OsiKmjRIi4dUachjsJ935RJBgDALlHUm0JGhkp/ZaObvUek0rtObGvwMITN/CK
         K3oF0nmbbMzhAj4EVMnj0jLWxYJsp8TdnrVdtzE0zpNkijm8nHeNPZuOIN7a4LQ6AeYO
         zrwKM7Z9PBiAeA/UHexz3wZTvrJdKY89KYO7HkQ08m+r7Qkp2O37Y5N/Eivg/7zTmOWx
         6euD/E4uTkkcLhU2O1SF/K2lL8L/xcLObZjsUqIrx7ZkbK7LmTPLHF3ssF8iqNeJiW6b
         7HFWy5GxOmY8kKZQIA96GZrawPgPSP+9vRGWRmo0eGiCUsskzC+2n2HfpGV0MHjn4qGW
         lUNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zR9kLKd2pi/Ct8sxuTvBqNwVdvPi5QWYN7lXDP7mi0g=;
        b=pjrpxvPpluZ6v+EAXSgcCJvxIpZjeTT9B0xZd+4P1Qaiy0K2KC2i7Lg0A2HrExx/yj
         oT6qQVXAi6Z2/EwgbAryM4NH5wq2IBXRZGFMkX/OUFjZvJt/bsDNDZAsDb3EJKzB2iow
         BbtB99kwnSkkkygd7NBLULV8ieu6TClq4K09ddALKBo1w9JNTOWbDfiJeylL9hhlcr4b
         bmLz1w9UZhCPS3zg8PscglJ8Ytkg/Gw7WuuT5ZtXYpDydsA+4w7jT2fxh1+2DtNrjOti
         uSwMrBPyMYRX8/0yEwWwaYiq2emvtuvRvXiayBAVXWPWVjuq+aUBAfsYUAua4Ib+8aJ8
         zbwQ==
X-Gm-Message-State: AOAM532UPGGDiBFugg+Qw4Nhfv/FN+PVKDwqZWfJUES4gndYYNYyEnVL
        XSHD+SPEy/Es7INEsIJcJoblcVHlr6e7Rcs/
X-Google-Smtp-Source: ABdhPJz1W53ZidVdu9bq62Zrt6NFwuOScXbcnXrwVXRkAiriHWR5ErFGx/nCVcBiUpblYKPmj2kXgA==
X-Received: by 2002:a05:6a00:16d2:b029:300:200b:6572 with SMTP id l18-20020a056a0016d2b0290300200b6572mr17851398pfc.62.1636768978978;
        Fri, 12 Nov 2021 18:02:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id on5sm3310163pjb.23.2021.11.12.18.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 18:02:58 -0800 (PST)
Message-ID: <618f1cd2.1c69fb81.97b5b.9edc@mx.google.com>
Date:   Fri, 12 Nov 2021 18:02:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-23-g317280d595748
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 130 runs,
 1 regressions (v4.4.291-23-g317280d595748)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 130 runs, 1 regressions (v4.4.291-23-g317280d=
595748)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.291-23-g317280d595748/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.291-23-g317280d595748
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      317280d595748dab3967ea44899aaa78e968fe73 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618ee340a3eb7221693358f5

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-2=
3-g317280d595748/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-2=
3-g317280d595748/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618ee340a3eb722=
1693358f8
        failing since 2 days (last pass: v4.4.291-8-g748a6d994abf, first fa=
il: v4.4.291-9-gf5954069c4ee)
        2 lines

    2021-11-12T21:56:59.101052  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2021-11-12T21:56:59.110551  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-12T21:56:59.128556  [   19.043182] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
