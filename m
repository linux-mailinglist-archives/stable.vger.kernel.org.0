Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA33458A9B
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 09:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbhKVIm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 03:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhKVIm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 03:42:57 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82684C061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 00:39:50 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id h24so13242607pjq.2
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 00:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ew/LXF60SZh3Q3h9UXXm+RzZUVSCC3J8C92dJ19zbeU=;
        b=Xh3FaSmYaEQE9c6yOgT4tuQVphNzOTbQ4aw8tZ1MlsBHFNgVM0AlvLs0F7B9aUOuEs
         tvEkwYvpPmEvjE0UbkHK3OQzWv4BjLLOZU7RHNXpR3whjtU9QDIAgSai+bJMywSTU1GI
         ePs1FiNYVyRpe/aBU/CuWv3vFZ0A6WhQKcEY2rxtmmCD94ITkeLKdWdcc1sNTBlRm0Fz
         v3pe670PzPMw/yXWBcHWDVlJ12jaS1dToM0eDTAoFcAFUY4yt3Zuljmxoz/mpMxFZpYe
         vF46VhsTv51e5R0RXx06xWnDBvUJCIsAZUZHWLiE284AaHMRg/OXvbFhRCDoGTMTLmqA
         JOhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ew/LXF60SZh3Q3h9UXXm+RzZUVSCC3J8C92dJ19zbeU=;
        b=YaOeGQ4U8jN1aeBvqhTpDGQFnS6Qc3uQKyTDPiePcUF6kvHy0i4a9ZaB81llQvtcH1
         1umUKXTwxI/BkK0tNG4qkUmxQYRW3YkJW9S7fhWOmmTxgJLhQ4GqGEep86mf9saGT60c
         3znItwdxoHwZnSWw0ExwlBTNXf+Wz5VxqM0sQC6Vyw8lEUw8AA4e1J1QgUJqzUo10lJH
         cm0GkJZEMUWJ06hzav1J0O812UMso0nMT3myhgImkcMcLzsHDpt5rfWv3Q+YrcnSjQyC
         Fj3vHMxbygcfs7ckE9raYfVMl/ZHXq27YIwohh9RLWxRjPCqHDQc8SRxsWXSfg3zIf/P
         9ZSw==
X-Gm-Message-State: AOAM5326mK3cumfZZALxYw0uv3Yv22hg9GaDYllT8Yqm4ixmyrUUhMg2
        g2ThhEsY4eB9OXys6vF38SfsfrBmTKf66zL6
X-Google-Smtp-Source: ABdhPJywPTBkiMzLlX9b6DD3C4OhEN3sYpl061iz0dq0OZpsnq+EB1HtGLAZ+XmhFxsQ+s7btBs5Vw==
X-Received: by 2002:a17:902:7616:b0:143:a8cd:ef0 with SMTP id k22-20020a170902761600b00143a8cd0ef0mr99253776pll.48.1637570389414;
        Mon, 22 Nov 2021 00:39:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p20sm8105250pfw.96.2021.11.22.00.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 00:39:49 -0800 (PST)
Message-ID: <619b5755.1c69fb81.4ad66.8228@mx.google.com>
Date:   Mon, 22 Nov 2021 00:39:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.3-209-ga7c460a89289
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 174 runs,
 1 regressions (v5.15.3-209-ga7c460a89289)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 174 runs, 1 regressions (v5.15.3-209-ga7c460=
a89289)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.3-209-ga7c460a89289/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.3-209-ga7c460a89289
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a7c460a892891fa89973b69b64071b58b59523d9 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/619b223f0f990a1f4ae55299

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.3-2=
09-ga7c460a89289/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.3-2=
09-ga7c460a89289/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619b223f0f990a1f4ae55=
29a
        new failure (last pass: v5.15.3-20-g3176a665db83) =

 =20
