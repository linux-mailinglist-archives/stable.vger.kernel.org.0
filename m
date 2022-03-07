Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAE54D0BDF
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 00:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbiCGXSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 18:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343935AbiCGXR5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 18:17:57 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD553E0CC
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 15:17:02 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v1-20020a17090a088100b001bf25f97c6eso856056pjc.0
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 15:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8bVQddVoepZEWdjLGQsWVpVZrzvUilhFcNHKh/D67tM=;
        b=CmV1jueb1uXjsUY/ZSkE5YkTqyHWbSNu6ZfLbduyz+pdBJ9j0zbSN6xX5oWLF0fiFO
         L4+Sf3QTwq22Yrju9xHEQniw0DsVbauUjmDOLawdZzq/Qbwyztk+A6whhOVBSbEkTava
         sgVpgfrc9Dm+1yNeIByumyGwNOKXrX055avwqi3W896edLncGst9aSyR0KDML+ckmE9k
         SijxVsSB0Vembz3nAaM9z9tXOHV62ZqrUjSwOFyuR433sBfRcrRWoon9xUDo1DnDcgZ6
         i60zO+seEEu4nDj8bFC1rrB+q6luEHToiGymEVUILfoqeEb5em5F0GWFcQsr0P1gLqut
         nf9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8bVQddVoepZEWdjLGQsWVpVZrzvUilhFcNHKh/D67tM=;
        b=p0olawIsMqxUqGUE6mDudS1dlMlh0NUVQCnwUrSP3Ei9z7HfYXH/4C3V5HruCi5cm0
         eAuO4leXj7GLn6xBpan4VguWWW74e4MxEvRyGhN4pyy5vQFQqw+NoQSpo9Ib4hqYJAGw
         wF5Ca7WsAvOhq2kb4kC/lMWgPS2XrwYynYjLSJLuEe5fmsiCYY50deknicz+vQd+TWTX
         UCZASIn8fG36qdVcZrygGzzAMQlWqEdQsfvNUYcAwW88wgUp3ugdaXcXoe30YVU4TNfY
         V/2cSspTGd5GIHu3Rr7iWolFz04iQktrx2T0LkO4tG829ZOq561YbG1DAPV6WL481KSn
         p5Sg==
X-Gm-Message-State: AOAM530hVbpSz3fOH9QDnu7m+skpddrkATQogM/NpP7fGbObPHh1Rx3v
        WQHW6cXMTl6tbNCZdDESRbRqeK1ciFOSAG15vjY=
X-Google-Smtp-Source: ABdhPJzhjmNN1qH4sz/P9QrKxFEaTvZP1tlfayJpwaIu4ik6OXkfYWg93xDnOEMayZcRglYGjatq2w==
X-Received: by 2002:a17:902:b614:b0:151:f034:4058 with SMTP id b20-20020a170902b61400b00151f0344058mr5487926pls.84.1646695021928;
        Mon, 07 Mar 2022 15:17:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z23-20020a056a001d9700b004f6d2974269sm9629371pfw.113.2022.03.07.15.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 15:17:01 -0800 (PST)
Message-ID: <6226926d.1c69fb81.ebe78.83fa@mx.google.com>
Date:   Mon, 07 Mar 2022 15:17:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.12-184-g8f38ca5a2a07
Subject: stable-rc/queue/5.16 baseline: 132 runs,
 1 regressions (v5.16.12-184-g8f38ca5a2a07)
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

stable-rc/queue/5.16 baseline: 132 runs, 1 regressions (v5.16.12-184-g8f38c=
a5a2a07)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.12-184-g8f38ca5a2a07/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.12-184-g8f38ca5a2a07
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8f38ca5a2a07cfadf266f1f33b1ff978d077e279 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62265bff7e9243c2eac62968

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.12-=
184-g8f38ca5a2a07/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.12-=
184-g8f38ca5a2a07/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62265bff7e9243c2eac6298e
        new failure (last pass: v5.16.12-85-g060a81f57a12)

    2022-03-07T19:24:39.889820  /lava-5830387/1/../bin/lava-test-case
    2022-03-07T19:24:39.900864  <8>[   33.509466] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
