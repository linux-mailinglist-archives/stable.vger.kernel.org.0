Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7CF3C4136
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 04:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhGLCa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 22:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbhGLCaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 22:30:24 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A7AC0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 19:27:36 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x16so14932419pfa.13
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 19:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g+v0l/ovZF2vR0h10LkeW3Sb0vfPVHazNfpfXYvzFQA=;
        b=YeORTxY/GLZCemrQCHIT6OJ6ukItc9z9m5bqklWyb70E6oNv2Sn+vcLS8lNgZyF+bU
         OuKOk0wM6NuiB1NHLripp9LI/7e+fGZCXLVzVmGvtgDLn5WfhAfGrx9cUvhjSo4hSXQv
         nvDmAfpAqbpE3LXQ9TYkq5KN/1ll4pKE9uINkCaOUbMdk069AnT4bQwg3wzq/b9q6rCN
         oYJzullYwfz17Pp42kQWOjNTJ/hVRpkU0wMaAI18+qXCN1VWRlb8v18r5mOoLRrTNp5P
         jjjYAIGhNMxhj+nV9Weh2l0bSLwwyUyO744HQeptX9JTj/TNQ7KnDyBAWIj+qnWS2+te
         A4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g+v0l/ovZF2vR0h10LkeW3Sb0vfPVHazNfpfXYvzFQA=;
        b=fM14bwCfIDaWv6gqQ++bNYzUcUIrUAVjVS8BcONiVm/oW15fp1Jf1YtN6qCMsfeEJ/
         HtNxNCcxW6QEwsLJP+YTWF64JLZx565FbSIqN4Ys+BoZ5UIG1XAgJ2+DQQshcmcqX4rx
         /Omp+DfR8JFVbpdRkyeOkCgKjhXeoy2+8nVbFkGtttIH0CMfn7k9OphrmmMbkXzp1Urr
         Oil0e+BdGIsBfClMgJw+JvVF/KoaMbwo3TnuOD7I/uhMBDlPgrQIrmGdPiVYKpU0lunw
         wFTIUtB12hQLFlnc9Rw2M9mcgQssyWQ7CvajVZEWEq4emuOrnD9GtVLxLuntyF2MUkX6
         0WHg==
X-Gm-Message-State: AOAM532g7L1ErhMxepGoBJ2nO95PRLFYJvFyzoalMoe/R2eumi7p9ADg
        bV1D5cAo1M0/r7OjA5kWUQCEl6arXkPUK/ST
X-Google-Smtp-Source: ABdhPJzLOJc2AZZoVN41C7VOAwQOobg67g1mCKMqBxNXUnBmisVmKP3VCsUpKuIX/QagsqcAqSnr8A==
X-Received: by 2002:a63:f44e:: with SMTP id p14mr50507089pgk.143.1626056855320;
        Sun, 11 Jul 2021 19:27:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c5sm14273648pfn.144.2021.07.11.19.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 19:27:35 -0700 (PDT)
Message-ID: <60eba897.1c69fb81.70196.b0a0@mx.google.com>
Date:   Sun, 11 Jul 2021 19:27:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.49-593-g1d9b6799b02d7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 185 runs,
 3 regressions (v5.10.49-593-g1d9b6799b02d7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 185 runs, 3 regressions (v5.10.49-593-g1d9b6=
799b02d7)

Regressions Summary
-------------------

platform  | arch   | lab           | compiler | defconfig                  =
  | regressions
----------+--------+---------------+----------+----------------------------=
--+------------
d2500cc   | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig           =
  | 1          =

d2500cc   | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-chromeboo=
k | 1          =

hip07-d05 | arm64  | lab-collabora | gcc-8    | defconfig                  =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.49-593-g1d9b6799b02d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.49-593-g1d9b6799b02d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1d9b6799b02d76593da850fe0cb38880d8fbccc7 =



Test Regressions
---------------- =



platform  | arch   | lab           | compiler | defconfig                  =
  | regressions
----------+--------+---------------+----------+----------------------------=
--+------------
d2500cc   | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig           =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb740c8e8f8b1c3a117982

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
593-g1d9b6799b02d7/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
593-g1d9b6799b02d7/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb740c8e8f8b1c3a117=
983
        failing since 0 day (last pass: v5.10.48-6-gea5b7eca594d, first fai=
l: v5.10.49-580-g094fb99ca365) =

 =



platform  | arch   | lab           | compiler | defconfig                  =
  | regressions
----------+--------+---------------+----------+----------------------------=
--+------------
d2500cc   | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-chromeboo=
k | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb75608390bdaed4117988

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
593-g1d9b6799b02d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
593-g1d9b6799b02d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb75608390bdaed4117=
989
        failing since 0 day (last pass: v5.10.48-6-gea5b7eca594d, first fai=
l: v5.10.49-580-g094fb99ca365) =

 =



platform  | arch   | lab           | compiler | defconfig                  =
  | regressions
----------+--------+---------------+----------+----------------------------=
--+------------
hip07-d05 | arm64  | lab-collabora | gcc-8    | defconfig                  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb817ef27e1442f311796e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
593-g1d9b6799b02d7/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
593-g1d9b6799b02d7/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb817ef27e1442f3117=
96f
        failing since 10 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =20
