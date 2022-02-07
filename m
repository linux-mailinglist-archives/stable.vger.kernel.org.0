Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB15D4AB7A2
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 10:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237566AbiBGJfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 04:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346739AbiBGJ1S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 04:27:18 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587BAC043185
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 01:27:18 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z5so10664314plg.8
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 01:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b+oEDovxzFXeKpG2Vb8od/z/bRXMVlruzvGEBa4phiA=;
        b=ZyqANJ0B8gwtxlqq8IazwCLMW8xIvDw42qryn24SdV+t+OEJbx49ZZhSdVYA3NVg+t
         zRqJ4AHNfokKHS3PgsYJWENhkUF5yl6QYW3Y1EFIqDYZ26wV1/SWMSws1tfnv4HRF0b6
         x751WBeuZT9DdA/vBL2SlQ0oYt48S4U1YNhm3sTbP/ur/dM73DSsL6THfnRc/rl9L7od
         lSFilHo7muzSHHMsTmAsWZgKdtTdL8kV92XJBlvgQGAd1Es+UENXaesU8gv4c7YlDD6U
         fSdr8zB62Tx0mYwURDGKKuAPnz1jKri71KHn5MFtlpmvf8a/slJUO//fLbEY9P2PzJU7
         1/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b+oEDovxzFXeKpG2Vb8od/z/bRXMVlruzvGEBa4phiA=;
        b=cdW3w1Im+SKNdLlBW/1HdavnNb09L0DOm6NhxH/ayQs8aq1KxkgvJyrUP6ChBFrWvM
         9kLrQOA6yItV941B2ZS93tgcQnixY/lw3undhqjkQnaJl37TtNmD4dShB2XeDSvX1u3c
         GZQTP5H63WD8oBpig9ynWVM/YW6WLtPf5ydWopqkDtFSF75etV03hIGr/MMH8KS4P6o0
         +vuHMAeymkVMcPjbwMkjpn0YSHZgOlNtFKCA9++4ytvWK2pCbD0bqhpKeK8x7IL9Ro1k
         AUqSil8gK+DZJuRELme0xJdmXwlUQJ32julzCqiYFWi/t/JnrYQM21L45IIwaac3IfLh
         PZRQ==
X-Gm-Message-State: AOAM5317iluSf4cOlgbYGutDhdmLQF5J5GcewA3AKdjc02vThVcg9ZIj
        a3PRqV0sgOGmby6O8X3WxgeEx/9GID1ezQlj
X-Google-Smtp-Source: ABdhPJyZ8yAEFXD/2fzNRNoGaKeLAI7UaHC4tqjnPAJ+cGJo94sUZhVhVyEGVrLBJGk2fX9mM5EoSg==
X-Received: by 2002:a17:90b:4c4f:: with SMTP id np15mr13368808pjb.118.1644226037748;
        Mon, 07 Feb 2022 01:27:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d70sm7986067pga.48.2022.02.07.01.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 01:27:17 -0800 (PST)
Message-ID: <6200e5f5.1c69fb81.2f5e8.435b@mx.google.com>
Date:   Mon, 07 Feb 2022 01:27:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.227-83-ge477d1fa26e6
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 89 runs,
 1 regressions (v4.19.227-83-ge477d1fa26e6)
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

stable-rc/queue/4.19 baseline: 89 runs, 1 regressions (v4.19.227-83-ge477d1=
fa26e6)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.227-83-ge477d1fa26e6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.227-83-ge477d1fa26e6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e477d1fa26e69ea6d71e324a45e55cc2d000fd70 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6200b404606fc17a8b5d6f0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-83-ge477d1fa26e6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-83-ge477d1fa26e6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6200b404606fc17a8b5d6=
f0f
        new failure (last pass: v4.19.227-83-gfd119a34964b) =

 =20
