Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC37D202416
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 16:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgFTONr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 10:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbgFTONq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Jun 2020 10:13:46 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F5FC06174E
        for <stable@vger.kernel.org>; Sat, 20 Jun 2020 07:13:46 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d66so5901551pfd.6
        for <stable@vger.kernel.org>; Sat, 20 Jun 2020 07:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jxxnLrZvD0cN9wVeTAKcQTslhEWDwi84W/qlxvkk78E=;
        b=k8WJgaSaDKjQyfPAs0JT17eb3/MWeYwly6Ow5+PjBgL4oQ6qPc6ONkCr6aNQ9qOWIW
         rNs/byReeY6Sc+ckCG9qcfdsc4o3KgnJbbIuXBYNzeT54jbaww7AzAJ7YkZV1B6IhveK
         pdbTwCSpP7Hf8GRP1llZbkCKBIHAmdEy2HAKZI7wrvKzbR/8mO18qOAwF9XA/ziFZx7P
         cCHYpJ5J+sEhBMZt+yAgXUIoRWW5FSpjAiXcaimRaGIwmuIiccg5yq7gc6aunvuWIDDQ
         5SxTswbEfAKTn6UZULy9XtD4s8s15Ak+71z2rtJVR29xCFOQWh3xzDpDPmG6M9r/RkuL
         7KAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jxxnLrZvD0cN9wVeTAKcQTslhEWDwi84W/qlxvkk78E=;
        b=rC10KgMZw7y+bcpEe0vUwlUHJnfQIT8iGXVLbJDNKtobRK+XrJxy1FwEOyY21J/wfO
         3f7Xm5TX2EnSneG+Lz7G9yONdTjixorRGAmOtwiR+cwMSxPHQKR0V1B2llDxI9m+9Piy
         Ha+zhiEzkL++fMHPeKf1OVa3sJqX5+m8hknhbG23eoCQPkvfT5RtdbxXjmSn+boHeNAC
         qw9scppI4L96RMrpCPOT38SxWH76dXudlGdI6pqD1GeaktBGKbGQzqJWUsj/DUVg5c/9
         N6uA8uTXLBDLgHQy/r5RqChV9Wt+jbzPsyPt0RwXmL7as7konS/NDux1JfDdlm6SafIb
         dVUw==
X-Gm-Message-State: AOAM533AH7ppr7wsWYBYitcbhz22rwQfdCBdNexWBWKKTt5NU+JHSEjq
        rZ2amrpoVCYxgdltNRgfq9NCgYQfE/U=
X-Google-Smtp-Source: ABdhPJwYHZxZ6R85vyR9u2mMYXQXWBUqjMa9lrLhLxhrPFn+LaimXmZdPGVpqAiOxLKlR6BjBcQ0+g==
X-Received: by 2002:a62:2acf:: with SMTP id q198mr13100205pfq.48.1592662425272;
        Sat, 20 Jun 2020 07:13:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b11sm8821189pfr.58.2020.06.20.07.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 07:13:44 -0700 (PDT)
Message-ID: <5eee1998.1c69fb81.d471.b7da@mx.google.com>
Date:   Sat, 20 Jun 2020 07:13:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.44-466-ga9a8b229b188
Subject: stable-rc/linux-5.4.y baseline: 78 runs,
 2 regressions (v5.4.44-466-ga9a8b229b188)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 78 runs, 2 regressions (v5.4.44-466-ga9a8b2=
29b188)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.44-466-ga9a8b229b188/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.44-466-ga9a8b229b188
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a9a8b229b1885e33c4e18d074b51ed2de006fb62 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5eede0660e4ca0527997bf18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
466-ga9a8b229b188/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
466-ga9a8b229b188/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5eede0660e4ca0527997b=
f19
      failing since 69 days (last pass: v5.4.30-54-g6f04e8ca5355, first fai=
l: v5.4.30-81-gf163418797b9) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5eede8d97b2797546097bf60

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
466-ga9a8b229b188/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
466-ga9a8b229b188/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5eede8d97b279754=
6097bf63
      new failure (last pass: v5.4.44-468-g1b895c62ebf4)
      2 lines =20
