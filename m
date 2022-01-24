Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF854981F4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbiAXOWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237478AbiAXOWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 09:22:23 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9EAC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 06:22:23 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id t32so15519048pgm.7
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 06:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n5E22zn4kwtsSU2cvHFegf54bTjPVRoAvyMGgKVkW3I=;
        b=yi+oLi1lRX1nc6XjeFQq0GjBs8uzNGysau0jrVCzJddfXsn6TAnqJQPqbgksAH2S8C
         +CHu7zNEjkE6pb4Mcj2p4Uaw128qCzvaVhmfdz+1WERr9lIqJzfgOarwDfUyxg591Gum
         3fSttnqL9mGmoIaxpoT8ZioJ6OFY82vvPe5j2BovX9V2xYOCSEcCnvCcR03bYCSzno+e
         IZ98veVUI3mV4+YYvNWlOx2lLR6+hmUirBnxR+TrwVttXqKnqivuHE4gTFyPUwMlSgz5
         6ovQiHc5JFIfCBZnoQy9pmB+2MFlKEk4jkvB7zCRxd23lqLzxDGmegESkPfkwuZGI5c2
         Db8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n5E22zn4kwtsSU2cvHFegf54bTjPVRoAvyMGgKVkW3I=;
        b=tqy1M0ziG7Y/GqrGK3IXQ9NXzhIXFz9UOmVEAoGPXDjg8pW7t0oPPCUnpwoh52lI0n
         Un+sPPd3OToGEPAz8S1l6SVTTqIet9b0ro13U8+QzjHfTkcFrKEigT9iBu49FGg9WSkC
         6x76awLhPRhiH976hsYh7k0INPbAKtOZImOVyudk03lz07/N0/RQymP4zEKUp4uClAB8
         J493kcTxz3KXrA+Dd3v3nyp6uBYnQjN9XEv3XT+xJkNIaIALn6m4p/VORouZ3p9kx1qz
         wnIAQGhxInRguYS5qCMC7/oBkNK+cItLku1v5WdeYv60lEtneX2x2ny9agzPvuXRsD/c
         7xoA==
X-Gm-Message-State: AOAM531DIyHSqU0PPdEZLFdZoeRXQCqsXDPWTTGdEdidQtvO6JjXQlhd
        AdAbYJrDquJpe5hUd1aFwcvDBwOC6groyqZV
X-Google-Smtp-Source: ABdhPJwrQ4EfEb5HhQw/0/TpDDJ0wbijOYcGqELMbXbfsFElQ+UY/gq8x8z6WfrGSDWKVIezKy/PcQ==
X-Received: by 2002:a05:6a00:2182:b0:4a7:ec46:29da with SMTP id h2-20020a056a00218200b004a7ec4629damr13995169pfi.68.1643034142532;
        Mon, 24 Jan 2022 06:22:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z10sm16770993pfh.77.2022.01.24.06.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 06:22:19 -0800 (PST)
Message-ID: <61eeb61b.1c69fb81.9ec5f.ca3d@mx.google.com>
Date:   Mon, 24 Jan 2022 06:22:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297-124-g1de5c6722df5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 139 runs,
 1 regressions (v4.9.297-124-g1de5c6722df5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 139 runs, 1 regressions (v4.9.297-124-g1de5c6=
722df5)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-124-g1de5c6722df5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-124-g1de5c6722df5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1de5c6722df5788cd798039dae9427a15a8ecb4a =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61ee80af3f460ad028abbd11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
24-g1de5c6722df5/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
24-g1de5c6722df5/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ee80af3f460ad028abb=
d12
        new failure (last pass: v4.9.297-121-g25c9df465ed4) =

 =20
