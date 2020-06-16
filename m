Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BAC1FC1F4
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 00:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgFPW5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 18:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgFPW5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 18:57:14 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853B2C061573
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 15:57:14 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e9so270533pgo.9
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 15:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7N3SvWNVjq92UsfGTN7y5p+QBZQAC/gIPtP2UnssofE=;
        b=q3uzzA7vNS9tETgW1RDrq9tfSRLadQK4OdtTOW7fPvTmp5ENduJNA4Lhj4HmjgzDIW
         NByTlin+l3FZv6JdHwAW7w3uj7GO7yNTjFjX3Suq1JhmqB3q7CAZpFt4z23ZcrHwFRcD
         Kl0c/kcBevmTvGnJKnwCZFHKxd60Xq6B/v6p+AqLrPJroWtDARRjdrKWzeLsU1OD8eo0
         R1VoUxnsoBO2RQ9i/I+2t83rHg69fV7eW2+1Ec/pun+ANweO+qwggrlpbZdTk1Rj+kme
         tG3QZ8xvO0wwwD3mMDfBi//JIdVEEYW3Wnh76MLU3iA7c0dXHnfl8uAj/hZye2jUSugU
         /Hgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7N3SvWNVjq92UsfGTN7y5p+QBZQAC/gIPtP2UnssofE=;
        b=hWbSZN8g4Hf1M9r39+BJACFVfOwErdVPl3lgH8GT4ZvXSX1XlCb5YB2trQdXmfCDSv
         abVWj8TJt5HiYO2lDiTfgPoA6cbiosnn9C273hR4ktCI/UIX2qJNuvyTku7b4LITWec1
         2MTzYt+RXAR+GSBcFXSrQYs21k1a0Ye3bfq1/spYeDBuEUvLu9jG80Saejl9lkevviM/
         B7kEqHVlIpDl9V4LBIqPqI15E7JSRfvVJfqPFmYpKsqaryO+5xR49f4DhSQ2bmqusd8J
         S3nrsAcVeD4v/ZfE7GRHcXH2mLSFpFqD09PU4JjJ0E4MwKRrCfPnlmKvBqpvSRVqgw2i
         JlmA==
X-Gm-Message-State: AOAM533tfz85L6aNozm4lDuyrIcFNx1wD0bDSxoufU2PvpaM1grXJ7u8
        mFvTGoxRLcnb9nlSUCUmyQfx8tyueuQ=
X-Google-Smtp-Source: ABdhPJx5IHWchPoojzpDqAjSfghmrkEyEDK5BWB+BQr93MNN2oSSR7TL+/UWPQVkhTh9gbIR8Otvzg==
X-Received: by 2002:a62:2cd7:: with SMTP id s206mr3967281pfs.305.1592348233498;
        Tue, 16 Jun 2020 15:57:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a19sm17925987pfd.165.2020.06.16.15.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 15:57:12 -0700 (PDT)
Message-ID: <5ee94e48.1c69fb81.3f3d7.9bf0@mx.google.com>
Date:   Tue, 16 Jun 2020 15:57:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.44-206-ga7debb64f8b4
Subject: stable-rc/linux-5.4.y baseline: 59 runs,
 1 regressions (v5.4.44-206-ga7debb64f8b4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 59 runs, 1 regressions (v5.4.44-206-ga7debb=
64f8b4)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.44-206-ga7debb64f8b4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.44-206-ga7debb64f8b4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a7debb64f8b4820a8a003bf3bd0b702a111b4a4b =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee91a11df46990a3d97bf1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
206-ga7debb64f8b4/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
206-ga7debb64f8b4/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee91a11df46990a3d97b=
f1e
      failing since 66 days (last pass: v5.4.30-54-g6f04e8ca5355, first fai=
l: v5.4.30-81-gf163418797b9) =20
