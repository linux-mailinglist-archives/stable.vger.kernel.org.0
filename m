Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA9C659B32
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 19:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiL3SEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 13:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiL3SEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 13:04:32 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70625178B5
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 10:04:31 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id c7so14870121pfc.12
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 10:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=QRaB6lu4+ot28fFY0yB6QIlcfOzRYTFQfrUxhStgwEA=;
        b=hCrY2vJojB+6cIftm8c1hxPBkEBwi38DmC1L+wpjskW8u4BPnZDJZRnxuT1PDy7+z5
         v/NmoH00J057G+v0qt4WNwQHdfqdHSC4c0eqxYoJvafUtYciTKT6/GCFZqOllir6ZNbN
         mJcKGAAHw+T/lQ3aXtz6OzhX+7IYGxtlz3AlJYGWWq2USQvts2myOFMIpOl9KoWei/60
         X3QGldzm/7OX6A5r6J/obmZ2mBKYF+gEdxnDfCOvyjwzndx//LXZzf7+/oueEQX37ItM
         3uJRLeBnHUZkXjeDmKMGDVlGMwu+ZNO5x/4XrC9wJPprzNvWoYDe45VxSlMMtEhao0xQ
         8Cdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QRaB6lu4+ot28fFY0yB6QIlcfOzRYTFQfrUxhStgwEA=;
        b=vOnGxat+d272fiwfr2s1ewKp6ToSdLJGs22hD+xan2ZQRzEG8y+KjWsLOhUsREW97u
         LkhkRe820rGTxl4uzqhTJn9pah296dhT4hfXUGHrW++Lhrz3ZmzMzv5LoiCYdw/0pGtF
         cN3ReTQsDDm1yo+fsh7WkqktozejiWSUBGqO7x0uohRziz/hs6DA7Qtgfl+zHY4KQHb6
         +EfMSgyqbBefncnyNSP1znu3aY1Mww7/CW4m23Kb5VeonBXIS0QAObu72KxfxGHuJzJI
         0u6A7iXrk1WMQnB3bW3SRPFlCyOh2a+WCcig8MlhrbV/rRxuiJbwlVCmgcJY0C7RwlDw
         KlVg==
X-Gm-Message-State: AFqh2ko24GOYXAiO7btAsm6igrND2G5Tzl022TFZ8S4/hOvl9VbqrrSy
        u/btQ+WxGSRhLfw/BNlf6gnvRQIhBQEDsUVKnuA=
X-Google-Smtp-Source: AMrXdXttpumjxv5ALlOkeGtnNlARjvn2uyGYdwZxZmDumZ8DwG8f9N4xeVM/FHAbEkzmQG+tHWJDcA==
X-Received: by 2002:a05:6a00:1f0d:b0:56c:3696:ad68 with SMTP id be13-20020a056a001f0d00b0056c3696ad68mr32924906pfb.8.1672423470729;
        Fri, 30 Dec 2022 10:04:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a1-20020aa78e81000000b005811c4245c7sm9298854pfr.126.2022.12.30.10.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 10:04:30 -0800 (PST)
Message-ID: <63af282e.a70a0220.3b389.eb9c@mx.google.com>
Date:   Fri, 30 Dec 2022 10:04:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.85-732-g84004df288ffc
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 125 runs,
 1 regressions (v5.15.85-732-g84004df288ffc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 125 runs, 1 regressions (v5.15.85-732-g840=
04df288ffc)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.85-732-g84004df288ffc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.85-732-g84004df288ffc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84004df288ffc0239ed4fa69d10ce885ca8b858e =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63aef2b7d5308387824eee8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
5-732-g84004df288ffc/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-=
bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
5-732-g84004df288ffc/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-=
bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63aef2b7d5308387824ee=
e8e
        new failure (last pass: v5.15.85-728-g0cdae0ab80f60) =

 =20
