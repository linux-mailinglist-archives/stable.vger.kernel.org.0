Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B4145B2F7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 05:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240230AbhKXEKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 23:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbhKXEKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 23:10:47 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1985EC061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 20:07:38 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id b68so1360019pfg.11
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 20:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vB24zVtC23h1mp48za13YoJyMdGbeHVPK1GWkUTdr9s=;
        b=nO43gJ2xOJJWjM0DpY6Uh7zNlXSVf7hzHM0aW9Jeg2NrdbFRjwSXvZy8wjwzo6xGKf
         JvqqdcxMSe8WSixYDkt0VdbugZalAUABKZpsQRv5+LTDukylh30FIWksxwvJ/fRxQA17
         xafgklTNsxHB0oMW8t+37ldY62McSdvYQIP7ghD+WXm3W8wb/Ete26v4kYF8lJFktXvy
         Fig1qXr84cRkvh2KZmrt9wzfX4HuPaapJoPfX0vrxgL8x0GINCARKbVUuH1x52qLqcIY
         ycUA9pRP1WKp+ym8iOCbKqK6vlsjPPuVBxJJ9tGr7JYHJMla2N4vgtnUY1yr/zAsx8rI
         Rw6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vB24zVtC23h1mp48za13YoJyMdGbeHVPK1GWkUTdr9s=;
        b=SbZPQ+DUNoMVv4Rjik5u+pAwKJ8gCHAO6+xrziSRZ0Ax3yK8+Bm46+ACizLuHtmghA
         /wWRdQbEZMevfecxIAsTdkPnR4XyA9uR9oAsJaSAj+vsOKe5lexB5Q0KjATFABeXuBt2
         brtUCBUqrpVGU3lTdpq6Q0mEFh4X/MAK5MX2OH4cgRR3j5b4CvUeJgw8qDgLDBJ4q0/J
         IZ38Lv+qnvinq7ivM+JPt+OUf0iAxZnOHMpWdUj+J/diQi6yigQeP/k9UBBBbQNE2Ay0
         haYuWk4Sg+55MfIGGv3HTnHo3CsJhzFXKBmKNX0xFmhR518D/HRCdDzvilbB8fhYZCjl
         AUlA==
X-Gm-Message-State: AOAM533fSsj1YhHpIq+MAC/+5ukhXzArjkQe1EIFoUCLYs2RKXUxAi2a
        iWhZwqFtA5AOTsrgXA4SDYQtIMS7ExH/dWvx
X-Google-Smtp-Source: ABdhPJytJ8jv/6/7q+ajo6iHTWhjhZrS+EJjXsQV3TebLcc2Q+xkW+R4VuXUWn0sXZbUoZrFXGr+Sg==
X-Received: by 2002:aa7:8883:0:b0:49f:f87a:95de with SMTP id z3-20020aa78883000000b0049ff87a95demr2904837pfe.53.1637726857374;
        Tue, 23 Nov 2021 20:07:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d17sm13787799pfo.40.2021.11.23.20.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 20:07:37 -0800 (PST)
Message-ID: <619dba89.1c69fb81.b37db.8651@mx.google.com>
Date:   Tue, 23 Nov 2021 20:07:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.4-267-gf7e74fa664b98
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 134 runs,
 1 regressions (v5.15.4-267-gf7e74fa664b98)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 134 runs, 1 regressions (v5.15.4-267-gf7e7=
4fa664b98)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.4-267-gf7e74fa664b98/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.4-267-gf7e74fa664b98
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f7e74fa664b98edbf9ae881f928764c53353735f =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/619d83e080157f9502f2efbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
-267-gf7e74fa664b98/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-s=
alvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
-267-gf7e74fa664b98/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-s=
alvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619d83e080157f9502f2e=
fbe
        new failure (last pass: v5.15.4-257-gdb939df2ad534) =

 =20
