Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA40053663B
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 18:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbiE0Q7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 12:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240866AbiE0Q7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 12:59:06 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE46122B57
        for <stable@vger.kernel.org>; Fri, 27 May 2022 09:59:01 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id z11so5093274pjc.3
        for <stable@vger.kernel.org>; Fri, 27 May 2022 09:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pK5TM0c2WbTH5KEJGS+Jv/6pDCtH7/SHfLjAhOLp08U=;
        b=MRYQ8yvC0df9isixYTW7an0asGj6354lTTlcODbXob3I8+7pZR8XMrHLVKcXp1kyH5
         CktYzIVtrRVzeObD7iFLsaGyNgHbrFoYym/809wq4CXMyZ6l3ZA0aHpQfjVEm5lBmhlF
         rIWrfCjTdwlWmtf1txygZIfsex8M/Xd6wtgw2ZTlrq24g0UqakgQFc3xaf193zk3AbUY
         iBCKCj+lmIVi0XY945rAKXr3v/77rx9nWCepc2cL8SWp2Xf9QRR2TFE8ymIfUlXMFhlz
         cUFHTKfVRlP4b85lXHB7AiyYo0MlrISRBCI5LDn3qBV+cMIePuBS1rDcPn3L7x2qRM7Q
         d+wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pK5TM0c2WbTH5KEJGS+Jv/6pDCtH7/SHfLjAhOLp08U=;
        b=M+dJPBPm5p5dh8d4a14K/QqPEDC8qdBa4R2nlQJNVUini6jjh0sVGAh1ysANjTO4Bv
         Piz1p+9AKlMNumIcd4yy6k3eku6ZVY6YOS319/6ptTaIr9sAEvx/VvinaZqmSh7x/M3E
         yfesqAlxcl7udmAdRIK9L9Aj8NSEJVnZeV4Yv/vyyd4Tnx5PwwvRWP8MUrOx/OSGZ8No
         dBfFYr8RHxDxbUgTfoCgg2nGVLngRz70tPznSgxHFaCwuQG/nYxR7vxB6psgTi4puIws
         VPvyX+xmPPvGBRnwxswPzbgv8mXq+2BFKLRoiW/IiCQQ5ogTPAjB/BeQcT+XkE8yZPtv
         39Jw==
X-Gm-Message-State: AOAM532Jp2DTc40m5Ra1qZqGA6FemvUCIATWwa/5ujJQ1WazDgpREXWw
        8m2UCRjF1f+vfaxQWhDsFO0l1LCQ2xwi1x76tVE=
X-Google-Smtp-Source: ABdhPJzslugWYhAADY7dxxjjm0vuVk8nVWLsKWncI5T7+KPg9PENwfP5ElPA6ssOWvuQZ+jm96fgMg==
X-Received: by 2002:a17:902:ef48:b0:159:51d:f725 with SMTP id e8-20020a170902ef4800b00159051df725mr45114137plx.47.1653670741323;
        Fri, 27 May 2022 09:59:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p12-20020a17090a748c00b001d840f4eee0sm1869779pjk.20.2022.05.27.09.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 09:59:00 -0700 (PDT)
Message-ID: <62910354.1c69fb81.25515.427e@mx.google.com>
Date:   Fri, 27 May 2022 09:59:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.11-112-g118948632858
X-Kernelci-Branch: linux-5.17.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.17.y baseline: 48 runs,
 1 regressions (v5.17.11-112-g118948632858)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TVD_SPACE_RATIO,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.17.y baseline: 48 runs, 1 regressions (v5.17.11-112-g1189=
48632858)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.17.y/ker=
nel/v5.17.11-112-g118948632858/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.17.y
  Describe: v5.17.11-112-g118948632858
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      118948632858649db5531086bb74e586db579fbf =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6290c9dafc6c44bd9fa39c0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
1-112-g118948632858/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
1-112-g118948632858/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6290c9dafc6c44bd9fa39=
c0f
        new failure (last pass: v5.17.11-112-g539bc20dce9f) =

 =20
