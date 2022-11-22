Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4807463484C
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 21:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiKVUhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 15:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234858AbiKVUhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 15:37:02 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A275132A
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 12:36:52 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n17so15026658pgh.9
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 12:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=MizmX+ilGmU5uyw4uWgsNB6SYxlVOs5Okdj4h4pAv0Y=;
        b=sxrZsS3Wv3HRbDbfahT4Kt494pTVs/NgSgeSQXKMLQ2tm0Skb8fnu+FJ5MwiyTIA+0
         +8vXqK+TyDF8JxlIrUvRV4IuCvTTg7JCqUtpxFvFe8jd9gxQs9cEkSwK1nlzP+5rHTwM
         B0Ksd0h6F6kviJbe/2AmFLPD2uz/yxerh+mbCaYqicnDeMPwoCpsRyi/UWSBEwhvhdcC
         TYpAPgm+jkgWICdCQKy92iyNU0rIkxcKc6M/2ZGqYSonw8xuDlyNy5W+Ac4RPJDc0bBg
         U0XhA0a0/IRZGJLaBkUSvPa1TPYNWKC8aa0kI7QWsYuBLQOScy5cqJ6jEuiC22lwXBfF
         OUew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MizmX+ilGmU5uyw4uWgsNB6SYxlVOs5Okdj4h4pAv0Y=;
        b=CPPzCcBVqmwgjnkAYBdEYvp+wYZlpPD6503acmbOHRLF6+YB0jVDkjBRALapTlqkYw
         423Z7Asp9xEbuJrMTF0rsBkxX3uZyogJj+/Pcjgs7BVDunhZzHp26OMSkqO4Lw/WrCf+
         kOrVPqnNIhBm3fr0i+QNJT/iPQTK1r1VOPbkVTVzKFBPFQtNUkVZL5RzR4sDjy+v+Ptr
         3b7u1rk6NfEmP/FcHArSJDRvMwr9UhGhkTxRgDEH7Av1leXCmxhQeXvJYjy9Y65PCcPM
         ALvRMwQMHHri1Qz93+8VKlGAW7JPYu/cHRMNmgpkIru7Xa4+q8pHmHgRKP+3dFlTgazb
         7jFw==
X-Gm-Message-State: ANoB5pkfky4OM/iXjtIMag3EZvDsDDICm1wmX5cX0enDhgYpwOAiMfqs
        LeQqXMRdGQ4HHefviF+6Fq9P+AGT4+71xSWzm30=
X-Google-Smtp-Source: AA0mqf4Nay7FVk8ial5VsnugREZ31CBoLSVNN5yRPjgE84qw4J8W4fuNApLOcwkiuD7MrQEELQo7UQ==
X-Received: by 2002:a63:cd52:0:b0:42a:9ba8:8c6b with SMTP id a18-20020a63cd52000000b0042a9ba88c6bmr23650272pgj.407.1669149411702;
        Tue, 22 Nov 2022 12:36:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u12-20020a170903124c00b00186fd3951f7sm12564596plh.211.2022.11.22.12.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 12:36:51 -0800 (PST)
Message-ID: <637d32e3.170a0220.3abc7.384e@mx.google.com>
Date:   Tue, 22 Nov 2022 12:36:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.79-168-g4e95de7f731c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 143 runs,
 2 regressions (v5.15.79-168-g4e95de7f731c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 143 runs, 2 regressions (v5.15.79-168-g4e95d=
e7f731c)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.79-168-g4e95de7f731c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.79-168-g4e95de7f731c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e95de7f731c573ae9710d9f97b459ac735549fc =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/637d00c56751963dbb2abd14

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
168-g4e95de7f731c/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
168-g4e95de7f731c/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d00c56751963dbb2ab=
d15
        failing since 58 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/637cff5cddc7d5076b2abd46

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
168-g4e95de7f731c/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
168-g4e95de7f731c/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637cff5cddc7d5076b2ab=
d47
        failing since 58 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
