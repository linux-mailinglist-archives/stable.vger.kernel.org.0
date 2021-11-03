Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC639444AEC
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 23:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhKCWrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 18:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhKCWrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 18:47:25 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BABDC061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 15:44:48 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id l3so1942310pfu.13
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 15:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5E+u0RgJUhav2HkwpnWWHtFUEP/vrbpb6+GKxAFrm5E=;
        b=dOvlXYczx0RCZSL41kTOYP3bZ+jaHGgqW+xAV0cEb9pns7DVR/xiTzrbusLEuHPigo
         JFaW1vQxJ1p0+K/4aLLrCxyHVLjTrvcQPRnHK0o3cjkneE0OH7Nn3jycPJwtt3sjpHGN
         E2pq9QNPVNIO5fau5AhWCdL/tVFOAxViHEaWImouv1iJ7iiVkftNQPvWVK0EWtohwWgh
         afIdAENwfw+EQhn1laMBT/L85XKqm1aMdM7bTE5FxhfjBqB0vA0OEj7+ChnSslH9E0ks
         1qHv96EUJ8ppdcX+qnDZ89kBj+3RYGOp5iJlH1GFHvV50aToHBrgp1VmPyXWU7syFpWQ
         1qoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5E+u0RgJUhav2HkwpnWWHtFUEP/vrbpb6+GKxAFrm5E=;
        b=E1GdfeX2/FMcG27+PNZkq/hg/rkphdVjPqtV3Gg9gSVCZKbtE6txJidGJCdEZPWlmL
         qq3qDgf9ZGQpf/+S99/W/lKttgjCkdqVae+z1hQXQuXn69nkn7qNADIW9AtmDkoIsYCU
         mnDus4Tm6rYdCIFHIWWYnszlVjllGCq3/KtLetFi0fRU8EkdgOq1X3Lsn+juX5UH4UWh
         mXUCi55WlL8II+rIYpZd0w9ylDgqFD8fVz7bqRNL4mJa1ECyHXQM8v7TE0wCQYzXMaOR
         aYXJo0x92WvhVDs5iUXG7EQXlRk0g+wwKr+W+Irz7ySxPiLAvPZrMdqwG3I0yXKvUN4j
         4sig==
X-Gm-Message-State: AOAM533Y29Y9fpxKJB+aITaU1qOQkAHQXq3rPlaadjEbBqMfrL8y4Rri
        Gtb0gtBIyZztEArnRndQDLtU4Mcd/RW2Lnw2
X-Google-Smtp-Source: ABdhPJxKmIYkA9MVLATqJIga+bCr4SYrrDhBjJKzt1avmgJSn5wWA3YLcvskE6iMfEbTrNxDLgAWmg==
X-Received: by 2002:a62:ee17:0:b0:47f:f597:eb77 with SMTP id e23-20020a62ee17000000b0047ff597eb77mr36206403pfi.14.1635979487728;
        Wed, 03 Nov 2021 15:44:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g37sm2603065pgg.89.2021.11.03.15.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 15:44:47 -0700 (PDT)
Message-ID: <618310df.1c69fb81.97d11.8aa8@mx.google.com>
Date:   Wed, 03 Nov 2021 15:44:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-1-g1f67e88441a0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 103 runs,
 1 regressions (v4.4.291-1-g1f67e88441a0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 103 runs, 1 regressions (v4.4.291-1-g1f67e884=
41a0)

Regressions Summary
-------------------

platform    | arch   | lab         | compiler | defconfig                  =
  | regressions
------------+--------+-------------+----------+----------------------------=
--+------------
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chromeboo=
k | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.291-1-g1f67e88441a0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.291-1-g1f67e88441a0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1f67e88441a0606a4a8160ca5ef27f3a610b2152 =



Test Regressions
---------------- =



platform    | arch   | lab         | compiler | defconfig                  =
  | regressions
------------+--------+-------------+----------+----------------------------=
--+------------
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chromeboo=
k | 1          =


  Details:     https://kernelci.org/test/plan/id/6182df1ced8008f4e33358fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-1=
-g1f67e88441a0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-1=
-g1f67e88441a0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6182df1ced8008f4e3335=
8fe
        new failure (last pass: v4.4.291-1-gca04241b8259) =

 =20
