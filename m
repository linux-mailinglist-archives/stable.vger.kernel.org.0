Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5247E4D3DB4
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 00:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbiCIXpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 18:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234529AbiCIXpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 18:45:49 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A76C7D5E
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 15:44:49 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id z16so3627750pfh.3
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 15:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+r42TtkjZLx7kcSOgX+86B3a4H50dQbksvKjAzTevq0=;
        b=4zGEWlYT7WuOlvm3yFv/zU1t1UPZ3+ZnMnuFNMDOCBoi8vg+m5TP2dmtf8k0dhJAo/
         EggghNglku3mvCTbkqi5XKiJeuIfBOz9sk/9D/y+Z6ZoKfxfpGvisCBk3/OKCmD0sxbC
         wnJBByx1ZxXKL49OZYHM2woFn5kmldPqVWj9d+u3Z+nOfekY/Wh+rSomXRSfZ7LvrEnm
         1HUbWnrSvAC1vv4U2gbLleMcmON3tJUqz8+1JR5417Ghr+N+SBZ9F2accIPIAAAPqA+u
         mY/GYptl31AsAC7vHohen1ZcMhxmhLqqRSJEIStdRYFxeYYC23rjEWhxlU4DuooLn4WX
         mjPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+r42TtkjZLx7kcSOgX+86B3a4H50dQbksvKjAzTevq0=;
        b=XtVH2Ukxn9f6Hk+yOrDWE3SKwbh/mFv4XhX5rVUaT/1iVye2NV0UWEk2fBJU28k89B
         oUbD394xJN9S57tnOxM35hZrIfAVAvxsiUSiYRTWIb9DLrInPW8U+fevaSkLvjj/XRu7
         c9lqwiVEVR9fP52UmZBRjyYiV9O0yXEgTP1kV3iJ84E0CNc/q+ddk+njWhCv+Uuy9vhn
         ICnxa0c3a4dWaaFHb2X9FxpHH6BTMyYR6tQqK9PyTwz8wbHEhRSKKMPMeRNfh8mRNFqS
         VZrBey0zcK/ojI3q7tzTxVwYeee+3YsKMIsSM/+H0zcgUJnMnOyeckxbcAOABEi4Oi/N
         h2CA==
X-Gm-Message-State: AOAM533tY9yD3kYi9l+AExIsZCDvZblA1Mkv2OdYQXEBUVGQcaObLKZa
        O4Tr7PZD8yGqIrrpnkcvSJksMhBMl5jtrHBtIA0=
X-Google-Smtp-Source: ABdhPJyjac3E5zna8moR9vpmRM1LdUb6+pp4VoASlAGE8abMFpzU8KzXRDL8Igke/rIzcFkdUR5GbQ==
X-Received: by 2002:a63:5756:0:b0:36c:67bc:7f3f with SMTP id h22-20020a635756000000b0036c67bc7f3fmr1736222pgm.389.1646869489142;
        Wed, 09 Mar 2022 15:44:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m17-20020a639411000000b0038011819be9sm3475428pge.41.2022.03.09.15.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 15:44:48 -0800 (PST)
Message-ID: <62293bf0.1c69fb81.e67a2.90e9@mx.google.com>
Date:   Wed, 09 Mar 2022 15:44:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.183-19-gc8d8adff2654
Subject: stable-rc/linux-5.4.y baseline: 48 runs,
 1 regressions (v5.4.183-19-gc8d8adff2654)
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

stable-rc/linux-5.4.y baseline: 48 runs, 1 regressions (v5.4.183-19-gc8d8ad=
ff2654)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.183-19-gc8d8adff2654/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.183-19-gc8d8adff2654
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c8d8adff2654c27d378906d4a4d90ed1ff2afa15 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62290aae3ac537386bc6296c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.183=
-19-gc8d8adff2654/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.183=
-19-gc8d8adff2654/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62290aae3ac537386bc62=
96d
        new failure (last pass: v5.4.183-18-g706b33173b11) =

 =20
