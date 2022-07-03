Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE0F564383
	for <lists+stable@lfdr.de>; Sun,  3 Jul 2022 02:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiGCAiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 20:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiGCAiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 20:38:08 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D193A1B9
        for <stable@vger.kernel.org>; Sat,  2 Jul 2022 17:38:08 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 68so5741500pgb.10
        for <stable@vger.kernel.org>; Sat, 02 Jul 2022 17:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fO2U0NgZqKAwg8u6tlk7rEfGO3MSDJ0dO5ZFYwFRtHM=;
        b=icWTHI1rmXlq4oKRIC4CM+LR25oOLZZWhJLlwkNyQEFTo5799aI/U0jPVlSdLZVPa8
         nOM6/P6vEAXFK2L6H6GfRDmP0Nr8sDmhQPjad+JWGy6VoH9t3/EgabQXdN/uX5jU2JMN
         k7mcqNjjN19SDnCHBF9r7GsFTUAuifdBKyfzjpDAUsoUNDMIPFAXuDKCKXWol8ZI9HHw
         L6+0K41NPCK2qVHO9T3ETWXGKd0rTQavJb6bNS+waZcS3xKYLjIpl3vXsnyxfe3rGj7h
         80FotR2fwTVfQkDtIk+/GDwJfiUtFljdCmDml6n/JsjKlBx6XzzakVD5VPkc3mQnXMxd
         Xv6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fO2U0NgZqKAwg8u6tlk7rEfGO3MSDJ0dO5ZFYwFRtHM=;
        b=7Wm5xTZppDbvVOVPthFdh2n/aw4k+ZGZTrTOlxc30KSRil1fNpBPGvo8PMLNssVvTX
         hXd4xgre0qg+3yv9chxG7lTe8VkCGENAs3VBvlO57IEp/FylKRaqgowiqEDEBzCbiDCo
         bghUpkgfKghtcgk+kQ/rkrYDOQkSImxbW7C6LizpB/6V0liXRZbg1n0S4eBAv+q1zlX9
         AwqGrOQGZJjCG3E4842k1bqEXl6xP0Atznptj11ghBQ9pjMhqHDTSncvlNIWc4GevHnb
         XeGrYNDgqgtTa4N+hhk2TBiqc9eynlmeVUclnp8Uhbp2zTIuEZR/58WJxJ5imXveCGAH
         SREg==
X-Gm-Message-State: AJIora/iZ865Tw/0eODWcLqoi2kD20yY6SojQOvKFpOoqAbOjUFPzHjb
        dWCO0W2rrc8DuVS36tcbrtPNVWTdku4aGqDF
X-Google-Smtp-Source: AGRyM1tZAUf4K8L5Xz1c6uHTw3peJFxBm2pB9mpIFcT1z/3b8Z/6ptnFFeh50wT8H49ba9y8DCtlag==
X-Received: by 2002:a63:4722:0:b0:40d:289e:8637 with SMTP id u34-20020a634722000000b0040d289e8637mr18468875pga.362.1656808687361;
        Sat, 02 Jul 2022 17:38:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u12-20020a056a00098c00b00525184bad5csm18300512pfg.63.2022.07.02.17.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 17:38:06 -0700 (PDT)
Message-ID: <62c0e4ee.1c69fb81.20b3f.a073@mx.google.com>
Date:   Sat, 02 Jul 2022 17:38:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.9
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.18.y baseline: 103 runs, 1 regressions (v5.18.9)
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

stable/linux-5.18.y baseline: 103 runs, 1 regressions (v5.18.9)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.9/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      64ef7e725db41552c219a155ab8c1f6caf2e7cb4 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0ac3a199dc3439aa39bfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.9/ar=
m/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.9/ar=
m/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0ac3a199dc3439aa39=
bff
        failing since 33 days (last pass: v5.18, first fail: v5.18.1) =

 =20
