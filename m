Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621F72AA8E3
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 03:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgKHCDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 21:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbgKHCDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 21:03:36 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8234BC0613CF
        for <stable@vger.kernel.org>; Sat,  7 Nov 2020 18:03:34 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 13so4913386pfy.4
        for <stable@vger.kernel.org>; Sat, 07 Nov 2020 18:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Sryx1kawNJ7TBv3b3iFBK4Qh1huBeOXmnwut9/jQUrQ=;
        b=lkIjO5rwavQF8LCgST2tOAhUuy5YsQ8D7iO6DfutOuvVpCjwFI1J5jReC17c3n0hsM
         nnzPX+h/ioimVXaaG6nxu9VMswAbhxKUtdB76X3OL10qDNEw8c7L6gZbrIwo/ABOqSV4
         2Ozj5YxpLm/jYafG8g11XICiE4Yy4jGGMmXQPGPW4sl69ei3l/Ted97DX/m4rq/hLUV8
         P1qxGFUDY80wmX30DxyXsmJTuffaELm9MzJK+urgiUmSx20dZ6Y2HkUO92HvqYSLheX5
         /Xe+8J7ESHN1xDFS5w9VVIdGKpUvZAZ6OyTnX+cq3sIoD0T2ecoMpLLR2VpnRInhFjmo
         3Ebg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Sryx1kawNJ7TBv3b3iFBK4Qh1huBeOXmnwut9/jQUrQ=;
        b=L7RBW+sMxoyGS6e+lnrtC7WL1WW1EaobFp9BQYhBYK8/Qr+PJ3rGY3XTx33Ipyzdr7
         BhGSEBhSQWFMAKeQvTBDzk7abhMm2Nhaf5+8RrPbSsjx/Yt/4zijZkhDYUbcqT5MGsg+
         7FXTwf4Jj9k5pBHXivWBiFcwTqKYAojvsDWWOISp1HDcZwhdDBaHR7bn4fs3CTRG2wtW
         5Dok7jN731shZeXJMq8OkE/4aV/LTbhcmZSyePw544CbUZGpLJ3D+d++aX3LLyaGFr1X
         GvxfE1eNjtF1Xpr0XMmTDLjviQhaW9kmcMVyIRpjSKChLMTGWhN9SlexE07Ect7YWTmz
         g1hA==
X-Gm-Message-State: AOAM5325rZJEHmimSL2sTgYQvXMy3nikZ5+opvSlJTdeyWvRgcSGlHpE
        u7PKvbnJwAbobmcM2bvtsSY1gcJCc4Lt+w==
X-Google-Smtp-Source: ABdhPJyFMtXr5WeWlztEm2G3lNN9GbeuVEHEFex2gET7bGtYfTzWH004N7iHCJBnunAQi0fIB7hpCg==
X-Received: by 2002:a62:1c47:0:b029:18b:9e22:593e with SMTP id c68-20020a621c470000b029018b9e22593emr8497926pfc.42.1604801013796;
        Sat, 07 Nov 2020 18:03:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r6sm2918099pjo.0.2020.11.07.18.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 18:03:32 -0800 (PST)
Message-ID: <5fa751f4.1c69fb81.15d39.610d@mx.google.com>
Date:   Sat, 07 Nov 2020 18:03:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.241-99-gfe0a8c1fa2f0
Subject: stable-rc/linux-4.9.y baseline: 145 runs,
 1 regressions (v4.9.241-99-gfe0a8c1fa2f0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 145 runs, 1 regressions (v4.9.241-99-gfe0a8=
c1fa2f0)

Regressions Summary
-------------------

platform             | arch | lab        | compiler | defconfig       | reg=
ressions
---------------------+------+------------+----------+-----------------+----=
--------
sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-8    | sunxi_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.241-99-gfe0a8c1fa2f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.241-99-gfe0a8c1fa2f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fe0a8c1fa2f02981561bad12daca3729f61808ac =



Test Regressions
---------------- =



platform             | arch | lab        | compiler | defconfig       | reg=
ressions
---------------------+------+------------+----------+-----------------+----=
--------
sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-8    | sunxi_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5fa723051b760c08bfdb88d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.241=
-99-gfe0a8c1fa2f0/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.241=
-99-gfe0a8c1fa2f0/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa723051b760c08bfdb8=
8d7
        new failure (last pass: v4.9.241) =

 =20
