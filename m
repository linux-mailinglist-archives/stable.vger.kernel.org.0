Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A783F94AF
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 08:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbhH0G7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 02:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbhH0G7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 02:59:40 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047ABC061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 23:58:52 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id m26so4928075pff.3
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 23:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oDb+R9lB15QOONN674EUUQ2PUShSXn9XnA6TX4sTYWc=;
        b=N42NLcM+gx8BIbOP/1a0i2CFxcx/a7/WO4EA0uAMuBoVb620LDwsO6o68WCU6yEr5a
         S+K3cNqc932t37ahmK97UehaKtbsiBkZPCVMJCr3QB8IQ/2IMVIt5CDP1vh6pHVOl0FY
         ntErGmzhSonP1gotik/LAjw6EV0yk8VVOdPfyU1fnYpCn1yy2DMwdwdZVfckF1A2IFXi
         CVoYNis0XMTavytklLZrzsaToC3F0YVTskJ59AzkLHcDCVBseTXZTOmcxL1ja0ooI4N5
         y7IrTgMwufAjS5U06tzrof1eC5Zh3V5xbV0CRh2RoQJI8BGYY/w5sdAkCj1WAraOPRoS
         /ArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oDb+R9lB15QOONN674EUUQ2PUShSXn9XnA6TX4sTYWc=;
        b=rknY2MM34RcwGPJs/lMhsULLd4Ss+C/5TP5LbZACnL+MW4F/2kTQIaSR9U/zW0QZ7Q
         ERXOEWDA/LO0NPaCZGafmzZWA30Prz4VYtqRKNEKrNHLvl2l059MpL3A0Z+jNCuxEI9L
         +CMXgog9z6bSJebJlGqZORZvk26svVJEAiQM+Levgr7VpGOSwWOE2VJgBr1F8MwjiL38
         thWehgWc+N6B83Yfl9MqM0jCLUF+FNnbQpBzbRYPmEJssnrD2UT7vQlACYiw6bF5/GDJ
         vdAVC+f33bsd59LEi6eMdQb/W+JGAxQu83GbqoEibqARGyt5N+niqB7sr7iqdF72nBsj
         3tSg==
X-Gm-Message-State: AOAM532dsDKGDGhfUUn+0g/hA29uy6v4mDgTsNWfuk9t1pITQTluegFz
        b/LEsckwoxykakDP/EH/h6ysc+JNrd7a8cy0
X-Google-Smtp-Source: ABdhPJy3a3b5xXi6EwxWQpXON5z0cM5i3T4ZAlemueTSjqYEH2mbr13pGiKa0J21/CdYImF7S1cqsg==
X-Received: by 2002:a63:6646:: with SMTP id a67mr6591685pgc.144.1630047531380;
        Thu, 26 Aug 2021 23:58:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p18sm5725728pgk.28.2021.08.26.23.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 23:58:51 -0700 (PDT)
Message-ID: <61288d2b.1c69fb81.41f06.06b8@mx.google.com>
Date:   Thu, 26 Aug 2021 23:58:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.61
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 126 runs, 1 regressions (v5.10.61)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 126 runs, 1 regressions (v5.10.61)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.61/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.61
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      452ea6a15ed2ac74789b7b3513777cc94ea3b751 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61285d4133c66ce8c98e2c7a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
1/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
1/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61285d4133c66ce8c98e2=
c7b
        new failure (last pass: v5.10.60) =

 =20
