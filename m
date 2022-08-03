Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49F5589103
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 19:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbiHCRK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 13:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiHCRK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 13:10:57 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018931ADB3
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 10:10:57 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id h28so10682869pfq.11
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 10:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AOgdbeTgszJJpLRKKjeMgo6S2nlPlKUVskAF28cbTBs=;
        b=l/8p/K0cIa8fhrOCs+XtpP+28S/O4akYs5Amh4QWL+mzoYkSNE3+1NPw9vmXzy6yLw
         YePngsmdBVNYR5/telKou4IaPRWWvrcQrHEX7DreWvWnF7dit/ZUwclPhEYmFUzhaXvd
         PKm807v383NKOXzCwtdCoifsFj32qEZhaQCkUsiOOhju61enHtqbqG1twFVqXdGlC+B1
         rMfj/rvzxj35QDrqVoCrHQz8NyAMn0WhikznwApiJU3y57sgDX4Gni/DUmm/4RSR5QWq
         7PMUixHTpTCBTdN4k9hHAwWW/VdUKuln2khGdQ8JU4Mfh/0AuJmmeT/LhXn6Shn669wL
         tTOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AOgdbeTgszJJpLRKKjeMgo6S2nlPlKUVskAF28cbTBs=;
        b=wrj4jvt6YQMLVKckwkl+d5kKcDsagojN7TC51vodHB9AmG9ZsSPWEHB8MKPNM5lMnu
         zc6KoFKrqwrynKl5NtKVkx0JZql71+w/BElHYbGLHijU6fTXho18x4bc473hgWwjaNcJ
         br8rJb0+Iq5btbx4trjt/9lhSNZVbvOnUO8Lah8iVb6q7bgmKGc+jRbVBKKrMUTQCK1p
         3pW8x2WhsQstaih3MzxM7lIuTE9ExLbibwG7c63+/2a4tBhlEvEXOeQEO20ZQNwCjm00
         pBsekExvt2Co61MAq2JFuKnIFnpat9ciHEZ1rLSLqmlmLiSSgoo+H2FDx4ur7OZmfi/l
         PCZg==
X-Gm-Message-State: AJIora/EfqlblOuEKttqxQn0Raq//HqVBJiQonI2ZyjX7H9wGZuTZBV3
        2WcRRwMrziQk9zkONhSJq19KvRtBkH1HRV/ZQik=
X-Google-Smtp-Source: AGRyM1vJTUobGjCgse491mraTy208M0e0Soeho2HVinpNCnYuZX2UrxDpuXEUkwsdRCccqf4ALszGw==
X-Received: by 2002:a05:6a00:c91:b0:52a:cad7:d755 with SMTP id a17-20020a056a000c9100b0052acad7d755mr26879232pfv.66.1659546656392;
        Wed, 03 Aug 2022 10:10:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h17-20020a170902f55100b0015e8d4eb26esm2245601plf.184.2022.08.03.10.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 10:10:56 -0700 (PDT)
Message-ID: <62eaac20.170a0220.407f3.3c97@mx.google.com>
Date:   Wed, 03 Aug 2022 10:10:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.59
Subject: stable/linux-5.15.y baseline: 144 runs, 1 regressions (v5.15.59)
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

stable/linux-5.15.y baseline: 144 runs, 1 regressions (v5.15.59)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.59/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.59
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d676d6149a2f4b4d66b8ea0a1dfef30a54cf5750 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea7646432c49e16cdaf05c

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.59/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.59/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62ea7646432c49e16cdaf080
        failing since 147 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-08-03T13:20:47.682866  /lava-6960562/1/../bin/lava-test-case   =

 =20
