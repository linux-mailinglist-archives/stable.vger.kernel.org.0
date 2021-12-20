Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87A547A7F3
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 11:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhLTKuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 05:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhLTKub (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 05:50:31 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EBFC061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 02:50:31 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so9275276pjp.0
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 02:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0oMVlts+Zd/M/jhV6O4oOsWex/9b8hduR7XdYlfAIpA=;
        b=ANyMPq6tWS6hDS3g6Z7o4BAcKj2mpFr94nbSvaqijaov6Mmt6UdO5PVV6NiYmC4T5+
         ZVX51crZyjrgkzKVaZzKT4mANPDtq34IbXMBt0HfcHgrL2UXfTd+ScqgYGcejSaIfsgi
         qXAiDYOD+ejQki3mxynxVWHeMnFEzkbw0j5kCdnbgasKKyEgRcwrum4hQVH1G5ZyNOfi
         arV9c2tKMbS+5YfAEM8am1iWZASKluqyCy/WRNqZZF4j8aNreGT3Zn00/jc5l0Lycvtz
         i0jNCliVxnMWCDKHERmEWEllxfMibR9rW/Xov0skiMuVzPhl+9vasIFRi77L4nesKYXk
         shPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0oMVlts+Zd/M/jhV6O4oOsWex/9b8hduR7XdYlfAIpA=;
        b=fGS7uspSUnqgxZ5oj1ZvTqdXtHAnqPMsopziuAZHVzwDHzN+Ta6UnojvgzJpSKuzTI
         De9iUC6AyBcYpg3+Q1oV1mi6f/CqI4pleBzP+rjt1oQn0P03HRW7El3ImpZPSUgvchWR
         4xqJoPdW17JqZuX0KvcJSHgD0um1h8o9Ig6hhcq3BwaXrSa8l0anPRSDp/ajtafWKSd1
         2jCR7IcID2ofvZLdZSTu7DtKAOwEhlMm2i9dxOfsPApLnPUZKjktLh2GuYoS00E1LEdD
         Hmzth2ZH19R+6AN09Z4RsFsnkUibcvsO2/JPivGalrda0lSS4KRqUYWJLZBy8BYQeAL+
         YrcA==
X-Gm-Message-State: AOAM5322pnjx+wfzjg9F9/D35BF8XrQa3DitUBQqjPpfcQIDqbl9e3wu
        x1/SCur9GWBK/mFUS+enqfVR5oTf6TNorZYD
X-Google-Smtp-Source: ABdhPJwB77PPV3m4OuYEY3vxJP+Y7qQGk//o9AzQQJaSlH1f6bqab8FQfz3KDfpKAPXMXo6Qn8QwrA==
X-Received: by 2002:a17:902:bb87:b0:148:a2e7:fb52 with SMTP id m7-20020a170902bb8700b00148a2e7fb52mr15936733pls.147.1639997430876;
        Mon, 20 Dec 2021 02:50:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i15sm7561409pgd.16.2021.12.20.02.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 02:50:30 -0800 (PST)
Message-ID: <61c05ff6.1c69fb81.ede1.503d@mx.google.com>
Date:   Mon, 20 Dec 2021 02:50:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.87-66-g2eb0aa8b2e00
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 192 runs,
 1 regressions (v5.10.87-66-g2eb0aa8b2e00)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 192 runs, 1 regressions (v5.10.87-66-g2eb0aa=
8b2e00)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.87-66-g2eb0aa8b2e00/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.87-66-g2eb0aa8b2e00
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2eb0aa8b2e0023f1361c1e60c7b2e50d7cfbda9b =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c026fc698b75a34239711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.87-=
66-g2eb0aa8b2e00/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.87-=
66-g2eb0aa8b2e00/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c026fc698b75a342397=
11f
        new failure (last pass: v5.10.87-63-g1b969379182f) =

 =20
