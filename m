Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3871F51FA8A
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiEIKyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiEIKyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:54:31 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DE711174
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:50:34 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s16so1609476pgs.3
        for <stable@vger.kernel.org>; Mon, 09 May 2022 03:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d5sUwVHU9Xj9YBevV/rr+kBKT1C3TYkdITmtebIfnw0=;
        b=3rwjUrzxpO7Remj9FgnXa3b8d6ZVhx71zqlkJh0EQgD0w7wdSiVekO68txvlz9tI+h
         yEDUr7vqG2n49XzVXhK6EbS1piZZoitSwkQ5VKYYYMH9BOPlNDSIgS1a4eY9qnoFO/qn
         KmjcnLQGDCZvqCKPb2cAGshtAcgesVbJl+YKCpQ//odjDJezrmtcg6AT/4lG226V09yG
         zehFGyhfew5PgkvBJlAD+vHwXLGdGkmBbox5mctmYnS9xkM69JH4zkkBLeIE7C2fXHEE
         EZZRz0vGaVbb5jAR9zRellfs3soRgwQrQdQro5gHR3fR8RWTpsomT8mP1HuCkynH2Yx+
         a5mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d5sUwVHU9Xj9YBevV/rr+kBKT1C3TYkdITmtebIfnw0=;
        b=QV4ZN0ZCTERlH1Nwj/ww3JVaXXQ7gCR6tHe+2j4aPKaHOl2PujAFS6ThIYR3JkJJN/
         57jnuRI74PKzsExzY0OIIMvs96HEcPUpF0oIKbrIfXmGR9XTaQgHWZMxfPusZ/RGG6Qc
         jKwsQKhe9E9E3ig03/Ox3Y2B95ffg1ocIg+bzyLgBvBhpqzlfNiBsQK2ziVfGx1buiQf
         2TNaaDw/R10K3M10NRK1dBQr2+BPoUIOaOSfgeiCuxOFCymuZ6r2sXOCS+Zk1Y/EzCOH
         agsSZ9Oux9qbhbYgAT8EfdKz+1wBAQW/owe77RlvW7+rmstdMq7y+MYW69nodICEH6K2
         llEQ==
X-Gm-Message-State: AOAM5322JwWhCvvurATNvbcSvMmxkNDmwb9xNNf8Pjih94lx7lsFDqvR
        r99FcWEa4l2zvFB2kfCPmelqR/+WAxsGbUyT
X-Google-Smtp-Source: ABdhPJx6f/I+lG/cxPkbxo6hjhed2xmpCnovc76YG0hdXqMh0LyObJ6z/GkugafbwIYTT31CUeGjow==
X-Received: by 2002:a63:1862:0:b0:3ab:224c:fef4 with SMTP id 34-20020a631862000000b003ab224cfef4mr13084643pgy.149.1652093433612;
        Mon, 09 May 2022 03:50:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 6-20020a631546000000b003c14af50628sm8124804pgv.64.2022.05.09.03.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 03:50:33 -0700 (PDT)
Message-ID: <6278f1f9.1c69fb81.6f4a2.2614@mx.google.com>
Date:   Mon, 09 May 2022 03:50:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.113-129-ga6b8adceb314
Subject: stable-rc/queue/5.10 baseline: 147 runs,
 1 regressions (v5.10.113-129-ga6b8adceb314)
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

stable-rc/queue/5.10 baseline: 147 runs, 1 regressions (v5.10.113-129-ga6b8=
adceb314)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.113-129-ga6b8adceb314/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.113-129-ga6b8adceb314
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6b8adceb3142d3ea7d5d6b7d6f40ad22c3714ef =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6278bdd41d9fcee3fb8f5727

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-129-ga6b8adceb314/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-129-ga6b8adceb314/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6278bdd41d9fcee3fb8f5=
728
        new failure (last pass: v5.10.109-21-gc5ab4afe121a) =

 =20
