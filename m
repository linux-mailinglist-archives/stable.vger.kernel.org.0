Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C312414EC
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 04:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgHKCXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 22:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgHKCXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 22:23:34 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1970C06174A
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 19:23:34 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d22so6787577pfn.5
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 19:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GWv1uwypx2T8C1b+WeUeV7jhQRUSaVaHpoBV1X7jB3g=;
        b=O9CR0GoA6UuDfveWDMHCtCzyH9eb3AxwHc/xM2kX3f7yVXYlnrkAL/eETn59FDLMXM
         eukW+nbfuOouaR7x/NJ8fBHTIQTJpXgjrZdd9GCdpxQ3rBvx6aCMo+3WgixOJGt6Nr5e
         km/QjL8IYy669gMAMgVnB2LhIv2deSF0AFIH6vL+kadpi1UznzneGamMs1hxKbVNCMaf
         HjtuUkM37YYGL1ftEU5mTI/2ojZLlUQygDcWVL5mdI4nj0sGhLaNAAhTsRtteexbsoaF
         7LyDUqWXxEhXyUaPJKTSuSPrz6Wd39BqpXOBUsow/NKMrWS631GuSSxMyvtODGrxL4uT
         CU3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GWv1uwypx2T8C1b+WeUeV7jhQRUSaVaHpoBV1X7jB3g=;
        b=f35cDm+Od69JElZUKwc4OyQ/w08VoZLnfJKTTdnE25CRKdkcGO1/ZtDNJrDtiL7Ljo
         0IbWqQsJz64Vs+QaJ/n7Jf2VXeH85uFg62FxmsvBESt9R8w9L7Z+k599OLO50Fzo5K3t
         7zSKj8XyYDgde6vykAoVJhVmRiyRi07zB4MR7SIEYxccXhnzQ5qZW8AFJu6wSFLzGzmb
         QXyb/AoqY3DNeD3K4F5zM6h82N2IrUNyyz6aHuew76gR06BU0YDkr2OdUopw1/IT6U/b
         vXq3T20cLjx/I0PdJwf8yDFrFeDOoqmHwo331H4K6rxeWMMmYTHzQCJAuNOC3TuILkwc
         eUBA==
X-Gm-Message-State: AOAM530OKYrKuxhrzb9OyPSB3PjtIGVE5fztsLbjDSwnOIi807qCM8JC
        j9kkTbeE29fHlZkizV68/noqdGmzD+g=
X-Google-Smtp-Source: ABdhPJzVo744heom2VK72FTR+XZF7dAdxQXBdJ+OjXFJfwtQvq/AWtBdWrwgiO4YjedyHfgl2SzQWA==
X-Received: by 2002:a63:380d:: with SMTP id f13mr23514886pga.16.1597112613873;
        Mon, 10 Aug 2020 19:23:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 196sm5992108pfc.178.2020.08.10.19.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 19:23:33 -0700 (PDT)
Message-ID: <5f320125.1c69fb81.782f4.90b5@mx.google.com>
Date:   Mon, 10 Aug 2020 19:23:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.14-80-g693b1e00f859
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.7.y baseline: 167 runs,
 1 regressions (v5.7.14-80-g693b1e00f859)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 167 runs, 1 regressions (v5.7.14-80-g693b1e=
00f859)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.14-80-g693b1e00f859/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.14-80-g693b1e00f859
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      693b1e00f859c9979003e6728adb23f20c9784a2 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f31cd15c877623b4752c1b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.14-=
80-g693b1e00f859/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.14-=
80-g693b1e00f859/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f31cd15c877623b4752c=
1b4
      failing since 25 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9) =20
