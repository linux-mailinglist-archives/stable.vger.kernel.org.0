Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7A84FC78C
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 00:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240779AbiDKWWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 18:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240754AbiDKWWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 18:22:08 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6195B6445
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 15:19:53 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id e8-20020a17090a118800b001cb13402ea2so778534pja.0
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 15:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HJ/8w4BUtIBhuua0sQcIOv224UlRGrlAU3XKLtJbTJM=;
        b=2QQZEdqvk75CzMhx0vwy4X2T7MZK/Yy74lvYRGYHsZkapBUg/9tLQ1C6Q1KrVPT0qn
         J91F7kMyBBvvVSo0S/JxWq51IiQ54XGkBjxddVZkEHgTmJUeN/tAy0WsllUQemnQy+5B
         EDH3Oz4UIYB4YBugZxn2GWCtJCgjsl74Sfacni+vyZm4qQ8XBDgRXukEIdo9+aWFC/2R
         XRAVZ6evJ1hlQg7kD/Dwl3770Yr/GPigbQEfDe6Noz0PPkssqt/QfUMEXGh2AEWj9g0A
         2Qnc5NDH302O9JiY9ld9ypNGnhj/otLbeB9ziNIGHg3KpK97H8Awc8H1xOZtGAwhyqq2
         avhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HJ/8w4BUtIBhuua0sQcIOv224UlRGrlAU3XKLtJbTJM=;
        b=kFlNkfjR4CrxL6aGOk0Kj8X+SvYFEXdb4X1BykpEqoqdQczUihHoMOypPtHxWzk8+k
         0XdKAtO7OUquNKrGwNV4yhvpkYZCMdsa/GDWWXbJQQvJx0koMVTWL1nmPwKZ64Vj65wG
         HhMHF6/PpKQTZhHrY2ZYnuFH9tpodUcOZ23Wy2qwq+DXB0sC5CHkDNQIfL3MAyUC+6Zf
         Op2Fg9HFO2Xjarw2w/0lJj4wexilQV+10WAM0e65jPiiPazieZiGzTHwWOzJPf8SLsjS
         2/YbCf6BDSiW4Z01oOGyIygXZ2nh673ms6FEurkLdaj4usT/iUtOOqNrZLK8szBTvRwP
         gRow==
X-Gm-Message-State: AOAM532nMkqUzyQiVAUCrCCJXEbZxXmM8GazZ6alhRPg6tZNfkSwXV/R
        CtBak7gw1CrJHyZne/3j0n2xvnMlc752PNnz
X-Google-Smtp-Source: ABdhPJwof4k+AeCgclIbUyQ3xmdzHl2ZcWE4XAODC/dXX/fGg9NVTpfP4guRoVnxdzbPt7fk2mdomg==
X-Received: by 2002:a17:902:bf09:b0:153:99a6:55b8 with SMTP id bi9-20020a170902bf0900b0015399a655b8mr33743015plb.142.1649715592727;
        Mon, 11 Apr 2022 15:19:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c17-20020a62e811000000b005058e80c604sm11515557pfi.53.2022.04.11.15.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 15:19:52 -0700 (PDT)
Message-ID: <6254a988.1c69fb81.17f18.c4d4@mx.google.com>
Date:   Mon, 11 Apr 2022 15:19:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.33-276-g676d46d4ca96
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 105 runs,
 1 regressions (v5.15.33-276-g676d46d4ca96)
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

stable-rc/queue/5.15 baseline: 105 runs, 1 regressions (v5.15.33-276-g676d4=
6d4ca96)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.33-276-g676d46d4ca96/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.33-276-g676d46d4ca96
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      676d46d4ca9656fb2993fe0f4929904633b691a8 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625473c63de0225259ae068b

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
276-g676d46d4ca96/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
276-g676d46d4ca96/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625473c73de0225259ae06ad
        failing since 34 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-11T18:30:11.175690  /lava-6064802/1/../bin/lava-test-case   =

 =20
