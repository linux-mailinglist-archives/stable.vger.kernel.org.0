Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AA23E1D2C
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 22:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhHEUM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 16:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhHEUM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 16:12:26 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA27C061765
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 13:12:12 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so14436848pji.5
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 13:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vlDk32SQV/RLPeRxd0MQFP40mv+y4dfGIf6n+bIt2hk=;
        b=kAh3wO36A+z8upNUggybrKrV+k9QCeYlRYVYFGZsXifx9M3B1aNQvCBmzYu15ojqVc
         hOO7q6PoUB3/74eI4mVa/vPuuMzkAJjcAiWbFULkkjE2VbiuodL8Ium9hy7tuG0baeaW
         Wfy68HZxP5AjjEo9H4Nzi1Gr1D6LuJftJZuAtfRdSCu1Jluq5dge+Tb2/NnRruqOmacj
         8TtpcClOyM3Vg3Hn+Ec5ec/wQ9zACpu1j40Fd67+97GrLpdHz1uWRSwGDntP5z4X1H4/
         GLXuICvkh5YtnL2OSCZ1gLCypwGiAlYhRgh3bCW8FcVfivU8JbHPVK3Hf9m3neQJxSQc
         W70g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vlDk32SQV/RLPeRxd0MQFP40mv+y4dfGIf6n+bIt2hk=;
        b=PrPZHrlf/f/PJyewmcZrS59xQQRwD+JfgOl1q5rXEFfelvNabNdgfbCebRCLi3thnL
         6HD4sWCaJHk9cwGRLriEJmHCAHzS38bYLPWkLA+ngFlkPxQCo54rPct22+sxeO/8qJQn
         ZfzuwcwfhH0icwtTGhAnf/YGEVSk88ViY4EavnnStHYtKs7pUIx18T1S3ci1EpwF8m3J
         59towZJERm4iUBU+xo94F2uUz9mkx3XHefcMu+vfGCkbm4XTAfhJGPhNVEbRWAezDHs5
         fj64RiNQh6T+agYRWd9nHikGbF4vwr7tD4KITP5Vd+3mV2+ZR23jCKPKRYfUXlbOigHl
         qscA==
X-Gm-Message-State: AOAM532di0xfImR8gFreg14d80WE+WVgEQx6tUwMrMD/AO/1UnJveIl+
        NayXFcr35R3LB9odlW2qGO3S/j0f+UaOSs6o
X-Google-Smtp-Source: ABdhPJzNfvmXh3QVhz5uuh+NX2bM3Hk/EVzejOSAyHuAhu0tm3yxGLb3FnV6UUclvhQhWUcq+pfDbg==
X-Received: by 2002:a17:90a:fa14:: with SMTP id cm20mr16991426pjb.67.1628194331757;
        Thu, 05 Aug 2021 13:12:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d65sm6091417pjk.45.2021.08.05.13.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 13:12:11 -0700 (PDT)
Message-ID: <610c461b.1c69fb81.a2bfc.100a@mx.google.com>
Date:   Thu, 05 Aug 2021 13:12:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.138-12-gb5475190be0d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 105 runs,
 1 regressions (v5.4.138-12-gb5475190be0d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 105 runs, 1 regressions (v5.4.138-12-gb547519=
0be0d)

Regressions Summary
-------------------

platform   | arch | lab     | compiler | defconfig           | regressions
-----------+------+---------+----------+---------------------+------------
imx6sx-sdb | arm  | lab-nxp | gcc-8    | imx_v6_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.138-12-gb5475190be0d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.138-12-gb5475190be0d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b5475190be0d59bb5ffdb7669293077cf97d6631 =



Test Regressions
---------------- =



platform   | arch | lab     | compiler | defconfig           | regressions
-----------+------+---------+----------+---------------------+------------
imx6sx-sdb | arm  | lab-nxp | gcc-8    | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610c112cbe402f867fb136e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.138-1=
2-gb5475190be0d/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.138-1=
2-gb5475190be0d/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c112cbe402f867fb13=
6e7
        new failure (last pass: v5.4.137-4-g2645f0d8ddfb) =

 =20
