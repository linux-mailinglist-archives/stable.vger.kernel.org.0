Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB8539692F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 23:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhEaVH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 17:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhEaVH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 17:07:59 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00333C061574
        for <stable@vger.kernel.org>; Mon, 31 May 2021 14:06:18 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 22so9781459pfv.11
        for <stable@vger.kernel.org>; Mon, 31 May 2021 14:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SXqY13yP8uHLjJq6tpXHfiiWy+lkvBEBKhDz3bTYiVU=;
        b=nMTxh48hW4/ClhwH8jc0wf4R97UBhmJYReRCrlgBr6xR5+Xhp4VbyJzUWicV34q93a
         ionj7NZEs7qymkjYkNR7kMb/I+BNrVH3DrqCtK5IPcJsnh+Rr/GFNBQqrDPoR1InmbTp
         zsiHWKyFVUlUeg+iAp9mY/DhFEyVBHSmwVO9ragJk3kGPXeF3nDk7HPpABM4laRsx0vL
         Q3sCtc78qGhcJjSRHiiopg9cuyIr+4yYp+/WYy78Ld4WvjRHNx3VdJwJytto31y+NoUu
         IVVOxm0pPWWbZE2aK576fyhq5uqGA2WvjpWufp/FM7kEsa8yeFbaszb9SV5PSlCEJKZE
         B9BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SXqY13yP8uHLjJq6tpXHfiiWy+lkvBEBKhDz3bTYiVU=;
        b=BFim6MnxufXZ99sARTxg/bTA30rYq5cPhoXHTyANJg+cseWqfiUpXXEk2ST3ijHZSx
         LgChFE9v98d+SVdPTxOJN/DIQyiv6qgYIFRyy5vEvAPKeQOygo+aN0cC9hEEsbEQ4Alr
         Y54W43EsZhBcsjA9RAAY3EyT0eplMDBZ96eG5wnh/59XsQ0kcdlMFRVKaEDcCnnlSSCD
         oDNv5Rq7fhBbH1rBE38XY4ALQZ6zRrwESjjMXAYOffufd3cidfBPtkLg8kTN0KXzAzlD
         Jv9esdd0J7eHCoA2V1KdLK6jTLY9BMhy1hI1yem8XUEKKKJQxfPV1/aa7ARE0sK+mxmF
         2j2A==
X-Gm-Message-State: AOAM530MaoAM6qiyGcrcc5oYQMgRZIcw/z2+ZaclW4WtBPPaVH8cPt5v
        NxG0zL9NBomV6pLCMYyx4xhrI/ix2CiP0ohl
X-Google-Smtp-Source: ABdhPJz5haz70kjjccNC45Bkdx61+gXSSXRA5BVVfcFT8nqYKmC1kAyTh8YSEAw6qgRw4ts4WHzG7w==
X-Received: by 2002:a05:6a00:16d3:b029:2e9:e076:e65a with SMTP id l19-20020a056a0016d3b02902e9e076e65amr4392931pfc.21.1622495178235;
        Mon, 31 May 2021 14:06:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d131sm11650465pfd.176.2021.05.31.14.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 14:06:17 -0700 (PDT)
Message-ID: <60b54fc9.1c69fb81.6df57.5523@mx.google.com>
Date:   Mon, 31 May 2021 14:06:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.122-185-g90d658854151
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 160 runs,
 1 regressions (v5.4.122-185-g90d658854151)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 160 runs, 1 regressions (v5.4.122-185-g90d658=
854151)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.122-185-g90d658854151/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.122-185-g90d658854151
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90d658854151852bfcec59459aa8437d631b4dc8 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60b5139999b80d4607b3af99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.122-1=
85-g90d658854151/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.122-1=
85-g90d658854151/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b5139999b80d4607b3a=
f9a
        new failure (last pass: v5.4.122-183-g09f40ed6b545) =

 =20
