Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FDF250BB5
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 00:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgHXWc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 18:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXWc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 18:32:28 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D623BC061574
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 15:32:27 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id z18so186823pjr.2
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 15:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1YiebNFf77qZBwIodjSsSp/XUm1raYWyglQI8njShM4=;
        b=iuFUa3TDhsYE4EQvytxNCwxof1kF/BVJdD0+m7fKOCCZy5BvLmFuP/WOXkgGICOtz8
         TDQ6wSLR7Ds8oroH15PykI7syTrBKEngIHzYTxFPNHYZ6LK4cJ7Fxs8k1GVw8HjHhQct
         KBGfhk+slxAwjZBaKMx1nb25j9Dt/mwbE+o9dgfRgV+Pm6ZbVKkp4M+wzW91qUTrSVeu
         YugW4rdUT/0fMCJ1dYmenQg0TUj5EIssv7N80tsjbwWCsI6cHRCgYnG1GicD9dRcheyk
         Fu9Y120vvxdO/SmKp18rihYwudwPrIYMTtBC7uIr+ZxKAZS5LDpOfoKwnuQufJxIENwN
         GSsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1YiebNFf77qZBwIodjSsSp/XUm1raYWyglQI8njShM4=;
        b=rE/aWEetOuced2DDpZ56WJVDOKWUPs7S2UcUHpA24aSVbttmHnMD5zb2He72CWZ/6C
         HQXqOkANTkwPZaoZzxvdvsqO1lRxOSt5d+U98NwX1eAUDRCMyuD4yRdyjGOzq8tsv+/R
         3ZXQybrr2e39xySQfSHhMG7EKRf0ErrsP9vUEOoMyOAAovsCcsK3pxUg4dNMwl1Lhoty
         bvYQpPZXLM4RtzN1eeRIqa+KO5v74AEaRApGnJiwlvYS0gInCkqsF9ojIQGkwEeaNkuW
         EDYU+2uRY7JOQlObE4zgtLEmUMRWynxjQ6lj2IZZKnae2OK2+1s/zptzSWYvYuJDllA5
         adCg==
X-Gm-Message-State: AOAM530YBxmuMmxgbVGmp8DTAgvuDeo2mUduC0bBVTktpBaAP8aMKleA
        TjMXoXbIs9/jNJmGXfaTkhLyfUxP7fSXBw==
X-Google-Smtp-Source: ABdhPJzsWchroadlctXAtGI2Er1ko5KIZSgDXnJ/28XPmV06e6iqTv1hU5673NOZ+XZqvLac0FA78g==
X-Received: by 2002:a17:90b:4c46:: with SMTP id np6mr1144152pjb.201.1598308346523;
        Mon, 24 Aug 2020 15:32:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h19sm506818pjv.41.2020.08.24.15.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 15:32:25 -0700 (PDT)
Message-ID: <5f443ff9.1c69fb81.858c2.1dc6@mx.google.com>
Date:   Mon, 24 Aug 2020 15:32:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.60-110-gd3dbec480949
Subject: stable-rc/linux-5.4.y baseline: 170 runs,
 1 regressions (v5.4.60-110-gd3dbec480949)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 170 runs, 1 regressions (v5.4.60-110-gd3dbe=
c480949)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.60-110-gd3dbec480949/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.60-110-gd3dbec480949
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d3dbec480949413c968365e6f8c25b1e7847e4dd =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f440b5ed30ff9ad369fb445

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.60-=
110-gd3dbec480949/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.60-=
110-gd3dbec480949/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f440b5ed30ff9ad369fb=
446
      failing since 135 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =20
