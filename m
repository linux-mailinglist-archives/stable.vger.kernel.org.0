Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808EB2AA677
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 16:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgKGPyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 10:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgKGPyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 10:54:31 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7BEC0613CF
        for <stable@vger.kernel.org>; Sat,  7 Nov 2020 07:54:30 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id h4so940602pjk.0
        for <stable@vger.kernel.org>; Sat, 07 Nov 2020 07:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D7EI4bBUSjaJVmTIse+kHvnH3DnpaT7+0qqrska9pd8=;
        b=imO9bLV/AbUo7W0y1ud5FH9bfC9RW+VAM/HSEWAO367NINCwDyCmtS/iUEOc5r9Ajo
         b3QA2rfI5Ur91VXPPym8J9sM1Dzkc8xH4RAUOgP/1ZqSatgKrzRqyskprqLPOR1cxwSp
         2SFlQao9ByBVQtCKwF1kA8pbaF8yTEEKRDvzIuQqVZOMiPm0IY2NXJsrcrk13CvS+X7J
         sSD1RAJ13t1T4nEjjTzdiADLJ4BDnewn2n289OX82cCBJPYWsVogfdU55Oqg2ToQ3V4u
         vVeEFGHx3SRFDJfj+6mNgi9nuIP4q+ESG3Zxlk8bed+KUNSmDkqLICYawp+a51r65/xI
         5NZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D7EI4bBUSjaJVmTIse+kHvnH3DnpaT7+0qqrska9pd8=;
        b=dnthkWgo6bM8/NmgdfWEulVDBDqLmIreviNA1QEG4OFUUEMxdEAgocS50G0/wHaoni
         7/uVDsiAwrtt8djKXKIVKyAJcznrp8vdl6OeNrERJtXtq+utMb33uKvrFYAWWIAfQLFH
         dpBwuddv4Yv/Vvpya4tdF6+r6zLUBZnM9ehd3R9d3GJirunDEPnZ5GL3wBOHIGcVojJx
         rReZqTLMOw7+z4sIv0+sEXxODjOKRBZn/1zSKrJDO7DK64wXS4YEUCKiMqb41eZ2bLuR
         FuF6kxpe/uugU6K+iZoVStuNc1PGH4z0huejiZuFr2lDuj9OQ03zIrIcEIUwQm1pGOeb
         wVgQ==
X-Gm-Message-State: AOAM533Q9e4LVhM4OMJpAj8dfwn4R4p5ivGyuO+XZcr6qYNGBa/fY5IH
        GPVB1DTh+XzgpV7M8X5FV8C2RU5jLt7qXA==
X-Google-Smtp-Source: ABdhPJyetjOGjFSCvwcAdDMSAg7Opvnv+acr3I3BNg7K2z3zfbcBKc0xkDkkmnSQNEOw+HqzLD4hDQ==
X-Received: by 2002:a17:902:b708:b029:d7:cece:626e with SMTP id d8-20020a170902b708b02900d7cece626emr2316314pls.29.1604764469347;
        Sat, 07 Nov 2020 07:54:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u24sm6327652pfm.81.2020.11.07.07.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 07:54:28 -0800 (PST)
Message-ID: <5fa6c334.1c69fb81.f2935.c624@mx.google.com>
Date:   Sat, 07 Nov 2020 07:54:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.75-21-g2198a177d7438
Subject: stable-rc/queue/5.4 baseline: 174 runs,
 1 regressions (v5.4.75-21-g2198a177d7438)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 174 runs, 1 regressions (v5.4.75-21-g2198a177=
d7438)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.75-21-g2198a177d7438/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.75-21-g2198a177d7438
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2198a177d743891602cbdeb1eeb0ca3c7ba57540 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa68f5ef6db921859db8853

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-21=
-g2198a177d7438/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-21=
-g2198a177d7438/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa68f5ef6db921859db8=
854
        failing since 9 days (last pass: v5.4.72-409-gbbe9df5e07cf, first f=
ail: v5.4.72-409-ga6e47f533653) =

 =20
