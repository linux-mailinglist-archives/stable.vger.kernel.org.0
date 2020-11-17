Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC642B58B9
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 05:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgKQEOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 23:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgKQEOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 23:14:45 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB045C0613CF
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 20:14:45 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 81so6789680pgf.0
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 20:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BbOjdxxHzHzjz6WIHIMHQVntSdE022cfn7YujYPbMu8=;
        b=raMRemMO0fNrBgHAAi5HLTVcO24nc6Ur0pnVLutOa8nWsubLqKkNlbZ6eegjrdbUXs
         NX/yVHcd3FpQB6kpG5S5EytwI1aQayTEPykImeXx+tcfk9F7TAe83ZNGdc27n0afZIk8
         nYGfpNuGlsHE3mn4rq2kHUPnvOm/yf/+fKtti2lPKC3NYeYpw+C7Ta5DLDx6Hxd5UwJY
         QdeFYdKdrtPyEpJJvoa+uTTkp54tQNgHOI5ZEFTtj2CTmtOm5niTzUjPqn2lV3hFE/b3
         XIPtvwqlWnPooN8jA9VS8TgstsWAS2XiWlQ9r2cgT9IQkA8j0+wSiwKlqmMemVwgOAic
         7u0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BbOjdxxHzHzjz6WIHIMHQVntSdE022cfn7YujYPbMu8=;
        b=ijp+r7VRQfrn4+7GJDwarkWHV/SUwYv3rr4jXVd6sAhC3WtF5WXR0BoNPFDTCrmTiV
         TyW4EHh7wTUoppUUZQReMtQ/BLA6Qd3B60381vI75ekchfleHM2H8PsA9lvQltyzej3A
         igjAeWmywe73fvdNVBN0E8PAxbUURNLSLDPM/Rmw4VrJoVnoLWMK4u2oL9ql+dWx4C3f
         kDYOoS/PDulEWdACidn1V/p50EPij5BfX14IaMmcR3A+MDBV5Ni66ck9+8n1i3Rw9Lif
         5lrc6OOCpGXh2kY2g4hSZAZ4CUjtOOa0CEcvt5wkV0c8r4VkwLjQ3oIZmsz9Y8+ypijb
         pKXQ==
X-Gm-Message-State: AOAM531hr/d4U6BHYyN3NBKi+KrjoiU9v7Seb/RluFqN/3+n8bsuteC5
        wFKPuUY8dGO91a9ILtPmucmdhnSj02hNpg==
X-Google-Smtp-Source: ABdhPJzHbBgFwgr6SLg/OeORKBJZfjp33asYK0ZkARcBh+yYAjtMOb9XLUg+DYotsvtvzlSGIWbvvA==
X-Received: by 2002:a17:90b:118b:: with SMTP id gk11mr2612361pjb.178.1605586484920;
        Mon, 16 Nov 2020 20:14:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a21sm1083487pjh.3.2020.11.16.20.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 20:14:44 -0800 (PST)
Message-ID: <5fb34e34.1c69fb81.6493d.3855@mx.google.com>
Date:   Mon, 16 Nov 2020 20:14:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.14.206-57-g106ef0d11ee4
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 build: 4 builds: 0 failed, 4 passed,
 1 warning (v4.14.206-57-g106ef0d11ee4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 build: 4 builds: 0 failed, 4 passed, 1 warning (v4.14.=
206-57-g106ef0d11ee4)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.1=
4/kernel/v4.14.206-57-g106ef0d11ee4/

Tree: stable-rc
Branch: queue/4.14
Git Describe: v4.14.206-57-g106ef0d11ee4
Git Commit: 106ef0d11ee4695a42a4544818b1b6dbf22379e6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 2 unique architectures

Warnings Detected:

arm:
    palmz72_defconfig (gcc-8): 1 warning

mips:


Warnings summary:

    1    /scratch/linux/drivers/clk/clk.c:48:27: warning: =E2=80=98orphan_l=
ist=E2=80=99 defined but not used [-Wunused-variable]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:48:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---
For more info write to <info@kernelci.org>
