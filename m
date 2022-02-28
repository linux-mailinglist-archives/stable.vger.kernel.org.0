Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DF64C6F06
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 15:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbiB1OLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 09:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbiB1OLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 09:11:31 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5879B52B15
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 06:10:52 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v5-20020a17090ac90500b001bc40b548f9so14895176pjt.0
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 06:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XZc8j1CDCngXIjuatEr/aCeLNB212FxIVgQYAWSzgnU=;
        b=SNv6aRQBBge86hXfyIt2suTkYhlmPrG1Zf50ENMDkz0Xv8xOOSF769b6kRWVBJ01SB
         QWsWNVdqli/3dlxsehmOSziG7V7iZ4i5JjM/n5POMzpk/xBlXj7prWFjvpy2WJHmJowN
         ndZtejlpzSzToW5SDKGyhJwoqJQjzOVEMrADdPlV7qMV/TzC2bpoWh/UO23gSQMQ85Uz
         WHWZzN99ueLCTGJKuu6Hk2fncA10Hp3OXRtZqtEtTClSFz4tfRSmLZtlWHaM5T03+fGc
         3bA9OGGTzOt9x7fIW9pyRTLQtwIMTmodhyuKDS1GFb61hZ0/hudz14T3vd/KTxBDA3I/
         kmFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XZc8j1CDCngXIjuatEr/aCeLNB212FxIVgQYAWSzgnU=;
        b=3lRF6szEMBgr3U78haWCTMjOtSzAR6GkXawR4JvFUTmVA5HROncwyagntZ1bIugHOr
         TAbm/3cbdIodvNmwjIHDnkwdzr4EelZc1q2PESPPVidhz6Cz6uT0UH7316EwtDCOsVyU
         LBuFDO0tJeJPW1Ptis2Ul9x8QWSjMedFXSDZsoWZmmNGPmv7nWWp5dCCCzQ0Vi6mrtu0
         3jEmKnbydUj2kdugEbhqMNItQDMXOGcouY6pRELcEW4TpDMMooF0Gsr540OsFxofIyga
         Bplfsh+9wwidxQp6uAhXh+/ClIr+fGL/6JmhwaQciSxPrJtdIqcXhgV/AYu96PcOkBc6
         T0+Q==
X-Gm-Message-State: AOAM531VFIkOluR/tuvlKXfdtmurDhxRLZaIA92rglIBvLDD5oeNPfA6
        wHoBgX5po++RHXxW+5vxhDIPQzuRiTyl695sX8w=
X-Google-Smtp-Source: ABdhPJykVYGz1pLk8uaxmZQycEN0NvReV8OQ0wSfzDACiTYeySi/aGQuI0ZCRfp6x6K4ulAdui1TLw==
X-Received: by 2002:a17:902:f684:b0:150:887:a16c with SMTP id l4-20020a170902f68400b001500887a16cmr20432195plg.31.1646057451532;
        Mon, 28 Feb 2022 06:10:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g28-20020a63111c000000b00374646abc42sm10173315pgl.36.2022.02.28.06.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 06:10:51 -0800 (PST)
Message-ID: <621cd7eb.1c69fb81.65add.8ac5@mx.google.com>
Date:   Mon, 28 Feb 2022 06:10:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.303-28-g8a09cb001af3
Subject: stable-rc/linux-4.9.y baseline: 63 runs,
 1 regressions (v4.9.303-28-g8a09cb001af3)
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

stable-rc/linux-4.9.y baseline: 63 runs, 1 regressions (v4.9.303-28-g8a09cb=
001af3)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.303-28-g8a09cb001af3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.303-28-g8a09cb001af3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8a09cb001af3f8e106c776dcea132fb067b0ad91 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/621c9ebc347615fcd7c62990

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.303=
-28-g8a09cb001af3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.303=
-28-g8a09cb001af3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621c9ebc347615fcd7c62=
991
        new failure (last pass: v4.9.303) =

 =20
