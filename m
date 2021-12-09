Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0355046F6A5
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 23:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbhLIWUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 17:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbhLIWUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 17:20:12 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0E5C061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 14:16:38 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id h24so5492709pjq.2
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 14:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P2NOpRy2waAO5lkoq4LbFtxZjtIjOxHVTfgdjfV81UU=;
        b=ImlI39Zk31TRl7DPFeiOf1g9LCLWRK8CNFbg92C0YPamo303xzCp862oaie6ZSmwxU
         pzkQ60on1kzAMuss6cKh5rm/vl7Z84nhCEk+eAp1Ph72a4aP1u9oAzBnvlOXV2AQ8MLh
         AZmXUW5vzNtop0SN0FO7GCIBlTso8oQhGvtAcq9/1y04fuVpdQ6XiRS5TMjFSBTuj/In
         SU0z6UyCFRqB+oV9UoQ04QurPgyIRTAkYu5pjJN1Oq1Tnuj3vAyg5gsx1h4ym1pt/4xp
         /1vJRJ1vP8sswzI9+4oPBccNGF43m19BHd+jCbOIAytB9VJ6oEvrKOZRjtT9FKz0lt6T
         GD4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P2NOpRy2waAO5lkoq4LbFtxZjtIjOxHVTfgdjfV81UU=;
        b=r3jqk89lXdXHqgOWFVlQYEkdz8gvfNwDtrAzZb6pfN4yxoLTp4Ip/tw7UT4eevZ9Jj
         UbJW/p/9qI2cgX7IjVLamJ+QChNesLZ7DshUNmuHgGup6lexIdz7YQbyKtcsC/qfzpp2
         yCCx+gh+caADn85SDtvESUK9WH5IrgLzYoVN/y7FYoXB74LUKXqalMh1nm4eNRjgjeZM
         R+aQ8hzoxEI7/LLLgF8mzx7zIzWCmEYVKOki8i4cBSw2/GH6Js/X7VWWJJmBXuFOxHbj
         VBzfug1/KfQAEtQG8ncLbEIcKUfIwMPML6bYq3BU/2w5uNomMdFOeY2zqiewL8sXGV4H
         7ZNA==
X-Gm-Message-State: AOAM532nLM/2oDi9qzvyf1mkPpAkzyw2PbiIqc2/z/yzFZhVq7ZLCNCv
        CKuAlo7K5LOOYy+LDlQ3YdyZyk/iTHUJsIXzCkk=
X-Google-Smtp-Source: ABdhPJwI4R6AWDlTEaeRS71IJlPe93YeYY4p14+2MObg+vRE5wUjf4673/NlK6+CAe/IIrChDeFkWw==
X-Received: by 2002:a17:902:f24a:b0:141:c6fc:2e18 with SMTP id j10-20020a170902f24a00b00141c6fc2e18mr71348819plc.55.1639088198128;
        Thu, 09 Dec 2021 14:16:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q9sm712349pfj.114.2021.12.09.14.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 14:16:37 -0800 (PST)
Message-ID: <61b28045.1c69fb81.e262d.3212@mx.google.com>
Date:   Thu, 09 Dec 2021 14:16:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.83-129-gefc3f818915f
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 234 runs,
 1 regressions (v5.10.83-129-gefc3f818915f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 234 runs, 1 regressions (v5.10.83-129-gefc3f=
818915f)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.83-129-gefc3f818915f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.83-129-gefc3f818915f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      efc3f818915ff9376ca75e3927acd10e96c65636 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b24676303b25991539711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.83-=
129-gefc3f818915f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.83-=
129-gefc3f818915f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b24676303b259915397=
11f
        new failure (last pass: v5.10.83-129-g307696aadda6) =

 =20
