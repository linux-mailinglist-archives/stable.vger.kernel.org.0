Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA672A5CE3
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 04:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbgKDDGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 22:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728972AbgKDDGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 22:06:22 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF36C061A4D
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 19:06:22 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 133so16102404pfx.11
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 19:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dwmqOhRfBGED6eAD3cPLmI3bgFJNpWkwtcPChSt1vsE=;
        b=O3fJTLAkW6jJ8RrtwKGxgF2nWjhfC/HOVsHrkmsP87OMrw4x37b1nD9grwj5M83e0o
         VEUukOysYt4gD/sCXmWevh0zpSK9EHaxk4re09XESUElOZDCjRY6pd3Dyj6YuEGk5pzw
         JHmOpk5FYtlINlhpA+xqFlsZ1IOM0KO8IQbL/4Ys/lyRfvPC8JujepBzmkI50DPzxzmo
         6v/ybr90++SLblW3jZ9uiW3bMae+U33iZo4L0ohWZ9JGYomGr20w/BG7BGtt5leLTBE9
         5lWId05YiS7HSOE7KeAppp7Dr5fq6U/iBDWVK5zz7bGx5GGJrslfvYjw50RlLQEB0yIB
         isBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dwmqOhRfBGED6eAD3cPLmI3bgFJNpWkwtcPChSt1vsE=;
        b=ESJwmU9tNsAf5IRCUWUr/Z5BoRUJuJJHRVbU0N+GbTzZBTGXlSmCPB9pFHuGHwbjEb
         rJoexXpXinPnza7GGIwjFB5Y0zVLLrk5zmG2Z5OE4dSzsROHq9CkQk6GIlK+yeQrwT6/
         U8HE+0dOmzM3ILWZDaHtg59p/6KbCxa0bc2UCTqf4G/COqJDdEtL4sDjHBXmtAYhLYk0
         ajGE4Rp4iQpE8E8uHJSqzgyQzOFWRWab/0v3xoMYB7CsE2v/h9yUIRINOweuOZoP1o8S
         aKCWL92Z3pCha8zlE2Lr0tCgRwhenSqLBRvh8FS+fr8CAwsivza418Wicowc6hymEIuo
         C0tA==
X-Gm-Message-State: AOAM532Vi5kwNhSik106j0SJBliZk6L9TjY+mO4qd7DyYGx5ig003+Dz
        K7+VlUlq7U0d1gPdm8oX3dri8bPkJirJLA==
X-Google-Smtp-Source: ABdhPJwuZtKqmMNm8WrEXllcvgJ221tSIuGOVQEC2Pv0BnbMnsCndGsu5pDAEx7zv8HWjjFoBzJQZQ==
X-Received: by 2002:a17:90a:7c0c:: with SMTP id v12mr2271545pjf.71.1604459181393;
        Tue, 03 Nov 2020 19:06:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y141sm499682pfb.17.2020.11.03.19.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 19:06:20 -0800 (PST)
Message-ID: <5fa21aac.1c69fb81.93f1d.215b@mx.google.com>
Date:   Tue, 03 Nov 2020 19:06:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-92-ga976024c6d16
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 133 runs,
 1 regressions (v4.9.241-92-ga976024c6d16)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 133 runs, 1 regressions (v4.9.241-92-ga976024=
c6d16)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-92-ga976024c6d16/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-92-ga976024c6d16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a976024c6d16927a58e27c05d6ffad8a409fc94a =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa1e92f959976237cfb5308

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
2-ga976024c6d16/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
2-ga976024c6d16/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1e92f959976237cfb5=
309
        failing since 5 days (last pass: v4.9.240-139-gd719c4ad8056, first =
fail: v4.9.240-139-g65bd9a74252c) =

 =20
