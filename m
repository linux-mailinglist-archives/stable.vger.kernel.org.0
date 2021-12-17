Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264BF478DEC
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 15:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbhLQOin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 09:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhLQOin (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 09:38:43 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D347FC061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 06:38:42 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id g13so2461458pfv.5
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 06:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KMzMik5a5+YvFJK20z36kQ6XOyYmPhs0Nbv9S86NPaA=;
        b=yriHfc6S88bZlx9wMzUqVVuQhnaDYZK5TpUzn3OKSRRDBwlHA9XO1nIFTYppLaFsss
         M7LCWUYNnA2ogVfZJxyZVjtfeqhbJmMkTgSRqFlHbzhzhM5PR5noAgDc4Q1FTLsZ/r+0
         qgRehXdL2NwpAaTmdvp7x3KFhBGNp3098XjZJ1EYxY9bdzCKf/5JxThwS5uGTE8vSov/
         ug5788MQ8ysvnjyEXC0ZsDMAESiMtXYqchgv9UF3kXRlJBiA+ULPL8+BsrM0pcDM6y6h
         3tNhTrwCHtcgowAOI+OFvZtO4VOP4ucmx4G6yoMCtZPUUcOik/uekzV++mKt7fyxYaT9
         tDBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KMzMik5a5+YvFJK20z36kQ6XOyYmPhs0Nbv9S86NPaA=;
        b=KcBvi+OhspZ2r9DMNdaDIj/wwbm2WoamNeUpvLWVZ68fEGmM7Ce1x1KaDPUaU3Pd9z
         UCzpaWVq/g8nN8SyRHoqyq0QOWCeTzx+9bg7GPUN6f7l8DmWLtKtj4KIyEtatdxCBLcP
         s8NMZTs6bmOTLBEs1rnNzdUA2xuE113RmcSnUO+7gXXQ5r0bDz1t3xiEOM1xFLmtAKNh
         sLS2a6OwQQkUt+bkOLYcTJj54ADbtiCgUY4mJ4PJHLoEwvFKjKwj75e4sKvkzCLqwvTl
         ojeVoXhUyv7aKqfXlaD5/2TGZHUNO8IoQe3Rc/TnUgIt9rLcHMolmU3DcvniStguv0Vd
         7OXg==
X-Gm-Message-State: AOAM532bJZGBw9JPAy9ctPH1FtAtHn9ywLq1JYqlGdhb1yGoN1wXFteH
        5V72JqA18WGgGJsj6texqdrV9IeEgmetXREJ
X-Google-Smtp-Source: ABdhPJwjzY1nHGxwu7Uus0NMTil1G4ZkXl8SitJGlT1/aZdbmfvPg4e7+u47LbTm2vVW4dGIW3h+yw==
X-Received: by 2002:a63:1001:: with SMTP id f1mr3123782pgl.353.1639751922201;
        Fri, 17 Dec 2021 06:38:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id om5sm9205514pjb.5.2021.12.17.06.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 06:38:41 -0800 (PST)
Message-ID: <61bca0f1.1c69fb81.2ef6.8bd6@mx.google.com>
Date:   Fri, 17 Dec 2021 06:38:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.8-42-g0a07fadfda6d
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 184 runs,
 1 regressions (v5.15.8-42-g0a07fadfda6d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 184 runs, 1 regressions (v5.15.8-42-g0a07fad=
fda6d)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.8-42-g0a07fadfda6d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.8-42-g0a07fadfda6d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0a07fadfda6db692413b2f1eee209f21fdab3d04 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61bc6c4f8fde59679939712c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.8-4=
2-g0a07fadfda6d/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.8-4=
2-g0a07fadfda6d/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bc6c4f8fde596799397=
12d
        new failure (last pass: v5.15.8-42-gadd3d697af60) =

 =20
