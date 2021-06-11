Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75C33A3DDA
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 10:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhFKIOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 04:14:06 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:34729 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbhFKIOF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 04:14:05 -0400
Received: by mail-pl1-f173.google.com with SMTP id h1so2464684plt.1
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 01:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hSmUKsvuss7qsEfZf0c9SBwFbQJ9zX7hfMZNMWUPi4g=;
        b=PoFVrUAMSNrxX/fduH9zprPWNfpXIeWKAiSgWDRJFJ/DJsEMDw5FRSUFSfj+FoDudc
         GxTuyuHWCHyeKKSaJoJtFs0qnFG43yBtOOT2oj7uHk7TQSrsOOtPaqVHpVbp8pCdj9Up
         mpMaqDX0uDBivW13guiItjo4aOKVHnOh+lenOchboJSMosrO4Y533N00plbEEqn+MW16
         kHKZXkvSCgGXqqer/kIq3R1MkmyZ7HO79xiQWLPHafOSiIOaWj53270eCkl5BXHSSS+T
         ZZ+2GZDleh4v0CUlwOTewJW7OdWEV+b1/eXW51i6AUnyVTbjrSEnvyuUfMivs7P+iqCV
         PwPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hSmUKsvuss7qsEfZf0c9SBwFbQJ9zX7hfMZNMWUPi4g=;
        b=AFzHXdxwzacRfwVQEJyvJnE/zC53UfjYtF8+/zbTnzK4/q5+vcKQcV5PTMc5yib+OY
         19zA+pXAu+LEhCqovCjhQX31wE8PAM+rAoiTUDN2zSASWQtIT5mj7EPGFJoyJpkXuCXT
         703IB9x41YACMeIXa3tqD70uXHEKoQMuSwJLLgXaTxXn0JBPmHcgPKGHH24tqgpcv7x5
         5yBTSc2TFoTBdi6ey5S/vruUok8qPxxaKAMyR0MQa4x8E1cDQ2At/Q2Rf2+ebsLdGqoR
         SNil7x3uj/1Kzdn3UN0bxhSd0uYKZN8YJ4SMpHwlpD+x5xuw+iScN14lE8KREil3t6JL
         L0Zw==
X-Gm-Message-State: AOAM533qpySAvHKFbDG14Xkbqg8nC+uyg8HpxVnICsAW1iJwkbEXXSZg
        6PP5DuiJGkwN2IAzo0vHLO/+kVg0D3AzEOhA
X-Google-Smtp-Source: ABdhPJyHgm7/XjBPNeaD5yurxOgoLrMQeZzEk+X0TzFR2+IwWRpGbR1pqhgHXNN01CgtkZOCLKuBgQ==
X-Received: by 2002:a17:902:e843:b029:109:4dbc:d4ed with SMTP id t3-20020a170902e843b02901094dbcd4edmr2863112plg.74.1623399060696;
        Fri, 11 Jun 2021 01:11:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t6sm9595057pjo.4.2021.06.11.01.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 01:11:00 -0700 (PDT)
Message-ID: <60c31a94.1c69fb81.bf6e1.e38f@mx.google.com>
Date:   Fri, 11 Jun 2021 01:11:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.236-20-g3f7ac3761509
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 109 runs,
 1 regressions (v4.14.236-20-g3f7ac3761509)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 109 runs, 1 regressions (v4.14.236-20-g3f7ac=
3761509)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.236-20-g3f7ac3761509/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.236-20-g3f7ac3761509
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3f7ac3761509258038dfdf0d1e3bd8f136221154 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2e7e437a3ae4d990c0dfd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.236=
-20-g3f7ac3761509/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.236=
-20-g3f7ac3761509/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2e7e437a3ae4d990c0=
dfe
        failing since 101 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =20
