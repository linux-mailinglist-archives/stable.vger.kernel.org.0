Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212A0CFE6C
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 18:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfJHQCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 12:02:40 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41014 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfJHQCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 12:02:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id q9so20062744wrm.8
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 09:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ipMlOIhPbpmOovLAksJ0ZPwQkcHR6yNjdTe3CBl2o1s=;
        b=daotUWsShNSJs+3ErQulMuxd576Vm8y/XCsS5FRs+H4BntwVb+bWpNT8eqm6OuOJsT
         kAlwY8GH9BXaHeJRoK83/EFkxT3eAhpeLXdltnT6heddRR7Zbhyl3S1++WPErc/ZsQJZ
         05Hh7+j17DnQAltUUvaXY3xzmbk1r/ftgwnTwVqfQsvy/Cqqa91GFUn8FumY3FBfQJZF
         9xPIapTZrVDvFcmQcSGRcdWghGQP+JGhE2l8JvwPfEfqDck+MAStUbA8WQmzE3czscOK
         GeR8VkPHe19WLHVlpu2U3gzpWfdm4ho61D9Tv30MWWRN54osVjWzRE1R8hbKXRGrJ5zx
         TyUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ipMlOIhPbpmOovLAksJ0ZPwQkcHR6yNjdTe3CBl2o1s=;
        b=DqfDhMCIcKyfliu4HNnKTFEYl6aa2U7kRNG/seSq8briGv69sNenPCF6Qi8QukcQSl
         3pmnQykJD+4b9ymyfZkCV34dtcsHXsjfIuTkTxLsyK7GCuWJnk0CApTWugBpb8XfXRMt
         4sceSvhx5mQ3Ke9hS4MHaomJ4wyNy/wzjaj8Yukfk3rcdE41Vbdo9ZLVjRGfVQaunPtU
         bdI3SS8mNahtkqDPV70adlbu7UvBREkHJKA1uWzULZuViqAI9/C3S4ZULRUWryHuxUMb
         +xtfDRkTu3SsK5Bo1ibNMVqvrclxxprpUMi3TC91Q2NROUtftKLKiKMUSkKI6R+/KtXL
         7cbw==
X-Gm-Message-State: APjAAAWMXlo1aTuO5stFt2KTCQ6gxYVGqoISL/wE30uWrry3KUs1Vpyw
        r84H4fSrORxJPn/tEPhyG+B10ZQfeLZmoQ==
X-Google-Smtp-Source: APXvYqx5PqYqWnu0YZf5jvB5wuIHUOxamJlZOBgtnQsKniW5QozJ8f6WvfQqbhirWgVB+kIXXMo5Sg==
X-Received: by 2002:a5d:4647:: with SMTP id j7mr28518063wrs.106.1570550556545;
        Tue, 08 Oct 2019 09:02:36 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p5sm3411218wmi.4.2019.10.08.09.02.35
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 09:02:35 -0700 (PDT)
Message-ID: <5d9cb31b.1c69fb81.d44ed.0b4f@mx.google.com>
Date:   Tue, 08 Oct 2019 09:02:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.78
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 64 boots: 0 failed,
 63 passed with 1 untried/unknown (v4.19.78)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 64 boots: 0 failed, 63 passed with 1 untried/u=
nknown (v4.19.78)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.78/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.78/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.78
Git Commit: 58fce20645303bee01d74144ec00e405be43b1ca
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 16 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-drue: new failure (last pass: v4.19.77-107-g61e72e79b84d)

---
For more info write to <info@kernelci.org>
