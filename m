Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C587374991
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 22:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbhEEUnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 16:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233990AbhEEUnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 16:43:13 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57375C061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 13:42:16 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id md17so1503044pjb.0
        for <stable@vger.kernel.org>; Wed, 05 May 2021 13:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4zMtnS7nOT8yzq4Wv0i5rc3oukMnBq4R9NKbBxl8zKc=;
        b=iRvja1Wvx122g7IiOmbjYkaAVPSSL8i4has7hgklQZTxTxooUNjy6mDooMs8pdBkPr
         HdvzWx2VlIRxCLM/ENhh+npZN6LmXCnL/Jx8kOyHqqtPwLFzHDrZC7Y/So8Hod7+gU2V
         OwDmXheQLE4dGLpU03XejwSNysDHjs/FIRN6JUGPp1sHSToMuD66td4sVlPJ7niMfw1F
         GA7Va+ttd7bimYF5LzNZSBisKBpI9FptPMYnSf7WcarJLKYCIBvFicKOnd8TiXYrhwh5
         sOQ1oM/rL1zavGfuEd7y/CRDLD/5e1WZDloqBTqmDRXv0PWkReBPZLJzw0ZUkbEGjHTy
         f6CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4zMtnS7nOT8yzq4Wv0i5rc3oukMnBq4R9NKbBxl8zKc=;
        b=GebHKUaTZK8FFLR+Sei3o5lMjUR8F8zXP40lN099O/6XIlq7y3PXEu+8+1mqc43Xds
         7bLMK7du8lFiPjPW4XOxvLNKqAjpOmKLihzJe5t9IJb6JFVSdB9GDYrjX2X7Kv022AIL
         pcatxRoDLXN/kskcLYCxgP79tuBsLGr3nUsbpA6COrsggr6fbESW+TtX28kkH9QjD0SM
         0trch1cn+xQzHIilyFs7o2BmRwmTPtO5ahdXNYJXmbrSDj6Y28gr01HmTtGIC+oz1X/H
         4SzNdspxN98PbrkSrV6LZcayR8xlmR4KKBiwJWJOZ+Pca0S3J5Uxe+XKkqXjv86bMRZh
         l9gA==
X-Gm-Message-State: AOAM5307lkh05PEgeXnkGUgwJ/rTEpHJHofQOmscndRwe2H7Vpu6466M
        obbjKyd3qrCCbN97RRjfa0jhbDoLwyO3KWI1
X-Google-Smtp-Source: ABdhPJxSZSyVFDCOGHoapEmwMPbLubBpIWJN6SDzqLwe/g7NgLadzW+E57/ZYaDP6KgAOa8mfkf0Pw==
X-Received: by 2002:a17:902:da85:b029:ee:c73b:8f97 with SMTP id j5-20020a170902da85b02900eec73b8f97mr766802plx.6.1620247335616;
        Wed, 05 May 2021 13:42:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mn22sm7764337pjb.24.2021.05.05.13.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 13:42:15 -0700 (PDT)
Message-ID: <60930327.1c69fb81.fedf2.1e45@mx.google.com>
Date:   Wed, 05 May 2021 13:42:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.18-31-g24116d24be96
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 85 runs,
 1 regressions (v5.11.18-31-g24116d24be96)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 85 runs, 1 regressions (v5.11.18-31-g24116d2=
4be96)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.18-31-g24116d24be96/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.18-31-g24116d24be96
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      24116d24be96bd46d04a478f13440421bca14753 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6092d139b1424e59696f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.18-=
31-g24116d24be96/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.18-=
31-g24116d24be96/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092d139b1424e59696f5=
468
        failing since 0 day (last pass: v5.11.18-7-g1b15e1a9a6fd, first fai=
l: v5.11.18-12-gb0e2a2f653128) =

 =20
