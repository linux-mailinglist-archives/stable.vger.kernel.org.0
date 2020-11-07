Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA2A2AA6A2
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 17:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgKGQTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 11:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728232AbgKGQTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 11:19:07 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6B9C0613CF
        for <stable@vger.kernel.org>; Sat,  7 Nov 2020 08:19:06 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id f21so2414358plr.5
        for <stable@vger.kernel.org>; Sat, 07 Nov 2020 08:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5f0j5EdTPc1rZYrl1zEw4i7yAXAFr0Q8okGNw09WQEU=;
        b=rYpIhkWGlRzcDVUmbhV9ZcD8SjfObVTXuDgEXP3/bQMlGFMKT47WXnWDPvKi3N7AjG
         /KpMgk2Kftem4+a/BsXjMlwT4eHC3zrP0rD2FSxnpDT5K+GFjtwawXxdea8KyRMpuNL3
         RC25mypDv6D8ajfHVjXL6KqWu02PFNTYeSGlp48Gs7/J8CjVyCz5OBTzmMn34t2RolaP
         qqciMUvmyW/8Spn0LBZ1HMlBjAXg7in0I7iFSYZaHxPwXExdkNkBiGvaXo0xuQoaCEP3
         0R6x8djzOHN8aq27LxiKgxU7bbnfGXDc/nNxK/aOXxuIe0rbbo/vRuFmWMJqTgEmgCy7
         YyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5f0j5EdTPc1rZYrl1zEw4i7yAXAFr0Q8okGNw09WQEU=;
        b=ao0kb3lu2f7xbBGQ5ZA/sMnbkVELfhl4FAe5uX+5373HLIz/HHbzEDAsv8eIiS3neB
         FhpkatNw/qb5tsdjIFHiOYib7fSILQQ3SKcF/5eHI5KcTkjiD1cWVCB2BCKek07yrB3C
         gn4C2G9LQpZKxf0B1M9BWhDCL7hNfAEMusKa+lfx9i/aKhR3mFxOrYYx3dNI3M9sBqGE
         xYUnloyX9c+M2mMF2xzOARUoPfOK/OIGQWySRMFCNxCfZa4tC5n6AKaG9Kr9OME+zRg2
         M/uqAueXoea0G7yi5JWjDCYA4ysu8D6evhzy9GC0HhWQZUwjjsxZX7TT1sM1afamPFRv
         erKQ==
X-Gm-Message-State: AOAM530jN95KFisNZsPxwERQH0EkYYnw4hbNs0isM16wp4q4vVao1luL
        QAnv5oizr/5CndvAS2Dc2pYfQFxPf1Ky5A==
X-Google-Smtp-Source: ABdhPJyy7FDrgCxZhdtjloOZ4twPwysDVT+jJZ0elyzKnBXNgeQhBIqnfExW2AIfXqIHA9RNTCf4Ig==
X-Received: by 2002:a17:90b:715:: with SMTP id s21mr4651689pjz.43.1604765945317;
        Sat, 07 Nov 2020 08:19:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v126sm5901192pfb.137.2020.11.07.08.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 08:19:04 -0800 (PST)
Message-ID: <5fa6c8f8.1c69fb81.76100.b6c6@mx.google.com>
Date:   Sat, 07 Nov 2020 08:19:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.241-93-g0a2684108126
Subject: stable-rc/queue/4.9 baseline: 149 runs,
 1 regressions (v4.9.241-93-g0a2684108126)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 149 runs, 1 regressions (v4.9.241-93-g0a26841=
08126)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-93-g0a2684108126/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-93-g0a2684108126
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0a268410812608b67cd5a8b425bcbe51a7dba6a4 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa696648aa0e271a7db8874

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
3-g0a2684108126/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
3-g0a2684108126/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa696648aa0e271a7db8=
875
        failing since 9 days (last pass: v4.9.240-139-gd719c4ad8056, first =
fail: v4.9.240-139-g65bd9a74252c) =

 =20
