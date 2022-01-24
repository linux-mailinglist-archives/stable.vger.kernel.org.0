Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD93497661
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 01:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbiAXACK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 19:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbiAXACK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 19:02:10 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23357C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 16:02:10 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id g2so13633356pgo.9
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 16:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=88MP9w37guSqe3omw2ZhzwKj1HdvJiY5qQEGmqhTG20=;
        b=aSLT6MjP3tfjMCExVf/vvzyzhDr/uo41/8syUfAYwPwMniCmKJJXtT6TPgkLs0WCRx
         u316Ogiay7e2yMCa39g7GldqMOGf+lyP2WSm579RTVJnGoNnwr1VoFT01TSb8r1yOG6M
         9rgZn7so3mE7i8YK4RkGI80xKidfDvj0XLkmxT/ZN3l7GS8JDlSZabDY3rNbufL9asXE
         zMziBeLw4QwUlGtZDs4wEgRXKdrFNuoiPNa152C3rfdyanrLQA0aUUUWyKLx4+80m7j3
         jRfzi7Mbm0c48B6dnHmMkhgtUrWzM5M9ukqZfiQtyq8z5XJMSTNW2fjyjjNOwX4Nj+ok
         a6Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=88MP9w37guSqe3omw2ZhzwKj1HdvJiY5qQEGmqhTG20=;
        b=AszvTZcbEaUuoUvxv0Mmdsu2zyJqs0P8zO2Q4k8Lx8ez+pYoht914ZvYTeZI5m8/Ue
         yoxArkWjLa4Vty0Xjcl9qOjrLFVvH6oNM9usDMJaGsXqPblk8mdEksUGjCQJ6RkU5Gct
         QInnyxxn/mXQjCj2Bf98IY3oLuyfiiJrOLgtmV+zcQsd1EEExWEdfWBW28EVT3PI12xT
         zDsZgn8I+/RSp3vdsHiOr1idFyo31UC2R8WPZ4nqvPL7tAXBkjXht+ft1eeb6OPk2ghu
         sg2c8iLbSWp1HXvosCWT4Xna/jjwsjophFA8o6sa9JZhM4Be0VRGHp5YkG8dOix4gT7L
         gpfA==
X-Gm-Message-State: AOAM533EauZkgDbcG/tG+S0mEhZirHjhKh9Z8/YgRiqJgRHj7br6Lo4A
        pNz5P6siYHbF6CDwpfVF1vJn5r+invEpRQ49
X-Google-Smtp-Source: ABdhPJyHW/8m3LvaasJDJxytXOCqzisrJpaUJWcK65iFpeL6np27xwet/lXA4tLGIP/3gHjEcdcC3Q==
X-Received: by 2002:aa7:9195:0:b0:4c4:f521:1ef9 with SMTP id x21-20020aa79195000000b004c4f5211ef9mr12058090pfa.80.1642982529480;
        Sun, 23 Jan 2022 16:02:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y193sm7090574pfb.7.2022.01.23.16.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 16:02:09 -0800 (PST)
Message-ID: <61edec81.1c69fb81.7be81.3475@mx.google.com>
Date:   Sun, 23 Jan 2022 16:02:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.16-717-g26d8a22a9267
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 179 runs,
 1 regressions (v5.15.16-717-g26d8a22a9267)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 179 runs, 1 regressions (v5.15.16-717-g26d8a=
22a9267)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.16-717-g26d8a22a9267/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.16-717-g26d8a22a9267
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      26d8a22a9267408d5d0c120b21c1017ab2faa89f =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61edb3c92ad69f5895abbd49

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.16-=
717-g26d8a22a9267/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.16-=
717-g26d8a22a9267/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61edb3c92ad69f5895abb=
d4a
        new failure (last pass: v5.15.16-606-g1d9b477f6cef) =

 =20
