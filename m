Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B1147082C
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 19:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245154AbhLJSQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 13:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245168AbhLJSQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 13:16:05 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9401C061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 10:12:29 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id z6so6788134plk.6
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 10:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a7HzSl+ib35pIvPzj6I8ek23sFqokEcKCy6CtE8C+Ng=;
        b=ZbKrp7eVl0Z33dRRMvB0xJGX1eX6QdWXnQp2boZCS1g5GHpdb2IS8Bk7+xWpwZw4qc
         aPaB8xi3EpYgkYpDWOvNDy3+WBFE5IAugqp9EL8ugdq5Xpd6pkf1mJT172QWADZg5Ldw
         MU/CmfKW1LPwlasK+9zL2tStIKVPoXjIW6dlwjO3G7tOTzslyhsfhMO/IY31vdog3J1G
         j2Y3KFXTOPR0J9Lo0lBtK5jyGHG/O0Y2CUdlUAWRrg3cSf3I4Npw0BHacU/B1uUFUKAA
         CRxGTbScpIbXByzmZ2hZjiMpb3BSQEaW4sfGYpCYI9JL3KRfBHZfnM3V4XGHl99GR+uB
         KxIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a7HzSl+ib35pIvPzj6I8ek23sFqokEcKCy6CtE8C+Ng=;
        b=Fjw/nVzLIQAOy1ujwp6I5z3MXvuX8Buxztxbjdt9sV/o1LzG9AIP4lfipXVk5/EYjI
         +wK3A6ZN5R47nRboUZpYD4mVyVUyFb4NR27zdVLyBahzQW7ZCfqzf7IMLoaW0fgXc5qw
         It1b3Allo3eUcfgtUXkp29E8uB3PlwCggJ65UuVBWSx9ZJtwkf8gw5RSt4CAc93wUI1R
         JgLAovDb5EKLERZgJEVyAkxb5XjAa13CDAM9PdWYcCl17OcBVPUIXTNs6Epyks/WeSUz
         kBDlxcBM+TS9ZCwUPI8qqOir8/jD1CTSMnVwHzr4TO1dtf9xHGkgcOgjdIWD7Y2e/wGr
         aScg==
X-Gm-Message-State: AOAM531lDfG+XxrISBrq5bsdJ+yQYOq7N8B0i76r2o+CZhCjjxJtRC7c
        UKPH3rJU7wb/VDT+Ei5UV6FvqxXB1xKLCwMK
X-Google-Smtp-Source: ABdhPJxqJHeyE8nuR6Fm0KxzbWG2FZ9QI//fO8Q/U0AYDueGkCe1jqezOfNOijK9F4LJeZrQh7wKkA==
X-Received: by 2002:a17:90a:be10:: with SMTP id a16mr25489239pjs.133.1639159949250;
        Fri, 10 Dec 2021 10:12:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z22sm4418184pfe.93.2021.12.10.10.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 10:12:29 -0800 (PST)
Message-ID: <61b3988d.1c69fb81.aab78.c898@mx.google.com>
Date:   Fri, 10 Dec 2021 10:12:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.220-14-gb7524491658f
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 167 runs,
 2 regressions (v4.19.220-14-gb7524491658f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 167 runs, 2 regressions (v4.19.220-14-gb7524=
491658f)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.220-14-gb7524491658f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.220-14-gb7524491658f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b7524491658f65aa1cf90be0e1d3bc80fb086e7f =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/61b35f0c06e865ccce397145

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-14-gb7524491658f/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-14-gb7524491658f/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b35f0c06e865ccce397=
146
        new failure (last pass: v4.19.219-56-g730dd2023c98) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b360ec310426681239712b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-14-gb7524491658f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-14-gb7524491658f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b360ec3104266812397=
12c
        new failure (last pass: v4.19.219-56-g730dd2023c98) =

 =20
