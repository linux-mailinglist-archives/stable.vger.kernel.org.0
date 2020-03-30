Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD611983D4
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 20:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgC3S74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 14:59:56 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41387 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgC3S7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 14:59:55 -0400
Received: by mail-pf1-f194.google.com with SMTP id a24so2214971pfc.8
        for <stable@vger.kernel.org>; Mon, 30 Mar 2020 11:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nLDt4Q1g5QbLOtfgAiNNzGy194Daw016M62B79FvpiQ=;
        b=xgEadEJ37469NzJpu80E6xXHvvRupManZcjjVZlUkFTK+H/bm1pxhvjpxyXmphcOy5
         DQ7HC394qSvyo3QhrkHIGtoLxjBpuvINniE9MAhP63ny8DnZqENyWIguOR+nEDSgH9w8
         ef2OWKMcnKiqmSc3r1Htbl/JpHf8TD6mL3yjsk/pfY01cEHLacs0O4JSJlv9dsd9uw2M
         txGVivp0WDOZ7C6ZuncwdOhxTGlKsIdAI2dGctZAEKcNzDWaO4iNcMqnS8HF/+BLS6bR
         sRqgi6nILN1+dbBWA+FEX3DB9qtMD9Xeh6+6mkUv1uGhzAShuZ4L82aDhca/Ey6yCFC7
         a+0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nLDt4Q1g5QbLOtfgAiNNzGy194Daw016M62B79FvpiQ=;
        b=EPF5NBzBLVFLXMbV9tLsIv28/hbKVT1GJgrp6S30a1Vtr7mb9X/dMiDUpnlmp4nXVd
         InHAR5uYPzhmHe9RIKxQJxCiZcuNX8+CbM3I/Ao07BEz3VRAgrm3PSIJJIMkOU+hR3tw
         rIpmo7hW5VmHhNPL6vlKCerUckhgWp0YGFgNoXgsgYp8Y/G1Y6kLcQrHINSIxaOmMpvC
         GRUr6X94OMCAzPb8f/Q65imesLRXhdkCRYAAT8Ja//60HdO2Znw+vEwVnAH/LVnqzAcI
         UZdwxSXA/XUlq4PgufYmLRPmzi4Hq0wjyCffC+eup7QQz2zIkqCcPql0ogrT1V97YUFG
         pXLQ==
X-Gm-Message-State: AGi0PuaSfHlQe4xi37oI9b6Qm8hi1TF3bDgDj0GgbnJuEaQ34dCnx4wc
        7pfotMtOLbldv2KK5vSGrIvqamgFBXU=
X-Google-Smtp-Source: APiQypIIsQ2zBwbhx8Tgo96is4gBZdgYJQ7jbBk2O361Vvgei3Rk2fr+BlMDjMHqm4GAhcGFlERRPg==
X-Received: by 2002:a65:4cc1:: with SMTP id n1mr502977pgt.94.1585594792318;
        Mon, 30 Mar 2020 11:59:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w29sm6016022pge.25.2020.03.30.11.59.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 11:59:50 -0700 (PDT)
Message-ID: <5e8241a6.1c69fb81.131d0.bfca@mx.google.com>
Date:   Mon, 30 Mar 2020 11:59:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.217-71-g6d7e889c2478
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y build: 197 builds: 1 failed,
 196 passed (v4.9.217-71-g6d7e889c2478)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y build: 197 builds: 1 failed, 196 passed (v4.9.217-71-=
g6d7e889c2478)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.217-71-g6d7e889c2478/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.217-71-g6d7e889c2478
Git Commit: 6d7e889c2478cf33e82cfaeedbd9b81867f05dc6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failure Detected:

mips:
    32r2el_defconfig: (gcc-8) FAIL

---
For more info write to <info@kernelci.org>
