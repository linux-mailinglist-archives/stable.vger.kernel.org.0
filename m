Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484E74F7B7C
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 11:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiDGJYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 05:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbiDGJX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 05:23:57 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1253197AD6
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 02:21:56 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id o20so4321007pla.13
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 02:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BQr4FVuUXY/eKtIt9hc5pz2viVqwVs6v9svx1HZVrFU=;
        b=7NYpY5weG+jt0mdvFyfXLRS6jeBtxMI9Y7EkPK5JVjiGd+pkLmmCrUD1EXCozrDIDZ
         TwrkGSH+91ihT/opc7EXf86PmI0ETU5bMo50h+JOcNQzah7WW16CouJXrJxrDVyWl/i2
         KVP57ewS6O6z2GLWxs91bExzuKu1IjPxNg65h5/pcP8aUf0i4QxqD0mcBwTYt3vSQDlW
         eV84RCbGMism8rnqqicXfn4d3l93MzxDXZ1JZt8hqK8FWaOVqNbZxTAz1/wbDVJ9ie0U
         98kOvIynxpMRuL3ORO1B/YC2al5J9xWAYFFme3Z10u5xf6NR/I+3hiZhVMO0P988v/XH
         EY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BQr4FVuUXY/eKtIt9hc5pz2viVqwVs6v9svx1HZVrFU=;
        b=GlQW/8VhaG2sogTiX94mpFapXdm2pLDxl3SYZPkQzyDCNBVB0xEDTduLiL8XXyZWPx
         CVPTARPyfooDr2mgXH5y3qDQcFoiCET+HjQcwulLSZhkhbEIT5xIBpXmanu+ZScwC71e
         LOOKCPr7SZOET63SQRoK2ddsdGtw9gmnlb0/wIU2L9UGX4LIqgLABl053GiZcRpcaT7a
         kqL+ljqdjlEVTAdmBEWjeGUE2nGemMY2Y3ErXtBDAsf9XLG/HgUtd9+hAfPUnf30cP5s
         fcAu05NX70++pY8wsQ3TYkyv6227EbMtJllENp81XblqPicskpm+q5JDJs+aCR2L+p5K
         YZiQ==
X-Gm-Message-State: AOAM5327QKO9tbl50g+qYgs8z2FyHWK12f1QTEwqrLiYsayvuQISQsqE
        0Y1VD5B7acj2WurQPTrrSX0D6aLOl97XPm7fkB8=
X-Google-Smtp-Source: ABdhPJzYLNPCcGlVfs1epZDy1QrapONzkGkChVCts3qe7xF4QLSQQb2xodmFoKAARCxQoCYlGIQ93w==
X-Received: by 2002:a17:902:b208:b0:14f:14e8:1e49 with SMTP id t8-20020a170902b20800b0014f14e81e49mr12739777plr.35.1649323316121;
        Thu, 07 Apr 2022 02:21:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nn7-20020a17090b38c700b001c9ba103530sm8273586pjb.48.2022.04.07.02.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 02:21:55 -0700 (PDT)
Message-ID: <624ead33.1c69fb81.331b.6a3d@mx.google.com>
Date:   Thu, 07 Apr 2022 02:21:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-205-gd6a5c0b1db658
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 83 runs,
 1 regressions (v4.14.275-205-gd6a5c0b1db658)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 83 runs, 1 regressions (v4.14.275-205-gd6a5c=
0b1db658)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.275-205-gd6a5c0b1db658/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-205-gd6a5c0b1db658
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d6a5c0b1db658d7059a637f89571e62665062d52 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/624e7c812e242a8309ae068d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-205-gd6a5c0b1db658/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-205-gd6a5c0b1db658/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624e7c812e242a8309ae0=
68e
        failing since 52 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
