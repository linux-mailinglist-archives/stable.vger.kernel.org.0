Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631B638B12D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 16:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243618AbhETOL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 10:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240755AbhETOKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 10:10:44 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34A3C061343
        for <stable@vger.kernel.org>; Thu, 20 May 2021 07:09:22 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id kr9so1123205pjb.5
        for <stable@vger.kernel.org>; Thu, 20 May 2021 07:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cDvb5ovi+VZVi1q/iJ3qouJ+JJ4uChIlcxma74uEdZw=;
        b=SXlbU9W49aXH3hAX635U9uSa1S6c+RRVtsjkDh9WNjZd74UkBQu5lQ/7+MXdKyEblN
         hpZ+z47d7ExsOZPJHldI1/8KgP+twgBw0QIXRzxB8pSeXZjGCSq5CpLuESk11rdHw9d8
         qj1ptEi6xZiUNhRFOpdZwz4W5ZK0xOzT+ACE7Wv6Ja4iVS4BVi4/jg0Day5vWNapEuh7
         XH86bxbihVFNs8kWtsU6ulUOXDiPayqijFFMcqYNwsps/o0gY/WUFngsyGRuWwarhox2
         tZkl4U+RB3g4jJKf8rmZioFVT11e1Gw6Yf7AFovD90Yn+LYAp8OivnAuDQh79D2zjQOY
         dv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cDvb5ovi+VZVi1q/iJ3qouJ+JJ4uChIlcxma74uEdZw=;
        b=nvSIUGbdlBfoJY8riPPEZIP4NVgBagQY+cDIttOOIBY4b4kIsdPlNqj651etu3rZdi
         GCa2MPAkqW1nQNn0xtI3/V68IUb8vsUdE/BpEDZ5ET+SgfhIMWwjsouC+Uk5zkodWrsp
         EAFPArmZ6zH7z2OiEYJKTr9LoBJlakf/bLg5u7+iVxZzfB3AmBw2hJ7EOZ6rGlWWh7YK
         6C5dcU+t+nmLGcRTZgCnqgD27AC/cIj/Vk42RCtpZeQfY5uWsLcDrsHTx2M14he52N+v
         wYCZiXQs3kcDr5aBmorVwJ1JYf5im4uBDdwcLGbU5Y3bYOcr4M1hiJEVcjLMou56Kcvw
         IojQ==
X-Gm-Message-State: AOAM5330+RCalNxQdJ8XKo1CXrVkTQt4ZTo1phq6LTsqF+S+QQCh7kjk
        Vsl0UdVgoXXqSzKYCAPuc9twrcZUYnz4QQYx
X-Google-Smtp-Source: ABdhPJwsy1WP7mXnhvQPXmlRlC5oRbPGAgBdFKK7bE/UHfOScVQEew5QOqkju42hLJ/UyadEnJbjEQ==
X-Received: by 2002:a17:902:724c:b029:ef:571f:8894 with SMTP id c12-20020a170902724cb02900ef571f8894mr6001078pll.49.1621519762130;
        Thu, 20 May 2021 07:09:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c19sm1602248pfo.150.2021.05.20.07.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 07:09:21 -0700 (PDT)
Message-ID: <60a66d91.1c69fb81.b9ab0.410e@mx.google.com>
Date:   Thu, 20 May 2021 07:09:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-323-g65ca645ade62
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 93 runs,
 1 regressions (v4.14.232-323-g65ca645ade62)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 93 runs, 1 regressions (v4.14.232-323-g65ca6=
45ade62)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-323-g65ca645ade62/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-323-g65ca645ade62
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65ca645ade621ef0f6bcf2d51a64979b5a7fc029 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a63ca6c7b419cb41b3afbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-323-g65ca645ade62/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-323-g65ca645ade62/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a63ca6c7b419cb41b3a=
fbe
        failing since 80 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =20
