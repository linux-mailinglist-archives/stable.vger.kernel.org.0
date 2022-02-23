Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98154C061E
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 01:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbiBWA3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 19:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiBWA3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 19:29:16 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E513F55756
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 16:28:49 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id y11so13723198pfa.6
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 16:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IS7tS0oVawEIHesPRiYmODg/8YSxOnCZ3aVgT4xceeY=;
        b=0HAFql679YV8VLi6hYiLt1fWkp/QH4bCIVbCKtlY/1D18V2QUIk5hlZrobM4R40U+T
         GRSWGqVk/2Ez6PR/e8B0Nemc2zJ04ik3AvGNEnMoDui22J9FzVz+6cR+MuWEcxOEvDRT
         kJ6NIrx8UOTb9hUy121XLcqg5nxFHxNRpBp7kWbCWta439kCsD2aEacabpZVQPnj67Xb
         YbjVfKFUYPL8tsuJyq8jZ99OSrFPaBN8LhYMo/uqV4s9zIMWm90az4cRlWClbeQcwAep
         tvAJNgynhdLaZbBIQiVaPQdCl/kzcseZ/YsDuNWF9LvQ3SZPxGFvYFTgwfyDJ52EyVoV
         Ew5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IS7tS0oVawEIHesPRiYmODg/8YSxOnCZ3aVgT4xceeY=;
        b=y+oyasEDlLFqbKiNFRQsUEjKbvaEAOEr0GNYUYv5fpplBuzoIAshqqE6Oiq4OjsuXP
         nPzjuIR9haphjIJ9qe1YXoCcoP9/4glewBEz2bbtd8KuD6naniroqcefx1ewTZjTZWr/
         pd2hQdXqm93llgTGgPUocZSDpveTEo6wcEC1QSmwrZukTIgsqYVLTpnJsUa4BMLKM8PU
         moJPYoKftUYogQ4qppaoe+UkuTRmiroWL2yUVNW4/DYuJtkEKEaXDeGaNwMOb7oTZ+9m
         XZ0x/EJEzaaFzfQ3ZzIhJp4zwRwSxlxHIH0c0lAJXNznkBsUNE8t7Dx4zQIEdzL3ZzZr
         p6Dw==
X-Gm-Message-State: AOAM532V70jxO70zONz48Bl/xP+snWZ7J7WD5kiXTXrSrqs6YLYzvPc5
        jZiQeFevkEPw4+pG1WGs4V4t3wGnO/49nFIy
X-Google-Smtp-Source: ABdhPJyuasImCGPzO62GEqeTcHhvTQO01HiDrTZZ6y+Pncn2OeJbgRHCQIf7idhPmc9S4PQNSQFudg==
X-Received: by 2002:a63:c13:0:b0:375:5941:1fea with SMTP id b19-20020a630c13000000b0037559411feamr396243pgl.33.1645576129251;
        Tue, 22 Feb 2022 16:28:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 189sm18292500pfv.133.2022.02.22.16.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 16:28:48 -0800 (PST)
Message-ID: <62157fc0.1c69fb81.be81c.2511@mx.google.com>
Date:   Tue, 22 Feb 2022 16:28:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.180-78-g050647b6d8af
Subject: stable-rc/queue/5.4 baseline: 104 runs,
 2 regressions (v5.4.180-78-g050647b6d8af)
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

stable-rc/queue/5.4 baseline: 104 runs, 2 regressions (v5.4.180-78-g050647b=
6d8af)

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
el/v5.4.180-78-g050647b6d8af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.180-78-g050647b6d8af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      050647b6d8af45cf9430c4c38f3d59738b14d2c5 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/621543331e1479620ac6296b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
8-g050647b6d8af/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
8-g050647b6d8af/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621543331e1479620ac62=
96c
        failing since 68 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6215436fd47305459cc62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
8-g050647b6d8af/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-7=
8-g050647b6d8af/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6215436fd47305459cc62=
969
        failing since 68 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
