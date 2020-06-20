Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD1E2023E9
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 15:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgFTNQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 09:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbgFTNQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Jun 2020 09:16:41 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290A8C06174E
        for <stable@vger.kernel.org>; Sat, 20 Jun 2020 06:16:41 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id b5so5817728pgm.8
        for <stable@vger.kernel.org>; Sat, 20 Jun 2020 06:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rToEykrhfBAWEh8sKVPJanTs74KR+XLMH2ysvOevMOk=;
        b=wi0dNKatxlPMwVYj3XgTZaDNC03EqSQYe2mHfmJD+Drnezg/oG5MbQCa7OJzfIalM0
         zRfKUnX+xuDRhagT11avjrGV5q06SS0fuRDKBdHHoIzJoptvphxK6dRYsp0jgXucAIGX
         b2nX8Dhe9td5WsqLE52WWpZphTXECkQ/eL9QruQPYIdPMCOsH+O/Af9uK/20xnEmDqUr
         TzwMJQFMtexAQ61x6sIN1Is3vqdDGWBrJ18OZEQpK/IYQu1954mNGF5iEDhqV6eRMFz6
         Zoqy14PCjT/eR+wdx3TPlqBlAaXsv61oah+LPKbOsY7uOQnAqa69RZdtiONOQOskfZ/n
         baRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rToEykrhfBAWEh8sKVPJanTs74KR+XLMH2ysvOevMOk=;
        b=UL9zEwyZOudjb3dMHt0c4w72vyk1TI0iV+jwwCEea3RBYd/hIi+x/gXLkNmSpS4R4i
         qNklj+ZxcQ6OfJ4NQg54fLL/yLaBVdtN2DC/jHaBmJlUq5fJltXfjamOjEQu9tdxXUTK
         maH0dzZndhG4Yalo6geg5IeE+i7x7z4SBwDjUdHRdSxyVjL1jfecaD64sFoCSGkEM196
         VghDcwiSAwqVWagF/508f3XGgqkwcycN8gSfQ8xxDAmoYQtkCBAqSD0lBgjMcldLBoGa
         Qnh2KfySh+wDd3IuqH0zUuc0kkkTrjWcHq/7heHIB1JHLWbqgcg91lBJyHbatjJ7MbrK
         QSew==
X-Gm-Message-State: AOAM530tGqFYxvewkFH36h6yF1XHN5cFAxznBtGX1uk6fZpzy37J79kb
        A8/pJWM6SkVNfZJxhJM4lLoeLeK5LjM=
X-Google-Smtp-Source: ABdhPJwSuM48x9EaDg8SEDsetQYNbXNu25jrcp1BNBxEfQ6o0+Nei9i5Y3kIcCyz+LLlOZ078B54QQ==
X-Received: by 2002:a62:154f:: with SMTP id 76mr12417090pfv.322.1592659000140;
        Sat, 20 Jun 2020 06:16:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q16sm8919954pfg.49.2020.06.20.06.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 06:16:39 -0700 (PDT)
Message-ID: <5eee0c37.1c69fb81.d6448.b4c8@mx.google.com>
Date:   Sat, 20 Jun 2020 06:16:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.185
Subject: stable/linux-4.14.y baseline: 70 runs, 1 regressions (v4.14.185)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 70 runs, 1 regressions (v4.14.185)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.185/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.185
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c5c055bda3351ea0af86a266fd968ef1cbf328fe =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5eedd926643c3fc78897bf4b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.185/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.185/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5eedd926643c3fc78897b=
f4c
      failing since 78 days (last pass: v4.14.172, first fail: v4.14.175) =
=20
