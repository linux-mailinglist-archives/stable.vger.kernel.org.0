Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747492A5D3B
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 04:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgKDD4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 22:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbgKDD4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 22:56:52 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660CEC061A4D
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 19:56:52 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id g11so3136351pll.13
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 19:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N+iMv2GqfSlIV3RHkLmzgoRUtgRPjKhnIrjDLFq7+nA=;
        b=cPM8tR+bufzygu4pX3l0eDCHT3Hfd1yrem6ImhpluucuOwMnnG0rJZNAqS0nPXiRSk
         85Xx71RKW0bBmM9IeIEspCBsakYWRqUW5+UCqUCxQvEfEYvaqqPRKqp6wejQSf42WhD1
         QIeKtF4mdD0UfDZhyQvi4iEhuTtBUeCqCMB1FvkSVNQosA3UMkcPqNuyY9UtaEsua2N0
         JAJDB0P+ZFT8uPeF9G+ec95r4nMUf/CHes62xidZtJ4nqfkTcwDWBCiDWmQ7v16M3XX8
         MGe8Q48pu4ah92gkgE3JLo495bUoCpvcIW7wLr5oSnugYEVqYjAKYYK2zRQAzV++oMjq
         anFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N+iMv2GqfSlIV3RHkLmzgoRUtgRPjKhnIrjDLFq7+nA=;
        b=bSbayELCsiCTBBTEqF7QfiEC8ttGXvUpuLewm4dNz4Pnw7ZEcduZ1wnb3Ewao6Dm67
         dEEVJXPYgm3mzRzjoACbYSklFsZb0aswTutwRpshc2lY5HqHrLWVuKzh2w48I1n0bQqn
         QJxE/enlwESouuxWnkQDzluHszRwolrDZ+8bMiGB6bM7vqZn2ZV61UdBCaF0gY36RL4+
         2hFCA7m7yb0PM4DRIghCNMMPUgCsHHdrxKrJKLPtv2X8PtWaWJC7A+Nb8tqoMMwyTko+
         QvicM+zmE9tDg1Wts7dnIwPnglXO8+ESXCk6iJrn2nlxX4OxZcMex0A4Lq1HQJuJ6wNg
         B48w==
X-Gm-Message-State: AOAM531GAcAes/3C37bazus8osgJWsMreA3t8TifbhCF5TqiB2dFRId7
        KYb2NLGkkDqCFrKw6Le9vC/1T9T9DHaRjA==
X-Google-Smtp-Source: ABdhPJyl3nG1NHsaKStUqZWDpZlWa/PwZL1Qpd1xj0aQLxlQ3ZShF4ybXAUDaygtgz0EaozE6SBcCw==
X-Received: by 2002:a17:902:6545:b029:d6:9a59:800d with SMTP id d5-20020a1709026545b02900d69a59800dmr23496837pln.31.1604462211651;
        Tue, 03 Nov 2020 19:56:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2sm590501pjj.37.2020.11.03.19.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 19:56:50 -0800 (PST)
Message-ID: <5fa22682.1c69fb81.458c0.2516@mx.google.com>
Date:   Tue, 03 Nov 2020 19:56:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.18-149-g9b91ca2c8d54
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 196 runs,
 1 regressions (v5.8.18-149-g9b91ca2c8d54)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 196 runs, 1 regressions (v5.8.18-149-g9b91ca2=
c8d54)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.18-149-g9b91ca2c8d54/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.18-149-g9b91ca2c8d54
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9b91ca2c8d5424aefc0d3d14176d55d744772af3 =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5fa1f58627a92cff34fb5376

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-14=
9-g9b91ca2c8d54/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-14=
9-g9b91ca2c8d54/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1f58627a92cff34fb5=
377
        failing since 8 days (last pass: v5.8.16-78-g480e444094c4, first fa=
il: v5.8.16-626-g41d0d5713799) =

 =20
