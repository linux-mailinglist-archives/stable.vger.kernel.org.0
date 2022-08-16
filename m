Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF7159657B
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 00:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238004AbiHPW1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 18:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237995AbiHPW1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 18:27:47 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C033590C5D
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 15:27:45 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id x23so10460845pll.7
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 15:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=wkaUuh2p0Wwx1fd2TA1fTlVM6WqNlLaaP7PnpNIN5ik=;
        b=AjllRE14T9QVDPtYwDg8aXEcCg6sPZ+mTwe9ZA8W9iDOouqYDtjhwp2AY5uX3djdpo
         odM7n5upTAFh410PR2qj6V0xA3eyhE0iQPepj5CHC4hFlkq0vQrY59xEwU7uZ8BtpNxG
         5fMzy6fgW1n8xZqg+ujkMe+Vu6Pt0GWQwx0ZuNstjOLYzqHooGi2rBjRZnUnW7xPmM2l
         YSxSMf0EMKTJGt1J9iHc+WuoBCW8KDgx2KRrGo9kTzsV5i9lgYFpLsCiC9zL3EvPZXuv
         J594KDCSBEcCHZdPVqWvVZMlWl3S5K5l7I12NXpP84yD1y43GvXMhOnwztZBDXkSt0ur
         Ucyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=wkaUuh2p0Wwx1fd2TA1fTlVM6WqNlLaaP7PnpNIN5ik=;
        b=qtUra8AP08IODzSJRPL82fF+I6kQku5WtwTSADZHxOKRENUdlyj9sYc5bHr3N9mWhp
         hgQT91PN3LcwUd8EgLaszouvzp9tQYsWPlHtaz1ZSfbmAPsh98E6K9/L6zQhSOE2sGDY
         C2OSIaT33XOs/9pC4Es2Ta8pYWXLtEHfQGq8o8T4swf0kufbTpRJrgYunOcwHQqtUBoZ
         taTfW5WoBSxVp7U7rSPn61d5kd+hV98oh52kiVgw6ef9uzkxhkBdK2IVBhG1VDtPZXNm
         xBp9/sbi3g/oBQcee5L4p488aU12XVMAT5uv5tQ4B4qGR2nNZUEp3PwBeT1cVhzTnszg
         9Akg==
X-Gm-Message-State: ACgBeo0NONFkQcreLkdzJ+nF2OqRA9V2S8WUMcK74F1uN1Ctjv0TTQUy
        R9K8EuR+yUOV0PVXZyLbdU1dWYu8yDT5a7Sr
X-Google-Smtp-Source: AA6agR5Nd7ktUa1+4Wch2WQo+IjopT4oZN25Poei8b161CuYOhbyH/1aEmgTK4J5h55mi7H0S/xBtQ==
X-Received: by 2002:a17:90b:4d91:b0:1f5:2073:6cfd with SMTP id oj17-20020a17090b4d9100b001f520736cfdmr699487pjb.175.1660688865168;
        Tue, 16 Aug 2022 15:27:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o27-20020aa7979b000000b0052d481032a7sm8944205pfp.26.2022.08.16.15.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 15:27:44 -0700 (PDT)
Message-ID: <62fc19e0.a70a0220.ea9e1.f8fd@mx.google.com>
Date:   Tue, 16 Aug 2022 15:27:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.1-1159-g6c70b627ef512
Subject: stable-rc/queue/5.19 baseline: 150 runs,
 1 regressions (v5.19.1-1159-g6c70b627ef512)
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

stable-rc/queue/5.19 baseline: 150 runs, 1 regressions (v5.19.1-1159-g6c70b=
627ef512)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.1-1159-g6c70b627ef512/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.1-1159-g6c70b627ef512
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6c70b627ef512acb50f940e12bacfa08b2dd06ba =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62fbe5fa889bb00d77355682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
159-g6c70b627ef512/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
159-g6c70b627ef512/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbe5fa889bb00d77355=
683
        new failure (last pass: v5.19.1-1157-g615e53e38bef5) =

 =20
