Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017B04AAD21
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 01:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiBFABp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 19:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiBFABp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 19:01:45 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75F7C061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 16:01:44 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id h12so9204960pjq.3
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 16:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=klr9jHH7/4sTBWTKVajYy63VoHspNQiDOnO9zdyInn8=;
        b=hU1IqmKyaXhWsSumXSEQxBUPYEyPfegTP19xbiyso8sYwRLnIxvV1/OmEPvXR0EGQ7
         FIBlHgZ8eZFQKPERCELLVTkgX7HMJW5FDWEwjcp2azCvZ7h+GgW6DcYxZqbco12if4DG
         ItExN/FvB1YlLyiTJpPe0vTKhMNIY7hmOZwb6x0nmKhm5H2fFD3IwWhW9/u9n/c2p4w5
         0bYrTsULWp3vIZ48kbHfv39ahdOiWVDkWFcnDPGM3zdHP0qJJ9T+kWO95vvqLlVhBxfF
         y52Mqp1PVzHQSkZrLR5r/qUsYKLxGNaOe+9G8MJC8hj5CPtdu3N9PnKI/krQWoGfsLyu
         2DhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=klr9jHH7/4sTBWTKVajYy63VoHspNQiDOnO9zdyInn8=;
        b=RpMIUxTti74c2LokI4QSn1Ms7IwFSk9w6iC7w3zbFoKbVKCLDAc9J2fMNd8/2aZfyG
         Vih4lB9pO2zcdRPl5r4pA5TpblKaE0QVe9aiUMD+XNxDSJ2HB0t8IM2SzyyLFotY9qQ6
         txDgZIOV0cO3kFozps1/1JrJZc7ORl2RoFYiAmcXiW8yTlOEEoOSEsjjG3Lp8z4bSuu6
         tS58VbCZNvhajmyVgfoirGlKfKCVaUx67SHDrLDtxYmW8XO2m89brMEhddLgMrTcJrQr
         FrIdSxzBlDZ1qCIqY1u/DCJdsaETTnTA0nODqxC33TO6D46Qfd/MlCQGO7/rA8Oe7d+V
         Q3LA==
X-Gm-Message-State: AOAM531aI2PcryxybFuU/V/TrNhPlqpUY8GpzM1UdN0kpz5QczD3wlUM
        7csIYj8bxng+OuLpIqP9jpGFioaEsCRaQQcb
X-Google-Smtp-Source: ABdhPJwLpYhMPqr2DkEkP60fo0ig/lI8LNN4fu1Hujjbvi22kiuR9u4xRvFO3E2OEonOeJVrt2E/jg==
X-Received: by 2002:a17:903:300d:: with SMTP id o13mr9834349pla.174.1644105704217;
        Sat, 05 Feb 2022 16:01:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j12sm2658897pfu.79.2022.02.05.16.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 16:01:43 -0800 (PST)
Message-ID: <61ff0fe7.1c69fb81.af932.5807@mx.google.com>
Date:   Sat, 05 Feb 2022 16:01:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.264-51-g39796219a1df
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 91 runs,
 1 regressions (v4.14.264-51-g39796219a1df)
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

stable-rc/queue/4.14 baseline: 91 runs, 1 regressions (v4.14.264-51-g397962=
19a1df)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.264-51-g39796219a1df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.264-51-g39796219a1df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      39796219a1df59ec9da022c2ec9199c000dc3791 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61fed93eb878bded505d6efb

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-51-g39796219a1df/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-51-g39796219a1df/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fed93eb878bde=
d505d6f03
        failing since 0 day (last pass: v4.14.264-40-g54996bdd9ffc, first f=
ail: v4.14.264-45-g6b11d619aed4)
        2 lines

    2022-02-05T20:08:10.621922  [   19.963989] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-05T20:08:10.664933  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2022-02-05T20:08:10.674316  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
