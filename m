Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A6D289C37
	for <lists+stable@lfdr.de>; Sat, 10 Oct 2020 01:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgJIXrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 19:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbgJIXme (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 19:42:34 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393C6C0613D6
        for <stable@vger.kernel.org>; Fri,  9 Oct 2020 16:42:05 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id b19so5230482pld.0
        for <stable@vger.kernel.org>; Fri, 09 Oct 2020 16:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Uf8zBz9EI2tmOtZiBX4rgeEAQwj1frD0ezpmfYkOc9c=;
        b=fZfcql+60YWLdzmdJhvVd24shQtkhlb5kTpqYPFBTBHADJ/3uauC2fuk9MxtgD5SJb
         5hq4aTPpkPCO88+5VX5GtIXj1AjKI6lNVFmMwNlvbluDBaMIoGLEob0xflheC+GUb/vh
         7yv9bYvM5Xj3MJPRkRkh71aY3XfZpbOU/9XKDTAxWj8sPnfll77PZg3Li1WeGHGgguYr
         oO61TB472gcaNSZjCxStdvVLba8DdyqM2Vrk8TwHC7JjkK23S9FwmXLenNr2mmvONUSO
         g3DS+i3tBp4t8KLdxyoJMplyRjykZQ3NIDMJaNvzZWlmDLQ6wGBXe6e0ruE4FrJoNQ0j
         f9yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Uf8zBz9EI2tmOtZiBX4rgeEAQwj1frD0ezpmfYkOc9c=;
        b=D66dksbN5emrKYa2kZVyPwUW0rqfNeoomjx6MwKHI8sWsYQGzG/NKY8fQdxgj2wGxy
         iauAOOS//dRk8nRbUCKUeOYy3QOyYJGqAkcp8Q7qX4RSK2R3KHAvotbw/MipQ+i2NV1B
         HZHwkQ1alYuG15GgxsSMYX/TEQ04h8YzMi6Rujhm4hE3oFDjrb5530v+QCOswXtJkE/t
         9FMoihnBcNvQjYWo6k+4F5MeTz+9HgqOz3kR0CqIC1dvgG4/atbBrAGpZOkytWPebK7w
         SwZYjnu07qTkAnW5rknUSaFIvtyLmpSkspo0x+zRoWOAG0IsQiDCoD9gmQp174algJEn
         mIUg==
X-Gm-Message-State: AOAM533jjdBE0Y9ZT0eK7An1QnOHVDy1S+b6dKGxNkdoj+RuhPRT6ZSl
        5+/kfAjMfpe5lI0frYKYQOJX/YqaPWX8Pw==
X-Google-Smtp-Source: ABdhPJyULnIyVBvfQBuF6qIJoynd0w937NTOkcv/czl7udSO5/Ni4ZEDYLLhLtMD5ynQK8a9mTzQWA==
X-Received: by 2002:a17:902:b402:b029:d2:686a:4f43 with SMTP id x2-20020a170902b402b02900d2686a4f43mr14109630plr.34.1602286924357;
        Fri, 09 Oct 2020 16:42:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u7sm11931853pfn.37.2020.10.09.16.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 16:42:03 -0700 (PDT)
Message-ID: <5f80f54b.1c69fb81.9318e.6e46@mx.google.com>
Date:   Fri, 09 Oct 2020 16:42:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.238-34-g9bc7672e9390
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 51 runs,
 1 regressions (v4.9.238-34-g9bc7672e9390)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 51 runs, 1 regressions (v4.9.238-34-g9bc7672e=
9390)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.238-34-g9bc7672e9390/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.238-34-g9bc7672e9390
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9bc7672e9390f3b47fc22d20c96373057537a607 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f80b6dfc987df5a004ff3fc

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-3=
4-g9bc7672e9390/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-3=
4-g9bc7672e9390/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f80b6dfc987df5=
a004ff403
      failing since 0 day (last pass: v4.9.238-26-g1959353b3c5c, first fail=
: v4.9.238-31-gff7df5c6ca79)
      2 lines

    2020-10-09 19:15:39.362000  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
234 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
      =20
