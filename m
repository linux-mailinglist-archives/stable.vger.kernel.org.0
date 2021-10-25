Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E9843906D
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 09:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhJYHgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 03:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbhJYHgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 03:36:38 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4725DC061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 00:34:16 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id c4so10050229pgv.11
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 00:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NlOPaXePn9LEtU2iN1dnQQN50C02n9h7Y5f7szZGLUw=;
        b=n5KjkiUvkwAo4j8fKhyeOX7WyprP67tmznmY062Lcm4vRCrn+4MButhnlaBc0N+jLw
         89sq6zu6Roy8UOEVW/QyQGqWxuxHCU22zoCKzMF8CkSg2UOq3AZttZUQGqemCkntVpGI
         WguWFkf73X3zs3kgXSZk6x0p36R5mcrqI/BJdzvQGzzWA0BiQjjOH/QLUsgGZbmFsgCu
         +xv1cJUWzFat2Hi++K2F4kHzgsVJmJvNuhW8K1rL1o3FlBsxp4zS6XnOtWtBT/dpQ62b
         VMSHOCJIoI5d7Gf16V4tu+DvSTW9LqABqa+hIon8QuIVn59Gd3I1ZRkW8RjTqSj+53mq
         BAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NlOPaXePn9LEtU2iN1dnQQN50C02n9h7Y5f7szZGLUw=;
        b=WHaBDil02lQwVXgtikc5kpl66086DhuwZ6kRRI0fnW6Z0dyiPSTtV54Mt6cAr338L1
         M8pkr2GT622aX+cDm3SXiNBUlVqNFxuiNvlLtwu8HmvL7DWQWotPoh3SjlRHM1GpMmso
         hPq1SgaAWi/BUWLjs4Y1sGJ/PGHSun6eYJwotu2kKKTGeo8lNA7p9KJrnjcU83jRIzDr
         hXuSWhqv6KuOwq2FbSuo5+BCOxR7C6I8f9rDBu+WeKcBApZ+/hISIKWmGqMAFnpd5tr7
         3FDea5OQCiZ+dlES0X/s2Y8I0WhmjvueObJw9Saw3dkhSnVR5YWA5BE2LCy5i2evIxPl
         Swag==
X-Gm-Message-State: AOAM530i3fCQzK1z/LP+mbqM8mmgREhZbA2tCZ77dQGgglQKeutqIup6
        qPXVQlFxL5+sFdKqPgMyuFb5yVVCIRVni0eQ
X-Google-Smtp-Source: ABdhPJxoPp39TtYgYdduVmgPDnwNXgQHeU/3N5IWiNdqh+zFLkOOqKUrFaw1wVSGxKEN8WXJy1iIlQ==
X-Received: by 2002:a05:6a00:138e:b0:47c:205:ac62 with SMTP id t14-20020a056a00138e00b0047c0205ac62mr191524pfg.48.1635147255667;
        Mon, 25 Oct 2021 00:34:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a4sm6873938pjs.25.2021.10.25.00.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 00:34:15 -0700 (PDT)
Message-ID: <61765df7.1c69fb81.f16db.121d@mx.google.com>
Date:   Mon, 25 Oct 2021 00:34:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.289-40-gc4516b7ce44a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 105 runs,
 1 regressions (v4.4.289-40-gc4516b7ce44a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 105 runs, 1 regressions (v4.4.289-40-gc4516b7=
ce44a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.289-40-gc4516b7ce44a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.289-40-gc4516b7ce44a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c4516b7ce44ae02b7e89a971f1408bd755caa8df =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61762c8e7e0a266968335906

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.289-4=
0-gc4516b7ce44a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.289-4=
0-gc4516b7ce44a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61762c8e7e0a266=
968335909
        new failure (last pass: v4.4.289-36-g3a917eeb361e)
        2 lines

    2021-10-25T04:03:07.682066  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2021-10-25T04:03:07.690854  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
