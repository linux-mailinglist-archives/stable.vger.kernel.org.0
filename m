Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77D20FA78A
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 04:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfKMDqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 22:46:13 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34639 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbfKMDqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 22:46:12 -0500
Received: by mail-wr1-f68.google.com with SMTP id e6so636443wrw.1
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 19:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dngZVE9Vo9Cjsspd+4k/sbLmPvsgKc7ldXGTkZkxDko=;
        b=VTZTxy+pUCHedmtpS1ym/bqkkhPJ1HlbN6lVfGq2VzPptLBBU6REPuIB4uRWoYKbTd
         fKeWSm9crUTn5LFEMHhb/jZN6kUffAdAD+OE7Upie8oaLMiC68gjItmeoeDPaW6v6gBm
         IvVBtwbjEmqGyVDFfamkZ5OWRa/OgI76JKi6Zd6vlchws6UwZqMxR15FmO2SgDOUzdgT
         6Ye4lxzPYvKAx8OxxdowIyXUY7W5keooDekczMb23fwJcC3l8oXwa3fYFrDVrMU6QxYC
         TgXpWynBWL37S2CSuOXw3mxRwnafvuZbKvwj1d06KlfVQ4EiQc/0KXbmCE9Dj25TrAsx
         Y/RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dngZVE9Vo9Cjsspd+4k/sbLmPvsgKc7ldXGTkZkxDko=;
        b=diast6RgDcPgA+l8BEU7xNN7pf5d0f62PMKGY19BD82i0SabN+idjljq/E23WE3urS
         hI9ObGk9o/9xETkGexU/QiJ5MhIopLTSHDIlqmivhUbmW+91dRx42Q6eIn37oFD9JGiE
         kczh47RSksFdUtsEHXrNU1JY1Mmgj2JxNol/xuCrSlx5WWoXXXW2gzHRiLKU9mWLci4m
         SBj+cibjr6sR7DykEHpi9pFZbqYcKmrsbomFlUWIxxNicTyq+yUOGtizmREUe/UlyMkD
         in5oBRWUsS230a6h+tZqeYjBaiBQOvbo0GI811QuWaw6iG4IasHLylSsbHD7W6y2CmsR
         hIXw==
X-Gm-Message-State: APjAAAWVYjF7aOtZO4/lnW+kClVtuh44Wi527J2PswuVo+F1PW6fKSli
        vGQ9UuZNgzoJVRbPB7/IR0vkEFir+IyF1g==
X-Google-Smtp-Source: APXvYqxO2OPBjAPX2HTF52UHSPKTpip84S8zIDLeVl8OeGxELhB3tpGLlKTkYAHc0zaGwfpM6teLrg==
X-Received: by 2002:adf:e5c5:: with SMTP id a5mr635578wrn.103.1573616770539;
        Tue, 12 Nov 2019 19:46:10 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u16sm1193117wrr.65.2019.11.12.19.46.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 19:46:09 -0800 (PST)
Message-ID: <5dcb7c81.1c69fb81.c08c9.4b23@mx.google.com>
Date:   Tue, 12 Nov 2019 19:46:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.11
Subject: stable/linux-5.3.y boot: 69 boots: 0 failed,
 68 passed with 1 conflict (v5.3.11)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 69 boots: 0 failed, 68 passed with 1 conflict (v5.=
3.11)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.11/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.11/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.11
Git Commit: dada86c5aaa8f2305bf8a8bf9014b60603f9f013
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 47 unique boards, 16 SoC families, 11 builds out of 208

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
