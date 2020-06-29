Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7496E20E8E3
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 01:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbgF2Wn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgF2Wn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 18:43:28 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A2CC061755
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 15:43:28 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id z5so8983783pgb.6
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 15:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sRbXY4cehngYiqmltIGKF5pxQvXR9q0G2ed+0T/nW+s=;
        b=Ye5n+awhL/FXfKdhVHr5ajM5nn8Aye0DbvKgAYm42Zwncu2jV6H85nuIanDKRjeuh3
         EUaGDPzXwOEbANCwNrkv3WXDmG8ykOMn8Q9tDLe09Cv6soStK0QUa6uHY5PwN/2XqKQQ
         ewq9ahWK1Mjx/0q1ndF6Gf1Gbw0BL8a5Vkp0n/eQQWo6ITAiJiBYFXtasgV/ef/qcPjq
         dInD6Ok5X1/0u8ixurHBp9myAwn9p5rNpz93AYS8pkLRMzdZB6JQ0FMLuGclDAVL+5qV
         HxMx8A79Rk0rBjf4poYo60Y9khlbXQ+RmAjCo5YYw9DASztO5XDP9hgZpDGBpvo0Kamt
         j23Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sRbXY4cehngYiqmltIGKF5pxQvXR9q0G2ed+0T/nW+s=;
        b=iXnOyvz8Lv59TzD15oXs+QA30TgiJwwdDAiJIPdoJxGlkNuvNrNVsmQkM1BOhCHNYb
         ZQuHxuRkkI1wCJgOSVWbLwaJCsT0sOPMNX90SFgirVXd8SzeN9Cfiw0AUIA5Xmfs0VsB
         5k6kP//dOPkFQjPwLlyfF1yE6/kpKbI8jh5Abr6Zmsg+CsaEgpYnRhhbuVjiaB+b3b+7
         PkKhIgku9D0XYueTzFMs18NgTbDSqhBxHU28B8E+yRJA7lmiy/BjdWBpHFs7iCwkFQYO
         I6xt3ENQZkYq3AJfQZlfuiexn70PJ8CfQCQCnhSaqxqWMq4LoLh6s34CRfMRV/kDGWpJ
         MSsw==
X-Gm-Message-State: AOAM530GVJqYwTAG5eBLaNg+8GWElA10iX6WNsWQQqDtrW0xiWFNCdEZ
        fzO5ZFOK0UrCROwBYZ7GwmPd1nd49Qw=
X-Google-Smtp-Source: ABdhPJxdlS4KseJ6ik0FJ7PxJi7LelQTYz4sFpcS+/oL177IsWWj/QY0hceX0UdDCEclweF0nKYBKw==
X-Received: by 2002:a62:6446:: with SMTP id y67mr9215741pfb.299.1593470606320;
        Mon, 29 Jun 2020 15:43:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u13sm442166pjy.40.2020.06.29.15.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 15:43:25 -0700 (PDT)
Message-ID: <5efa6e8d.1c69fb81.57d5b.1bef@mx.google.com>
Date:   Mon, 29 Jun 2020 15:43:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.49-178-g7d61c4b6865a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 72 runs,
 1 regressions (v5.4.49-178-g7d61c4b6865a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 72 runs, 1 regressions (v5.4.49-178-g7d61c4=
b6865a)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.49-178-g7d61c4b6865a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.49-178-g7d61c4b6865a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d61c4b6865ab9c9f22e4ddbc65645c0c4b0427e =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5efa354f8e13ac2aa785bb35

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.49-=
178-g7d61c4b6865a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.49-=
178-g7d61c4b6865a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5efa354f8e13ac2a=
a785bb38
      failing since 5 days (last pass: v5.4.44-781-g065c1728d31a, first fai=
l: v5.4.44-778-gf7f032930408)
      2 lines =20
