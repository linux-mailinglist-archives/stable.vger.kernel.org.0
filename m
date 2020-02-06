Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60081153F72
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 08:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgBFH5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 02:57:38 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:39552 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgBFH5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 02:57:38 -0500
Received: by mail-wm1-f49.google.com with SMTP id c84so5778155wme.4
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 23:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9M/mKRoFieQaXGVFHmtjTfm+i8yjtKHF/UbuIJ4XCXU=;
        b=UG0TkA0UO4D8OH1s8GX+OO6anDBPuF+toAZ5T5NTN86k/o33pUYK/66+YRBvZbPjtt
         XM/C75wx79noaenEarKIJwPCQmo3CFckOA0J8doZwd+lD5F86HUp27ROBdZKdZ+cj7hC
         K7lE3AzcZ8D0HaWsy6upd71EMoKtXKnlUjnuIs+rhiQsMHSOsBBIhUHTbprOV1Ix13CC
         ONSERQwsYCVkWIILhoqD/8d7/FPskfEwl3sSLLXLKQY5Y/5a3uuZUzoCyugICz4jGTIJ
         PfZizCrl8gZAE+EM9YeWGVlk8KDjD3IpwIJ+6WUFRIoUzzH1kYi/jjHdG9hFgYvFSSDJ
         jOvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9M/mKRoFieQaXGVFHmtjTfm+i8yjtKHF/UbuIJ4XCXU=;
        b=KKHh51nUlZ5PNXwTIOIZWaFDgec49LsUw5PYJo+pJPMLljvbUZTuaKOG4fUjjU08eM
         dsLqUzidHA2RzIX2RqpVvqfzaqjA+WXq81St4ZWSvyFHb3U4QdpVDFXWp/p6ObhOCr/P
         +K5TQGzI2fy956Vjfk2U4f7wSnQmpO71unXcHyCHblJzt2BzjmYrfA0aDMy4vtXeKUSY
         OjEw4VQKbazdDXOeQG2PHTEQXm3OTkZ882oZVlA/LUtPGftMpnXM3QwMoltCjKpIxWGd
         hXPyInEWhbjCByICO25IsHLCz8XYbTrIt4VX5uuUCej6h2+SrqRdmPLNkmUw9uP4l1oo
         8Qhg==
X-Gm-Message-State: APjAAAUdDOsKivmrl0szmgL5Aw0cNTuCraI35azCM/k05sscXJknGTsh
        EGNyQiN7F1a0zcC3HX2LHO9Jc18uTZF7fw==
X-Google-Smtp-Source: APXvYqxb1pKOT5oBm5GEfcjip5KOGU3cBVvUPYi7YHoJnMAAr+M9fWOe5PPrFWU/1YSpkE3vf61BVA==
X-Received: by 2002:a7b:c416:: with SMTP id k22mr2992421wmi.25.1580975855018;
        Wed, 05 Feb 2020 23:57:35 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z6sm3187403wrw.36.2020.02.05.23.57.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 23:57:34 -0800 (PST)
Message-ID: <5e3bc6ee.1c69fb81.3ea6b.d701@mx.google.com>
Date:   Wed, 05 Feb 2020 23:57:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.102
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 28 boots: 0 failed, 28 passed (v4.19.102)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 28 boots: 0 failed, 28 passed (v4.19.102)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.102/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.102/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.102
Git Commit: b499cf4b3a901e87e1f933df04abf69b54de4457
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 9 SoC families, 1 build out of 25

---
For more info write to <info@kernelci.org>
