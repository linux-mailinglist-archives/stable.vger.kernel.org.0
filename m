Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72894470849
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 19:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245283AbhLJSSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 13:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238639AbhLJSSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 13:18:45 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73BFC0617A2
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 10:15:10 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id d11so76797pgl.1
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 10:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pjA4Cd+hjSqVCDqlMKn6ZGj5Djs4gfoXnYse25wK/AA=;
        b=wEiS9sDSJienFuvvDTAH3PB4Rrj+WzmY3VhHNReU0GHMad8NL69+w/HsFcImGdjJkw
         z0CiICnmM1xVNC2BQvf0mM/t2cT49tmIAI192Ye2cKloC7esn1i/ukV7pCd8q0rcmOew
         wCFX7DfjKhC8I8v9puRDBvOFkcg17kqpIZfsjp65KQI1yVhkFePDAeObHvPpktvwZMTa
         y3xLC/HW7XKP/aSafeZY50fcZ/CCMu1NeaRdAsXDcQ3nBV4ym9wJ5YhwdCz7V8RKnp1X
         ePK0O3/LCRnGcEu8RtH9bz7IYVoplKPPgeBTOqZuDzM4sbUa5UfsEwLEOnRDWc90XgqG
         cQuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pjA4Cd+hjSqVCDqlMKn6ZGj5Djs4gfoXnYse25wK/AA=;
        b=AzzJiT/1I3ktFrfxikYMu7R49De9gQGNexwWkRhJ4p96N8y5NWC1QbnCKu1HlLiUTQ
         llpQTS8p3E8vaqRG18dki8mJG6LiOjPqPLeqFhBsjIBMf3EOpg/BGh6Qb5CaXqOiJlWw
         ZeZKkrtG5NeZqcWxkXwVKug24lBpvJNAP6Wwx2zxyLYuf3jgcG5LCn8rOMU5lS1z1Z/j
         HqycGk2gnKCJz9Bj16Hm4QQcpPRZ1fzTZLzaTlYLUPAHwlTmDK8IbizdzXnBHEE79Y1V
         MGRnKH6pl6JP7+skUsydUPXArCrRdAyXXzJDcZIvR59RiVfQ9qp76ecdDQxIoq0+4RPJ
         2wMg==
X-Gm-Message-State: AOAM53364O8+gnmGs4vsAQ8tYSGRijvB8MTBs26W2VE4XdyPsUcJ0mP8
        +gc/ktulJRR3BTVX8bh8rv8ZGkDMJHTJm1YW
X-Google-Smtp-Source: ABdhPJwpsokVbwdoSOEHeBhy6Reosl0rIWzy/GfewkggKUK8cPKFS04GqGHgABF7kQLQqorQg1qyTA==
X-Received: by 2002:a05:6a00:1903:b0:47c:34c1:c6b6 with SMTP id y3-20020a056a00190300b0047c34c1c6b6mr19423526pfi.17.1639160110062;
        Fri, 10 Dec 2021 10:15:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x14sm3562156pjl.27.2021.12.10.10.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 10:15:09 -0800 (PST)
Message-ID: <61b3992d.1c69fb81.cd43b.a988@mx.google.com>
Date:   Fri, 10 Dec 2021 10:15:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.164-14-gf7f75203d7fc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 200 runs,
 2 regressions (v5.4.164-14-gf7f75203d7fc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 200 runs, 2 regressions (v5.4.164-14-gf7f7520=
3d7fc)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.164-14-gf7f75203d7fc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.164-14-gf7f75203d7fc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f7f75203d7fcf7cd8a14fdcd7d0c92d21cee1ece =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b3634578d4bf0bff397129

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.164-1=
4-gf7f75203d7fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.164-1=
4-gf7f75203d7fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b3634578d4bf0bff397=
12a
        failing since 0 day (last pass: v5.4.163-72-gfda44f5f463a, first fa=
il: v5.4.163-73-gf01a13d9c502) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/61b364c611b15b649d397125

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.164-1=
4-gf7f75203d7fc/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.164-1=
4-gf7f75203d7fc/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b364c611b15b649d397=
126
        new failure (last pass: v5.4.163-73-gf01a13d9c502) =

 =20
