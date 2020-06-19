Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7181201D16
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 23:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgFSV07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 17:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbgFSV06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 17:26:58 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE90C06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 14:26:58 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x22so4987082pfn.3
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 14:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=65lFtPyGGtbv+x58/bL/u4aUXYsBaDeIK6y1w0qZrNk=;
        b=vPluLK8Kv4iml+8KpNBEbMiFyJfNtRamfW6G+OU1ebIiTCjKSNoZ7ORaRZcIq3YQ1P
         i0XubhDzpgTHSC6Dvy4+V380c1lwbVO1E1yuS9VcSnAIXsnq++y0r3KIrv/2z/2fnvrM
         4YJrlbhOR0JPv81dXigtZnOz4ucOPldwT/3p0+kwvtgIvM4Jtp32mnZV4DWqZkaxqP9f
         7+ytNOQQTfgoLUyI7MurHRLm6Eyf5Qn8GLIcZV88Wahpi9GROHycwEzCsvOhTZXLpDI2
         EzBcVa9uTdI22yGdeA8WtnDn5YOfnN9/9vPQGBweawqWzwYq30y2dd6rPBZh1JAeZtcV
         s++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=65lFtPyGGtbv+x58/bL/u4aUXYsBaDeIK6y1w0qZrNk=;
        b=prnKZR+hpA31kgWP5Qk3FV8eeMOXJEKbk+JeApF3Vvkq5KRGYc1n0rUEsEN66CFvhW
         9TVWIugHMc9pmWPPp0M3EOOQCHmOvv2smhYDvhO83/X1neTNZVg7RvBUZSOlCLQVpy2I
         iWGeGCaXutgKUQKUcZLQBEFMzyMrqZmJ38ViWBaDTP+T3S32nfCJf1Yxaeva8pPTHkQ8
         qNexs05yC+fn/muWuTepwg/BTmXC/XvpfzVif4aMBpXtV/1ej9A/4iwfLwt+Jj/Np9IS
         lSsXeTOq4rD6ijLZyhGsyrfuDr/UbMLwQOLY7E6a8YWNPNWLm2gj2T6gTDYxqDhCYKMa
         DsKQ==
X-Gm-Message-State: AOAM533n8GpXm8eNOvnLiCaoDahjxkqfOadnrrqdIKDRvrUWs0wFks62
        n3mO7QNaOni+n1RJfHRCaRg4k/IjgKg=
X-Google-Smtp-Source: ABdhPJxhBpea7MAcGBs9mYDFZ8mKwzDtK8eVi66mwtd+TwJMa0KwbeXWO6g5hpiFFTlOGCiKTqlsjQ==
X-Received: by 2002:a62:640b:: with SMTP id y11mr9659897pfb.195.1592602017382;
        Fri, 19 Jun 2020 14:26:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6sm6811643pfp.144.2020.06.19.14.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 14:26:56 -0700 (PDT)
Message-ID: <5eed2da0.1c69fb81.d7909.5a23@mx.google.com>
Date:   Fri, 19 Jun 2020 14:26:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.183-238-ge26bcff6a5af
Subject: stable-rc/linux-4.14.y baseline: 70 runs,
 1 regressions (v4.14.183-238-ge26bcff6a5af)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 70 runs, 1 regressions (v4.14.183-238-ge26=
bcff6a5af)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.183-238-ge26bcff6a5af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.183-238-ge26bcff6a5af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e26bcff6a5af4b6e19e350a39e88637307e07eb8 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5eecfaf1037bc7278997c00c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-238-ge26bcff6a5af/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-238-ge26bcff6a5af/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5eecfaf1037bc7278997c=
00d
      failing since 80 days (last pass: v4.14.172-114-g734382e2d26e, first =
fail: v4.14.174-131-g234ce78cac23) =20
