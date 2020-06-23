Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35BB204698
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 03:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731695AbgFWBRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 21:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731466AbgFWBRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 21:17:44 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E4CC061573
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 18:17:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id i12so754649pju.3
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 18:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1FE9XdJd6LSwLeVgVc6eao0FuptUNRYFHnvUaM+qiKw=;
        b=ql3GjdrRB+/1VxSaRcBGnSX7Y6c9HUB9VIHZHkgB+UDVErmevcpiq5RBYn0DMAN0gf
         MiXhbuUePQh9BBKT24KHlNm6aBfPwiJ83LNEwU+8Z5w6zZUYWTQEfEQOXwCioMdj3zzo
         fhj2XSXS7nOmd6jRLyE93gQtLoeH5pnYSdPZmQ7DStzqzwr9G618+IDJNHz7ZG2Y78Q3
         zpAKdAonAGCSseWdYL+LhraIryQKq3w//FBjclpAeup/RrLwixKzii1WWlwXoj8DQVgJ
         Ep+qYNrKgmwFztZQYuhESEakKExcB5V+1c9qjdhsL1tOEnbBcHGzBybao59gbwoYCZ/o
         W7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1FE9XdJd6LSwLeVgVc6eao0FuptUNRYFHnvUaM+qiKw=;
        b=awX3R7F6O3o2CJOje7g/d1CmNhPjcQ+VLqXKKvVDBuwnCIeqSXRGX4mzamxR3c3/xy
         g+oW+gZF5V+fQlTZDLmyaasq1mAFI04TxbucxExvxS2YXkiOE1fv5D6fkMZdNw6gnNGL
         MOVl81T7CE4cOrGSAEAfFrmTKCCGqAGBYE8dEb9PN5gw/PwPCSgFUgNS+1tlCgt+VtyR
         0PehSndQw7Yxf0987Hf3uMIraqqdmmjB3LVfsy2S0OaYI1Gv8bDprHH6nJHOiPs+DGYn
         cdsIdqGoKl1jZbLOoY/KPf3KC7Vo4fj4wHnSiHDqLddcJ9q1sFG2AssWNWt99wDmLPBt
         84Sw==
X-Gm-Message-State: AOAM5328gNRl/br+px7jTj7FLtdzRHpg4dCpbR25mqVxwvvzFjDFVdVn
        4TTCc8K3bFyNLrr0ivu5KS7jCK9+/tc=
X-Google-Smtp-Source: ABdhPJyCh7i21xpGz7UGKN4exxstudZr2bxggEc1JO0OOWTtW8bDVv1uKPOva0kvugLvqm0SHwUW5A==
X-Received: by 2002:a17:90b:23d5:: with SMTP id md21mr377648pjb.0.1592875063695;
        Mon, 22 Jun 2020 18:17:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 207sm15423350pfw.190.2020.06.22.18.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 18:17:43 -0700 (PDT)
Message-ID: <5ef15837.1c69fb81.5420b.0918@mx.google.com>
Date:   Mon, 22 Jun 2020 18:17:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.126-501-g74874ce1e245
Subject: stable-rc/linux-4.19.y baseline: 49 runs,
 1 regressions (v4.19.126-501-g74874ce1e245)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 49 runs, 1 regressions (v4.19.126-501-g748=
74ce1e245)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.126-501-g74874ce1e245/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.126-501-g74874ce1e245
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      74874ce1e24550bc345185188f9abbaec8ec6746 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5ef1233804522ec58597bf1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-501-g74874ce1e245/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-501-g74874ce1e245/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ef1233804522ec58597b=
f1d
      failing since 6 days (last pass: v4.19.126-55-gf6c346f2d42d, first fa=
il: v4.19.126-113-gd694d4388e88) =20
