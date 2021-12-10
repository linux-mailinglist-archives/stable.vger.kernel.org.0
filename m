Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08EE46F908
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 03:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbhLJCUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 21:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbhLJCUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 21:20:49 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B780C061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 18:17:15 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id k4so5291599plx.8
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 18:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TTvlqTxGJ5sDUXQWbHHtVydDtIRH8MePSQ4W/3+fC7w=;
        b=onbeo00/o7ZG9eYUO+O+GdUEsMRW4ak9cnjB7Fz3rYup6NktyybVz9vWX+vDsOlaEE
         o1Y4sxDfpEI5QdFUrZw36y+sQa9B/Lv4im3LyZDtTlgdFF+qNFBXCeUHPSGyuqBK46wU
         X9rGkT9mqDoI/tMpluOhZxanO8NPOwTWlKz5oc9zuxZ0QUNgIM0RLMDFWUnxR7wP6Y4M
         TrqUP+s33phnZa/wy67ddrWZNIK2LNExMrnGMiTU3ff9L7SlN8thPVrjiMO0M02yH7KM
         eqFsCrMWA+ZQ7nnyVG6nqhaD1QgarrnKO14FBaV+9d949Evj2A7+52Ec9IE4u4ehjmoO
         gpNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TTvlqTxGJ5sDUXQWbHHtVydDtIRH8MePSQ4W/3+fC7w=;
        b=Mqr3APc71Bl+iiEj1XJ6hFazZyEvHrHpzDEpJxT1ngmTDcGky2b0f7/YyHuxLzjwwX
         2/ICSLxIPA3hVGBt8nWKjwL9izurV565vDZ+PjdUc5r0oEdW7qR0VvSd/iiwpWGg9cO0
         AKE2VoZIFHMqn3lw8XAkfxjpD1kLoQPFtZIbA9QbNqvDv/gALLd8M1ZRxRAYDHNL1lAA
         Eq59aFgjc4uAenAshhng3zUeM7OOpvFo0jspK59Q+v46tC3zN28jlOaQkV//0gUYDCr5
         48s9OdYmB9OKXeYw2hv00is90bVmVRmQjdKQgwW/pdL0jBFygXunYrwF9b99EW4ryj7K
         tRzQ==
X-Gm-Message-State: AOAM533vbnyOd76grRiVlDhUUbI5GEvBxNdQcmEQv18QMqboKbhFlB1U
        /EYOdeYCA777O1B2HZwn/dO2XnsrPLefJSByUnQ=
X-Google-Smtp-Source: ABdhPJxMXCMvQCrbXolCdilr2Q9p6vnO7syZO189zzSIa1Xd/aww58zYOkYfuRRZcAd17CTYHBwpew==
X-Received: by 2002:a17:90b:1644:: with SMTP id il4mr20307150pjb.39.1639102634621;
        Thu, 09 Dec 2021 18:17:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h22sm798598pgl.79.2021.12.09.18.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 18:17:14 -0800 (PST)
Message-ID: <61b2b8aa.1c69fb81.8885a.3a79@mx.google.com>
Date:   Thu, 09 Dec 2021 18:17:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.163-82-geb87458fe457
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 177 runs,
 1 regressions (v5.4.163-82-geb87458fe457)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 177 runs, 1 regressions (v5.4.163-82-geb87458=
fe457)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.163-82-geb87458fe457/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.163-82-geb87458fe457
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb87458fe457374b0914459be403daeafea5408f =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b2811cdde377f47c39714c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.163-8=
2-geb87458fe457/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.163-8=
2-geb87458fe457/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b2811cdde377f47c397=
14d
        failing since 0 day (last pass: v5.4.163-72-gfda44f5f463a, first fa=
il: v5.4.163-73-gf01a13d9c502) =

 =20
