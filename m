Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975BC13B8C
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 20:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfEDSfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 14:35:17 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:55580 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbfEDSfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 14:35:17 -0400
Received: by mail-wm1-f45.google.com with SMTP id y2so10523997wmi.5
        for <stable@vger.kernel.org>; Sat, 04 May 2019 11:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QHH2M5dKNVH1PvqmVNHYjAZA57Tdu9l0sGoQ9j849ys=;
        b=j4GL74EHsn4rukVNN7LSHITJJsOri8hN0kSAT4oTZ5i++h72+MI37qT71qlEvT2d7K
         tK7mJ0KNrMANkCHUyibzNnmdl3+Sl37fKn37R/YsLHXqe9d3lzZRK+eowDGHw7X0gYyq
         69kidrf7ZIQyTHYiC75+0g/eucA1Nj6e+xKMxbgtEzZAYzztr11NV+2mNF2PBArrn0+V
         SbJpj8ce58KPz8SO3liVA9DWMOiK5O/UN/LpIjJXXCoauWQ1Q3SSXDHa9neq8RWc1LR7
         VfuoSkfoE1KUxXg/Etf4u8DM2kAwCnJ0ndBkHjfoEw7B9nt2dJIX6vzRtk0+xZxd9jz3
         PbKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QHH2M5dKNVH1PvqmVNHYjAZA57Tdu9l0sGoQ9j849ys=;
        b=ld+IKUy4vKf/NSlhPSmGtDRJuGnsuKT9dpNY0ZsLhsheLcemGOEmnv4nY5HEvb42bn
         mM044Tz4uxSXfKnRI2Qg61NPq1IN7C6zeDeCeyd7ttJjlGNPuh8IloSDl+6jaYVh0cx0
         x2ORP7jTFdxb+BBJ4Y2zigyFrLPLeKuAhWvzKRxlB29QTDV+qlj5/qls6w8b2qyQL5E6
         ko1eRkg82VTIy7n/ItUAUGBn5K1/V+HiOMOZX5aLDURxoEpCNjqZEtCH7Iw8Me1Wg5H9
         W1opq7Pkg1hRmtaV8yPK8QyvlT22gyeFVjMUWAMtL1HXhW5BnxSySkk3bxaxyfAJqAma
         47YQ==
X-Gm-Message-State: APjAAAUSpWtBD6UIh9rA/hXZxEfZDo9cx1hyKXYvWulQ36d3sUU19Ynf
        kA/EoSUOiw/pTkQG8qttd8WhByZVwJ8=
X-Google-Smtp-Source: APXvYqyugl8C08H6Z53c1KwBqbmJOdj5VaB4wi3YJpzI85esB4XTsauhPdlSeFUjPTwcIDo72Eg2cg==
X-Received: by 2002:a1c:7613:: with SMTP id r19mr3083743wmc.120.1556994915135;
        Sat, 04 May 2019 11:35:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v189sm10561076wma.3.2019.05.04.11.35.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 11:35:14 -0700 (PDT)
Message-ID: <5ccddb62.1c69fb81.5d408.c705@mx.google.com>
Date:   Sat, 04 May 2019 11:35:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.179-111-gdd4cd40c70ad
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 92 boots: 1 failed,
 87 passed with 4 offline (v4.4.179-111-gdd4cd40c70ad)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 92 boots: 1 failed, 87 passed with 4 offline (v=
4.4.179-111-gdd4cd40c70ad)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.179-111-gdd4cd40c70ad/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.179-111-gdd4cd40c70ad/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.179-111-gdd4cd40c70ad
Git Commit: dd4cd40c70adefaf06b3170596cbb132be053372
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 21 SoC families, 14 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-7:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
