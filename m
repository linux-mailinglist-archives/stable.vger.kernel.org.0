Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53DFA4C8339
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 06:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiCAFhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 00:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiCAFhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 00:37:20 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B3C70F4B
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 21:36:39 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id n15so10344009plf.4
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 21:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YTj/NDkW3u4UMgRY1KBLb3FwQefy3ANUgvMGYVTKWCU=;
        b=Djlj2UsI/glCwG2ZJYzlh1+0CMPa63Rnvf+MQJ26tAJddlt21Y6ViIDEiXizsWXCUw
         c+3ziHa4UbLCfRC7CXPil3UFOGw1MLCKKKRDEP7PF5aqZSJ/LqY6AYokQtgKr66NQF0E
         6gIjd7qyy+bZsu05pVA1JNm714yh9Bzw4hqHqKTYGdwWL3us5uwTUtQYfeMzjzhUU8mj
         xFNnC1v5Y/+jwyWFf6BkEL71Z9+0Vb9VxTwg/qSHwQic8O2LxSyb+m14kXJauRtS0mh/
         HXBfg891O2HWDzl3rJjDPt9DqEqJkc3lgW/gOGZ7RQvh5/wO/d3OPe/1dFALNbc7Lcfp
         YLBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YTj/NDkW3u4UMgRY1KBLb3FwQefy3ANUgvMGYVTKWCU=;
        b=sr0HiqpznwmXbsCm3tl7S1+A1ZQ/Veb7Y0t3ZJy4ha+Kv7CTqnQ3ty+3UiUHWpDPrK
         rqZJwzCisA2PkSekn8olCPwyz76YvlYN6bPIW+r70bIDY/2f5sx8TnNeRkJsVUfTYtF4
         Of251Wj6Uy38UG6SsxBTIo24nWC7PwoNd09dRSMG0ov2hgSusjbgbTK8+4Fb+aBof/zQ
         ANR0IZTlnlNtHKbwLgwiLl6xY3razLqTL1Qg93rve1UDBxepIUAw+44txGMtPYTYpLR3
         dCB6F5xmgKaCM/n/v9mb7GaNWL62hOGa2yT/r7sdrGFYvDsW5JfIVT6VQzmkj8b0yjV0
         iJlA==
X-Gm-Message-State: AOAM533P5aYrC8MsfiWjyMYspukWV6BjSnKuut0hpaOazyAg7lBaPd2t
        jaX/Pjbqz4sLMAbW5f9aOVEwTLnPmG/o6lHHM9I=
X-Google-Smtp-Source: ABdhPJyS4HmHaQjCknzqTBpfw7vJi5cWQXrVTqsAifMuaX1h8HNn+gM/Ti+ykibkx9gAWMDfZEar6g==
X-Received: by 2002:a17:902:7b8d:b0:14f:1aca:d95e with SMTP id w13-20020a1709027b8d00b0014f1acad95emr23660971pll.122.1646112998895;
        Mon, 28 Feb 2022 21:36:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b14-20020a056a000cce00b004e19bc1e81bsm15703737pfv.18.2022.02.28.21.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 21:36:38 -0800 (PST)
Message-ID: <621db0e6.1c69fb81.617bb.8bf0@mx.google.com>
Date:   Mon, 28 Feb 2022 21:36:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.268-31-g23cec7ad45df
Subject: stable-rc/queue/4.14 baseline: 65 runs,
 1 regressions (v4.14.268-31-g23cec7ad45df)
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

stable-rc/queue/4.14 baseline: 65 runs, 1 regressions (v4.14.268-31-g23cec7=
ad45df)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.268-31-g23cec7ad45df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.268-31-g23cec7ad45df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      23cec7ad45df2d8b9fbf413e5d224167d360e4df =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/621d77073e0c4f3a2fc6299e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.268=
-31-g23cec7ad45df/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.268=
-31-g23cec7ad45df/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621d77073e0c4f3a2fc62=
99f
        failing since 15 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
