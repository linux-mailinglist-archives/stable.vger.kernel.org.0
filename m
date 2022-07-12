Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD6B57211F
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 18:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiGLQlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 12:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiGLQlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 12:41:07 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9254FB31F0
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 09:41:06 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q5-20020a17090a304500b001efcc885cc4so8772171pjl.4
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 09:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aJB/AS4v3o6pcekeMakidmFNzCylqdyvay+V9YNsw/M=;
        b=l4AwlIabegTA3BEN7nWQfjCcjNyyFkoGNtOan0yA5Z3KmjWCA7av/xkIXCrukHq1hl
         lfIyQMCl6qhBBxFG/RHLX5sKiPG+EL3biEJPhJve9d7ZE8gRQvZT8D5+OnraQBOYkvuX
         Wg8aafNRAi1lNLvMN8cj1xJEZ6ELHnJrgaaBgKNd4ASDke1mTZcKcnnGLLYJ/BTAfBZ0
         kA4vq4zNc55ZPaHfDaZNmbxPdHA+Z2W4SRIkbIPHwfwcCGW7g6oA7E92ofjYPsQxP/Zq
         Ze9pnP6vsOAaqdckT/AQmigxvQHq5nfwy8MYjBNJsezxGyveCRtId4RYyk1fOw/zzBa8
         r9Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aJB/AS4v3o6pcekeMakidmFNzCylqdyvay+V9YNsw/M=;
        b=71oV6RRpNCuEtvkh8IOqqCY/ZCXkfEdRT0n9uOvntP6Soy/d3yg7mLqyLrzFtv1l9V
         0aU8awOH6KfRcYelsZ9W/KV7jAkH3hgRHZxy9zcJatJ2BF8FeXsD9wdX5gafQO9DOkXD
         OH2kfPAghNqRm3T9d79LuD3Rm4V1UoNB9hLmDIF/Zpgs6E38asbk6gpcZ31U85IYJxWD
         oEk/LR/Lxl6vGs7/LTeLd3x4cOJEWcK2qnLyFKHC4KJYfXHECE9OTvJJTyonod9aiR3F
         +OXRl8ZA/KwjR+9HUVeIOYMSLI4NUrLE3NEJyW8qqx5LWOuP0Gqv6ZvAsEFgJxNHxsSr
         5yvg==
X-Gm-Message-State: AJIora8fFlj+cfSaR9Riu51whuqsxU2vQRgwK+LfT19jxGZ0WH9s/5bX
        rU7/ctv8dbBJQzskrDDWDOmpqpDY8SeJ0Kvs
X-Google-Smtp-Source: AGRyM1sG/Xyp9/Bx/tAnl/Rl+rAST3zdFCp2W2rqafeGIg8NtUcnCRL/ijz4k6rdoYBOSVzGiDpnIA==
X-Received: by 2002:a17:90b:3841:b0:1ef:f0ac:de55 with SMTP id nl1-20020a17090b384100b001eff0acde55mr5476919pjb.35.1657644065930;
        Tue, 12 Jul 2022 09:41:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902e74200b0016be596c8afsm7222621plf.282.2022.07.12.09.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 09:41:05 -0700 (PDT)
Message-ID: <62cda421.1c69fb81.ddbf2.a805@mx.google.com>
Date:   Tue, 12 Jul 2022 09:41:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.10-112-ga454acbfee6a
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 93 runs,
 1 regressions (v5.18.10-112-ga454acbfee6a)
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

stable-rc/queue/5.18 baseline: 93 runs, 1 regressions (v5.18.10-112-ga454ac=
bfee6a)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.10-112-ga454acbfee6a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.10-112-ga454acbfee6a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a454acbfee6ab7a41906aa06b72a6b68a506b2b2 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62cd7469c1b3111a64a39c66

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.10-=
112-ga454acbfee6a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.10-=
112-ga454acbfee6a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd7469c1b3111a64a39=
c67
        failing since 6 days (last pass: v5.18.9-96-g91cfa3d0b94d, first fa=
il: v5.18.9-102-ga6b8287ea0b9) =

 =20
