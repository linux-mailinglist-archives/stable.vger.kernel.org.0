Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE3B4E99A3
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 16:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243758AbiC1OdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 10:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243887AbiC1Ocm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 10:32:42 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA5844757
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 07:30:59 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o68-20020a17090a0a4a00b001c686a48263so55621pjo.1
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 07:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AhjFXyc9cVBuUaBRpBCf1cozvXKCt7+nntuSKtbG2is=;
        b=djK7ts8UBio69144aX4/ZtadGgv7KwyLxxBcbWlfePG1i2EIgX5BTDtrQdKpl0D2AJ
         Z7J2lBUq5mkAi2tIW/aIfJSHP3CGbxpCu5j2/qkVuSVikb4JFuhiHeVshd995qCOASbi
         f45Tl3j9q2uuSGBo5sTFf2SzxJnadS6SLzPiaDPWDUmOc0lzbFGTqT5/Mjp0BJQxZngB
         nUoqRrIhZweQABalp3li0RGLVvFBkYGunpGdzxNKpbbEDRwMQ1Y3FVNhKHb2OVy82ffJ
         RmJLQMjvkrZbIseZcuKPVTlJYVuDP6SUBWLCGrinKQWNtDswxyNSNnh/NU9wIUkjV2KO
         ZuYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AhjFXyc9cVBuUaBRpBCf1cozvXKCt7+nntuSKtbG2is=;
        b=1YzZKVu89byL+gNpxqXOnNQVdt1su2voXyu4RxZXBeZwjsk7UHQeX6VbcQKOXuvHex
         0mK4F87Q4H/cC+I+6iLKRqT6jnCWdFVbqma+Ssw5BNFuPtp3KVeypFNe+dDqT/qdNkQY
         /PitjFUVy0191FdPl/EJqoPKDLemsyJ4L1enyoE2n7w7wiADehKYXkm0C5tygvLv0h5/
         y2DaAKckpc2l1/YI5zXNctqB7xvxzI0ZR4xvxIpXxx4tnf2IwGR7ofE2385ATvwiw07x
         YCEyMj1YEAI6v+5EiVXhKjZ1Rbvbvdyl5y2isjJ9xqh/EfGkQSOpju3JSy4clRHD3/wc
         6OpA==
X-Gm-Message-State: AOAM532S8zRsaEWc+8T3cBbzvpnxhueCqZLAClrI8xT55HM2oWvZaPhb
        z0gwGpccVSnMLhynWcybuhGShcJoXpx1pxgZu7s=
X-Google-Smtp-Source: ABdhPJxKapvOmxST65RYLPX5UzVf5CX6oOtkmCX55djWS9eYXs0etR8lYMKQlYGsSFFYMeFr1HETsA==
X-Received: by 2002:a17:902:ec8c:b0:154:7cee:774e with SMTP id x12-20020a170902ec8c00b001547cee774emr26371905plg.61.1648477859181;
        Mon, 28 Mar 2022 07:30:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p11-20020a17090a4f0b00b001c6e4898a36sm21265825pjh.28.2022.03.28.07.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 07:30:58 -0700 (PDT)
Message-ID: <6241c6a2.1c69fb81.a01f5.8e4a@mx.google.com>
Date:   Mon, 28 Mar 2022 07:30:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.32
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 80 runs, 1 regressions (v5.15.32)
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

stable/linux-5.15.y baseline: 80 runs, 1 regressions (v5.15.32)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.32/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.32
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e29be6724adbc9c3126d2a9550ec21f927f22f6d =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6241992091d38cb3a3ae06c7

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.32/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.32/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6241992091d38cb3a3ae06e9
        failing since 19 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-03-28T11:16:27.620729  /lava-5959179/1/../bin/lava-test-case
    2022-03-28T11:16:27.631359  <8>[   33.815097] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
