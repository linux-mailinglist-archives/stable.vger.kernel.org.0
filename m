Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01536234F01
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 03:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgHABBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 21:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgHABBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 21:01:30 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9E8C06174A
        for <stable@vger.kernel.org>; Fri, 31 Jul 2020 18:01:30 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id c6so8159933pje.1
        for <stable@vger.kernel.org>; Fri, 31 Jul 2020 18:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pJGxGfdeUutUTiFwuesJFsuk29eEa+TI3DbVgGhPEgU=;
        b=YzM7UhKp6waouzyrnEmoBADEljXkbYYUeaE718cMNyfk3x88yUG45Be3wk8GpzrTn3
         orzEk94aURujHmwel1f1ggg/U10o0EnBT4RNuLqLkqW6IadJCuC+GeGxr5FkpaetUlnR
         UjJ06czC+Qt0oixt5TrYOrJpvNq6f9QUf964Kr1IQrf4QEC6i/zG8lxboYB/hUWW6BnL
         lWwh9su84z8h+qYYui22wXTdaMiRxC9vy/aGlNvrROT4JSZeQu1kOaz1pi3pLOPf8KGT
         cWJJ1raiDWXZJSBY1RajMO6iS1xd8a6nmSq8h/dslzBxmYHoHUMhMOnDowJYerlt3qEx
         s7dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pJGxGfdeUutUTiFwuesJFsuk29eEa+TI3DbVgGhPEgU=;
        b=lcw/1UQh/azKn9CZcWtAax3eAGXngEK2EqarmfDfJoVtMnmDDj7NMSv7w4sE8z1ClW
         kAYNZV+/BaY9TXAST30f3cNLDXDS1OyoaU04VxQMF7YbHjQN3F43gZS7PxEhT2qO1Fz0
         H7W0VoK5t/2sUaOCpU2i+tqwbcymwpZMheYJiuGiPrVAxeeIN8Zhjq7xCAWVVL8iMM+c
         UNlsvgQLo3FGf8SgDz8H2CKG2uOFZHtVlO47b2eJ1ECZEiq/ukkFVYtzMzS4anzFuBV5
         sA5l/upOE3LxZuJJyEr35okt6emtkBLPfatQdJbX/ZRx8gbRk60S5tMMn/mkf67iyovM
         APyQ==
X-Gm-Message-State: AOAM5321hZbkMYILBjkixkbQ+Q8WOSFJ9+0bvjILOFaUcV+Wh9fj13X3
        vjGT3ayw6jv9D6Jd7IQro1dq2ZNgLAY=
X-Google-Smtp-Source: ABdhPJy5SEyNyVHv91feds9BS/1cJpj2Ep3OTJftAyG3jtGzHo3ddsmdXtNCMuESzOSajT75NHIlHA==
X-Received: by 2002:a17:902:9683:: with SMTP id n3mr5720960plp.65.1596243689515;
        Fri, 31 Jul 2020 18:01:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n26sm7452377pgl.42.2020.07.31.18.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 18:01:28 -0700 (PDT)
Message-ID: <5f24bee8.1c69fb81.1b64c.fd60@mx.google.com>
Date:   Fri, 31 Jul 2020 18:01:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.232
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.4.y baseline: 121 runs, 1 regressions (v4.4.232)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 121 runs, 1 regressions (v4.4.232)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 0/=
1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.232/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.232
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e164d5f7b274f422f9cd4fa6a6638ea07c4969f1 =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5f248688f3161987f852c1a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.232/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.232/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f248688f3161987f852c=
1aa
      new failure (last pass: v4.4.231) =20
