Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C9B2A07AB
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 15:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgJ3OSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 10:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgJ3OSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 10:18:20 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F107EC0613CF
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 07:18:18 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id n16so5302802pgv.13
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 07:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IXiGgQHHrHBbinZ63ih4a7aLaEmbfi8Wqi1Qw03XczU=;
        b=NTod7Nv4z6K3SA2/HZdqKKG5aus8nArsxtkLMCqS/R7N6fAAh8R6YlzvZikyGIeBil
         Fi4kVBDgGAZlQUSjyTgDCYK6rv9NsZ/EE4Vkdcvf3jJH6Ak35j7slT/vFQFDk7zEIB4W
         gop72Zow3I5YN38nIZtUDBP7upczwmEL8YpUGSxlK1w9ai02B5IDtuxkCegTDeXZzKIw
         qRFh4/q8gdVj/A0LMSukIFiU5CUvVC9x58RRCyymeRa5plVlmEr8Ozb37ecT5S2eKCvY
         zuuZ5whMwpKP/JMENmCzx/SSd7TNE2+sRADdQhF5XdcS/IHRbfGTdmd19SYcL5+rBDOi
         gKow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IXiGgQHHrHBbinZ63ih4a7aLaEmbfi8Wqi1Qw03XczU=;
        b=GnjukSi9KO0BCNlxLeOZl6LVaKldpzgINa4Fgohp1qwQOB1zYCvqzqg/I1xkFYVn0O
         I/Zg8EX3lUxvwSFpCE6ZXhRX8EMn+tqJdnpg2n6P4HEsdxaYPd5LU9HE3WhLdGnvRzvu
         NoO2ea92GifkKdQNPOlOxp+4OV/OW/dS47cNLdKZ85tTxABC0poK5Jx7OP3Qk+zZgSSh
         wPcHW81ZykLmDSz+EWtJD5iHxginlwmj/N7tildYa+9ZmgLV6kI+lUpLz1b0PFTqUe/z
         llO/o6/xApisq7vLNscny858ckEWszRAj/EX/MPN5wVRkNkXBasiazcNuiJYP8FjBL55
         qfhA==
X-Gm-Message-State: AOAM533X67T4uJcaHWftUAoITmzsdRN3Gc//InCUy9CLYSyOsKFQWiyC
        5Bq/xXbiQZfiIzZIYBCfE06uz8nzFhXw3g==
X-Google-Smtp-Source: ABdhPJyAPziVE1TkSqdubZ84F9zeR+gzw+Dd1Sv4SxKb261oMcl7Zjz9k0FMBEyz4yBdkXHwhl+3mw==
X-Received: by 2002:a17:90b:1204:: with SMTP id gl4mr2367755pjb.157.1604067498175;
        Fri, 30 Oct 2020 07:18:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ck21sm3722291pjb.56.2020.10.30.07.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 07:18:17 -0700 (PDT)
Message-ID: <5f9c20a9.1c69fb81.40b84.8d32@mx.google.com>
Date:   Fri, 30 Oct 2020 07:18:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203-3-gd24321bfc541
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 160 runs,
 1 regressions (v4.14.203-3-gd24321bfc541)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 160 runs, 1 regressions (v4.14.203-3-gd24321=
bfc541)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig          | regressio=
ns
---------+------+---------------+----------+--------------------+----------=
--
panda    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.203-3-gd24321bfc541/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.203-3-gd24321bfc541
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d24321bfc5413cbc74ce225565059390a6dd34ba =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig          | regressio=
ns
---------+------+---------------+----------+--------------------+----------=
--
panda    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/5f9bf0a51a709b10bc381029

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-3-gd24321bfc541/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-3-gd24321bfc541/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9bf0a51a709b10bc381=
02a
        new failure (last pass: v4.14.203-3-g96ad6f5436f2) =

 =20
