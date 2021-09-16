Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E500040D2DD
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 07:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbhIPF3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 01:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhIPF3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 01:29:25 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BCCC061766
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 22:28:05 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id u18so5148083pgf.0
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 22:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Kuik8S1rnmD+zjPPAi8GOX3SNNYdOJRoGwCMRQp8FKc=;
        b=45HsC0SlnbxPOVxvAmuC4E8dG0/ED5Bo7nyr8IxtfT403zohBKPEAd+kggToZxdMML
         JQvh7IFKa8XnOsMomSBNa4xF1HgjhpQw94DAD4HLvF9AbGbMf1zSup+1yIKinkbTolml
         hwa+oGbSMyDdW7mBY5O6EdrHttjtfDX5QUJM/d8FAJdqWMefklLz/S/Sfdd4SEavdBYC
         ANCn7hg6vU7IOV1Ws3WVDkkaykiQAs0j31mjE3+3o3sonSKf4GKZIvcV9Tjz9jnKvKtS
         OP7dN3yli9gIdiKGJyyHuFBSqpjiphdqhxGycPauhJNmTlVq8eKp78N4NrdbXlJ7TULe
         Wd6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Kuik8S1rnmD+zjPPAi8GOX3SNNYdOJRoGwCMRQp8FKc=;
        b=vUXee/Oxhnmk9d58e9dPYrBJZlxkBxA0Qvg7121sEQ6brKymNyU6r2hIRP+Jslzjy0
         I7B4gfdNDnap82n80av9Oi6a2fG/3XOHS3TLe4/cHZyuc9BMs25o6TJGm8xJNZ+76D8J
         gsqYhM9wzQNDkB2F1WvIAYk0ZKZwS3xnQlauln3DDhsW8jbVGp8Xf9lHSto2kVg8UkjR
         IOb7lnk2EqVtdFjpbdt+hHW+YagFJiVNHNrwDOUT6ovgTd+hi+mjNNQevB63ieEFGI5W
         dKQI08WV7TBGIXW2aPUEOT9CD6u74P1dseDCXcLrZN5MD2SZpWMEu8ZudqHaIlPtca4B
         lPAw==
X-Gm-Message-State: AOAM53192tGI9tT3W5nIiD0TosZgy79arcEFan664g8NlhIAfn0QytWv
        CS/fGrcbtD4ZLVl/L8wv45cYZUfZouUsXIlRtBg=
X-Google-Smtp-Source: ABdhPJxZcEhNjhkacjzLwjCLse+Oy7MT2YEUB/RVzhMwRAPzj6krIKrU6y/JONSi2lM0d/cgJDO5BA==
X-Received: by 2002:a62:1697:0:b0:43d:eaaa:cf5 with SMTP id 145-20020a621697000000b0043deaaa0cf5mr3245126pfw.56.1631770084415;
        Wed, 15 Sep 2021 22:28:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u21sm1664013pgk.57.2021.09.15.22.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 22:28:03 -0700 (PDT)
Message-ID: <6142d5e3.1c69fb81.79ffa.77d2@mx.google.com>
Date:   Wed, 15 Sep 2021 22:28:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.17-68-gfe61ccdae2c1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 80 runs,
 1 regressions (v5.13.17-68-gfe61ccdae2c1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 80 runs, 1 regressions (v5.13.17-68-gfe61ccd=
ae2c1)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.17-68-gfe61ccdae2c1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.17-68-gfe61ccdae2c1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fe61ccdae2c14fed6c3efcb1426691db8598fa40 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/6142a32474039bcf4099a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.17-=
68-gfe61ccdae2c1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.17-=
68-gfe61ccdae2c1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6142a32474039bcf4099a=
2df
        failing since 0 day (last pass: v5.13.17-17-ge0578f173e9a, first fa=
il: v5.13.17-68-g71a177e69b76) =

 =20
