Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0A4533C78
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 14:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiEYMPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 08:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiEYMPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 08:15:36 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8C827169
        for <stable@vger.kernel.org>; Wed, 25 May 2022 05:15:35 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cv10so2873390pjb.4
        for <stable@vger.kernel.org>; Wed, 25 May 2022 05:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZO/Gy49BNDY+eaKuEB5zIC8gE8hIiVQ3ih+2tGinUzs=;
        b=IWEaiBo9P6NJ0y+L8AaqnxY/jCDFyzFtAQVq6G+X9Z58b7aCrF+Cuu2CZVGy6yOAyL
         Z5oEYvKCKRprwVA09n++2v43MEEspOIIZ0cf05FnTGpHWD6sI+3xMy67ikPrvPCeh/sY
         rJL1LneY8pAM8rEn3RqvZXpqt2sI3de6aAu8p/KCSCLgq7kgos65ZQliXcAgM8dsTfjk
         qRmUJAClXYBsUptzhdyi8x/tdkMLuEh/8cLcSiBsMrhxM3mZB0+W1j8ATpG24l9A03gj
         NygiOl/F8CEn/XkZu6GE60OKEt6DLL/sk1Zcgjs8cxatZhjwUv7nc1r+VPQljb61qyF+
         HKJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZO/Gy49BNDY+eaKuEB5zIC8gE8hIiVQ3ih+2tGinUzs=;
        b=2ol8MvyWAkdcenDa0a3NrCW2Ax4KVGwK1gDNw6nCnpuOojBSo3Rxap0QPvoUOM/uuW
         SIe+y9BZ8I74AvlCcu5eijppd/6A+g5cCMdy4jh3tOISISy+vLo5jsQCaglJiai8wl/d
         3UrYoAn9XWtKBGwJWtoeMW2vJYnimX7QWL2tpXwpG/c/v74nrVXoRpaSFzqZtAaxTJK9
         RUw8Ftmzlw+yiPndqr8oPSfIKO4G4i3iJB3INMhDNzLedsOJlyqw0JaPio+d4SbItJ0e
         5t6EBMjqI+IWWF1Q6KTdBOt+kfWQHx3PblVPlnDqhe+vzVSrFbSFGlC12YgeoBfhKxT2
         lM+A==
X-Gm-Message-State: AOAM533LRmMWWYX3YugkP6Bj8kmI3NQFRTsTgsr+pszz8U5HYOxIEUCG
        XOAfMe8kA4alpLiykKbdyEV4LCyUh5e2g+5zTzA=
X-Google-Smtp-Source: ABdhPJwvqKaCQXycGeMJrng2TTvzyTGIUFGuAR5IcieSDGmzrDB0phK6+kRNMrMt6ITGkIdLnVvD5A==
X-Received: by 2002:a17:902:e8cf:b0:161:f6f6:f68 with SMTP id v15-20020a170902e8cf00b00161f6f60f68mr24306473plg.13.1653480934995;
        Wed, 25 May 2022 05:15:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o2-20020a170902d4c200b0016168e90f2csm9272368plg.208.2022.05.25.05.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 05:15:34 -0700 (PDT)
Message-ID: <628e1de6.1c69fb81.76e92.546f@mx.google.com>
Date:   Wed, 25 May 2022 05:15:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.9-159-g2d0a99577edb
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 118 runs,
 2 regressions (v5.17.9-159-g2d0a99577edb)
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

stable-rc/queue/5.17 baseline: 118 runs, 2 regressions (v5.17.9-159-g2d0a99=
577edb)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =

jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.9-159-g2d0a99577edb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.9-159-g2d0a99577edb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2d0a99577edbef00c3ecaaa711f4021558bac3f8 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/628de99f2f6513923da39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.9-1=
59-g2d0a99577edb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.9-1=
59-g2d0a99577edb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628de99f2f6513923da39=
bcf
        failing since 1 day (last pass: v5.17.7, first fail: v5.17.9-158-g0=
fff55a57433d) =

 =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/628de5ca9a106536c1a39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.9-1=
59-g2d0a99577edb/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.9-1=
59-g2d0a99577edb/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628de5ca9a106536c1a39=
bd5
        failing since 1 day (last pass: v5.17.7-12-g470ab13d43837, first fa=
il: v5.17.9-158-g0fff55a57433d) =

 =20
