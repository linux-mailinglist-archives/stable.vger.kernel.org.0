Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F325ABC95
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 05:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiICDbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 23:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiICDbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 23:31:18 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B59B08A8
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 20:31:16 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id 9so394089plj.11
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 20:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=5jdnm1DdJc3RzpTrcZrpund1Y8ITdNhKRH7mliGU3V0=;
        b=TrJsR7C1Zpxg3sZnBLCqsd72cmAjNJC06IE0t2NudyyW7T7nPRdONJ8rT7XkRtr72R
         q9+F5OyOiPCdjvOFbYOmZMQakvBXpintbpQFeHWhmGHHmD4b0yZsXWXQs3d2F0GbMhrO
         f7rk4X1pzCKy7qZSsCFaP98EEcr4eHl1kWr2B5qE6XK0pon1PwYwOTZJjtYRTMV7d5Uy
         DTiKlPvUox5XfNOGQQiHcPiwApFcTPAYT/F+Py3w1ajQN8pHvoHwiLMZK+/1FwsxLE/n
         tpRNXbWH5Ya4ZeX1PYQBYC9WeoIAzoTaxuLskl9GSEqxwpmMOb5SkNUVcFd9ahxQFOTJ
         NTiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=5jdnm1DdJc3RzpTrcZrpund1Y8ITdNhKRH7mliGU3V0=;
        b=a7uwlLWKfY3fBL3HvqQw2AapGIGuPpUBHkfwTiLz0iOti813by64TCySYKxSEGb0Qa
         /44P1wlMKMWkjVoh+8buPSkmv9hpgWxnBw6Cc33B3pMTOgoJOhaP5gMVqm6aZnPPxFGd
         TVSTJK5woE+IqrITrd1HRZJnz4WoJuYIquh/Qh76H9WEanwRU3o8f3UfpH1peSp2SYAM
         7UNFl0VhCuQPX+O77xU3fwrtWd/ECj5NhS8Rdyl9yhl0EFa4/ExJT2jk/9v/ul3iDZHL
         y4Ohwd2V7vLVrakUS7PzIffwVk7crgE1pWJu06XqJ2KOlTj3FpIVcwu40Zi1COKUm8c+
         9yeA==
X-Gm-Message-State: ACgBeo3jRDzttH2oQlB7IvvHvRTNUF7KPP0SYQHX0AzHy4rT98bKST5a
        G9gOb4LevM93G3wOdlkxWvf1+hZGVUqDD95Q6rE=
X-Google-Smtp-Source: AA6agR5wXcYB9WlcJNqWfZW3WeLXlxRQFEQq69DHLj8GypfgNURZe6H52IoC7yk0ajjsELGD20e2Hg==
X-Received: by 2002:a17:90b:23d0:b0:1fd:af26:cee9 with SMTP id md16-20020a17090b23d000b001fdaf26cee9mr8314963pjb.23.1662175876012;
        Fri, 02 Sep 2022 20:31:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a12-20020a170902710c00b0016ee4b0bd60sm2408778pll.166.2022.09.02.20.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 20:31:15 -0700 (PDT)
Message-ID: <6312ca83.170a0220.c67ac.4789@mx.google.com>
Date:   Fri, 02 Sep 2022 20:31:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.4-234-gdd6b2254d7a72
Subject: stable-rc/linux-5.19.y baseline: 199 runs,
 1 regressions (v5.19.4-234-gdd6b2254d7a72)
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

stable-rc/linux-5.19.y baseline: 199 runs, 1 regressions (v5.19.4-234-gdd6b=
2254d7a72)

Regressions Summary
-------------------

platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.4-234-gdd6b2254d7a72/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.4-234-gdd6b2254d7a72
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dd6b2254d7a728898c6d445789248f8a57f7bd97 =



Test Regressions
---------------- =



platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/631293ab955066be6a35566b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.4=
-234-gdd6b2254d7a72/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu=
_mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.4=
-234-gdd6b2254d7a72/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu=
_mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631293ab955066be6a355=
66c
        new failure (last pass: v5.19.3-366-g32f80a5b58e2) =

 =20
