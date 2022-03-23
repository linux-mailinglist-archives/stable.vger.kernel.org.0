Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A7B4E5381
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 14:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbiCWNtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 09:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242760AbiCWNto (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 09:49:44 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C0C1EECC
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 06:48:15 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so1884216pjm.0
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 06:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c0micBBuZ4iQblI/CFQ7Efcp+6rZGo+BKzN3nFvAT7Y=;
        b=RtXcO4PuW8Fe2eavGuDkpMHyKQIQeozSDntuafwQx0kNTnee3fNa0ALivgftJP8wJX
         OBVTSEQhSw991cUN1rAuCcINa4gj+emqctlkTFfhPu6ziSgYHypabSxHWT9ZUuyW64YJ
         hmUXf0Wb9r9sH5k1IIxi0NfGSlSJ5vxC9nOlcVkfNebzbiThaoPYNP4WTuwK0UQYjrrS
         T3Xe7bdOJACkoi/6sThQvFMyQksEVzIoUWK9VzAvE5Q3HW3yAPrJlGdQBPlzkyo5VI50
         KWyER+wx6CFHNj5BDAA43cJ/58hTx2XFU9or+CUWghfaep7Fs7T5y2NHGXHD39ApjeaG
         YtEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c0micBBuZ4iQblI/CFQ7Efcp+6rZGo+BKzN3nFvAT7Y=;
        b=L1cC3TDaPTShwt2npuycC+7l2W6GBx7pyAvAw8mWuO74eow3An1O13qFxsDsId8DEr
         7zRhSZ8zCT6huLVoEoV4bqpWCEFJdsHSBBsIcXcp29i/CnzgoudxaYIbOjMus1DaQC/A
         3EmGpDXO7UlF9Y3h6R927jwbvfIjJSZbDmidCsjEIdHo3Iojno9/7ESrc4fCKIoEF8zB
         +8KRhQ0zpE2Hvi0VDb9E7fHxDWoVlVKHxsWenF91dSNdXLQBxQGYdKRO9LQp2oQYrlzs
         yT0lXekm9vWL+axygV1azxd/T94M5pzmSlV8SnuKCZqAP4quxaq0WfJqOsO/wTtM/Zce
         v4xw==
X-Gm-Message-State: AOAM530WAWTYW91hXqBLzLC0f4qJEcoJIBMXuVzlN4pcjsRzWv0I4Itp
        BkO3hPBHOWpLDFMghGhyNnM9IMyXfjOrxdbj1Ms=
X-Google-Smtp-Source: ABdhPJyv3FXCheys41XGNHSW7kmMF7C7TW/wha3hg85b8PBrJIlHjlXTX8SQGZDsJHtZxFLPi9Ybkg==
X-Received: by 2002:a17:902:dac4:b0:154:5d6d:ccd2 with SMTP id q4-20020a170902dac400b001545d6dccd2mr15537843plx.167.1648043294692;
        Wed, 23 Mar 2022 06:48:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 21-20020a630115000000b00382a0895661sm67pgb.11.2022.03.23.06.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 06:48:14 -0700 (PDT)
Message-ID: <623b251e.1c69fb81.4240f.0000@mx.google.com>
Date:   Wed, 23 Mar 2022 06:48:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.107-30-gfc9a659744f0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 84 runs,
 1 regressions (v5.10.107-30-gfc9a659744f0)
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

stable-rc/queue/5.10 baseline: 84 runs, 1 regressions (v5.10.107-30-gfc9a65=
9744f0)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.107-30-gfc9a659744f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.107-30-gfc9a659744f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fc9a659744f085f9926b5ed2267ab877487481ea =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623af93ada7c754d65bd918c

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.107=
-30-gfc9a659744f0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.107=
-30-gfc9a659744f0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623af93ada7c754d65bd91ae
        failing since 15 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-23T10:40:51.461315  <8>[   32.929271] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-23T10:40:52.491182  /lava-5931037/1/../bin/lava-test-case   =

 =20
