Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45B33C590A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 13:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356134AbhGLIzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381257AbhGLIw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 04:52:26 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7486AC03D33A
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 01:47:04 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id u14so17511142pga.11
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 01:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IQV7rXDeJ1wfaPJqlTvj96HlOfKqxm8L9qbZ+FuQ5QU=;
        b=BBd9G0NGaG7xJ0vNYxgAmeogyr4jtAhES7ysBxy+MBCjW9I/OsqBvxuxBgWFZ+Jz5O
         +LVRQz6tUzUktoIuAYQDuxx7+UwdFdDO4xJH6YZTTlYNOdnkzWV4325HOkQdL8dw6pCO
         eNUpHq0zuv9IhQRi4JAPORJnNwdqeIxYmZwvV2n3bgpw3YsjqBvMVM0cwuJVrZsQ4Bpk
         uLmFcgJZQGDowAxn3lcg/mv51MgvVJzP29U6gTVIElKlo6O15FBo3vKpd5hjsrEQTEJG
         km7zDpNL54kav9PJ+p7m29eHWBYP5jVLqaWq3GgaiPgv7XIugR+7oxtFgiBt0xmDqL/b
         gT8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IQV7rXDeJ1wfaPJqlTvj96HlOfKqxm8L9qbZ+FuQ5QU=;
        b=AIvN2mz8U4uPcDDMetfYBPz6iNuc/K72/UE0cgOm92sOds5vS8TszrTo331Fr3iBJt
         KObYTx7HTKEaRK2Mtmuyuoupt3y7SfqwwyIFDgC3iXWz/Jt2gwvcSqwlGh/GW0VI1/2Y
         7wL2BprL0dI0AAO30fZFN273X6SV31ZF6EYb646ETRy4yMnSx8R6S6nlTXIvq0/1A+2L
         U9ld06tmleTlapEwFMXi8vv4sOhUbNkaV48PbtKo2GKt+gbt+JLiEQK5t+xHuKI7WPZZ
         nRCzdZD4MsPuyGWH6HniQm5ZIe56vB7BJuNCkcPQdrPOCk+lXwvvzIh1jI09IDr1lJcf
         68vw==
X-Gm-Message-State: AOAM531UWu860dWbOr9TZ9yr2vLZKaOtUoBaF+GSoSJUB5jk7/FltIHY
        8lgQSeO/Fs/LHJYLv3paNvZxENJjRu6PJIFh
X-Google-Smtp-Source: ABdhPJyIDFRRVrOd7ZevvmoW5mpS51vt4A59Jou9gTTPKwN/LH9NNDABDriqa+DzHOlE7DFNX+l8qg==
X-Received: by 2002:a65:41c6:: with SMTP id b6mr53001559pgq.206.1626079623824;
        Mon, 12 Jul 2021 01:47:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 133sm15753594pfx.39.2021.07.12.01.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 01:47:03 -0700 (PDT)
Message-ID: <60ec0187.1c69fb81.3979c.d6d5@mx.google.com>
Date:   Mon, 12 Jul 2021 01:47:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.239-158-ge648d16e66dd6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 126 runs,
 1 regressions (v4.14.239-158-ge648d16e66dd6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 126 runs, 1 regressions (v4.14.239-158-ge648=
d16e66dd6)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.239-158-ge648d16e66dd6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.239-158-ge648d16e66dd6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e648d16e66dd6a427f5a6f868d909fd0a41244a4 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ebd1ff21c9f796f5117978

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-158-ge648d16e66dd6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-158-ge648d16e66dd6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebd1ff21c9f796f5117=
979
        failing since 132 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =20
