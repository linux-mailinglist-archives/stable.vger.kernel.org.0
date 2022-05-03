Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9C5518518
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 15:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbiECNJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 09:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbiECNJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 09:09:38 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E83CDF41
        for <stable@vger.kernel.org>; Tue,  3 May 2022 06:06:00 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id k14so14012944pga.0
        for <stable@vger.kernel.org>; Tue, 03 May 2022 06:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7FgZC340LXCqRmDzTOAKJ5LetTIgM0PFAQTYNxKOPAU=;
        b=cJh+SIHuFzr6SnCmfYZ8XmiRag3iG+fEOI51IfjVGt4fkVAyB7ge5xpzGoVb+8mtoA
         rBicddWttAFejfZFLXyZk66yRthZfMcdDB0uar/5vwyRI6+QNO4X3aXPZj3sK0zLtT0I
         FcEKUhrUMo1cyx/NpstwiOySmxR4R8YSPV9CRP+VEwn6lgKKmKEQRrO0tXKgEOeZvrhz
         dJRg5kYHcgpQKloWr3vuYgxluyq/V2sMCqWyGR7xjKwa5Pct7GWul/+zxl1I/fyIgv0n
         tNWmbCK88X+kvq2FqA7vEK51ILa/CPKetACll66o0TEdqEki36MuybkA+QgSyto5D069
         Nnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7FgZC340LXCqRmDzTOAKJ5LetTIgM0PFAQTYNxKOPAU=;
        b=OqDnmjrM92FD98uGuQNMZ1jQo9/woqjnnA069vzHnhUWZ1hxjckbqwQK442tVubwiK
         X4fvCoL8gQxuFF7ufeXwHffOn5eruwl3k4MUTeprnTNxvaD97nYDEM0toaSl4XAdE7np
         vin5qh/AGnlImoUBDVKNG15IWC9IuwfSBxsVhFe1kWCZlz8Gj5S2/0BM5DT+Amgmzzhr
         ZEXLqRHAcoZoTd1uywfPlMolPjdfxY/n7IslQ8dmqVxtrz5rjAg/JsDvOh6SJOhiZnW8
         n+GTl6TwADmfE4+E9mBRrZN8zEB+aVHWthU0NWejPPcLZATU9Bora6NuFFijE22T8whw
         FEKQ==
X-Gm-Message-State: AOAM532p/Lmv9gCE1lM6i+f+Yi0IcjwneLHVWOj/gfQSEC8FMRKT8pru
        jVIosBoAr2EDnFqBzbvuB/+2XlXGELt3ABiDi5Q=
X-Google-Smtp-Source: ABdhPJxIkyHpHuNhuaXF+uKC+KhNBPzokz1oGnIkpW/skKqo2UvheY6c07UWIE9+S3rQwyl/W+YbWA==
X-Received: by 2002:a63:5752:0:b0:3c2:1c59:666f with SMTP id h18-20020a635752000000b003c21c59666fmr7800504pgm.59.1651583159917;
        Tue, 03 May 2022 06:05:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l11-20020a62be0b000000b0050dc76281e1sm6236418pff.187.2022.05.03.06.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 06:05:59 -0700 (PDT)
Message-ID: <627128b7.1c69fb81.3aae6.f6bd@mx.google.com>
Date:   Tue, 03 May 2022 06:05:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.277-48-g4797f88b821d
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 66 runs,
 1 regressions (v4.14.277-48-g4797f88b821d)
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

stable-rc/queue/4.14 baseline: 66 runs, 1 regressions (v4.14.277-48-g4797f8=
8b821d)

Regressions Summary
-------------------

platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.277-48-g4797f88b821d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.277-48-g4797f88b821d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4797f88b821d0fb855b0becfb8ad3da31da79243 =



Test Regressions
---------------- =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6270f8baf0c9530542dc7b22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-48-g4797f88b821d/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-48-g4797f88b821d/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6270f8baf0c9530542dc7=
b23
        failing since 14 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fir=
st fail: v4.14.275-284-gdf8ec5b4383b9) =

 =20
