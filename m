Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4DF42CFF0
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 03:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhJNBcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 21:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJNBcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 21:32:42 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0A6C061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 18:30:38 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id k23so3634599pji.0
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 18:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n2VqgLJqRulkVgGoc89ZW4hGasxqn115v8bW1SPfAhA=;
        b=0Uxj20/z3W7kKVohSkOi+21esP0N1GGg5/LfvQlEhv4YgbL3Aff8zY/P+5qd+nrwGo
         pvDI5m1uRfScAXb1Wxisjy7vopFx2YYiC6Pk7C+RR8omdPNy/SeBcMn9F20QIRP30rkC
         RqTd2rZiv1nOn6R9/C3e+dOmXDpl9wUkp9n2XTlvgpGGnRS747DHkfichfYbIX3VCAGH
         hmDP3UdUt3GZkIM6g3J2D5JNMi8dtkXC0KqBwKHbQhH8IhHx9R93eu4sZe5d8FVt8q4W
         ZzyHpn6O7l8iRPg5ksJlPWO5sr0y8t2srTZQOD6dNmboNvWVTqas/KMz5Ai/dXSJQJkE
         g7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n2VqgLJqRulkVgGoc89ZW4hGasxqn115v8bW1SPfAhA=;
        b=m8zyHFc0Wdwhas52FXhwgfIPe3959nFiZbeebPOXGcUpp5YGSHRRArh2167SLY4nbA
         g5yP+onpU11vU10aoZgUZNu9Y+fUPkacn01qHmbxDtFLucSocMw4m0qIHIMQyt0e4s5C
         Bqg0aGI7atZS9s+dHwcd7WucPS7vhw1yX/b2KP6/3kAZqrCke+3YX0Qwiu4VOz5HMK2H
         V0LuOTP9f1EW8zPichRbj3E786p63EAa5fzzohi+qOuAMvItantgyhzezLKycMJvoDbw
         RFUIgbIZa+suAb7Sp7zPBNIeOoveOnPMrSNYg25veb2ITqFWTeuSzaVhIIg3A5LzFhhR
         OgDw==
X-Gm-Message-State: AOAM531x9Rad5u26nHuqkisFSTbA8yIC0rISNryavG1oyyOHvK9XMBEx
        xvGJcGN7bHZKEAK3BjCNnqCcKdjFsnHaPS0zYrQ=
X-Google-Smtp-Source: ABdhPJwRcNtRUdlFNRIit8LYnAdtYb5b6yPb9bHud30hTuH/C+WdD9fsZC6ftLruzW3dtZd/JBPt3A==
X-Received: by 2002:a17:902:e74a:b0:13f:3538:fca0 with SMTP id p10-20020a170902e74a00b0013f3538fca0mr2478174plf.22.1634175037759;
        Wed, 13 Oct 2021 18:30:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h23sm658459pfn.109.2021.10.13.18.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 18:30:37 -0700 (PDT)
Message-ID: <6167883d.1c69fb81.2f86c.3012@mx.google.com>
Date:   Wed, 13 Oct 2021 18:30:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.14.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.12
Subject: stable/linux-5.14.y baseline: 79 runs, 1 regressions (v5.14.12)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.14.y baseline: 79 runs, 1 regressions (v5.14.12)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.14.y/kernel=
/v5.14.12/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.14.y
  Describe: v5.14.12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      325225e2f9fa0a4edf0b7da30c256df2433db6bb =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61674bf719bec0c24e08faba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.12/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.12/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61674bf719bec0c24e08f=
abb
        failing since 4 days (last pass: v5.14.10, first fail: v5.14.11) =

 =20
