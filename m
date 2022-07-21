Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF9A57D749
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 01:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiGUXPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 19:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiGUXPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 19:15:02 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A222788CCD
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 16:15:01 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gn24so2917059pjb.3
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 16:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=db2NRa6MwjGDt/cr9TfVEm8Dc3v8oWzZ/gEQZrnWzvA=;
        b=E2RH+JXDmTZfpnrBVZYOwGoTxZl/lP2g3ujAUSlApiXlJKi4V+YqD9ijJyLOqRXieH
         4miZlumDS1el8Q1PJmP8EItZiaEh5ciAhUJKmMvtDNJo8VHVjM+++2dfONWfvksxh4Cz
         PCBQdcsS+B/bzbUj4VjHfomWeni/xSvgciaQM3kFpmCXj4fm8koiyjUUXKgh29eYGFm/
         RjFFrnyc8ExlGtvD2u6uTroqlrSUGHK5NSBGm1UKzhYRjdTV86GrbRsVkYmuTu38FtPA
         NipGS+AJOeZUQ8aHribvDLJ15y9iQ5cjGRGvr0QJC2e0CpuciX3fLtobzzn8JOnhl1sR
         4Q+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=db2NRa6MwjGDt/cr9TfVEm8Dc3v8oWzZ/gEQZrnWzvA=;
        b=r6frjKmPqo6+bZEEdTipzDCxxrKhfzTq2FZjJYRlbIdSeQdBdNZhaOyQFQqzjB5MJ4
         /6/nuAwUi7kJv4NXMAp9zjCtep1Y1fAYPbjfn0qDrEigBAov63OCjTR/ZYSVGBB9oAIx
         Muo1oBRsKmN81n/af/vCorG4Y5Nj9rF8it6E3o1IaBvFVq04IWG5RG7OTvutu4s6VD5I
         ZGT5io2kAP4ZTwjWgie2wbys2v4aY290zsh0uiRx8reOpIWpk6CsSOsKLW22fmfXY5iV
         KMuMMwAAXK6zi1vRRfCLq2+uCMTgkUM9bfvUsC3rDrpK7pwsCzlXEDhZeY1RxkSG8m89
         +kCw==
X-Gm-Message-State: AJIora9qy7HTRi7k4bZxxDlFxewwSpabiYrTlPSsSy1F8Nqljcmurj7+
        7OKfOohS+ZfJ+fw7PtcBskx1bxoLmvenUzWjBwA=
X-Google-Smtp-Source: AGRyM1vBLS9gX2feEK2avKEgxNEy5kyMJ9Yq3+C52W30Ae8ftfINs9B7bJcB0jZNsoehmmg0jBdCeA==
X-Received: by 2002:a17:902:ba8a:b0:16c:ca53:72a1 with SMTP id k10-20020a170902ba8a00b0016cca5372a1mr732811pls.159.1658445300728;
        Thu, 21 Jul 2022 16:15:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u3-20020a626003000000b005289eafbd08sm2408066pfb.18.2022.07.21.16.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 16:14:59 -0700 (PDT)
Message-ID: <62d9ddf3.1c69fb81.8b3e9.416e@mx.google.com>
Date:   Thu, 21 Jul 2022 16:14:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.12-225-g5f43a8d4f689
Subject: stable-rc/queue/5.18 baseline: 165 runs,
 1 regressions (v5.18.12-225-g5f43a8d4f689)
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

stable-rc/queue/5.18 baseline: 165 runs, 1 regressions (v5.18.12-225-g5f43a=
8d4f689)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.12-225-g5f43a8d4f689/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.12-225-g5f43a8d4f689
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f43a8d4f689f8d6d5cb8f1208be98caf196dc9a =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62d9afebe91d50674ddaf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.12-=
225-g5f43a8d4f689/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.12-=
225-g5f43a8d4f689/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d9afebe91d50674ddaf=
057
        failing since 15 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =20
