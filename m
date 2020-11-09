Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA692AAE8E
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 01:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgKIAmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 19:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbgKIAmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Nov 2020 19:42:52 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4927DC0613CF
        for <stable@vger.kernel.org>; Sun,  8 Nov 2020 16:42:51 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id z24so5423690pgk.3
        for <stable@vger.kernel.org>; Sun, 08 Nov 2020 16:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O2JgEwOuQBFYIhtmI5RzFnE2e6lwZrgKmFWboO6A7QE=;
        b=hjIXS0kdYARKSbmblmaXRJStXXNK1RenjqLFLEK158A5jrXRFgEIjzfYJmo97wlvNY
         erJaq8Nk5foTzQu9F+3UanVcM1HdMslN/K+JITafjcImOo7yig+5X/huersv2F7AsNab
         iJWthslKGinolnO6iL+iWL7U/74XZ/QfqEmkswkpG6yTZBeWZPH/x2hOVqo2Enw7PCiu
         7Y1E42/Cs35iKh1GYSiOZNkLx1lxDDEx8LrjRO65bbYnBwCkhvZLSuZKpOcLybgBc/t4
         NM0TDz04zADqF+EwYQCiUUX+qwkQ7lLNllDUlZh4z9ryqqQKJZB/Sq4NB0wkFe+mQeB7
         gabw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O2JgEwOuQBFYIhtmI5RzFnE2e6lwZrgKmFWboO6A7QE=;
        b=STLn1zm6GDMZq3tgXaoghi0FZt0p8xqfeRVXRTqXP20QMP/Xxb1yacAn6U9aisIbpj
         PY6muyS2cdgvpBhLGUc4vaAU60ub1Uvp7OwgCC6PwU5xsM9OzjSq9rrtB6gKP1MHctCy
         Vi4VASZjHS55RPuoqseOAat8wEopou+feFvYcbJav8SfNnhFhTDyjisOh2Ar4LJBSKUl
         l6IMwZGSJM2U4yVjTcx19Hh1yiqxqk3grxi+K56UmhqtnKeBSMjOPuHhLDPpopAr6m/O
         Wc1bbzvJ4UtgI7QtwZRAABdCJLi+xFbzkClWv1zahMWjU82FRxXcVFLn3KOwuy7zE+WG
         X8xg==
X-Gm-Message-State: AOAM533HaT3j1uGWhjz6YRmgE8EIliXUNoZhSxwEFQm/rZcrStNUygAB
        RppIUlNtnD/ZnsoFPNUQ9i0fXafeEZPrnQ==
X-Google-Smtp-Source: ABdhPJyVuSWvDKej2U37xROj6arKgFpHWF6QF3AKwWdwvvtVLepX0CSiWe5PDZR72TBVD5BIdtYgVA==
X-Received: by 2002:a17:90a:ca0b:: with SMTP id x11mr10126810pjt.155.1604882570408;
        Sun, 08 Nov 2020 16:42:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gf17sm9519391pjb.15.2020.11.08.16.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 16:42:49 -0800 (PST)
Message-ID: <5fa89089.1c69fb81.2d128.4196@mx.google.com>
Date:   Sun, 08 Nov 2020 16:42:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.155-46-g0cc1c3c9e2b1
Subject: stable-rc/linux-4.19.y baseline: 183 runs,
 1 regressions (v4.19.155-46-g0cc1c3c9e2b1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 183 runs, 1 regressions (v4.19.155-46-g0cc=
1c3c9e2b1)

Regressions Summary
-------------------

platform             | arch | lab        | compiler | defconfig          | =
regressions
---------------------+------+------------+----------+--------------------+-=
-----------
sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-8    | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.155-46-g0cc1c3c9e2b1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.155-46-g0cc1c3c9e2b1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0cc1c3c9e2b178f626e4aa8865d343e2cd087d4f =



Test Regressions
---------------- =



platform             | arch | lab        | compiler | defconfig          | =
regressions
---------------------+------+------------+----------+--------------------+-=
-----------
sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-8    | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa85a35bee93e0383db8864

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
55-46-g0cc1c3c9e2b1/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
55-46-g0cc1c3c9e2b1/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa85a35bee93e0383db8=
865
        new failure (last pass: v4.19.154-192-gd404293c7653) =

 =20
