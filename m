Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701CC501821
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 18:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbiDNQB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 12:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359155AbiDNPmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 11:42:44 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740CD13CC4
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 08:28:39 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n8so4942735plh.1
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 08:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xk7uMHwEhOEbQ1vjkznckgLUbHpUR4Q/xafzs3EPh2Y=;
        b=bs7wEK2/ftmLX8WJXqbbUow/7XP1JWBnrtNXoYmLSEXJUH15yV1G6b9RHUGpK9o70X
         FPNOzQ/pA9SdWWaqFjHPvBWowy61tlf7MrOlxLD6TaOvS/GMVrMZn/wVLLLvFRViRX01
         Cy1mMr4TLQ6TiqaOrEz2dxrcmeky2PE7pDTTWr4I7x4sG9vnrY5Lqzt077PIGAbGgqoP
         XeHIXOl/f3FkxpjcGMPw2zPvbFouKnQRRX5zOh7/s0A5TfsQHiWmi/rzYdzxO7gHpLCF
         a0w044VE2hiydnXXHk6vGfzu+4TKNiub3J4BxU/qgdHf0GWuTQGk2bV2rAe9YTQlTzMO
         bZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xk7uMHwEhOEbQ1vjkznckgLUbHpUR4Q/xafzs3EPh2Y=;
        b=gg0afJWU7J5TC/BYY9xqLHyQB6pLRubFFd54zqhHT4mgKdR6pU4agZpNTh25W2sE+A
         giGSIuJj3SElZe04PlGwYh+kaC63nWhNM2SZ9Rn6eP+DWGAcRDxyXpsliv3rKMJHXDRe
         P8PfCCziRA5Y0J3yF+BQZq1mrg0D7fj7SNFEuHLpDJRHy+MBv3aVmQc4SGK26ea2p783
         8N8DB1+8Ap2fUjOKytL7mUG+rhHPwyleH2sXpjlJun6Gik3LUOM+0fTNCV7jAExoPiai
         +N6YoUdhakqXiqwHN4gzryvjaBbdROnMGkT7MrnJegsOulsgMczx6jYBJ8IxTuv8sy41
         2eKw==
X-Gm-Message-State: AOAM530HZWFlYqTb5ceZSdPDdqxvQ+KGl0YMDKGYgNV9WKZFb0jnwUhP
        6TP9abKRYsxgLNhqhpLZE0M0izggW/ky6PL0
X-Google-Smtp-Source: ABdhPJw8Dgn5kyE9GXo+FLNiJjNAnpDI3tHXExKXGCL28FMZy6c9qiS9RuUXVi1aLhkv78xUFTQwlw==
X-Received: by 2002:a17:902:760a:b0:14f:4a29:1f64 with SMTP id k10-20020a170902760a00b0014f4a291f64mr30772868pll.90.1649950118851;
        Thu, 14 Apr 2022 08:28:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x5-20020aa79a45000000b00504a1c8b75asm269980pfj.165.2022.04.14.08.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 08:28:38 -0700 (PDT)
Message-ID: <62583da6.1c69fb81.62d74.0c53@mx.google.com>
Date:   Thu, 14 Apr 2022 08:28:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.310-202-g346293027e299
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 28 runs,
 1 regressions (v4.9.310-202-g346293027e299)
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

stable-rc/linux-4.9.y baseline: 28 runs, 1 regressions (v4.9.310-202-g34629=
3027e299)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.310-202-g346293027e299/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.310-202-g346293027e299
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      346293027e299259342d5d386daaa9fd525d0349 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62580bfaa11c96e64dae0701

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.310=
-202-g346293027e299/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.310=
-202-g346293027e299/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62580bfaa11c96e64dae0=
702
        failing since 8 days (last pass: v4.9.307-12-g40127e05a1b8, first f=
ail: v4.9.307-17-g9edf1c247ba2) =

 =20
