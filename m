Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C50D638AA0
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 13:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiKYM5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 07:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiKYM5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 07:57:48 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0344313F9B
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 04:57:47 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id c21so2201469pfb.10
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 04:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lcHQ7EJpJFMjLDWtd3D21lZU+V/3vi/ov9/TbEK/Xbg=;
        b=yAuVAgNHmxJ8+UxIUNE7js96c2o1JrMsdvgkAOedhXZjnHOZOvK3NyvIOAV1l1/9ZM
         zH2OBfhdj7e0aoO3lh77fdHffypPqEaqqkPBY8N/XToItV8gYH3WGznDYr7Zl2xEsLEr
         wjj19FTcMVuzyHLUhXhR2AWJBEqsZkTeGzp2KuQ2UaI1bDQgyg1+4fG4hx5WmdPxpsG1
         yvLZmG+mSXeApVIZIl5fSSEOwmzDGzywRfo8R9Ie9glTTesg4BaywesleaYWG9Gb1KAK
         bJpkmRepPOJg1PjeqBZOs3Ax3py9X6wIE4NbNHQ/7IthFWxpImjtqhJq7NiZNWjY9p1r
         zAcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lcHQ7EJpJFMjLDWtd3D21lZU+V/3vi/ov9/TbEK/Xbg=;
        b=Q2M3lWhwdDfoCY4iGNk9ydZDIDO38hDDkLYf5vbS1rMThLMznbRTX6tJ+CYPO3sfLd
         HAWwjAYYYE7IjBlC4dalVquNxXb+TJO1NNo1Ik6931JBv1CkXbRYED+U8B22e1QDGP6J
         ZLjpEJxyf4xKutwr/56fb5NmPc8FMYMTkC9RuXSWlgMalCkX9IxZDk8ANCjVZEWjiV/r
         oJNcy2IuS4907DyNYUX6KtJ7Y3cG13fJUuuq5o6nxwxxyF7+L0U/MZlT2Xu1QOATPB+j
         7hdZ8rRU6cyq0zolDufXIPCcpye9k1cO78jeHmMUPAL81Vy+iNZ4CcgUMk2G/fJn4P84
         tblw==
X-Gm-Message-State: ANoB5pmamBti5CR3eyNj03jpm0tJ6HgKdB+oO/5BgSwZM75CrsUYukuO
        6IUx926xGDpDn891o7F7tUuFpxJMc/eGny1s
X-Google-Smtp-Source: AA0mqf4qP21B9BiJO6hrnK8dCEOEyZRKTDX3ABFgtWnTl4prIuTtLFsB/8f87LiLivwvqj3kpPsLRQ==
X-Received: by 2002:a05:6a00:330d:b0:56c:6bcc:cf0e with SMTP id cq13-20020a056a00330d00b0056c6bcccf0emr18823793pfb.64.1669381066209;
        Fri, 25 Nov 2022 04:57:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i65-20020a626d44000000b0057458d1f939sm3007244pfc.152.2022.11.25.04.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 04:57:45 -0800 (PST)
Message-ID: <6380bbc9.620a0220.48df9.3e33@mx.google.com>
Date:   Fri, 25 Nov 2022 04:57:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.79-181-gd0344da1eca6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 83 runs,
 2 regressions (v5.15.79-181-gd0344da1eca6)
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

stable-rc/linux-5.15.y baseline: 83 runs, 2 regressions (v5.15.79-181-gd034=
4da1eca6)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.79-181-gd0344da1eca6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.79-181-gd0344da1eca6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d0344da1eca6840c665685e68ae82c09b301fc02 =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63808cbd389eec5c712abcfc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9-181-gd0344da1eca6/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9-181-gd0344da1eca6/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63808cbd389eec5c712ab=
cfd
        failing since 59 days (last pass: v5.15.70, first fail: v5.15.70-14=
4-g0b09b5df445f9) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63808b2eb2dab1c7b52abd3f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9-181-gd0344da1eca6/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9-181-gd0344da1eca6/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63808b2eb2dab1c7b52ab=
d40
        failing since 59 days (last pass: v5.15.70, first fail: v5.15.70-14=
4-g0b09b5df445f9) =

 =20
