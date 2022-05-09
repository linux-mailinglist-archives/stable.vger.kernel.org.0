Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECB051F954
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbiEIKJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiEIKJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:09:35 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA1326606E
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:05:34 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id p12so11845189pfn.0
        for <stable@vger.kernel.org>; Mon, 09 May 2022 03:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QPkkQnFZpWBC+uI7nLQETuNmoURrty5+zCn1yJCG/Jg=;
        b=BU3X6LWlm5BMvnelFRQSeYD1Z3tjD74ku+cooW1efxqGVfWy1n1q4J6TeDY1lzor0l
         TCKAFrnauWJwgLxqIv/wD//92FrogT/UDRHV8Cl79FUDvL5AwxEHFaezygV6fNYQidi8
         JQZAzCUH+e4UVf4omW2BJsCimKMOSMuiam4urUQRtP16V2gbhrs7wxsaPzGfAeeKWT3H
         IjDmKzuO2VMvSgah3RJLmc7CsLGT/B1SvsLYCapJw3N9rYR0+vyQWH7dcwOV+OrkTquy
         3+dL/Y0PPP5VF08A9d+BeKIqwpcklwu6lBRHmhNHrNm3/xcuyiiXzKX/3U2dDYTnFeVi
         k1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QPkkQnFZpWBC+uI7nLQETuNmoURrty5+zCn1yJCG/Jg=;
        b=bmkdep/vSzLSLfqWLeM7P6DRqUDUXjVtaawhawyn0u9ViWytlTd+so/JJFk4up+iBE
         tMZSiE2Ytvu9rysvkszfs8Akf9481xZ3+H48s6wWoq/sWJ8a5AKfQ2CcWtauykUfzT6z
         uN+uyXxSLW+SXENGxCLarQWeFyZP5hT518D9uTqyKfsun8K/vGe9WnRTFu4usdlDPSkn
         fHqPshBmWGxFilsNLslFFhyMv8t/YQ5O2xRhTQi3z0rbCKd8HhquA4Xvass87BdWJshk
         liK/yjlnWlFgYpJDivjoTbJv9HuelQ4+W6PYWn1hpQmMjk5sthkihYeGpLpUgzkLMVXj
         J/Ow==
X-Gm-Message-State: AOAM530F3FzKyutXcTzN2/9uLwh9Y+pOmVKApMko3TLTLID4eFGO5oEx
        uRWgs/3OuAz32Rj8BNeq83N1FkQRLDGd6YLI
X-Google-Smtp-Source: ABdhPJwDtyFO9oln5Axigjr+oAxvTo0pVBrgxsC4LKBcEonVjeqV3GJAs7wy8DkoKsU+wp7TFIG36Q==
X-Received: by 2002:a17:902:ea11:b0:15e:ae19:f36a with SMTP id s17-20020a170902ea1100b0015eae19f36amr15520631plg.52.1652090439655;
        Mon, 09 May 2022 03:00:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m4-20020a170902768400b0015e8d4eb264sm6649713pll.174.2022.05.09.03.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 03:00:39 -0700 (PDT)
Message-ID: <6278e647.1c69fb81.118e3.f01d@mx.google.com>
Date:   Mon, 09 May 2022 03:00:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.37-177-geb4347bcfaa3
Subject: stable-rc/queue/5.15 baseline: 117 runs,
 1 regressions (v5.15.37-177-geb4347bcfaa3)
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

stable-rc/queue/5.15 baseline: 117 runs, 1 regressions (v5.15.37-177-geb434=
7bcfaa3)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.37-177-geb4347bcfaa3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.37-177-geb4347bcfaa3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb4347bcfaa364890efeed595c75a80c75e3c26c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62782068e03655fe518f571c

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
177-geb4347bcfaa3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
177-geb4347bcfaa3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62782068e03655fe518f573e
        failing since 62 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-05-08T19:56:12.526498  <8>[   32.396072] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-08T19:56:13.550206  /lava-6303318/1/../bin/lava-test-case   =

 =20
