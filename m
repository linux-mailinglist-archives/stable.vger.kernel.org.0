Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7559198343
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 20:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgC3SV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 14:21:26 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50984 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgC3SV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 14:21:26 -0400
Received: by mail-pj1-f68.google.com with SMTP id v13so7987673pjb.0
        for <stable@vger.kernel.org>; Mon, 30 Mar 2020 11:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Qltk+PWFTjKjP2hRg3FyZAuqLFvG83DYYoa+4wffpFo=;
        b=lTP6JeYx0Ux+9r0EO6+yhzpGkiRPE8FwnNRHDgJnYEuY2X1ar77yaW5owDlM6chMjb
         KqPReLoyWkR5sFsE7HpYU5DEhoj0RvLEOts1KdLVNEcWIXbNCHSoOm6LhJydD84iuWXs
         gKzDoY/XuYoWtJeD3DneJVXf3MDx51tWlU1MnlrBIoQ4WpABv6osYN80Ne2kkAOS0suk
         gCu8sIToB0qIJT//i5UlqJO/qLFRo7pYD4W1lI5XSdkHAaqkknsbqYyFDJZgeUvRx8ac
         DBp5e2aJ5eeKfchPt+eXBUNLlQb5Fy82/TaOHcTEGBxLPe2RMT+9RAMypcITWgpz8gsn
         MqiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Qltk+PWFTjKjP2hRg3FyZAuqLFvG83DYYoa+4wffpFo=;
        b=Dcro9/rOEzrReJs/NPXia6c80mCjxK+THYdM+dRZkjWEZ1RWJBCiLAbBa5Awh8aKSP
         G9WN1p4eUPyUgDN87OAHH6oO0QphhKnO0ZK4znYI+uefy12USsrCw8ktih7Ii2jxeela
         Sjns9eaHiYPOua3DwaD8jIPG9AK5/uUUs62P0GJbz0aNm79FMHQ7zri04Ep9pR0JLGYj
         dCITdnQLFSs3KJifTbudoOr4fIXLLvj70Xsy9cwQxVo8ow8RPRg7BvrIQPU7nRiVbZ8U
         y1Fg7Xg/wRzzCxTideK8/17GqxA2JajZ2V/JrqktOuyV6k9bOJkc3Cq7nyY7GUvMHd5Q
         hJgw==
X-Gm-Message-State: AGi0PubnGucZbxh89V4PThbwRzjHNDkRRnj+QsrYmjCajpwPHK2KWjXt
        tTFz0Z4C2lmi+OR1yo6qlRBWpX4lhHU=
X-Google-Smtp-Source: APiQypK5+aTSuUZgCX957xfYHu0SsPCBKQTFQQ0ffoa9n68acTRYT/WnAjIiKx+lUZ3s/PpTpAsQgA==
X-Received: by 2002:a17:902:b101:: with SMTP id q1mr712597plr.246.1585592484971;
        Mon, 30 Mar 2020 11:21:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i6sm10687630pfe.62.2020.03.30.11.21.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 11:21:23 -0700 (PDT)
Message-ID: <5e8238a3.1c69fb81.b2b09.f6f2@mx.google.com>
Date:   Mon, 30 Mar 2020 11:21:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.113-79-g81a370c0d238
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y build: 206 builds: 2 failed, 204 passed,
 2 errors, 8 warnings (v4.19.113-79-g81a370c0d238)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y build: 206 builds: 2 failed, 204 passed, 2 errors, 8=
 warnings (v4.19.113-79-g81a370c0d238)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.113-79-g81a370c0d238/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.113-79-g81a370c0d238
Git Commit: 81a370c0d2380a99e6a2fad5d3d9456ce054966c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    multi_v7_defconfig: (gcc-8) FAIL
    sunxi_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:

arm64:

arm:
    multi_v7_defconfig (gcc-8): 1 error, 1 warning
    sunxi_defconfig (gcc-8): 1 error, 1 warning

i386:

mips:
    lemote2f_defconfig (gcc-8): 1 warning
    loongson3_defconfig (gcc-8): 2 warnings
    malta_qemu_32r6_defconfig (gcc-8): 1 warning
    nlm_xlp_defconfig (gcc-8): 1 warning

riscv:

x86_64:
    tinyconfig (gcc-8): 1 warning

Errors summary:

    2    Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:419.38-39 synt=
ax error

Warnings summary:

    3    net/core/rtnetlink.c:3190:1: warning: the frame size of 1312 bytes=
 is larger than 1024 bytes [-Wframe-larger-than=3D]
    2    drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c:159:5: warning: =E2=80=
=98is_double=E2=80=99 may be used uninitialized in this function [-Wmaybe-u=
ninitialized]
    1    {standard input}:131: Warning: macro instruction expanded into mul=
tiple instructions
    1    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm'=
 invalid for HOTPLUG_PCI_SHPC
    1    .config:1010:warning: override: UNWINDER_GUESS changes choice state

---
For more info write to <info@kernelci.org>
