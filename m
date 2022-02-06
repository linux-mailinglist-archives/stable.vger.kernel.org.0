Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DEC4AADA8
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 04:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381030AbiBFDkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 22:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350308AbiBFDkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 22:40:22 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B790C06173B
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 19:40:21 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id t9so6359543plg.13
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 19:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p3IbFkCBw+jv2vMJs6TXaFALofMZ3iZvYPj4mVUqdMw=;
        b=0UObV0NS2gzCkUN3TCuPt4q4e77mHQY7THa7K+f8fUr4tO8DS9yeMnTz53tvdPjHq0
         Tf8t9exJwO/kDeYNoS3uZjf256qfMUMvu09rEWtEjP/bc88sUkPG5nPAvIFCfuQqJgM1
         gcUc+y5UKAU1f4Z5+qVavjY9k8SjP0MYJN/Chsu74ig7Oq/MkeHpuggciTSK2ftRaLpm
         Ga+edUW9i64QCFhUlK196rIv/PI5WAl5fJ+TtTsOxY0rwZlXtj+7FfqdAsY2MhU9oHuD
         MdyuE/K5xE7y4o5ti/2hM0tE90ouUF8EMRcHmxmytqA8K2mLUQmmEo7FL3rhZto25yXp
         MR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p3IbFkCBw+jv2vMJs6TXaFALofMZ3iZvYPj4mVUqdMw=;
        b=NhWxk4jCmrJ5nRQwpT2bLMDMt7QWDVc01jemoXw5rPswn4rgu0Dieq/pT+JRE/Lfa9
         GSDHTGz0+oD2nl4dtVIRsTFw4m2y7xZkIJhGpDK9w4PlBHkjinVKZFhbSpo2HXGgToaI
         8wnULkgnCLuUE2oYnUnb8AVPtZZM8sYLrY8+IlBp+D+qagjYCKZj8T/okmvhXwp9U9fl
         53umhkikieABxW+7RyZ1I7PIFTTSJ7YGiPS83EN1LxQkXh2nipwLKll7J5jHSAMGWrBm
         7OdbZIPSqtZjNjhZDIC+b4M8IZSfTC8bj7byeJy7bgZQMfX8bduo39bDWlXMyOI63+cM
         02HQ==
X-Gm-Message-State: AOAM532rOV6MYtCmMXBG1l/Lz5Xx141yYE8RCXXoNguUwg+rVB/z47yH
        nsMeWbg9J7mFEiAW8O+FRsCtfnT99NfONrD0
X-Google-Smtp-Source: ABdhPJwPe5v9WjjVHwb1y8Hcg0m1ocwnrcInbozlVTnZ+uQ+8CnevPs8u2bI4aSj0UU3iSHYnx0Giw==
X-Received: by 2002:a17:90b:78f:: with SMTP id l15mr11473846pjz.40.1644118820850;
        Sat, 05 Feb 2022 19:40:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12sm7873514pfk.199.2022.02.05.19.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 19:40:20 -0800 (PST)
Message-ID: <61ff4324.1c69fb81.46a37.451a@mx.google.com>
Date:   Sat, 05 Feb 2022 19:40:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.98-22-g52db255368df
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 131 runs,
 1 regressions (v5.10.98-22-g52db255368df)
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

stable-rc/queue/5.10 baseline: 131 runs, 1 regressions (v5.10.98-22-g52db25=
5368df)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.98-22-g52db255368df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.98-22-g52db255368df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      52db255368df07478d9746e42100e44ef017b49e =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61ff0c772eda8bdc3c5d6ef7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
22-g52db255368df/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
22-g52db255368df/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ff0c772eda8bdc3c5d6=
ef8
        new failure (last pass: v5.10.96-46-gf063d5e33f46) =

 =20
