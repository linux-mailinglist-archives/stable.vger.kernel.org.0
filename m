Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6349B45AF0E
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 23:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhKWWbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 17:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhKWWbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 17:31:55 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D717AC061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 14:28:46 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so2951907pjb.1
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 14:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xXWENpgWlVU02Dl+cUXfWGVJh7aYJYdRwk/KnAkvyZA=;
        b=ClT3YfNscpgcHo+x59mFh36Wa38Og7QHn9HEweR92fg8kQ0fFwASFKY6tHeSa5f8+i
         AgS086QlSkl3QHWdr7dzqu3KJGPAO5xzdEG1sDNFKsC5TSawSGecv69m916oTQz1W0HF
         0PRSq6vvYvxQtsIdKcHisWZbTl90DtWY0JUn2BX41MUCtVGSetk9KfQ+83BB28tv7LoP
         2x8IIP06RNh8/GV/ESQS3bcSxyFHf/TKpqHQwiT0jlLtnh++Nl3RcABOY3XJkO2XHhuq
         u2s/2Xg5b00+sqtbLyulIJzteer5IJYr6FiV/Ju2SlhBmfDGuwnx19yoM+eXs6jSI4tu
         zZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xXWENpgWlVU02Dl+cUXfWGVJh7aYJYdRwk/KnAkvyZA=;
        b=1G0yyV8XhYCyrJFFQCxaAaxE+HH96iIDPLWfTLOyIjd/97Y4TsYWHTuPnuaz5w8/ar
         +lphz8HsNbVWOXWs7S+kw6+/mq/MMD3dXtYFTxsYGkVh8LAxpHS/Z4mia+WoH/nYMl3u
         watF+thEpfSs3ixOG8Y1ifYIWNWXObY/XBxPHdpbN1J5YoKD0r1jwG2zQhVZtucn+EOA
         C5ciHMZdFZp2Pus0kuo7X1X5CWKCxs13JX4xLj0ZW8M0G9li7mTl7Hi+pM7bQRq7dENp
         TMQvm3T0Ovddd2RE80AA0VvBATYFJof9Bvsp/f7sLgSjh3rt1NomTwI0Q+c+lUOSVx3c
         6yaQ==
X-Gm-Message-State: AOAM533q0KPlkiiUeoGHY0CP6ZrukG/bePZWFmD2YBEKpZIWucyou0Ve
        StWY92oADTsoOxhtBEu2Xgalry7wdNn6/LIz
X-Google-Smtp-Source: ABdhPJzkshDjBTbX4MLbkxoetyVOC9ekaMIAFByA/jRdJheGkEwsMe/wAZXo2sMve3c5J2HSk5Qp4Q==
X-Received: by 2002:a17:902:d703:b0:144:e012:d550 with SMTP id w3-20020a170902d70300b00144e012d550mr10873419ply.38.1637706526257;
        Tue, 23 Nov 2021 14:28:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v10sm14010892pfu.123.2021.11.23.14.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 14:28:46 -0800 (PST)
Message-ID: <619d6b1e.1c69fb81.a38e2.6fcb@mx.google.com>
Date:   Tue, 23 Nov 2021 14:28:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.290-204-g0f8512aac86d
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 120 runs,
 1 regressions (v4.9.290-204-g0f8512aac86d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 120 runs, 1 regressions (v4.9.290-204-g0f8512=
aac86d)

Regressions Summary
-------------------

platform         | arch   | lab         | compiler | defconfig             =
       | regressions
-----------------+--------+-------------+----------+-----------------------=
-------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chro=
mebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-204-g0f8512aac86d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-204-g0f8512aac86d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0f8512aac86d82537a4c327c28e986c707a29413 =



Test Regressions
---------------- =



platform         | arch   | lab         | compiler | defconfig             =
       | regressions
-----------------+--------+-------------+----------+-----------------------=
-------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/619d4017fc8e71b974f2efad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
04-g0f8512aac86d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
04-g0f8512aac86d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619d4017fc8e71b974f2e=
fae
        new failure (last pass: v4.9.290-192-ge1c5881b115f) =

 =20
