Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2778439DAE
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 19:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhJYRin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 13:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbhJYRin (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 13:38:43 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF5EC061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 10:36:21 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v20so8432385plo.7
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 10:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EW1JBDuen4UDjVRMftq+NXQLLC5jYQQjwl4f3s5yLVI=;
        b=uWRMUC4M/4lpwgEi+otse3r/Wr8GJCJggS2bFJntqbrifSh1cuF7+65yx7An48KcHM
         hyVFRT88QrvrF8pWC/G7WfJo4zhELj6WK1hTyVwQKNV6KAqQK5M2S4F0RSs4FkaSJ809
         2H7MyvEZjmJfBwad0M7W2NU9TofCiyxQrlCDI7APRdhWpVHHpz+JfgX/MV5P/K3Oeqmy
         8Khp1fgJ/Aqm76pptp4S6Xorw8aQr9Ck0xkN7KAhFkt46s2OElvVRTMoWr4eQYOgdvyN
         AVZSLJ9aZoYZqjI/xXsD01vams1CnGuZtOEQsRNrPDqh7ODJMCM+wrIDlgXHO1wMBt7T
         1DtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EW1JBDuen4UDjVRMftq+NXQLLC5jYQQjwl4f3s5yLVI=;
        b=KTJ8tY8ZKtai3eLKXFXGsgEkCH0mCOPQxpFnCxf2Ov+MfXowsC2hxvMprNfBbt/5Gj
         OUWPNLRz8z3SQqlA05xe7dWcMR7+sqAmsVIIDtoytgQ5emcUHp78mkxe8MOUKop56SB8
         uWrY26StZwY5HgPxocjjLiDWw6ahnsegNTi6VJKGOKr8Nh0Ed7MOyAczLNEUIUowSKGI
         NWAZynu/FsIuKkEU8kvnOri6wp6fUeX2tJhYsyRo0hHmPFe9hjp1F/DM1GYXgy7zrdAa
         lAQyjRLVDChvIomeHHvT7E4oejxADgZF1Qqt19BaYe6lm8aEsTNyLDFkPrUcRpWcEHRH
         fWBg==
X-Gm-Message-State: AOAM532bYXcx2yYi6nAiH4bSnJchWEK8906d/Da9gDZOn7fM2aNGTGME
        pzKZUaiGrOcKEx4hTRDIvAvu1kmKzLk9RsrA
X-Google-Smtp-Source: ABdhPJyT2c/Uo4bwJk5qaHcltXOV2I5jQr13X2JJbhhXqE6cuQnZL4utzeRAoPuJVhiQ/ln38hYGVA==
X-Received: by 2002:a17:903:189:b0:140:5f35:437 with SMTP id z9-20020a170903018900b001405f350437mr4484084plg.56.1635183380369;
        Mon, 25 Oct 2021 10:36:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g14sm16727218pgo.88.2021.10.25.10.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 10:36:20 -0700 (PDT)
Message-ID: <6176eb14.1c69fb81.5c77.b781@mx.google.com>
Date:   Mon, 25 Oct 2021 10:36:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.287-47-g24dd986cba73
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 122 runs,
 1 regressions (v4.9.287-47-g24dd986cba73)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 122 runs, 1 regressions (v4.9.287-47-g24dd9=
86cba73)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.287-47-g24dd986cba73/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.287-47-g24dd986cba73
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      24dd986cba7369dc8a36d554172d7b55bec13c77 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6176b86633f76f56823358fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.287=
-47-g24dd986cba73/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.287=
-47-g24dd986cba73/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6176b86633f76f5682335=
8fb
        new failure (last pass: v4.9.287) =

 =20
