Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F47C57E88D
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 22:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiGVUn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 16:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiGVUn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 16:43:56 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6659AF704
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 13:43:55 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e132so5307841pgc.5
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 13:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t0d2Z/2KumuREZ7XvOXbpGXIRjDckiPY1TvySlEChvQ=;
        b=jikKopYsVRpc1wYAe32rWHDBE6QegaAGAAs4hdHRqUT88DqW+kstvdQ/P/DZdpkOrb
         wGmpD3vcfmR+o4jZEK8TLBx/tFO5B7T74Uigwfb2CI9Ie8jPs0bA5Z8iXIJ4NfK6TeJW
         7IIdk+1KFI0/X9wgC9COA5ZMZGtftHk6bV07rB/e0VbLHoQjLaOzU6xHnKPzUjVyAG/0
         d9rpzyqLLoBHVY+XDI3/86dvnU8iVaq0Vwwg40lrOEbfGJAbEXx65MrhwXOKXLSv2V+Y
         qQQKJi73VrWLiJ22hhbt5ZnZtiIziWVEVwsgI9rR2xsKmTuupGaEV8I9V2dt5OnwpLTJ
         AeLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t0d2Z/2KumuREZ7XvOXbpGXIRjDckiPY1TvySlEChvQ=;
        b=DNqgPVLvyadjDNdkTW2wPVy68qj8NYWvAhizD+jGTPimONzaVV1xuHgrtdZaYH6JwF
         tLdOXdmwv8un1nnY1Vep3knbWpobzAhtT+UOiIsGciGdRhMG6zDKWkRbzIEXxgCVFdiG
         PqtAUfr8LjbFMshIMsMo8kw8V2VnqXfVNE9lhJe0gYMTMDq3CSKxyXl308iiDn5a2KdA
         2VnmPkjLIsfctrNUMfCav4oicVeRQgfr/WBrRqOxfOMEfew1DvN8OIcTaXHezzISGJMm
         SwIe4b75dlrXgwvtX+LgKPsz3T1jPctnTLPNfl702d2U2TXu9K2LHHUvN49KKr08/M7p
         wsBA==
X-Gm-Message-State: AJIora8jNJMi6IFsnhuLLDyvmqxeGB5AzEvD+SnbGlgFRaoe5YbHDtnL
        Ok3Cuko3jYAwoEq/EEzS0c2jMXTk/YQLeS8l
X-Google-Smtp-Source: AGRyM1ukumIJEbmhsJIFLZ+mxuVoxrOCzu8DtjBYHYQFvp9pVNnI2Jc5M/nQxGku2pWeRJN6YncEqQ==
X-Received: by 2002:a63:e5c:0:b0:416:8db:4f5f with SMTP id 28-20020a630e5c000000b0041608db4f5fmr1296326pgo.620.1658522635066;
        Fri, 22 Jul 2022 13:43:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 22-20020a631456000000b0040cb1f55391sm3862696pgu.2.2022.07.22.13.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 13:43:54 -0700 (PDT)
Message-ID: <62db0c0a.1c69fb81.f9e1d.6091@mx.google.com>
Date:   Fri, 22 Jul 2022 13:43:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.324
Subject: stable/linux-4.9.y baseline: 30 runs, 1 regressions (v4.9.324)
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

stable/linux-4.9.y baseline: 30 runs, 1 regressions (v4.9.324)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.324/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.324
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      65be5f5665a580424a7b1102f1a04c4259c559b5 =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62d9b1bb825212e13fdaf065

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.324/ar=
m/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.324/ar=
m/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d9b1bb825212e13fdaf=
066
        failing since 9 days (last pass: v4.9.319, first fail: v4.9.323) =

 =20
