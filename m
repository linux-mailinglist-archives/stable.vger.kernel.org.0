Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4CFE4CBE88
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 14:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiCCNJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 08:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiCCNJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 08:09:08 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607F712F40A
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 05:08:23 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id bc27so4471464pgb.4
        for <stable@vger.kernel.org>; Thu, 03 Mar 2022 05:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GWgg4DummqdA4+LXeC5zaakx12MdB3v1DO9GAZHbn8k=;
        b=ANsyitSbKtGnu2MCtesTwHRsybCf/fpFldFYM7Q8OuZ8Bee+iENwiPxrCwHM/7Cxaz
         4lrZyopg5woeS3oMHHpX9Ajmakup3hE/MRmckDvXF2Cb5KcLCiS+qBwAANkiFxh1RWIi
         2s3XeJitL75fL0LCfUfPXiPRtSWwoBu7XsmzFz/JADj74WP4/kP2XeItuqRHxPO3ksa6
         blL9kjhylzifvXJv/dpvaUEYELOuS4MJJA0fmMYZh8EZamEHBTIF+d4ISvlWXgqgE2MG
         Z2hv/ajKovTC4UwQC0b1YKCjgtdJ04Mf5W5trXKfLz3ouwDebPir0UCdwhsCKWaTcgqE
         rCrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GWgg4DummqdA4+LXeC5zaakx12MdB3v1DO9GAZHbn8k=;
        b=ltMBBv5ADGCt85IWTky/mXG+s4zdCAlKf6lbpeU1Zan7rpvPP5sXh5076eOzi2V2uM
         hFaawPeIQfG9m9QGlc3su4TPQs/5iiQGZ51WiO/29chaxIg+7y7HM8LKixEtucT5RvZW
         7FmiND2RU1V0ct20IawBdXU8YtebGoAbh/jJwjMJjqFj4EaUFsXRwtk78muaDjGBAWRJ
         ZQTFuiXaJakvo7VDKExtKr5IfMpcsMxryAVYzP5N3wwWKGmhDI+JzGYkv7RFBo56/Hiy
         hetjY8utHOTh8to7c6nu5GSoX1+n80yQr/LEW1vP7PMK8t1O5WENJM3Iwe0II3ioh4F8
         DHdA==
X-Gm-Message-State: AOAM531/EiVPE/+2DWxpJ/Y5RYe/Ls2FIpnEO5QcBTz95oFuVj/b7+U/
        NPHYsBvYzMyXhA3LEHsOLhIzGANg7hJn3RXYU9k=
X-Google-Smtp-Source: ABdhPJxQIGFIaorIjY3gqnFw3Ajo+LcPGnFrAnDGa4xbiHwPXcRGP8F00gL8Ja6EpbsJfdTJY1FTIg==
X-Received: by 2002:a05:6a00:190f:b0:4f3:a81d:c4c3 with SMTP id y15-20020a056a00190f00b004f3a81dc4c3mr38451499pfi.45.1646312902692;
        Thu, 03 Mar 2022 05:08:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j8-20020a056a00174800b004f26d3f5b03sm2640600pfc.39.2022.03.03.05.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 05:08:22 -0800 (PST)
Message-ID: <6220bdc6.1c69fb81.d4d3e.6467@mx.google.com>
Date:   Thu, 03 Mar 2022 05:08:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.12
Subject: stable/linux-5.16.y baseline: 75 runs, 1 regressions (v5.16.12)
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

stable/linux-5.16.y baseline: 75 runs, 1 regressions (v5.16.12)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.16.y/kernel=
/v5.16.12/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.16.y
  Describe: v5.16.12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d6d1706b281324361ad5ddbe069e7f7912a70430 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/622088302b7e6b1365c6296f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.16.y/v5.16.12/a=
rm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.16.y/v5.16.12/a=
rm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622088302b7e6b1365c62=
970
        new failure (last pass: v5.16.10) =

 =20
