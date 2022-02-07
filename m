Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E4B4AB65C
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 09:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiBGIMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 03:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244314AbiBGIG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 03:06:56 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB53C043184
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 00:06:55 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id i186so11690898pfe.0
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 00:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yx2TQW8a7zDhsVP3ktZ7JGGI28sjf3OF2I3mpdUTigw=;
        b=RSwKbwuLq7SUT3/dUzgF1HhPkgaJ61aHUPki3JWG5zxx0Qoh3OSR1CFrppb8o5Trn3
         n/QQu8wLfBGHC2ecVfK2PaZON0cksMKDWMkXtNJ9SEshqPrUYg0fBNGZRgy57iSN7FhT
         66J/cz49svXHKzUHTeWqgc5qh+NqyQL4Do7o796tcL08K4JMijxMZ6y/CR2V8j1iC9Yw
         aXiwliWe2A4czVL+l675WD/GzhPS8zXk51BPEgr4IxuM6kUvFcL506taJV9zk7fdbhMr
         3pvMTH2sCEpiCKPX931WHGhlb1KWhKGGMEzoTtx4fho7E82uH+dJcI3Ro2qctXRQgnZl
         KgnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yx2TQW8a7zDhsVP3ktZ7JGGI28sjf3OF2I3mpdUTigw=;
        b=EAmZIIMhIZfTArlxX3ygaTdMZkabWPfr/nzTSIKsXFazJoLJnJ+2MnZIANni4sbuq5
         TFdL4dCgjxnkfRcFB1Aa+dswHloHkaAKjp8kXScwFsjPOUPLF1BuCd4310sfpg793l+S
         GrzqSTRPO2evKbOWgxdb0nytBzGWpCFZBuUt8odfhJqUglis+/wuSq+01hpfFO6h2BsO
         43g0FznJPzYjdlGXPV4RJP0LpFMORBoHovPcmKWMjtdmh5Nz0D+fE4RefRC1bIrjdsyW
         yMBU29EzA+4YDu3I7UjF38hZrKfpCSzkllVDZHiyfg0pnNaQJizqOi3RRSJL/Hulis2C
         bZ8w==
X-Gm-Message-State: AOAM533QMb7PbI1DXfqlN9tgov6k0VSPEKNTb7CfH40oqSTHcMnLdOXe
        zNAEdYsbYzYIkLEbYA+ELKBWMJbMmTKm2Zne
X-Google-Smtp-Source: ABdhPJyivwHtv0kwXyPRBO0z6WQ7Lv/nQGOiTTYtqNbGApOUk2Fm7Vx2U9dQHAFdpUWARJjCggFyAw==
X-Received: by 2002:a63:7e1b:: with SMTP id z27mr8392409pgc.345.1644221215036;
        Mon, 07 Feb 2022 00:06:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a4sm9667920pjs.24.2022.02.07.00.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 00:06:54 -0800 (PST)
Message-ID: <6200d31e.1c69fb81.2976e.8f2b@mx.google.com>
Date:   Mon, 07 Feb 2022 00:06:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.98-62-g9bd5c420eb78
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 158 runs,
 1 regressions (v5.10.98-62-g9bd5c420eb78)
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

stable-rc/queue/5.10 baseline: 158 runs, 1 regressions (v5.10.98-62-g9bd5c4=
20eb78)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.98-62-g9bd5c420eb78/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.98-62-g9bd5c420eb78
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9bd5c420eb783215791a2964fc90490abd36aa14 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/62009f45eea31ce57d5d6ef8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
62-g9bd5c420eb78/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
62-g9bd5c420eb78/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62009f45eea31ce57d5d6=
ef9
        new failure (last pass: v5.10.98-61-gaad123f55679) =

 =20
