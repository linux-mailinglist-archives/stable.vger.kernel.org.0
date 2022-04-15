Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28914502D26
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 17:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355493AbiDOPg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 11:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355487AbiDOPgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 11:36:46 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D827E7F47
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 08:32:24 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d15so7350803pll.10
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 08:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZB15G09CILyPgOHaC4m4blwrgbvvCm5BELNRG8Ndy/U=;
        b=Wqix5zs66aCrlhjz6EXsDnONfn+JXfgfK7WSSbjowWEF0IsEyguBKfnenLwsn4qa0R
         4udAbhvuDYiMAseG0oGTg69aukFwE8wHiTokoBRKa2hxH84LmKfqtJT6ncwLzLug9NVk
         amgbfmzKXP8u+oCFjID3NmucxJC4klBji4c/PpRqAsNFGSC/ATReIKHtG6VEMwgBVE+G
         tmX9WHT3R+vgXM0hZDZh4wqZ7p84sZv025OrcUVwnnr0ezWoeQGLg0EGM20Rlr6cC5Ef
         Rl0PPnKxznIqyA9Kt6u7QrPs3XFKRQ1cDV0aTnf2zROESlma9zlXoCBKuP7LaDsa9uwe
         NrAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZB15G09CILyPgOHaC4m4blwrgbvvCm5BELNRG8Ndy/U=;
        b=W6OxGmvNDPA+aaYLO8vIkphcAD9Wcqb3T9lK9ooVIeJuSdzk0cRdTrJf1Q4iejHX6f
         11y3HuSeWnib0rA9DH/4uUp9qeB9rbLrOoCBXls7lsCpID/PzR2OatKXNMP//xt+CQJ6
         iFbdtU3xcwoqAA3rpW2OM/S9WRlUbkADCGif2zdIwFMrlcnvSYc8gJZatur2+Qwf98k1
         Fo7tig1NjetjlGEZJdqCtdZ+n5PnjVXqJCah+hqnMya3zxo+oKBE1fXfSEprBLt14vmm
         SsoNy6dElH7asaqvXg/jgGNKXTP4UmBnZbKorHWpeA2eTYbkURrdWH+VNp0hDOX7d3lq
         iEGw==
X-Gm-Message-State: AOAM533rQadSVDicTzMAI9AWH8bFPvdYWFkAhELUWPp/QY9s+RzK5eLI
        5bgLN/U4UPvFoqSJJjm8SYoeQrfDqFI4govm
X-Google-Smtp-Source: ABdhPJxeFF4v+g2ETQxosSc5ihyBoo6lx+caw14/gev1vDUnn1Xrd3HP6ORey1C2CpUpipRMrYxpyg==
X-Received: by 2002:a17:90b:3b8c:b0:1c6:ed78:67e2 with SMTP id pc12-20020a17090b3b8c00b001c6ed7867e2mr4771458pjb.163.1650036743191;
        Fri, 15 Apr 2022 08:32:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k187-20020a636fc4000000b003983a01b896sm4649015pgc.90.2022.04.15.08.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 08:32:22 -0700 (PDT)
Message-ID: <62599006.1c69fb81.ac6be.c5b6@mx.google.com>
Date:   Fri, 15 Apr 2022 08:32:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.17
X-Kernelci-Kernel: v5.17.3-57-g5e21d22d278b6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.17 baseline: 111 runs,
 1 regressions (v5.17.3-57-g5e21d22d278b6)
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

stable-rc/queue/5.17 baseline: 111 runs, 1 regressions (v5.17.3-57-g5e21d22=
d278b6)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.3-57-g5e21d22d278b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.3-57-g5e21d22d278b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e21d22d278b6f5fd37eccdf324dcc2f17a5d16a =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/62595c4824c56d1ce1ae06a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-5=
7-g5e21d22d278b6/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-5=
7-g5e21d22d278b6/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62595c4924c56d1ce1ae0=
6a9
        failing since 0 day (last pass: v5.17.2-343-g74625fba2cc43, first f=
ail: v5.17.3-7-g214113ee8b920) =

 =20
