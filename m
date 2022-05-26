Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E992053560C
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 00:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239056AbiEZWSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 18:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiEZWSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 18:18:39 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671903FBC0
        for <stable@vger.kernel.org>; Thu, 26 May 2022 15:18:38 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id w3so2574686plp.13
        for <stable@vger.kernel.org>; Thu, 26 May 2022 15:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=udap1u3TSuTzdV4wspcctCt+d/TW0XXgmIWt+XxCkP0=;
        b=I7nfwbcNCLnnPNKYFl8VfrOtcwMDOWLVjOn3LomXE9vAYOKEUV6a/JcPXB3bOxlXEq
         aAw/Oq9MfEXKENn4g7aX6NYSqwj39mb94VlWYLjPwl6bSxaSsRTsSTUYv4yUV+36+wVV
         Dx5QWi/UxJrZ1DIbeGEWDXWAL1PS3zrQrzyjasmySjcOBOpyTdMyhzkLgWJd2NTCSWu0
         1ZFFarZTxNRtYxdvRdOduVEl7THnFepA66u4ELBCD0+r043dqFDppKkrSTik3QNol7Fu
         XnR7ylhBZCFSwykgWfxSorCdpO4p62G51N9/B61CsXxKUYLuQQMuDmbz12sFIUoYiJKA
         fnbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=udap1u3TSuTzdV4wspcctCt+d/TW0XXgmIWt+XxCkP0=;
        b=E6dAveGs0BRugyqzyF1I0NBQ1p80jrKdnuPCvmDlDMCZ4SZrAIde4AQe0z+PfBpJRS
         yfAIguPKUkc8FPAbLINIL0eKQXVAUoHW5ojXhpoXN/jMJZ8ShVBB5U/fJAGwk6yxeftS
         /zdf5RIjpEpBJCvABiCQ/IYBQQSDG4xqLhSoxHbVNrOI4/Uj5JPrEXKv1U9tPqZY2Ame
         k8bzgDOKhWIqNj5EwnBOz/LV/Dd/gpMu4J8+MBqNPDWJtXHs4AHG+yqJjT67nZLeglSk
         T2zhDUiwHumJ5V0xI0Ck4dRCIYABzWcjB+smw7t7+IaEbszjg16JvLuWLyAzRR9Utw5P
         jYjQ==
X-Gm-Message-State: AOAM532qZb7fNLbgKLNJYzwN9wrON7NROUI8WFlhYLNNcTL3+iLiWj3h
        JEsVfVCfVePpDvHnFy8Q+w5MXwD7tqhlP9D81dU=
X-Google-Smtp-Source: ABdhPJyWIzpa+8ICHKSQAtHm/dIXVzWPyCc3Hn7b7a8HgfbxQsJlmLWPQeDqajdAE/JAFFZl2+YFsg==
X-Received: by 2002:a17:90b:3902:b0:1e0:50ef:3ff3 with SMTP id ob2-20020a17090b390200b001e050ef3ff3mr4792720pjb.137.1653603517856;
        Thu, 26 May 2022 15:18:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q5-20020a17090311c500b001620960f1dfsm2098935plh.198.2022.05.26.15.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 15:18:37 -0700 (PDT)
Message-ID: <628ffcbd.1c69fb81.1147e.4ae3@mx.google.com>
Date:   Thu, 26 May 2022 15:18:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.11-110-g77c86f3d903a
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 68 runs,
 1 regressions (v5.17.11-110-g77c86f3d903a)
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

stable-rc/queue/5.17 baseline: 68 runs, 1 regressions (v5.17.11-110-g77c86f=
3d903a)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.11-110-g77c86f3d903a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.11-110-g77c86f3d903a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77c86f3d903a91b1a0213b971df38bbe509c68ba =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/628fd7b15090553a82a39bfc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
110-g77c86f3d903a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
110-g77c86f3d903a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628fd7b15090553a82a39=
bfd
        new failure (last pass: v5.17.11-2-ge8ea2b4363353) =

 =20
