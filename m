Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B971A242E
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 16:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgDHOho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 10:37:44 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39883 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgDHOho (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 10:37:44 -0400
Received: by mail-pl1-f196.google.com with SMTP id k18so2564354pll.6
        for <stable@vger.kernel.org>; Wed, 08 Apr 2020 07:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8O37/CYHCA/KypHDA97f/LUSr3Erf4x0yedbOKrdhes=;
        b=K8BaazYNcqR5TPyI0lhQ9WeBuNiaFEB5nlq1zCT31mXNFQykmpcgE0f1UO3bYoBYgz
         ZbnpEfMLQ+hykEgWj2jP8U6E5WTnn93P07SwzZ4W4Vw2D3XUfr4KDgcg/nlrvBAoqwiV
         tPhT7hDTKAtjrEg1YD4u5JmHP8Hl7x/Q3bCTLN6eJsOzHdFQJHVMfvk5EqwjyTU6oHHF
         wMuTCKxmhyVxA+abDasAqf95er0XpYWJExJI1G1TxGy2uhRh2ZhKFweIsaiE9QP1Wg0Q
         0xliI5t7rZHWRzNBOKPN6WB8cKDVlKtnBQDyVNgaU0yZGv45ojk4ptm1m9TymiS9bQOb
         iaRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8O37/CYHCA/KypHDA97f/LUSr3Erf4x0yedbOKrdhes=;
        b=pn6Fx0/5Zmz+M+ZIuWAPsFHy7mVN3GjREIZ6SW7MZX9mKq7ja7LZbXeiWn3HwOJ7LN
         vcktpzuP8JWzVE66Iin+N3lZqyXEr826SIuowKkQtyo1b5jVF3iKcdk4PFPy960+33x/
         u0IBSa/PLNDIcxtosJCRdi4yKLpIqmiFqrFsTamNKnmSstBFWgPgKTUVx9muyG9vFMhF
         d/+5+uhyJrz/9DU89LewuRgORL8FSc0fT8+o8wktkvN+1fB5FZWviXTOrSBT7FzkWVKw
         zrh4zLiL9ABwdrNtOvHc9NHV5J/HapY2VsKrpFCx44WvhXmcGeXQ0cxx+fHZRCs9MZBh
         B+VQ==
X-Gm-Message-State: AGi0PuamDhLfvOdGgCVfg2YLjO8fUiYoTu7tzN72jjTxpuuhdmy2rdJ+
        9e32+FmP/yIyBVAkPU+Tg/IBRU+gznU=
X-Google-Smtp-Source: APiQypLOYFyu8J8jum0OZBBdMdcHMV85W0mlrXgL0PXg3DQbV56tCiJNR2N1zZCKl+a1LcwId9YSfg==
X-Received: by 2002:aa7:9f93:: with SMTP id z19mr8283735pfr.187.1586355453110;
        Wed, 08 Apr 2020 07:17:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12sm15712676pgi.86.2020.04.08.07.17.32
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 07:17:32 -0700 (PDT)
Message-ID: <5e8ddcfc.1c69fb81.7c60c.3eba@mx.google.com>
Date:   Wed, 08 Apr 2020 07:17:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.6.3
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.6.y
Subject: stable/linux-5.6.y boot: 74 boots: 1 failed,
 70 passed with 3 untried/unknown (v5.6.3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.6.y boot: 74 boots: 1 failed, 70 passed with 3 untried/unkno=
wn (v5.6.3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
6.y/kernel/v5.6.3/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.6.y/ke=
rnel/v5.6.3/

Tree: stable
Branch: linux-5.6.y
Git Describe: v5.6.3
Git Commit: f9fb85751506e75ecffaa498896efbb0c886adda
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 55 unique boards, 14 SoC families, 16 builds out of 200

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v5.6.2)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
