Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B2B36B24F
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 13:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhDZLXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 07:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbhDZLXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 07:23:52 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F93C061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 04:23:08 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y62so6074741pfg.4
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 04:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vM+uRvCiVoS0oZgWukLZU8UX4dGcTmIsb66Uy1XlZyI=;
        b=jx/FwMBkYaAOjyUBT3gVryv6UH37+Y1PgSy3+CPNM6TEaaST1XvQMHnNaYFH2Yel7o
         j35yIVsZoFYi11yC51+wH8l2fdzGtZLnkiwXb2ZsmmGTJ26RkjZg8WVfthaShPp7U1aP
         +OqoVVepu7CfUOEDzy2ELt7aRbUVJYepDYxPGnSkHMi29KwCzo1juV61BbboEwZtSkb/
         ahIqmAStXcdP9HYe1urz70dnXdBUUzDiSOLzlXtUBaFv771xQIl7nbMB5eSZREbVEUPv
         dQZbPseNbXEM4pVs0GKprjWNQW19FwzrptnlfHgLMUxfv9tYmlJfMhFH2c9DGor9ItgL
         a+bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vM+uRvCiVoS0oZgWukLZU8UX4dGcTmIsb66Uy1XlZyI=;
        b=ZSSOuCJcOfQTzDczE8+/UVOtefTVpI3pKoL840kMCIrGkh0se3O8JW1+KTekRPA/jm
         fLWnX8+IGq+1KoV0DUz3fJuMFhR2zVkXIF6NilwoK3Yws8fURx6+9ODDW47/jujH8EPo
         1t9RUu9k9qgFXoG6r7RgX72eITjT0TsoUdrrYYbfpu8g3ipejYczqNX/CBLjaWcGt0FA
         641hR+xP/0Jh0fCfGXJFBMwzNNb9gQcw0dS9+XgcMkE49qJuE9Bo+2vB48ShS+dp/Hp0
         XpNFJqx1iQ/5dtABZulnw4EZ/oYB1SJY17K8y//aKQbw5T4fmtNYRn6dWLGrZy9ENcV9
         0/0w==
X-Gm-Message-State: AOAM531P2Yu1RU0u/83S6YXVQvwsN047NEgBtZHDoX9ZaLXJyBrehL2g
        MTfxRp07PdpjtAUaZmnAkzv7p18tWdfma88Y
X-Google-Smtp-Source: ABdhPJxIeutZJY8n99BuTaCR9Ai7uY0SCymZjUxXD+BDlFnImiUnv/nZy8WovZxqD5yRoVG5STn4ng==
X-Received: by 2002:a65:6a0d:: with SMTP id m13mr16691558pgu.43.1619436188246;
        Mon, 26 Apr 2021 04:23:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b7sm11158900pfi.42.2021.04.26.04.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 04:23:07 -0700 (PDT)
Message-ID: <6086a29b.1c69fb81.d4351.0484@mx.google.com>
Date:   Mon, 26 Apr 2021 04:23:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.32-36-gcaa8429a5a1a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 147 runs,
 1 regressions (v5.10.32-36-gcaa8429a5a1a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 147 runs, 1 regressions (v5.10.32-36-gcaa842=
9a5a1a)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.32-36-gcaa8429a5a1a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.32-36-gcaa8429a5a1a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      caa8429a5a1a2f56ad51bb889a6b932fc300b24b =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/608673162ef6a7cfeb9b77ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
36-gcaa8429a5a1a/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.32-=
36-gcaa8429a5a1a/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608673162ef6a7cfeb9b7=
7ad
        failing since 0 day (last pass: v5.10.32-12-gd2a706aabb95, first fa=
il: v5.10.32-35-g413e8e76f9149) =

 =20
