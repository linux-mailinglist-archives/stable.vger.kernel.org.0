Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653B0284009
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 22:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgJEUCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 16:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729424AbgJEUCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 16:02:20 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB18C0613CE
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 13:02:20 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id l126so7661912pfd.5
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 13:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=84yoICzcKtYlb1n7Sthu46J+vmUBYjZ14NTEIrYOUAA=;
        b=U0SSKsnxoxuGLfqz8HFjL0IbzVAliH4v4v1reAqeOYajTJxE3408XIZu+not1730cu
         wrJtVnah4SIsaSs4RndEH9gItd1pKg4m0Zhpqxdb3BYaiI0U3OuB8WIRoin0n5Jjxpng
         rnCREuu1u2oE2dUk8Kkcvmf8uTDJh2wnQOc+yvGiMPFWB1DRz7Br4ccBdRhHY0vD6wLL
         ztXEhxkxsgzUnOoG1/rItBtZtMYM3BCT3GMBzF4vpVrDd7x4bmR7+fUODVzRzDHhvLfU
         cQ44sfVa9VccHWEFuds7WCHvmkharQQBEqUdVv/2j/WNGrhLAdXPlpxRN3Wg8AZsklHA
         5MDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=84yoICzcKtYlb1n7Sthu46J+vmUBYjZ14NTEIrYOUAA=;
        b=NgQ+L8IACsMUr4lhB9KTLhBH5sJYGsGfPBYegBpOFNi2qx9M6aOIacu2bf55tIAiCu
         Dzr0EwbfJ3AR8PQQbs7ByHRqSvnZAfjMKkc5DixG2ew/YgDL1IWmi7mt4YSnlugS9y5A
         erqP4dco880BnOEb0KHj4gYrcuT0d2/tb8m6G7zcCkk6N2SLhq5CUNS8LFlkZvmHxBez
         f5UOYmsr1blMKji8TrNUTeV2F8ZrtSMfI8Vfha4CxTdv3Rr8Cx69TEl0og6Of+6G3bNf
         YFqFavPHPW5XYk1KGNFaKMr5MQRG9vw1HVakWx4t0qu3NyDFlo+gscDnH+x2vX61nLqy
         X6sg==
X-Gm-Message-State: AOAM533/e2Cx/zND06WQ4RUHKbDcZff3o7NsGhl+vP4VqlXCQS49/f93
        l9ktjiaWrDgIGw71Ad2yUn81FiKGl+VbiA==
X-Google-Smtp-Source: ABdhPJyUeWpv3ITVubhNyS1njT+1RJL869jrwYL6zGddTyxzrRm23SjwkflF9s5nbzUvPl0C4/Zo/Q==
X-Received: by 2002:a63:104d:: with SMTP id 13mr1046390pgq.445.1601928139151;
        Mon, 05 Oct 2020 13:02:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c201sm755123pfb.216.2020.10.05.13.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 13:02:17 -0700 (PDT)
Message-ID: <5f7b7bc9.1c69fb81.a4b85.1dc6@mx.google.com>
Date:   Mon, 05 Oct 2020 13:02:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.238-16-g98ec56901158
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 83 runs,
 1 regressions (v4.4.238-16-g98ec56901158)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 83 runs, 1 regressions (v4.4.238-16-g98ec5690=
1158)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.238-16-g98ec56901158/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.238-16-g98ec56901158
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      98ec5690115898ecb3f8d45802239aa06a3f46e4 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f7b42e45e29efac8c4ff3f6

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-1=
6-g98ec56901158/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-1=
6-g98ec56901158/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f7b42e45e29efa=
c8c4ff3fd
      failing since 1 day (last pass: v4.4.237-85-gcd7b2e899081, first fail=
: v4.4.238-3-g44c1a5097bba)
      2 lines  =20
