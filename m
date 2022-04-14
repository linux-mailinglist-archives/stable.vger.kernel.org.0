Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F2450034E
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 02:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiDNBAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 21:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiDNBAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 21:00:54 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312D241624
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 17:58:31 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 125so3339322pgc.11
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 17:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GOKsgrdu10A/lV13jncTPS5V6fMtKFVRYtXsLt/1lnY=;
        b=KE71uFDLCxXNQMOcviQBcHwpcGnKXlL5gMGBsxiKv+En/6b0R5WGpBu3wBBERU+daY
         QDLte0XRivzDLzEpZqXQ+7Mn70PAIfJi5hGSsOiGtR2cMIddh1KjhYTYZduE/rYbYxeq
         KP6OHcRyOqQh2YeLvvPIUQytIlJfxJn+GsLdisTDMH1B/wv+9j4RchFqFvTafL7kQXZB
         y+3FV73nllfyn+19OOYLzDEkKVsa7UK9JkVE9U7R7aozb7wPpqzSeKhYFfEDmZyBGE+K
         HbInE9NenqPtfFILNe+83u4u98gyTEd1cCpdV8ouIr/OP9MH0WTcidzvRZ7ALQ8ivjnd
         WWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GOKsgrdu10A/lV13jncTPS5V6fMtKFVRYtXsLt/1lnY=;
        b=S12mOZgR6m0lf1N1B7DVjorj34PKUt6PGnrdI7YYR1CjxyTH/CQJemPdyGVWG8x2my
         Mr2bs0LKLkWa7A6yYdJnRvWdbxCg+LEG3vOsEbNRzjYNE/oUDt9uYwgI3E2ZKtZqOXtp
         KwN9HD0Nu60fllC3kwGCm2olxpXRdNKGdN12KAGUhtJ3bRDSw0xnWXJKsT8HmCgJFjir
         nkwLoPKAKhR8gg2Qztxn2woObzE1xZGUR8rSqho5mOkdBMd7Y3T3QCfuN2yzpL56pdPS
         Lmud1pQYEenkm5kdiWpTp2+SSTP+zmH2nA6CcHBkelp5Ia16Z0P2zOB+IJkAV0YkYrxG
         xajw==
X-Gm-Message-State: AOAM533kvlu+i3RgzBclHhl5QWPx3iqk85Uo5olbTokPsEdoVuSID4co
        gSN53xz/0MKAeq+eKF5T+MgIdUC1Oro17SXF
X-Google-Smtp-Source: ABdhPJwta/Gok4GRVV7RF8LRlgLh22AOq76XKxKaAcUSEGquIUvc0pBHGYOIV+CZdLocWA3RvpcoBA==
X-Received: by 2002:a62:5b44:0:b0:4fd:e026:f4ba with SMTP id p65-20020a625b44000000b004fde026f4bamr12375097pfb.55.1649897910544;
        Wed, 13 Apr 2022 17:58:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g17-20020a625211000000b005056a6313a7sm267507pfb.87.2022.04.13.17.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 17:58:30 -0700 (PDT)
Message-ID: <625771b6.1c69fb81.24811.11b5@mx.google.com>
Date:   Wed, 13 Apr 2022 17:58:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.310
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 66 runs, 1 regressions (v4.9.310)
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

stable-rc/linux-4.9.y baseline: 66 runs, 1 regressions (v4.9.310)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.310/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.310
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6348ae07835a05f78ab3ada1f7293665a410a273 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6257420dc0e7700006ae0682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.310=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.310=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6257420dc0e7700006ae0=
683
        failing since 8 days (last pass: v4.9.307-12-g40127e05a1b8, first f=
ail: v4.9.307-17-g9edf1c247ba2) =

 =20
