Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231AA4CD06A
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 09:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiCDIsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 03:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbiCDIsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 03:48:07 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AB9527F3
        for <stable@vger.kernel.org>; Fri,  4 Mar 2022 00:47:20 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id s8so2993353pfk.12
        for <stable@vger.kernel.org>; Fri, 04 Mar 2022 00:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4AF84kketuwVzBgheJqTbycF+OUZit10QKPysk5sNsU=;
        b=fKwKJUO60RYTR2BT9hjshEPXCsDaoiaEI5RRwMpivbZ5duA8ZIxes6Brs0Bw19zKbS
         Z3SLqAWrDJau8Q7rwDz5HdaqyAeGlFtNSQlgGJkky3jMx40iaY6Yro0X+PvKpOhY7/OD
         2n5G6Kq7JLadhN8/rlTW0qCiDLvQJyU9lmrU7i/FUM7QuSRLjMcdGkqyw+KUaGdmWQa5
         Q/Wk1A65xw2HuAloarO01Ci8agFTcqui/vI5QWlFf1kOKB9Kfs+thCUcPVrdo5NyIuzx
         8NeY7bXKHrkDC4munN10TX0fQDwqP1DAg/mxxoqdNeqSmrBttNVyasYtvnzRTUCDiaJn
         kyTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4AF84kketuwVzBgheJqTbycF+OUZit10QKPysk5sNsU=;
        b=y3EkucHIMmPKZ4OaFTfPpmeDM+sW2kgqshGZnvPeDcrWqspTzzrePhzIilXWHjUntH
         /cQL0bS4d2D5Wv8OYu4ZYcH6oQjI8VoPK4tcCLZAmF5/Trf5whE4F+58DkzFIrXXMpgS
         z4B362AInxNMJhGa8bglOfZiQrJ6XsQHLtcQhlmtK1kedGSt02rvhqzTtdytLX2WRC8R
         07FISfulic62t47nveS3Q6+X01Bg2VtOcrjmNkgjXo436Z4Tw8xsHUJ9NazLvjGP2cwI
         PDUApBA5bGeo0thiDM14J7XoK044cER/jWdUDwtokQuRQLAiRsIjumIW7MNWFVymF1DQ
         kPIg==
X-Gm-Message-State: AOAM5323WbJj5sgykW4k1qFUFIxqoWdImxwg/6f/Vp4dbcpL5hL+gz7z
        8f4F6v9dDkZJumWz3AEqgajAiqfmHcQIhjh+iUM=
X-Google-Smtp-Source: ABdhPJzMx2Q2Jp6l/snGpaUZz2S68P6RBm9/lD2nk/S7R3yQo4gkoUaYIJhopGUM0rdfL7dFSioi3w==
X-Received: by 2002:a63:e854:0:b0:372:fa33:c0a4 with SMTP id a20-20020a63e854000000b00372fa33c0a4mr33527104pgk.379.1646383639390;
        Fri, 04 Mar 2022 00:47:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o6-20020a17090ad20600b001b8d01566ccsm10355619pju.8.2022.03.04.00.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 00:47:19 -0800 (PST)
Message-ID: <6221d217.1c69fb81.5afdc.d227@mx.google.com>
Date:   Fri, 04 Mar 2022 00:47:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.269-12-g7dea77addaf7
Subject: stable-rc/queue/4.14 baseline: 54 runs,
 1 regressions (v4.14.269-12-g7dea77addaf7)
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

stable-rc/queue/4.14 baseline: 54 runs, 1 regressions (v4.14.269-12-g7dea77=
addaf7)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.269-12-g7dea77addaf7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.269-12-g7dea77addaf7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7dea77addaf711bd675c7d5b7ab62f96b0e9a5c8 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/62219ac0e4f00a3a6cc62999

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.269=
-12-g7dea77addaf7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.269=
-12-g7dea77addaf7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62219ac0e4f00a3a6cc62=
99a
        failing since 18 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
