Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A871C1F49
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 23:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgEAVKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 17:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAVKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 17:10:09 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FECBC061A0C
        for <stable@vger.kernel.org>; Fri,  1 May 2020 14:10:09 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ms17so398400pjb.0
        for <stable@vger.kernel.org>; Fri, 01 May 2020 14:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y/dBT/BjLZW7TMWhnY0UXKA21hTt8pfGNmlMpR0+9zA=;
        b=LkgPG5aK4n3SoqA3xN+poXbSvVK0817Vs4YSmxNYuFgUYwzs/LUd/a17wzKnGfkPrk
         92gg4ir3hjGuFAWSGTw/ECbXmAVahg785w0JKUytRMT8v3Tm9yhni2L+bb1TyGMQnpr7
         y6MXKjvu1QoYkdFBtagz1NibB3WxSCZsJZMt89b3rVGWeVY0uC17V2w5RsQfaD/trHDu
         ogaquFe0YWprrAVtHRpy7YyVh4o1UgUOYIDVt7XWJjlDY4JpaqOUYJcC3vCnXn8wtRxL
         2Uu06OM8iZKhwsr0s4k0lpxTALEwB66IxPOLjpiIkgNFa+uncRvpEwKedXg1mCRpD0jR
         EeVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y/dBT/BjLZW7TMWhnY0UXKA21hTt8pfGNmlMpR0+9zA=;
        b=fQIKnjyKYgMzaRgtqIDVksJJ9/+CzkaeXgoNNWW1OiUiz0Xt2ghTpZmWTeAFLxLbmX
         EVThnLqRSlnoDp17UV3SgiZuIpVCboqyjy98809hFamWl0WjFHL634CaPvO82oa9kjGe
         4pGQxsdeB7OtKHwi5sMOB4xmmkhRDxCJFrQuNBYcUWHtNgv7awjtYWzOjfHmIRIWYXpu
         p8Cv0Trhy+UBKhKOWzf6aSXEwL5Cu+dLeRni85fRzAcT5T/esLAWe4WJWqcgauweZynG
         tg4PvX+qyVAf0SpUQxMDS3ucTC79ChdfMNHG6na5UuDfqluj/2mdPBvyhrW0ieaZYBnI
         4S1g==
X-Gm-Message-State: AGi0Pube1r8FPNuoHpwrcXOnmFeifu3I9oswhvmenznlZM1unoD7WINF
        uX2j7ifobAv39wGn3ciF0OCaDlDe2Q8=
X-Google-Smtp-Source: APiQypKaG7ks4/TbGsDv2jKNjImbmLpc0wyeDcxm7MKnJwUrAeMwi7nkowiPiOcXN2EuR4Nx1+yEPw==
X-Received: by 2002:a17:90a:f313:: with SMTP id ca19mr1766014pjb.7.1588367408463;
        Fri, 01 May 2020 14:10:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k10sm3016040pfa.163.2020.05.01.14.10.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 14:10:07 -0700 (PDT)
Message-ID: <5eac902f.1c69fb81.aa9b0.abd9@mx.google.com>
Date:   Fri, 01 May 2020 14:10:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.119-47-g81d4e31e1418
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 106 boots: 1 failed,
 99 passed with 6 untried/unknown (v4.19.119-47-g81d4e31e1418)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 106 boots: 1 failed, 99 passed with 6 untried/=
unknown (v4.19.119-47-g81d4e31e1418)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.119-47-g81d4e31e1418/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.119-47-g81d4e31e1418/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.119-47-g81d4e31e1418
Git Commit: 81d4e31e141844fdb5678510f819e09de1c9f607
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 16 SoC families, 18 builds out of 204

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v4.19.119-27-gf142d35ff=
6ac)

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 49 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.119-27-gf142d35f=
f6ac)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
