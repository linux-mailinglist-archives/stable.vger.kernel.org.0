Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA04B142B5
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 00:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfEEWNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 18:13:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43007 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727232AbfEEWNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 18:13:20 -0400
Received: by mail-wr1-f68.google.com with SMTP id l2so14821398wrb.9
        for <stable@vger.kernel.org>; Sun, 05 May 2019 15:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P1BI9zXnFFEWgYC7ZhI8Cmiuh9ADGekruD+0aQFheOE=;
        b=uK14TRP5W5UUcZ/rZdKk0wDHdrPctX0ZWJ7CRvcsxEx3OWEO7RDOmiUrfJb1Z+29Zz
         RzBt67jIHGAGHqG8U69JHgSgmwOmKcYWKQDKUVliCrHz6+PjS9n4jAa5tmTueVljlIzV
         68J6INqamrBMyXDDeimm6LdAaKzEMaEJiqe8nD8wfe2F2l20NlUfspSqgWPWnmLqWX9+
         UFKs59dUODJAjkIUxS6aGLj2KYYVPBtPMGB4L+rnpPPkeILMPnM8j5JwlWfC3imc3J6u
         cFeVIR8oSCX+6g/HoPrwuQmsidVjmnCa6oPy5ki3rUZo9qKeO1vfnapvUB67D0G5GdHF
         w7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P1BI9zXnFFEWgYC7ZhI8Cmiuh9ADGekruD+0aQFheOE=;
        b=SI8NGBJqOTFJ/x6zPjs4AdiFmB4/8Q/AEvBehPgJmpDd+5+R7Ixe63sPQry3c5itJ8
         UVNxEpUlUL82EoyVNb1b+4Pd/a+UruOSRRjPfQWViUyRRLxd1nLfFp4d2ztG6E5Z2tQP
         JT/P975dTHwlmIxb5Wjj2GB1oVxX7f8EhUEdOsGIwceWX7ltrefzcZW/URE3avY4FHe9
         5am0OnuGiGIHLwx8EtnZCYMTImddNLji/lRoJOpkHa1V2rMNh10LJg408xNNYb3wP1//
         NiZlPNgp/C500v8Eot0WRZ2kQ59ewHjbHfqNYqaiGr53S/PpTGCk1zF2kvA7HVrILEC1
         FRGA==
X-Gm-Message-State: APjAAAVTOY8IZLhGRNqKquZIHmYXkxEcCdqb2eApksf2EMxRk1tvJ/bs
        9Byh+Rfp0insyDSScyOwGOm/6sBNQtA=
X-Google-Smtp-Source: APXvYqyF3eGvRduYxe1d9HR31KorxqgEPeSuGNk/KCDX/mGpi1YUKkVzjpWTTQpPNoIWFZ6vT5Ee+Q==
X-Received: by 2002:adf:dc4a:: with SMTP id m10mr15183403wrj.0.1557094398136;
        Sun, 05 May 2019 15:13:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z14sm8024wrr.34.2019.05.05.15.13.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 15:13:17 -0700 (PDT)
Message-ID: <5ccf5ffd.1c69fb81.ff6fa.00ac@mx.google.com>
Date:   Sun, 05 May 2019 15:13:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.116-25-g653fd35ba15e
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 122 boots: 1 failed,
 120 passed with 1 offline (v4.14.116-25-g653fd35ba15e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 122 boots: 1 failed, 120 passed with 1 offline=
 (v4.14.116-25-g653fd35ba15e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.116-25-g653fd35ba15e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.116-25-g653fd35ba15e/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.116-25-g653fd35ba15e
Git Commit: 653fd35ba15e677c5dd90b9fd4aad60e9dfe69e9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 24 SoC families, 14 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-7:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
