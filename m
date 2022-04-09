Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA594FA588
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 09:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiDIHNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 03:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiDIHNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 03:13:24 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E487325EBB
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 00:11:17 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id u14so10624356pjj.0
        for <stable@vger.kernel.org>; Sat, 09 Apr 2022 00:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RoL6ELnPdlCfW5gnwZNd9XwYpDmQklA8HnOmZgr6aEc=;
        b=gNm1SDErnqZlMW9mzjQCNEwNBHgDQl3/Klp6T4TGKZVqe99JL/6aEiYSKbLVU0iOzN
         NTHU7iZP2DRFLz43SQEHMe0jNNa4bk78x1jJ2UmPhYCRacJLRascymPe9ALBKiEyxgp2
         IwdflXslOgGd7aRfJ34ZxE1R7bkhh3wiGB5IsdR2TNmdxOYnZtxKf25ucYxgd/5rY1Jy
         eQ6TlhdzgTYkZnxU97O7xvVnA73/1YbupP70O64ifV+FXtTCkoO2lwyfvt+apqi27fr0
         p3VSRLtF1ORwq51lhWczaZKOEmOmXVoXXEPZU31G7DXn+vV+4BmNa2XNYAOqHXC9Ul7Q
         Ou3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RoL6ELnPdlCfW5gnwZNd9XwYpDmQklA8HnOmZgr6aEc=;
        b=JG0+o2XfmURmfv20WGBlVvWktNFHT2E4h7ElMgUb1pBBLBcpp1T3Z2xcHTGGdB3lFI
         FHgCg+1BzJquAUQsjia0MbsASsvJl4cEL2/qFsiYYBpRahiGVgVI8d3AdA2I0OBQwBVS
         cWEVMWU739hmj5r5CKqj8jJv2mqpPfN0l9XHaioFRqcdYgd1ty7AfYW9okgi0EdxGeXt
         azzAi/Z88ljIkfrkKXkK4zUw9FlmuqMtEFk09zRTAPWz0E05WY3EqCdClNNssKBMurST
         SeKnIehaeXfoEwMYAZkL6t9mnKrdFuqWKbEjdhamm7ROLneD/qdDYhx3OZeAPfpmDHLT
         jNnA==
X-Gm-Message-State: AOAM533Km4TT/6P2fAFWQBrTYLzS5PNGst7VxYoj6DC1dCCWo+l/Qxzh
        pPZBsjp+xoi8E699s5EUWFMNm2jJd90bMdG7
X-Google-Smtp-Source: ABdhPJyW44l2LQrMW6o9XbRzzAcThmF+7ZoDeEx8MP0182B/R7Oogw1SGbYHtPxSX1xeTgXMuPvBug==
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id d22-20020a170902729600b0014b4bc60e81mr22602176pll.132.1649488277338;
        Sat, 09 Apr 2022 00:11:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d5-20020a056a0024c500b004fae56b2921sm28081290pfv.167.2022.04.09.00.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 00:11:17 -0700 (PDT)
Message-ID: <62513195.1c69fb81.45aa2.ab8a@mx.google.com>
Date:   Sat, 09 Apr 2022 00:11:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-205-g5403ad1f31b6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 91 runs,
 1 regressions (v4.14.275-205-g5403ad1f31b6)
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

stable-rc/queue/4.14 baseline: 91 runs, 1 regressions (v4.14.275-205-g5403a=
d1f31b6)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.275-205-g5403ad1f31b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-205-g5403ad1f31b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5403ad1f31b6cb37ca54c89b6bb1c079953250e9 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/625100c171a2f8e331ae0699

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-205-g5403ad1f31b6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-205-g5403ad1f31b6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625100c171a2f8e331ae0=
69a
        failing since 54 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
