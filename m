Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491FF4F4065
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347233AbiDEOf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 10:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391863AbiDENtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 09:49:13 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33B314926C
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 05:46:45 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n18so10805546plg.5
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 05:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DNmSzchIRYyHVJwJXwk+FekKQ2MgDujy0vcoK7WWxhw=;
        b=cfZn+W5N8ukBFSo472mQEvsNM8yNwxB8D8DHfq1q8yqFozzRYjLGrs8vbX3+vY9yr5
         C9RldvMQVkHQdqkSjvkAAs0JV6kqEEZio+hQK4ddFnrDg9HRDrNv8Xcln3CjeygY2eSA
         mU59ek1aVBZn1yy64z23IzJkFyEs4usRdofVZh91dDK3KE8zazvHiz/XWK13zhVPT86v
         OGdHONYKhLGtaru6ie1rEp7plSnCm1hLM23BYSw2LGS35zro2p1btFIiPASVdyEK665R
         tpmX1pdUdLSvtnKN07r5BjuLowHdQ2TEgRJMqGJQxKsN+B3iJ9uOTqDvKICN/gZHlhrA
         VTCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DNmSzchIRYyHVJwJXwk+FekKQ2MgDujy0vcoK7WWxhw=;
        b=FD0XUAOeMOt/HGHXHpWY3rdxsFadzO9nWM8qgAhyEQbFJzBF80S8apQWqHGT6QdSpL
         DFl6pp8Mx4NRNGjncZHA81fiOfkpUTBP48ergkwfM4j1IUVRgkxVnTTfeCkFJ1/dj/wA
         xUjiAYmdwFD8NtWGk7Z4tkEm3qAcHIMPvWFUeE2j1kiNeIe+emTJo0eW2TAfA84OhHYm
         AlvLjhPw21uWfRBtuGTkeLOu0vE3jcY7R/kW3hlhkMY8bW1S24xuXoxs3BA3CtY43TGp
         wj0mMfSBVFYXs98l5pVfdJ0/CCJRCiAcyzbCF6wK0jH7M+/QFY51oKtwgpuIqN3yQJ8a
         HDGw==
X-Gm-Message-State: AOAM5310y2315TxSsegu5aKrZ+3dQXmu6FWdtv7F9B4VrT1nWXkQpU1s
        87VGqIWThIQWHJBP5HaIKC7vbWeH69n+VfW56ZM=
X-Google-Smtp-Source: ABdhPJxqwNE8TsnckvnlaSb09VTICfOtVAMWHX6eyjYq+nJdYLmr+n5ZqX7yTVuoXvqvo+PQOXZbEA==
X-Received: by 2002:a17:903:11cc:b0:151:71e4:dadc with SMTP id q12-20020a17090311cc00b0015171e4dadcmr3327009plh.78.1649162805285;
        Tue, 05 Apr 2022 05:46:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u18-20020a056a00125200b004fb112ee9b7sm14350880pfi.75.2022.04.05.05.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 05:46:44 -0700 (PDT)
Message-ID: <624c3a34.1c69fb81.12bee.5c8b@mx.google.com>
Date:   Tue, 05 Apr 2022 05:46:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.109-599-gb05af0e7e6aea
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 53 runs,
 1 regressions (v5.10.109-599-gb05af0e7e6aea)
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

stable-rc/queue/5.10 baseline: 53 runs, 1 regressions (v5.10.109-599-gb05af=
0e7e6aea)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.109-599-gb05af0e7e6aea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.109-599-gb05af0e7e6aea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b05af0e7e6aead49892fa691d747e44fcd481e0f =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624c10ddfd83a3a754ae069e

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-599-gb05af0e7e6aea/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-599-gb05af0e7e6aea/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624c10ddfd83a3a754ae06c0
        failing since 28 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-05T09:50:00.160487  /lava-6025191/1/../bin/lava-test-case
    2022-04-05T09:50:00.170620  <8>[   31.836786] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
