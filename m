Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A8847A864
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 12:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhLTLIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 06:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbhLTLIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 06:08:31 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE673C061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 03:08:30 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id z9-20020a17090a7b8900b001b13558eadaso10844196pjc.4
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 03:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UvA0VwvF/h6uXpoj8ief9LEDTmC8hm9BbvN603/cueo=;
        b=A/M7yEHVZsn1HDUXaGnTDI2/a9BlBjNyJNP0UAmLoc+fj6kgsKXmnDFoZ1HtwxFJ71
         fS1EtkChYq9P7Lai4lAyhFqyVQjAG/iGoTHl0sGNL2RxPriJUs0Xx8EHYfW9OVaYwwqB
         fbIKM5mH6ByO/ctXB0uyLZyEiL+yJG5t1HPOnZd/Dn+6agHK76t8LwhmkF08AaUCURZc
         8TqVl5nizuZBrEFnvGLczdC1Rr51RzvQSs2rHx03enKjH/KyeTjwtFNli1seTdcMa9zj
         yoekKOJL/tml14JLhYL5trbqivv2ZU4zQ5JJxlZnUdjcIs8Z/wKJwajtgpCR2hrBeAPt
         siHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UvA0VwvF/h6uXpoj8ief9LEDTmC8hm9BbvN603/cueo=;
        b=6HKGsAU0QYhMXtdI2FZqJe/ketqdpkh41MBBXMQj+YsUV7evnZH+0RioqqHhU4/zgL
         DTB3SOhn2TG9+ghdNoJxX6LQrDPXEZy9Hjl+dMT+yUo9tsiSuunOvZTWVXrgmUNTkA1b
         vBlkFvPGoDFghDApMCMgiI1/6kJd+oBumJUTFHnjNxQV1+yWl3APz8HnZoh2bbLZmO5M
         iJaQmNUy3GNdMqQhxOdVCksTm+5W0f/90160eaBcm9zX+Fkr0yPCe1LTRIzlTLUowZwb
         T4TjE03bcGQB3GKQC9aJcBFbxDTyXyNFhYu+SCaLkb+X0VCiEnlZ5PpCz+tX45X3jojR
         EUEQ==
X-Gm-Message-State: AOAM533ibFsr+AWATxxB6+J0SkPkUvr9uQHnkFXmzFd1MnFqEdAl6vK7
        LPf0MM/T3NomzmGEnBll5wc5KYzAKuevyWTH
X-Google-Smtp-Source: ABdhPJzIt6ip9aRLE+txSwEUQKFKX+Z1cnAqSZ+hn3SCzgNWuGTl9gKMXft9A0O8li+42twQmvScLw==
X-Received: by 2002:a17:902:ed85:b0:148:adf6:cbe1 with SMTP id e5-20020a170902ed8500b00148adf6cbe1mr15842724plj.170.1639998510307;
        Mon, 20 Dec 2021 03:08:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e15sm10084282pga.53.2021.12.20.03.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 03:08:30 -0800 (PST)
Message-ID: <61c0642e.1c69fb81.e5c0.b713@mx.google.com>
Date:   Mon, 20 Dec 2021 03:08:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.10-115-g72f2e86659b7
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 199 runs,
 1 regressions (v5.15.10-115-g72f2e86659b7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 199 runs, 1 regressions (v5.15.10-115-g72f2e=
86659b7)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.10-115-g72f2e86659b7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.10-115-g72f2e86659b7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      72f2e86659b77a1de93b76f0ca12780dd39194ff =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c02b8de97f4eed45397143

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.10-=
115-g72f2e86659b7/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.10-=
115-g72f2e86659b7/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c02b8de97f4eed45397=
144
        failing since 2 days (last pass: v5.15.8-42-gadd3d697af60, first fa=
il: v5.15.8-42-g0a07fadfda6d) =

 =20
