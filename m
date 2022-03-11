Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7A74D6921
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 20:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346815AbiCKTfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 14:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348041AbiCKTfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 14:35:38 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7FEA1BCF
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 11:34:34 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id t2so6010203pfj.10
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 11:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zgducnFCX1jdz3FHtvUMvdTeeQT0xM6BPjON+FgEBFk=;
        b=mhGkWlUfOXqnYg6y5/RMgaTlYO8hBFq0+sTUH6Zb1zLbc/PSpEdrKxqn1ICMEF7ai7
         uXDT7vE5QvZZGtRzGETbnAqMoyAOWD2MyFpfDKtPIO2bkFers1cV2Hm8j3LBFS/d0IuW
         QIwN9gUN8WxfZ4JHMghZpXOhyPMApmC+dBCbIhux86UbVpAaCMIQkWN47oZ+K99iRVBM
         XDwylCbTjVriSs2wLnDFoEdB2P9HnhFY22xBSuJkOwZQ1zaOEVZD0VOU1jMM96mSK7wF
         d9KRpYrGXbEBX4j0nnUzIRd2n/+a4D1TJeJC17Ghbd72die7oiXMhG0qP8ajNnygcqt9
         3yvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zgducnFCX1jdz3FHtvUMvdTeeQT0xM6BPjON+FgEBFk=;
        b=LbwmhZ6Tpy0CtNNiBvoFjwEjxaablkegxHG3UHYqjfAfPo90Q6BCyfCmc3t7lyrif3
         BgR1ctH+9nqLxVN7X585tnFmgErr1eNRTBGaE0FDzMJ+SImqNfO+OdcUMINFu7o5r60z
         dARm2s4CF0Vjm83zylRGEO/KqbtDT7jSUNLTEtLC1Pdael49jaK3sZcy6ST2pdd8QKcl
         W6hmg0fcYhMWKjkDwvZacTMQ0Kg/9BGlVP4AZFeTnXJj5HfN35sLffBX64xSSjVzhEKo
         lOBcr40FJrembce+HoaynVKeWhaoK2h7jjeNFHGoEUoII5/OykvkEnJqbb/53lcpCXwp
         UYPQ==
X-Gm-Message-State: AOAM533yqoJyfq0rNbnl4NUFqpkkO1/j+R4kKiCDMZTV+zvwAdIdp+rw
        k18ha+X7ZCPvjxCpxK6bhQendVEA4m0Aro+VX+Q=
X-Google-Smtp-Source: ABdhPJwIs3aMxeV1phym1/HlPHZv33GEpEXf1X5ClhNCHBugnmchqULTqRSqL/9s5XtmTUI/4pR36g==
X-Received: by 2002:a63:2d07:0:b0:381:e49:ae0c with SMTP id t7-20020a632d07000000b003810e49ae0cmr3365630pgt.261.1647027273719;
        Fri, 11 Mar 2022 11:34:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b9-20020a056a000cc900b004f3581ae086sm12489271pfv.16.2022.03.11.11.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 11:34:33 -0800 (PST)
Message-ID: <622ba449.1c69fb81.6956d.f721@mx.google.com>
Date:   Fri, 11 Mar 2022 11:34:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.233-33-g7f14a8aa5043
Subject: stable-rc/queue/4.19 baseline: 84 runs,
 1 regressions (v4.19.233-33-g7f14a8aa5043)
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

stable-rc/queue/4.19 baseline: 84 runs, 1 regressions (v4.19.233-33-g7f14a8=
aa5043)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.233-33-g7f14a8aa5043/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.233-33-g7f14a8aa5043
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f14a8aa5043838c163913de339bef48851b397b =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622b6c6ebfdc988911c62973

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-33-g7f14a8aa5043/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-33-g7f14a8aa5043/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622b6c6ebfdc988911c62997
        failing since 5 days (last pass: v4.19.232-31-g5cf846953aa2, first =
fail: v4.19.232-44-gfd65e02206f4)

    2022-03-11T15:36:07.457208  /lava-5859900/1/../bin/lava-test-case   =

 =20
