Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0CF47D565
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 17:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhLVQuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 11:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbhLVQuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 11:50:40 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54709C061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 08:50:36 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id c2so2910550pfc.1
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 08:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LatJYF4DBU24431qGPgIZU9x7fSfH4UtVoIryRic11g=;
        b=FcvQ1V5bej3WGrhZlT6i/U7ZoAkSdgsiU8KMhZI6Q7XeIiqddUObEs89Q4ov2xifi1
         OXgcXXef/d5w0PBDhVKOWGqxWuVihLMCtmk7ZVaSu3jpNv+kTu7cEfE/Ft0eTNJ/3hk1
         +lMBNq8MJ5gH9gqkaO08g64aWrJXw4us7OYd7j7twqvBdQ6lw4+ITSjEsn+cptzBOw/A
         5FcOAXpaYQ2u8oP2zBPz/RVpsTRYtvDUMjAaDkVa0SxLpVFa5K3qcg1IPBtGbEuHQNqm
         JUX/11XmBJw5Mm1his1JsryvhEvxAbbxk0ExvZ90n4UMKXqTbmh8AHssZls9AuFUR65Q
         k24Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LatJYF4DBU24431qGPgIZU9x7fSfH4UtVoIryRic11g=;
        b=4eRIPNvx+3vfwaUaFwhXvKT33zJlSNxCZX9RMIBYkSZuY84ivuPD0BB3TChC0zl0oe
         srmyAZEo4lejpac2uDB3vBDRaPtI3u0WpcSAPzj0qG0COZ3OGUWWpxelAtZkKJ+dNuqd
         dxeKCoc2LRIlYMD4RHY8ZDNw2/Y3+k5q1jiRQ7NFfL4WjXzr79UPQ9n1ElAonGR5+yp0
         z0IV1K4hcgFHMU7ef9GElUq+Gn69lsJEbJw3ySXGyU25iCgXkkKu2FiFeOKbJLvXitO4
         RquQrZ8TdQxEGam/zRU1EbLGfA2krl0vntlfyNwUQiSZYNcqGh093N8Zc1QEwPb2PuV1
         940Q==
X-Gm-Message-State: AOAM532B4KmUq/r2KvxDheY9B1j3f4uFcKOg6LIGvaL4Z5qWN3qEKE2z
        FlOA/zZ052CXVeX4U+5ogmAgAI5rsc3DrMlx+CQ=
X-Google-Smtp-Source: ABdhPJylN5T22ueW/nZR6phfobsCGh9YNeyPJmj2lwy7SHL3j2F6+Lgr/Be2R+BnJfJ6uTg+BpZi1g==
X-Received: by 2002:a62:83c3:0:b0:4ba:bb14:4bf7 with SMTP id h186-20020a6283c3000000b004babb144bf7mr3708185pfe.32.1640191835579;
        Wed, 22 Dec 2021 08:50:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pc7sm2982302pjb.49.2021.12.22.08.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 08:50:35 -0800 (PST)
Message-ID: <61c3575b.1c69fb81.650be.7973@mx.google.com>
Date:   Wed, 22 Dec 2021 08:50:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.87-98-g493843b2b209
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 120 runs,
 1 regressions (v5.10.87-98-g493843b2b209)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 120 runs, 1 regressions (v5.10.87-98-g493843=
b2b209)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.87-98-g493843b2b209/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.87-98-g493843b2b209
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      493843b2b209adfc5bd4a69f2f2bc0684e5ac7fe =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c320e51f260d8752397143

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.87-=
98-g493843b2b209/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.87-=
98-g493843b2b209/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c320e51f260d8752397=
144
        failing since 2 days (last pass: v5.10.87-63-g1b969379182f, first f=
ail: v5.10.87-66-g2eb0aa8b2e00) =

 =20
