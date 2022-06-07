Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125945415E6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359779AbiFGUnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376494AbiFGUiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:38:46 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1BD1EDD3B
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 11:38:17 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so16177226pjq.2
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 11:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+OhesSH293MOiPbahhalj3sYsDcqFhy6fC6cIx4dXpo=;
        b=FktEEpoDekn0DwT7eNpWuqIriPjeWOf0h5XLw0WQ/TPCds9vCYIH7cD52EqcK5/4YT
         FcvgQUamKmYiInSgTiARvRexuCKXc/PX4qEWuNfjlhmSpSbbJsZpT6G0Vrev0bNSYqYY
         FytsbJ9KxpePFjtNpszwGasXjOscNmUpESMVcR2UPbG6eRvjbN9vCo4waTjkUh3twQz7
         KfCtKR67SKUCyX3GumAxHgRjke9a+MQeHQsUHHJ0VG2ugQ30H54WxUsfguZNSu37jThE
         M7F2T885beoKaLhDvgaY6DuMb7n7s0Ahnu/boR1MjZfTbHlYFH45/UX5BdsCHKH5Lmhx
         BsGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+OhesSH293MOiPbahhalj3sYsDcqFhy6fC6cIx4dXpo=;
        b=OmfYZhurHOYn1Yw0AeMMS+Y/lLsjTKnl/9q6ONM/MWkn4DqKHSSItt6jgK9MwA1mTY
         DQVT232bVe2pwwozb16FZKmb0RjzycBrzril+nMw35uTKPPiyfvSEPIkehyt4Sht0lbX
         Hj0mqTTYZfBsiS13XD3y22dE6Heb0uM0sjLZH0bH8pAyC2vxnn7T38QSv/4lUWPH+M+u
         NicIrePgL/H3z1nJSdVXSxJNbjsgi8l8QpYWSru3lctYhUMgQNHWGhrpp/F2FtoKrsTC
         sgC5MsOxvE6IgHG3MTe8dAPWvhwvs9sDbOdu6ejgqE8LwGzEoLOmrQXTs/ZRZyTEXGK7
         +2Sg==
X-Gm-Message-State: AOAM530UYHIDCcW6jUnk6hunjvLGYTn83SgdVlZCVWbWugj09d9ZmhLY
        1TxHwGZVXnk5WktbNort/Tb3PZ+NxLn1oF7SGRY=
X-Google-Smtp-Source: ABdhPJz6237ukXOrDyHfBBwRFVFJzcHU0JYwAhvQXqN/HAvR/nRzJZcC+oupli/8ZQQYmTdihXfJZA==
X-Received: by 2002:a17:90a:780d:b0:1df:959:235a with SMTP id w13-20020a17090a780d00b001df0959235amr33582188pjk.92.1654627088395;
        Tue, 07 Jun 2022 11:38:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e63-20020a621e42000000b0051bbb661782sm12465546pfe.192.2022.06.07.11.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 11:38:07 -0700 (PDT)
Message-ID: <629f9b0f.1c69fb81.53f61.b305@mx.google.com>
Date:   Tue, 07 Jun 2022 11:38:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.13-771-g1bf589e90ab9c
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 157 runs,
 1 regressions (v5.17.13-771-g1bf589e90ab9c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.17 baseline: 157 runs, 1 regressions (v5.17.13-771-g1bf58=
9e90ab9c)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.13-771-g1bf589e90ab9c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.13-771-g1bf589e90ab9c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1bf589e90ab9c862905b73505fa7926dde93f7a6 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/629f68f1b6c118e3f4a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
771-g1bf589e90ab9c/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
771-g1bf589e90ab9c/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629f68f1b6c118e3f4a39=
bce
        new failure (last pass: v5.17.13-759-gf64e250b75652) =

 =20
