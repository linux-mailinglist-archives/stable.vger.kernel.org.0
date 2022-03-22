Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29A34E387E
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 06:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbiCVFaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 01:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236751AbiCVFaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 01:30:24 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB9913D35
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 22:28:48 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id g19so17277899pfc.9
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 22:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O7UcKSxm5mOhWMQz1ucaiqPHcAZZ59ACYBtbGPfA+E4=;
        b=ikKKIspxfxIrmmhWOUDa0JSy5WHMkZV9gjqwxwDk2wRlRdsw3/N29RSAzfRYm+C5eo
         LKiHyYkP1vCOlmIOtf6U6Uz53psINlfVhOwFTd9KcFctheSnfw4914JWGEgqnmxgiWXn
         RQyM5HefQET5Qb/v+1pHTuWYHzj8iNGr7Sa9pM1RCoTHXVr0AOBIS7hIsM672G5mBTwg
         jrmavo8FTyJvGvZPfOHjrWq9XDETHbJe7Bp7cKSwtgBq+225kAhJ+nJ3drZrV4MRYR8O
         ddtvtAr6mJJEaMwD620ozCzd7LpqX30jAarvGAHJYlFMSmdSDHywAKQsVAGIWCpiELUu
         +d7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O7UcKSxm5mOhWMQz1ucaiqPHcAZZ59ACYBtbGPfA+E4=;
        b=N3l8quj62n4k8oE2TySSR5NgQIrhkj8x37WDWwLkXD3Mg2A9MDKtMImllz91N9P+yo
         D93aj5ol6/kE8fT4Ln8L8GTRanoZ4czf11NrxojmfTYiknqmB4flEqGieImn2jeTa6Am
         JrLetQaGhReLWd6P8TZywkq0Sc7FZ28rpl8qSqMbeXvsy6EBxP8C9COKFoVjUq9ftdHr
         rC0dNXZL/2MhxOg4vce7nPzqoJtPRJP6VElJlcrd/aWmuhz1bG6t6D+Gl2HJ6ZLcVk/H
         NOuwTRbGp7M+XP/T3Ju4oosjWiGTX+5mTxDcB4A92Pn75j09voSOqKQDPRo5pA7RmrEp
         HHwA==
X-Gm-Message-State: AOAM530TvoNQnI+ATTUcchwq2G2TeLBN5ERxD62tFSM1u+OjtVYPC0E5
        YPvMazWSRoMJz520TeUFkxWd9VoNq1cL4XVLXuY=
X-Google-Smtp-Source: ABdhPJzbXXv3FnCew13sZ4L0pd89MCUlUOx7YEImsmvgfbhVEsAXB4sjHupv5yDNO61BXMYKn1n4OA==
X-Received: by 2002:a05:6a00:d6a:b0:4fa:6940:f2dc with SMTP id n42-20020a056a000d6a00b004fa6940f2dcmr22312864pfv.61.1647926928256;
        Mon, 21 Mar 2022 22:28:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f13-20020a056a001acd00b004f76d35c1dcsm20885756pfv.104.2022.03.21.22.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 22:28:48 -0700 (PDT)
Message-ID: <62395e90.1c69fb81.e462a.9dee@mx.google.com>
Date:   Mon, 21 Mar 2022 22:28:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.16-37-g2a1b62676c09
Subject: stable-rc/queue/5.16 baseline: 84 runs,
 1 regressions (v5.16.16-37-g2a1b62676c09)
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

stable-rc/queue/5.16 baseline: 84 runs, 1 regressions (v5.16.16-37-g2a1b626=
76c09)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.16-37-g2a1b62676c09/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.16-37-g2a1b62676c09
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2a1b62676c093c9c59c5b96d77fdf382bbf56bea =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6239282191fbde332a2172d8

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.16-=
37-g2a1b62676c09/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.16-=
37-g2a1b62676c09/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6239282191fbde332a2172fa
        failing since 14 days (last pass: v5.16.12-85-g060a81f57a12, first =
fail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-22T01:36:15.218104  /lava-5919549/1/../bin/lava-test-case
    2022-03-22T01:36:15.228825  <8>[   33.603233] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
