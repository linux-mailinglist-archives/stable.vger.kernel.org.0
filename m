Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C98B2AD8E2
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 15:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730525AbgKJOgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 09:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgKJOgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 09:36:32 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E6CC0613CF
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 06:36:32 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id i7so10318522pgh.6
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 06:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3Qquu2Rc3OKjSWl8KqrlIDIYk1n3Gic+DS8tEiMhLmw=;
        b=m21wGsMgGQdANYX8RL30+iXZCVByPNmaFcGkgE6X7OAjjZz3Vk0oG4LU38ErKIT5wJ
         bYf3yxAKBBpfR14YMsdsuU5e7fm5Q6kmtOVSdD6polmDDNsVzrhx3qFNmDLsJ/+hvmav
         nLxolWzaWBYZ70dj/qvgx1PO3VEgXNJi3TjYmPFDhYlTLhbMUNtPq31JXq6W8OKb1GeC
         14vZBQyVHChlvA12+FBeEl+f4Iw/qJL1jIVxBU9Mi0jtUHZzOkl0AuhPmM47KgJvbGK3
         3y4GVys9MrR7H01BAvFXnWS3yZys6Ynsc2Itc3eyAqsh3Qb0PYD2SMA9qzSQePUEIbvW
         7teg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3Qquu2Rc3OKjSWl8KqrlIDIYk1n3Gic+DS8tEiMhLmw=;
        b=I8li73c3UxZX8G61g2FMJuZKzcbaS98BdezgFXLl0ETYqn9Jr7zCB0E6MFqMneniNS
         Ejr77Mgp9f1U9KgF0mDPtfwM4Fr68StLL9LsZ33gFtzVPlS4f2M+PlLikdqRV2vK01n3
         Es4waPUYugE+WjNQEIAIhuwFHCEuxcvWZm6gSgobZzhrv43jn2IyBYr+LWEGRZn3/PMV
         b8m2Pz5c21ZyKXD834u0CkKHyEStSwnPYexvq8v4h9cvbOXbD6zKV6ZZdVSxq4u6vwCm
         Vlp9tuDDvjk3ub9TN7I7KxhX0rEUFrvgk5hOPijdttkkSb9EhLsjch3VIsnJHXeBVrtd
         QIaA==
X-Gm-Message-State: AOAM530N9QJdnCMkEZ73vkKglUR2cXTAHLGSl3PgtZkXaZdrnLp27j1i
        g1lMEhe7DpujIKMs3whDM3WawGU5BgzNXw==
X-Google-Smtp-Source: ABdhPJxcwgSk99nYEiVhj+ioJGQ3g+Sfi6kfLjJJmqZ8fWhPd0+YR6pqRVPuIqPQy+SlKbT73uArIA==
X-Received: by 2002:a17:90a:9403:: with SMTP id r3mr5633928pjo.66.1605018991996;
        Tue, 10 Nov 2020 06:36:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fz5sm3884443pjb.49.2020.11.10.06.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 06:36:31 -0800 (PST)
Message-ID: <5faaa56f.1c69fb81.677a9.9470@mx.google.com>
Date:   Tue, 10 Nov 2020 06:36:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.155-71-gf085febade75
Subject: stable-rc/queue/4.19 baseline: 185 runs,
 1 regressions (v4.19.155-71-gf085febade75)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 185 runs, 1 regressions (v4.19.155-71-gf085f=
ebade75)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.155-71-gf085febade75/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.155-71-gf085febade75
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f085febade758516e98b6231ac0a63c42c4fe3cb =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5faa724dc8341cd6fadb8875

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-71-gf085febade75/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-71-gf085febade75/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5faa724dc8341cd=
6fadb887a
        new failure (last pass: v4.19.155-71-gcb057990947da)
        2 lines =

 =20
