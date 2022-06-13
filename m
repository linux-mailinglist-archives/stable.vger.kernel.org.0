Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E752549CC9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347314AbiFMTEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349534AbiFMTED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:04:03 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3314C7BB
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 09:53:08 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id i64so6247570pfc.8
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 09:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i01nzndchSNYOYnaTbT05QfCXnNfjJjZcYQMC2knL6E=;
        b=fFSDJZhPd+0pq5wm1tYzuswKzPebV4mLtq6hrTwhANNGkglgc33wSm5acVylDJINHR
         yXuzVmkZt7F+GnCaqH8RH+WGymbFiga1gNP/ibWjUhuKn0Cc9/y3wjsoEpvP/1yFTxT+
         k11x+0GQeQRUaDi5GyJ4vVByHdiVHoip7z32uZeT5Q/3rMVyZqfq4WhD+mjd6ewgvnhH
         uiJg/lW1bYSeJGLjwwUAmgjrJzQNB+0KPwDUzKJPI7nJJg5U3tp0eXfycYld5PiPENRr
         Pbqi+Pv+lQYEb20hUQbzz1ehQ3891/9TAApVp+IGwWsqCWCAk0Supitv1N5NLcH5yc0/
         3Ssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i01nzndchSNYOYnaTbT05QfCXnNfjJjZcYQMC2knL6E=;
        b=vZqVMiv0lQDnCVzffH+UxnCmDTTHNpG0Vhj36ydhuRPn55UxUPDKrJG2WVyIbN/J0H
         Z7L9zUa7C7UydI1nkyG4fXp9LTZKXJNoI4AGdOwAmt/iccvqNpsgUgR9zM5pB1/NBPxZ
         MvHjYHETIjcnmH8o7EH2RshzYdgg22uV0E8KcBabiZygPWQ5snWW2RuCJM26D46C2Gf/
         iYCOHuRoPnYYdZgZ8DGl+MB8ttTeySVWZduloLLDuTjIKEpisvVIloLyw6VhGV7X3Pnf
         HFNjPMXpn1uX7SZQjWU10unH+mWP+h8pdkBn1pauFx7j5z9I8wRvkkuaZyl+pmYcT+r3
         ugHg==
X-Gm-Message-State: AOAM533P0/CC69mW+ILUDr2Mg9/cZ7haj37N0ifvNfQjC9+5CJ+TBj/Y
        cTC5t0vCQfcQ7AzD9EMbpNZ2H2uS0ht25FhqEyg=
X-Google-Smtp-Source: ABdhPJwl9Mo5izY4oWA41r+sUZibhlSO0Clj/Ca806JEiqb1KNxqu+VZLd6yqMAK84kAmdKxyc47uA==
X-Received: by 2002:a63:8543:0:b0:401:9a45:b604 with SMTP id u64-20020a638543000000b004019a45b604mr489762pgd.202.1655139187466;
        Mon, 13 Jun 2022 09:53:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g14-20020a17090a578e00b001ea90dada74sm5403657pji.12.2022.06.13.09.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 09:53:06 -0700 (PDT)
Message-ID: <62a76b72.1c69fb81.43167.63f0@mx.google.com>
Date:   Mon, 13 Jun 2022 09:53:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.45-915-gfe83bcae3c626
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 118 runs,
 1 regressions (v5.15.45-915-gfe83bcae3c626)
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

stable-rc/queue/5.15 baseline: 118 runs, 1 regressions (v5.15.45-915-gfe83b=
cae3c626)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.45-915-gfe83bcae3c626/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.45-915-gfe83bcae3c626
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fe83bcae3c6261e9d8d87fc67f86574266534143 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62a73eeec66d198373a39be7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
915-gfe83bcae3c626/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
915-gfe83bcae3c626/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a73eeec66d198373a39=
be8
        failing since 0 day (last pass: v5.15.45-833-g04983d84c84ee, first =
fail: v5.15.45-880-g694575c32c9b2) =

 =20
