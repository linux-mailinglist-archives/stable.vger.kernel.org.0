Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C930D2AA7BF
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 20:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgKGTlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 14:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGTlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 14:41:24 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68347C0613CF
        for <stable@vger.kernel.org>; Sat,  7 Nov 2020 11:41:24 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id x15so1741079pll.2
        for <stable@vger.kernel.org>; Sat, 07 Nov 2020 11:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rDx1fGqsDWVmIcyQZk6htmuFcXNH3lhmWWajG8/jqzo=;
        b=yNndLbnZFcz5cFiYY6Uoi42DYHeSa3lu+Cl8SFzQxwpD4q4aocqvZGwhvkL3q+SXaq
         yOCQ1/9mWR7I8F2f5AakFcfvYF8mOqynsr6Czvb2xS5OZF2sQ1dYIIRyzh90mOz3y0XM
         FmQsFxEYmYSK4hLierDXTixbFh16sZ6LEbitPTLudt7x1V8snbo+PFzeowFzxMJyo3Xg
         xYo3n4u7VuaRQ84YcMYPODCFvQ19jBW2yvU6Xt3BGM+a/WYbZD2higCwi+KzUOJKiLT/
         G8sUsppOyHMzT9s55qOBJ6kDZ41dUoYfQHRmr3ABJ/rxhAlTbSXIgCzYTzF8SwfsFZf4
         jexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rDx1fGqsDWVmIcyQZk6htmuFcXNH3lhmWWajG8/jqzo=;
        b=PZ5CwgjJApuhUQ7xqUrVOaMQ0G7gzuaaS03hHrUdQhF5zgPIXgOAnxOz2UO55jcJbB
         ZELXe0z9jYkcl6/EeMOyelumsBs1istYihI47N0MWlcJ4+eaBpevstkcXclDwvS6+h6v
         zTFTGc3HllVz8QXYUuiqXApLffAV5sWVQWr+T376EyNOf/tp3ZF/sPg+R08s+wMXSc2T
         RQEucKiKEE/TkZliW60NyC8DG999dfa8YjFkwLLckQFo2jf/ukDqHy3FZiKis+po2pNf
         oeRr2T+7UI2xZYnSiOjuYBEr6AOvocTgnbQ8nWAYNws90EbH3nvM0L3o9+Xo18hMG0+2
         X9aQ==
X-Gm-Message-State: AOAM533qVDXnudKzEQa/K2BBMzZEuN26wNYub3fxdN0de+EZtDuxZOqg
        2kqSmEsrCM7YYyQGbRYlzk3cjjjRky1A4g==
X-Google-Smtp-Source: ABdhPJyf39Un/R7mHgUzTjCnq3F32k5dE68094nYK10vXc0bgC6A3biXh8nDLXcBDgZFeeDPgSvJcQ==
X-Received: by 2002:a17:90b:4a07:: with SMTP id kk7mr5306292pjb.175.1604778083554;
        Sat, 07 Nov 2020 11:41:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 9sm6288587pfp.102.2020.11.07.11.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 11:41:22 -0800 (PST)
Message-ID: <5fa6f862.1c69fb81.1667a.c4c5@mx.google.com>
Date:   Sat, 07 Nov 2020 11:41:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.241-67-g2727c0277428f
Subject: stable-rc/queue/4.4 baseline: 130 runs,
 1 regressions (v4.4.241-67-g2727c0277428f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 130 runs, 1 regressions (v4.4.241-67-g2727c02=
77428f)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig      | regressions
----------+------+--------------+----------+----------------+------------
qemu_i386 | i386 | lab-baylibre | gcc-8    | i386_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-67-g2727c0277428f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-67-g2727c0277428f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2727c0277428f93b2b9bfcedd7cc8f872b8bd1a0 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig      | regressions
----------+------+--------------+----------+----------------+------------
qemu_i386 | i386 | lab-baylibre | gcc-8    | i386_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa6c184d4485647f5db885b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
7-g2727c0277428f/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
7-g2727c0277428f/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa6c184d4485647f5db8=
85c
        new failure (last pass: v4.4.241-65-gf1e9f1c7f0b9) =

 =20
