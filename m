Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272CF4790FE
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 17:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238859AbhLQQJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 11:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235181AbhLQQJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 11:09:51 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FDCC061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 08:09:51 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gn2so2660816pjb.5
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 08:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tOTvOWaqElruVtM3IjchfXyEJ9lOh4mqo0v+/8jew7s=;
        b=jsQBY/+RcgPKkh6oQ9TvndrO8APXppj11ZJ36Dd1Cx478bXJtFYrjnQH3sEDBEI/nR
         aQVoTCaeFdRdkdVviOnMRYt60xlsClDf4MyTZrBfD2D1d0tBiih4KhHWkaiM8QhjB9u0
         zSKMuq3pqzCKTtAqW5Nsxyhy5iosF0aomFg1QaUs6VsnRvhWBtUilw6HiNYq3VS++/QM
         47r0J3MopnqyJzNwatS/S7tztTwtq5+fkUCPJsmPMAtTA6TX8TUvSR5fPgI2tsaOgI+D
         EiPo7nWVxw2RMmEJswVsMasZ8EPG/I81KEvzzg99xPac7AFNLzLI47O8ZGdbCA7huZaV
         WZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tOTvOWaqElruVtM3IjchfXyEJ9lOh4mqo0v+/8jew7s=;
        b=mbq/lOAF6qJ5B3xzBU7yg88Cw8RAMOo9ooxYr7WETQfvehlsYhduJJ3g1khm4Sda9u
         zGSzF1sreZPtM/+TLJpKNmSTmA4OxOZfmwGBHy42wDJpvRGGNRl7ImRe3Cn8ICZsLXrO
         J890PWxhkG4U0J9S/aD4h1Y1t+t/8NCNSKWlwP3y5QcwKO3SMiE1KfRVHAx+cG0IcMYx
         H09eHGmL0ZpHG9Gzsnfq+GFSzhpyVJQJgVBaKLY43tdjboBagCcH0rZ8ZlFnEJYNrly0
         hMrNw8PlfD+8n3xpdR7DTbiHU0ZyaF++hilM0SLacH8rH4BUVIkx/tSsx3Exhcd3aij3
         B/0g==
X-Gm-Message-State: AOAM531qwYUsFBEpSwboCZOT+7rIkFKxssnfYsshAELZlYPo1eiSL5Vk
        b/Q/hbmHbBquHc/vM8dI52LkAyWRmtVYZ0MQ
X-Google-Smtp-Source: ABdhPJxbWbQAb1PgplticIwBdo0Bd9WvZUp33066BRnlGzl5KxPf4DQAzlMffR0k9pAUPbYspr3wDQ==
X-Received: by 2002:a17:902:7b82:b0:143:a6d6:34ab with SMTP id w2-20020a1709027b8200b00143a6d634abmr3901015pll.30.1639757390651;
        Fri, 17 Dec 2021 08:09:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f20sm10547419pfe.103.2021.12.17.08.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 08:09:50 -0800 (PST)
Message-ID: <61bcb64e.1c69fb81.d9bfa.c662@mx.google.com>
Date:   Fri, 17 Dec 2021 08:09:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.10
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 171 runs, 1 regressions (v5.15.10)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 171 runs, 1 regressions (v5.15.10)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.10/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      57dcae4a8b93271c4e370920ea0dbb94a0215d30 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61bc7dc0de65c3ba4b397128

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.10/x=
86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E38=
26.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.10/x=
86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E38=
26.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bc7dc0de65c3ba4b397=
129
        new failure (last pass: v5.15.7) =

 =20
