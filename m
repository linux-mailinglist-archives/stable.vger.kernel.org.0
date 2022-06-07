Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BCC53F594
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 07:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiFGFiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 01:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiFGFiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 01:38:22 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7368B3DA48
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 22:38:21 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id e66so14822390pgc.8
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 22:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=slT/Z0tHIjveCAQGTg7NJ4eGm6YiwXVoGFYlCwWGpBE=;
        b=MzUULqIHNOehih95xHdCoRSTrCv1A6xCMZgI55AEjdwq953MGvM402Lq7eSzE2JHjt
         QqAwvEBmjgoFRsK/Nnzuia3OX8VvA3C6mdaj5CvAl0oV2jEHDlfwJHrj7AgE0qoZck06
         ICYg1q/M0f9OamlDhh4PtYvN2dcsVvWdnX0vcbFUUrBOwo0o+nSmKCzNgQs/2uVmunnW
         aAJmIpzRdGqB2EQ9wVFIDX7otiKsFu+SeM69pCG/tLQ3qYfOg08fnpDe6CkFFnFnIdrn
         FuG7RtF7c9K8XFJtHdsnEGTSMrEuejyHWYSNSjUKe2mz+ypLDTPi/st0NbR4LEKIdfAG
         8EMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=slT/Z0tHIjveCAQGTg7NJ4eGm6YiwXVoGFYlCwWGpBE=;
        b=wK+4HVV//UzyTD9Q7voNu7XZwpkfhxWUBs/YEZX7GnA1CWiQSMV1pGDCDi7uB7ZXhS
         Nr802ZAyou1eSTnVUuNKsEyilLUU9WpTj6vYK6nX8LB2KiasWJB9LsKsA01p5XpONhnG
         JQUmijIraFBxXRAitxA9Ac8YYmSmVo4Pz+frZuh2ZUZWVdxFBFsdiCtB+1GIkkETaGcU
         HlFEhG120uLvV3K0KymnlL+4t5Vd/8HvnOkZUfFxYx4pLbsrOso4DdOiKdM35m2OnzfI
         lLXk/TqW4xU7AOWJeQYpFkq7sTibS0GtVuXyVhqK6cX2xFafo/W4RyS1T3ZEROudldNK
         gAVg==
X-Gm-Message-State: AOAM5309pXSEbQDHnDnNISAJzVgHP3YL9TvdZUoLsDvbZwOsb5nrsXq7
        Y5tRgmkkepMy56PQKEQOVxOuS8xqmP26KoDx
X-Google-Smtp-Source: ABdhPJzXLbcaHTPgCNXPaqYZCBIr95ixZNx8DPEmsk8Wdwd8Wflo2+c2EW69IzsRAyY5symV6j4u8w==
X-Received: by 2002:a05:6a00:2403:b0:4fd:e84a:4563 with SMTP id z3-20020a056a00240300b004fde84a4563mr28146974pfh.60.1654580300791;
        Mon, 06 Jun 2022 22:38:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d4-20020a621d04000000b0051b930b7bbesm11599621pfd.135.2022.06.06.22.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 22:38:20 -0700 (PDT)
Message-ID: <629ee44c.1c69fb81.fbdbf.a78f@mx.google.com>
Date:   Mon, 06 Jun 2022 22:38:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.120-446-gd5985cbae71ca
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 43 runs,
 1 regressions (v5.10.120-446-gd5985cbae71ca)
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

stable-rc/queue/5.10 baseline: 43 runs, 1 regressions (v5.10.120-446-gd5985=
cbae71ca)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.120-446-gd5985cbae71ca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.120-446-gd5985cbae71ca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d5985cbae71cabdd47d59b9c2ecccdccf16e4bf0 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629eac96989a240ad1a39bef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.120=
-446-gd5985cbae71ca/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.120=
-446-gd5985cbae71ca/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629eac96989a240ad1a39=
bf0
        new failure (last pass: v5.10.118-219-gf43a638e7950) =

 =20
