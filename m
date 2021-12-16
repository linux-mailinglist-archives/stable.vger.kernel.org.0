Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2D5477E9E
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 22:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbhLPVSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 16:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234877AbhLPVSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 16:18:20 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB54C061574
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 13:18:20 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id g19so428312pfb.8
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 13:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PqOBYlVcnmEMpSjux8ayIQH+0OeuwH9G6w7HEnEWyvU=;
        b=Y/R7JWqcj0qNqFJnhetLKNy/f8epg0T6MPBBTf/Bw+KDi0H5XvdwqtDVVSh1zShBOY
         C05LnBh725zr72+6kSx2fEg9F7IujVw13O4HvtnXvUX3wt/VcEJdMP2x9H0fjzo2ySrM
         LS+0xH6NjxRyhX9VZEl0CD0Awh+3kt7GJuTW3qJaLOzjQieAKgaP4nWG555z8FLbhg2+
         gQKE1XQRLj4XJ/fZj7G/V2ms0Wn6lpUu8zByqoRPHZWKeRKNLHSm2RG1CUHKQPEOKB3G
         IQs1O6moFHogcqNBX0OcstggxzDF6bGyjXbGSKszJeUpoIZLFgITaBAQVa9iZ5TA2UG0
         sQxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PqOBYlVcnmEMpSjux8ayIQH+0OeuwH9G6w7HEnEWyvU=;
        b=O7m3vEXtlWpeQ5jNpPyFPt8SqK/Rxrl39OOwOjztxiiww0mG5KGGMIDBXvhFAUDHLm
         GE2hJZRWFpDxRffiZb7I6sBE+Xs2Vh72eTr29/SP1TNb+464yrDTfuzcBRXCqc0GYZ0t
         KC4EXIlI4LwtJn6RRcRmJW4FfXvYOHGsPxQAKJEuJ9qQRA8Vu0abBKCJs+FR4VCdcFr3
         IQeOBuEL/r55HOVBMzMp8vP9GxZB+KisMW8VHKXgM9AxmJqSw2pcK4323dzJeBWPFawH
         exa9rC6HdP6zJRU6D2o25+ZEACZOTllA7BwBcVeR270CVvqKs1E273ZqEqwxtu3+OiiG
         OFSA==
X-Gm-Message-State: AOAM532AX6w+7jm2c6lEBqbAOS8VgQtbRVBfEVQkvlRDFAOmOscBgFCE
        rvJ7wKBa3fQ4HXpmeBYvO4H5mbuozo+49eJu
X-Google-Smtp-Source: ABdhPJyFma6HloN42Sbf7R8SE/QywWp8KVbhEPJXlg7AEWXOgUgwUm1p9nVbTH0rlQqO11VuQAhmjQ==
X-Received: by 2002:a05:6a00:188c:b0:4ac:feac:3afd with SMTP id x12-20020a056a00188c00b004acfeac3afdmr15528342pfh.22.1639689500250;
        Thu, 16 Dec 2021 13:18:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gk13sm9565035pjb.43.2021.12.16.13.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 13:18:19 -0800 (PST)
Message-ID: <61bbad1b.1c69fb81.72cf5.abe5@mx.google.com>
Date:   Thu, 16 Dec 2021 13:18:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.9
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 185 runs, 1 regressions (v5.15.9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 185 runs, 1 regressions (v5.15.9)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.9/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      14655b6d42046a537950bfb0dee371742a3dd1fc =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61bb73650194f4bb5a397175

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.9/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minnowbo=
ard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.9/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minnowbo=
ard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bb73650194f4bb5a397=
176
        new failure (last pass: v5.15.8) =

 =20
