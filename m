Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B3B50497E
	for <lists+stable@lfdr.de>; Sun, 17 Apr 2022 23:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbiDQVEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Apr 2022 17:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbiDQVD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Apr 2022 17:03:57 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77B6DEC0
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 14:01:20 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id j71so1943420pge.11
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 14:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UmKCZdZ12/X0EEaWZFWajqMzRNStEBBBTbHDai69luU=;
        b=kGAY7SUDmVSwKHpFUJQfIVLWCrQmkYA1N/09VfSOe7ODwm5iDMbmMTXml6o2betqXa
         l2U/hDG93MUl7H0BgohYl0oqxGJfAgNNcAlRGjnx3WPBdRBxgXfooGY6V9f7ZTWX9iXk
         UstpY2at19BiNR9SmFwI4i1S7UgZvbSwoXpyFVl+2qY1DUKYT4cnU9szAExJsZr94gMy
         brO7M2BFkBn8poPP1axVOaITslPjdgFh1QIyvB5aTTQYOcmvItZ1VMgyHbxOkw1Kl0WP
         /wFgr/xh6h3iWc7cCha4VTVeMLyHglnCiSIUOuLcrG+WkZYCA5HmP/HhDYR2W7DgryQh
         3G7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UmKCZdZ12/X0EEaWZFWajqMzRNStEBBBTbHDai69luU=;
        b=NsdbaMIBRRVPL6+Pd+amy6moOgIu/aJb8ZzhnF4MyVyTlYAe+mPwjBYR9XKdUt737E
         NN/SRIxXioMDMoNmacAcuyWqkg4sJKa9fsgAgGav1h6ktqfczLMTDDerECk12HRPlJ/+
         7iOadq+nPG/4LTSMH7we4wvcZ9YrotPInpeTQGK0T03/3dgCkAC5d11Nhxe4WkUxDNEX
         vgTclY/xe1WpFUOyBt4wSZtFVnO6TdmUsdmmJ21TfDzrTl5wTSAjCYTdukv3mzLVLQe9
         fE1JxCaK2eBcjEuD451LBjoDfVQIzfHDwcXQFLYa6nkLB3t9NvL6SpEU6ys9PGa7Olav
         fT5A==
X-Gm-Message-State: AOAM5328f6REutCrcX2JnbqySzd7EDOSVGvh2wY2LmVp2Q+NkZoSLOgG
        BvgErUPiLY2X0eRs2uJW9+V3BNpVNA5VUwBL
X-Google-Smtp-Source: ABdhPJx4QsjB8F3/gQSQyI8+nIUqw6nW8z9h7STnHg+qK/K2lSyeITXT5R6b0e9VVbxa3cpKCa1jmQ==
X-Received: by 2002:a63:de53:0:b0:3aa:8b0:b690 with SMTP id y19-20020a63de53000000b003aa08b0b690mr278082pgi.580.1650229280181;
        Sun, 17 Apr 2022 14:01:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w14-20020a63474e000000b0039cce486b9bsm10495161pgk.13.2022.04.17.14.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 14:01:19 -0700 (PDT)
Message-ID: <625c801f.1c69fb81.b3d2e.9577@mx.google.com>
Date:   Sun, 17 Apr 2022 14:01:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.17.y
X-Kernelci-Kernel: v5.17.3
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.17.y baseline: 145 runs, 2 regressions (v5.17.3)
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

stable-rc/linux-5.17.y baseline: 145 runs, 2 regressions (v5.17.3)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1     =
     =

at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.17.y/ker=
nel/v5.17.3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.17.y
  Describe: v5.17.3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77b5472d00d158866e2e1d03c13862b428b65405 =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62572ae5741b3b7236ae06a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.3=
/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.3=
/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62572ae5741b3b7236ae0=
6a4
        new failure (last pass: v5.17.2-344-g66349d151ef98) =

 =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62572c393eab180e5fae069f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.3=
/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.3=
/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62572c393eab180e5fae0=
6a0
        new failure (last pass: v5.17.2-344-g66349d151ef98) =

 =20
