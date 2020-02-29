Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 691C0174828
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 17:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgB2QyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 11:54:08 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36922 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbgB2QyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 11:54:08 -0500
Received: by mail-pf1-f193.google.com with SMTP id p14so3375719pfn.4
        for <stable@vger.kernel.org>; Sat, 29 Feb 2020 08:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DMd0osAtBhHj/k1H67UWNfyYzqa23JRH+1sUSKmL0j8=;
        b=jNCwOaMqnp93MxoHMTqvFoVeo4KVDph1QJwNFX3qusQKQw5EFnMoynRU3jkMEyc3pU
         AdYhf4Of2J+lsw+cAxwNUBgYzLpbyooEysPZ352SadKxyVfQen2ZTFWxL5KTQxpv3lH+
         RFrW165dHsujmgC43k/95d5V8RQhkL9UXPuud4BxoNt91araJpHJ9DdD9MVzSSt/aY88
         zPdCCWwHGLkPp7Sav7YR7tuZZgz4dBzxwNW0rXVVxvw4efktlJ+h91H6YnDYTixwZT+7
         sa4XcLGvoOIBNts1JJ8cyQqVGJQBYnKrk+NGeAdSx2g8U8N2/y5ngvMe1flFRFjQeXGY
         g84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DMd0osAtBhHj/k1H67UWNfyYzqa23JRH+1sUSKmL0j8=;
        b=Z+kl551zNHYNV97FZ2GN41qKTyXwXBNU6SBY8VVp27Kaknt1FNnjPwxXgSeQkzRARL
         5GgSQcO6bxjFDqHKyxyDWe1hOwPN9qusF2CMv2obY0C1VN/PLal9zI80SEh7mFR5ntuY
         X2g9xqfIocy5IOUJj3j30/Q2+l4NSh0uAy+YQ46u2eEmB3neizA53Ttb4dc6r/hyiS5q
         +RthAnRp7c67e85Ajgz3vxiialVB2VMy84KPfzkXCwhhJ0r+IqMpK1PwsqySQHBVhm4M
         1Fb5JLF4PoZdAyDX5VwmoEDr9kUgPOJtjnb1xe6IlaKsF2QEJ77BVo2p5ZcjoRAJyLLj
         1ftw==
X-Gm-Message-State: APjAAAWgVWnhJ42047vX5sKDT2YT/EDc275F7u+URhWyq3TnJ05EGYGt
        RZx6NbOgwfh+mOrBjfxA1/bqvfNw6Ks=
X-Google-Smtp-Source: APXvYqwyoexK1FGtohK//wz1d+KdjxF2m78dZqFVjEi09Oj4V55Rojt7Pg0XlbNx89pW+EKdy8JuwA==
X-Received: by 2002:a63:5916:: with SMTP id n22mr10514120pgb.190.1582995247012;
        Sat, 29 Feb 2020 08:54:07 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p14sm14033738pgm.49.2020.02.29.08.54.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 08:54:06 -0800 (PST)
Message-ID: <5e5a972e.1c69fb81.c32dd.4399@mx.google.com>
Date:   Sat, 29 Feb 2020 08:54:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.107
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 39 boots: 1 failed,
 37 passed with 1 untried/unknown (v4.19.107)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 39 boots: 1 failed, 37 passed with 1 untried/unkn=
own (v4.19.107)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.107/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.107/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.107
Git Commit: a083db76118d20d070794ecf79af17843406c3f6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 38 unique boards, 12 SoC families, 13 builds out of 206

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.19.106)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
