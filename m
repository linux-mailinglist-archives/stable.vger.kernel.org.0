Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2264462955
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 01:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhK3A6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 19:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbhK3A6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 19:58:47 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFB2C061574
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 16:55:28 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 137so10800859pgg.3
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 16:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bzMdEZ5X9+AZYgFv+8e9b1t3ht2f4dPk3nMGReqmDKc=;
        b=CUfxKTdLLb5Mh8qg8+/QqboJJWTeq0T3nZevuOfhoMMYAMcf3ZEOTmjO0glPlhpuqW
         d7jiJvK+Dlv6+NKvypjlO2ZFbmqZvuhH6bzJK18TbESr4gBfNGFO4O9SNyrLs7uvQ0hg
         NqX89VZiRnXepCE9mGfBISh6/3hNhjqH1nzc5+2CxLH11Yr/ksrLKj9KHbblUkXxTdVE
         OHNivedHLiG3AIOXzBVl5LL4fAlhsaES1DrMFSXLSPcXWUfVN0gtRNQs0ttbErMzOpvU
         cCwzd+LroS3bYuKJgD1AtHT2Cnxcp3AuvsD9fVvnsEEZlkSvEj8Z0x17p6AAqOuKSAPl
         9SXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bzMdEZ5X9+AZYgFv+8e9b1t3ht2f4dPk3nMGReqmDKc=;
        b=r1yy0sWqFkd0pTmoiMxgv01DzwTTLrla5J0sqOWZItiLXmUexfA2GDL06bP3t957Wu
         yePYAwdmjzTDJxLIB1HPurhI8SF8T/Yetddy3ll594bCQdZeKsfFm5dLeihPNqA5Av7s
         L531dStKL5AG7g8KROwhj0oUh51bfLa43nn+H/s+8IcDu5tUep++pbXuJqI0QofrKOkd
         m55D1rxaCjOSWq6MXkt2Bo3c5oD4eoeoX/5dKAxbgyXv563AwgJpPlEfwjVQYLJHK+x+
         TgeuDjyYE4uMYd3N5QPOtB3VlWRgpdyKkFSdKaprmDh4+e5q5QeyEUx2QRJbAlTLD138
         wH+w==
X-Gm-Message-State: AOAM533Ae2EO2nzXZEfvDtvL+hILR0hxDt6D8Zeb19m0DT/PiKTD9b1C
        9hZQUORwMcdtq/7lZOdVabkW6NSIle3XHuOE
X-Google-Smtp-Source: ABdhPJwmmLJ3cQWcKFG7nZfI1pmkPXtNZ/sQ7y2e97Hu8emTlUqXwLFh6pJFYb6/WE5656zlnKxrgA==
X-Received: by 2002:a05:6a00:2151:b0:4a2:5c9a:f0a9 with SMTP id o17-20020a056a00215100b004a25c9af0a9mr44102590pfk.39.1638233728250;
        Mon, 29 Nov 2021 16:55:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f19sm18984942pfv.76.2021.11.29.16.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 16:55:27 -0800 (PST)
Message-ID: <61a5767f.1c69fb81.86479.3aab@mx.google.com>
Date:   Mon, 29 Nov 2021 16:55:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-36-gaafa77f2a96bd
Subject: stable-rc/queue/4.9 baseline: 86 runs,
 1 regressions (v4.9.291-36-gaafa77f2a96bd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 86 runs, 1 regressions (v4.9.291-36-gaafa77f2=
a96bd)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-36-gaafa77f2a96bd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-36-gaafa77f2a96bd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aafa77f2a96bd18e03f8f4e31eb7e6228c60b558 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61a53b42eb9317880f18f6e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-3=
6-gaafa77f2a96bd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-3=
6-gaafa77f2a96bd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a53b42eb9317880f18f=
6ea
        new failure (last pass: v4.9.291-27-g7ff5d3e83f3d5) =

 =20
