Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDDB5B7818
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbiIMRhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbiIMRgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:36:48 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375AE792FA
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 09:26:46 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id s18so6403966plr.4
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 09:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=IarJhYm+OKMEiwpTVCuhCEbV2SnEt5GDqE3OKdpQdmk=;
        b=Rk/UPs7l0QeaKgMiWLbCKsc9A5LVy5yWvqAE5sbBnzB5K/d0rR2zNFHUSCnHDt/RPe
         TWr4ijTcZAXrS3de7tSG6lserNxxR1E+qXWJlJIpwrqlSkLqrtaYmDiPM2dzGSeXGOPE
         EUBHw6AWyON2xvsQmkWZdKuLZ4Sq3R/qpCnKQNA6/BE/IzBwZZ8DlAmahQO1Hb4ylIf0
         QbPGgSqPEs2bswfl0OViuT4hXNGOT3DyrlNiZqpAvGtLRxF5BmR62kczpdjvlK8SsN4v
         eil096G8UEyaa1NbmXxtPqD9yCK4a6G9r2MVFapRWaCERQVfJEGwK6njN27sOnnnwTYp
         isFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=IarJhYm+OKMEiwpTVCuhCEbV2SnEt5GDqE3OKdpQdmk=;
        b=UZcnVfT8PznkIoK3Lfc0tNDXutg4aiaCoCFrLHs9wlU5mdmDZHtYty41NIMyIU4Mnz
         iSxr/AL7ngC8AXvyJVDTh6xsIKq+6ZCO06NTGgmLBSYvlj0uVtlyqapRiL9hat+gC0jk
         aq1NcFJBfif75rfrwxrzEhLljcKzZusQ/F+XdFOSiJhz3Z2ZUhd5jS5xWMoiqhlHfPBE
         /FtfFDRkAdMT8gPn6XvRVgqN4nNUDWCRg/3ky/n/WZr+Atdmw9kxO9VLFcKxw9Sy5TcE
         zgLeRmJF2BL031K6syZUhoYQEjjoBHb/16XFcPjCkQ79k3kmruIsXHzh43jeeikIe+za
         Vz6g==
X-Gm-Message-State: ACrzQf1mKF9kjovJMe2eGEQRj5tVyD7Wf5zNSNsoB8R8qwW10+avI93r
        r28yiDo3U1piOr1kgBME4sH7AvqTEa2onVqvfRQ=
X-Google-Smtp-Source: AMsMyM4X5Tklx/GT2q4Ryhh6zyrdTtktHUvTDoLztX60Kvpdw0FoH2FEyNtLQpJUygNOemWKToHVNA==
X-Received: by 2002:a17:90a:8688:b0:202:91d7:6a53 with SMTP id p8-20020a17090a868800b0020291d76a53mr80078pjn.153.1663086405033;
        Tue, 13 Sep 2022 09:26:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w63-20020a623042000000b00528a097aeffsm7846305pfw.118.2022.09.13.09.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 09:26:44 -0700 (PDT)
Message-ID: <6320af44.620a0220.5e719.cc29@mx.google.com>
Date:   Tue, 13 Sep 2022 09:26:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.292-62-gf491214424eb
Subject: stable-rc/linux-4.14.y baseline: 6 runs,
 1 regressions (v4.14.292-62-gf491214424eb)
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

stable-rc/linux-4.14.y baseline: 6 runs, 1 regressions (v4.14.292-62-gf4912=
14424eb)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.292-62-gf491214424eb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.292-62-gf491214424eb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f491214424ebd5c0fd6a04a0058731320917d375 =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/631f71633769c13df135565e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
92-62-gf491214424eb/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
92-62-gf491214424eb/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f71633769c13df1355=
65f
        failing since 4 days (last pass: v4.14.291-43-g3eabc273fb308, first=
 fail: v4.14.292) =

 =20
