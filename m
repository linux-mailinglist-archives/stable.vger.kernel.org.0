Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0390A465B93
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 02:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354263AbhLBB0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 20:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343896AbhLBB0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 20:26:14 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216B8C061574
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 17:22:53 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id s137so25432186pgs.5
        for <stable@vger.kernel.org>; Wed, 01 Dec 2021 17:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JP19uWHnZiDaibt6jqmUgVPqvZVb/ATphBX4xTxJ7e8=;
        b=K3KOTjyJiu3IOhhINnDCn1sHiK5p9cAkILOTrNjA85iww8elmXU2KHxUmuhkx/OBc9
         UtiEsv3oNnV2aGWFc3Fe0c380vZRv6PSU1cl8Ts0DPt2bUm5mmiadDbMSEkX8tlYWpcb
         1rU6BU7wnwsQJpEHD6j4KXhnMGPEyrDt2eCxuJ9JfrEWG/y5YmqZG1TQBgy75Xl8Kccl
         c1s9MXOg6smiJhedO/MAfe6Hhn2a2c6cUAMQUr61w0IS3STYLIxd6s7gPV76QOK6AhLN
         fiFkAoF/QNVebYTJuPTPqekxJ8rxmH1W7jdLOoFS8WzSFeIUbVximctDh1BAXJie6tdx
         a7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JP19uWHnZiDaibt6jqmUgVPqvZVb/ATphBX4xTxJ7e8=;
        b=I58rdLkcyAwiV6rSEueMobTGANvv20q/OOwgSieCVijNYqimJOhE/46Z3W540aMVTM
         V8lGYwWsM3t1j2QDgFMIXFldDlMceL+TQkp+F3nJHoVcQ2JdA0e3snAuNWG2GOOZ+MyS
         vIkJ9z9bEEexElk1moTavMybBUAZMecrMinSm83W3vnD4K+AQL4SJddQiyfOPOYv8REk
         9F1fxHB5wgbmipFYHlo/rh+Yu+WEf0CQFwtbaVuLL/gUikHJLgcOjLEtUDsD6C21pS9A
         z/nosCkjMRAOhkcW9lScpCj0RFsspii/364AwlvusD91K2u3U6uEzg6+BRO3WQZLQPDC
         sxtQ==
X-Gm-Message-State: AOAM533uokzbSEc4QmbHbLyNfgHSQgzfkYqIEYKxrvTpOsRQuwNddXDh
        smh8CO+7btEYAD2HNuwTcOz9109e3ezbw7NS
X-Google-Smtp-Source: ABdhPJweTMJ1YtZt+hIOu+l+fdN6YfWRvM8KsrjjCzJTrNwyRxkFWjtTeyk40bq3B72YAVYiwMLBww==
X-Received: by 2002:a63:854a:: with SMTP id u71mr5876516pgd.66.1638408172526;
        Wed, 01 Dec 2021 17:22:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s19sm1035481pfu.137.2021.12.01.17.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 17:22:52 -0800 (PST)
Message-ID: <61a81fec.1c69fb81.9fc16.4d92@mx.google.com>
Date:   Wed, 01 Dec 2021 17:22:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.6-12-gece74380b79a3
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 140 runs,
 1 regressions (v5.15.6-12-gece74380b79a3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 140 runs, 1 regressions (v5.15.6-12-gece7438=
0b79a3)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.6-12-gece74380b79a3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.6-12-gece74380b79a3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ece74380b79a3fb3e39a3537c6c6f45723dbdd5a =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61a7ec9746bd0aebd51a948e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.6-1=
2-gece74380b79a3/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.6-1=
2-gece74380b79a3/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a7ec9746bd0aebd51a9=
48f
        new failure (last pass: v5.15.5-179-gf46e126d61072) =

 =20
