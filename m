Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F42E22BD17
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 06:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgGXEnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 00:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGXEm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jul 2020 00:42:59 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14C6C0619D3
        for <stable@vger.kernel.org>; Thu, 23 Jul 2020 21:42:59 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x72so4421541pfc.6
        for <stable@vger.kernel.org>; Thu, 23 Jul 2020 21:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D8rKD0VEb6DT0xmrTWRbARXBC7EtUjFAsHc8KRe4YE4=;
        b=UQClIkjcF2Knr6/mtwB+YGdc6ye5QTUZcVJH0wcSA2FZ9jC5O0n7YpEHNuqhTw90Mo
         Oyq+FgZT+aQSypehFOY8tIfCnW9Pc1cSgzK2bRJDCWuocCfaM3Ob+D2+N0VIb03g7Mqe
         3pkt5sDNtDie4rp3WU4+pV4WfXgOxn2S7UA2AZD3Lw/e3AOXQiU7Fwdqz9jsepFDNj4k
         rZWd2uOCy9weO7svl+74mZENHcv/cHTZuR4O1eUNoi4umN96dSY2m5zvo9iI+yEZsoJb
         VYS0ByLzxsOU/vyz4DWzPDWfNn3oG5827R5YmlrRT8Eajr7IgR99cmCnijdS+RAF9COJ
         uy2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D8rKD0VEb6DT0xmrTWRbARXBC7EtUjFAsHc8KRe4YE4=;
        b=Nfw/8EQ5LmxC4bDeXTq+FiD+dQQ97KJBikDUxoVtxxLZUmvbnTGJS1Gc51uE+0HJtP
         R0BT5GXaH5lwVxk3JsADKLcbg1NKeNQpxdhteyW23M0SLeuhoX6rqJwithw4N2QHsnMC
         L+lHgnqijmZfT91XV3UULzUGvXevcwCvEp2DsSiZT7zQHjP37K1oVaGRoGu3kVnFHWuk
         zX4Gw9cTuYYeM6Ge/9kSg6OaYGf5E1zaxTGu8b+lzCTVomDL1oVzpvX57eT2jlmhOM34
         Z2NWk6P9nVQnE5+I38d+gHIV7ohmbfQQLuSECMbtOEfVkNbCchKLG97XajDOc2Rk+ECg
         uExg==
X-Gm-Message-State: AOAM5319bd8wjcLLVhQEPe6r1TcZFJDcdbapS41mqVf9j4CDtdB/KfOL
        KQ11aBPNpCQznJT3ohwODkM/dlofqqA=
X-Google-Smtp-Source: ABdhPJxmGbiIj09qI62AXgyzZ2604riXumkNO+DVRI8LzZhPVjq6NJzpzCrPx4wqbXd9adztwXiksQ==
X-Received: by 2002:a63:b919:: with SMTP id z25mr7283432pge.416.1595565778491;
        Thu, 23 Jul 2020 21:42:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s6sm4765043pfd.20.2020.07.23.21.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 21:42:56 -0700 (PDT)
Message-ID: <5f1a66d0.1c69fb81.53441.059f@mx.google.com>
Date:   Thu, 23 Jul 2020 21:42:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.53
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 186 runs, 1 regressions (v5.4.53)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 186 runs, 1 regressions (v5.4.53)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.53/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.53
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d811d29517d1ea05bc159579231652d3ca1c2a01 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1a3442eb40d27ed585bb20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.53/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.53/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1a3442eb40d27ed585b=
b21
      failing since 103 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9) =20
