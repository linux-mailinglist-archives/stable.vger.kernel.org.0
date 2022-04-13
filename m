Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D364FF8A2
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 16:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiDMOKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 10:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiDMOKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 10:10:03 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEBC61A13
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:07:42 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id b15so2106912pfm.5
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zTfYOjN3ebsvJCS1RlmL1kWW7WB2x/O5QVN4nL8KwoA=;
        b=LQcy7Djf3rq95ygVoC04JIjS5mzuq+lG6dXv0CCik52KAD+/ZqeRa6KqnZvU7bcAzF
         paUqPqIz7CV0HFugvAPK+itdW1xXf0tCdK+2iQKRIfzlxbMhc747AfML5jtivUwPUa3q
         DKF9TRYU5b/M8eAxR+xQ7bBPp11WR4zneTzoaP2ilCDxUx1aC4BZloUFcQd+urTfj/mC
         7PLYVXApaSu19U4Uu5X23h9ty7fQ6Nxy9T463ZRSgq84nq33Tm5Pccp6z/iN3RwLu6Jp
         TqDICT2boRuKpI97GSwPN3ajbs87boNrzVVIl4bHCNV8k+l8bIldbhy9bqrbQ4V+U6Do
         PnHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zTfYOjN3ebsvJCS1RlmL1kWW7WB2x/O5QVN4nL8KwoA=;
        b=Osx3UKFoA8a+htnJP78L50ROfwX7Mw+IU+OnCBG6N5KCWjTcEzrAO5w8MA1TiluFug
         yjHXQzyvwo5SfG80Io7sHNG0Ne3CAtfWXc6mWq5B16d26KyIPrRhN4/d9U9/8UHD4aeN
         SZHeBGjLfzEd4s6r27Yyry8GYZBjke4AfWBjedHw/WSCSKPuRZ2yEFmEtIGhkpQwp7SV
         FLHe29aAOnbEio71tucqHKCh89xQ+1fj2fCS0XoKhWfCaMdbCKLvxNkCOW8KdvfMP6bN
         GucVyiNoAWVSBA2GqZft7k27n/IhltVZcrEQpTznlCV4hKTrcDK7Ge1Kn1VJ3Tb2E9L8
         U2/w==
X-Gm-Message-State: AOAM530vq7RgRZ+PVfCi23H/3Ufg1QcQR7eIEVh/gDiWI6MCZUrfReQw
        0MRcr7mapL/duxDvpRtrwQ6imDcZBLGY8OyZ
X-Google-Smtp-Source: ABdhPJyTj2MuSySvcUuTx5X9g4ubOkzE6KW9fCnex9NOSUUV9nv3mf45Q7zrALC8bwZsSozbbq+Gzw==
X-Received: by 2002:a63:9203:0:b0:386:3b37:76b5 with SMTP id o3-20020a639203000000b003863b3776b5mr35965808pgd.234.1649858862207;
        Wed, 13 Apr 2022 07:07:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 124-20020a621682000000b005061d974f5fsm2917707pfw.19.2022.04.13.07.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 07:07:41 -0700 (PDT)
Message-ID: <6256d92d.1c69fb81.1fa91.6a97@mx.google.com>
Date:   Wed, 13 Apr 2022 07:07:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.110-170-g2f10423b4f33
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 85 runs,
 1 regressions (v5.10.110-170-g2f10423b4f33)
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

stable-rc/queue/5.10 baseline: 85 runs, 1 regressions (v5.10.110-170-g2f104=
23b4f33)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.110-170-g2f10423b4f33/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.110-170-g2f10423b4f33
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2f10423b4f33b712f9dfde04dfde6d12aa21fa31 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6256a75f4fc614a705ae06d2

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.110=
-170-g2f10423b4f33/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.110=
-170-g2f10423b4f33/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6256a75f4fc614a705ae06f4
        failing since 36 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-13T10:34:53.784243  <8>[   33.091412] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-13T10:34:54.805989  /lava-6075443/1/../bin/lava-test-case   =

 =20
