Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44B84356D0
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhJUARc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhJUARa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 20:17:30 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32EFC06161C
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 17:15:15 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t21so9229411plr.6
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 17:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hBqnS1q0GYGNglDr/8jEFjuBPmxWiEwPPDsfDowZoXY=;
        b=vflGgFexuNV5U1CShszEdBFYKN7kPBl8VN7oyu+LpVjpcdSsifgzRAQF9dH2iZvEkV
         C/CJcQmNFWCiZxZ/hxb0oy9V6q85c0TTw7idMDOoqrqpqWnnmg29I6zpv5gQR9wazWVY
         tmvKia8jk80rgyj8ry0aUVXi4O4r7nyMG07+K1rL/AYyMBZdmRjC8KMWY0nvGGXmpY+K
         BKxEvpN+wzB/sWNzROX+jBIo2bwkq3+jZTIknpeQvi5QoQbg/7/lUb98xVD8X4OJL6yt
         O9vY4awzsgUB6exS25fi+CGI3oVgxjdbUyde25jB5V0X8TWxfH8qqMTzDCWZEJUnff8C
         O2CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hBqnS1q0GYGNglDr/8jEFjuBPmxWiEwPPDsfDowZoXY=;
        b=vSEWb7GtregVUzIMW2O7hryVOZ9rO8dSkmLnN5gElC5b+9m4zDMuBAye3N1450ckom
         xaaYLjot2sEIdfUYNBlAJgZNxRWEqO4JHdqMHbFqK8sgMwDIFnOTkN/S49BMDkRRfO2e
         gYNelVu4Q9A+LwU74sq87xCNJs3bAj2r0j5qjm0zi9cMOx4XOS9nyIITtcCFQCpPOc9U
         A5LeXXYHw9gXcNpgE2uMjt6RmrraNPTspJy0fLVRkcj5T3caXh1zkEoICrlZ8ba9Qd5t
         nfsxjJyt8XSrFCD5eagGlaQU4rsD+LULGhPiC1nISzeRgTgDIZtgKXESq9XvJhIJjrEg
         8HnQ==
X-Gm-Message-State: AOAM532P26NCl3qwaBswX+8WVNmO3rnOH8IG0g7iNgp1vDWhTCT9cIRu
        YSmD/7EtrWOujWSgsmxIsUtPrM3pMiBxXyrC4XA=
X-Google-Smtp-Source: ABdhPJxwA/bvmQehvo1C6JN/nl7ugTnHrGiosArWikFpDMc+Yye4OwQGJJdZmmCgtRE0hmKFtUTRVw==
X-Received: by 2002:a17:902:8b81:b0:13f:3d30:f624 with SMTP id ay1-20020a1709028b8100b0013f3d30f624mr2148744plb.51.1634775315251;
        Wed, 20 Oct 2021 17:15:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i127sm3328284pgc.40.2021.10.20.17.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 17:15:15 -0700 (PDT)
Message-ID: <6170b113.1c69fb81.c6db2.a174@mx.google.com>
Date:   Wed, 20 Oct 2021 17:15:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.155-3-geac33b1d5763
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 165 runs,
 1 regressions (v5.4.155-3-geac33b1d5763)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 165 runs, 1 regressions (v5.4.155-3-geac33b1d=
5763)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
asus-C436FA-Flip-hatch | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.155-3-geac33b1d5763/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.155-3-geac33b1d5763
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eac33b1d5763dbc7af633a91d2ab185162995ee8 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
asus-C436FA-Flip-hatch | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61709497904adb1dd13358f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.155-3=
-geac33b1d5763/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.155-3=
-geac33b1d5763/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61709497904adb1dd1335=
8f6
        new failure (last pass: v5.4.153-83-g2b0cde94652c) =

 =20
