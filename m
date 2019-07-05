Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4E2B60D9B
	for <lists+stable@lfdr.de>; Sat,  6 Jul 2019 00:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfGEWEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 18:04:31 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:35364 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEWEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 18:04:30 -0400
Received: by mail-wm1-f53.google.com with SMTP id l2so3706262wmg.0
        for <stable@vger.kernel.org>; Fri, 05 Jul 2019 15:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RzXed7lQ82WfreQZaq7GIpMwvJAwUl0Mgh9jRDImBKw=;
        b=Ukxf/XCHqP+rgfc99ieCcdblVQGB0z8Jl3bKzMF2Z2XJSB/edK5cOFUxd8f40wZJ65
         suGTnjPkQ2WvrsQcCb4RVa1s9XOttwypPzWP3HtMwCuI8SClwtmOzPmITTpS7mYgPEcs
         N3Thtzbgx2UP/e1QMOl5F3F+FLoI7wNi8RoBPfXXVJc1ZmqLfkP8a3g4OMj+M6RIeDks
         NdpCNJse7Pw5P+NAOXArZ/jqFj14/zmTUAY28QsaXACokYfZRjVCWXZy+X9pnRNBtb3O
         kfEGhnuphE0E2rL4fGU84CLaD4joXY+ugU0AE8sEVFwt+VlskfULgjiODCEWwT/XyRU4
         oNhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RzXed7lQ82WfreQZaq7GIpMwvJAwUl0Mgh9jRDImBKw=;
        b=MjskJvFtby0Xp3vUZkePV7f4XFsp5s8fYduRmNT6Vb15y+4scAoW3F5oF5y0fo0Jw1
         GBt71muHVzthbzwdJIjxzykMJ2ziFD0IsKVaTWScKltVTxhleLvRvohX3SnBWsBwwPCr
         P5GoWgOpUEaXjV1eHD/bffmKKwYWo4CQbWWQwfBPTaNdWbTBrn+m1INQLXLzpWLY7T2U
         +i/56Rq97KCwPdrtQJeLG0SSZ3/+rwa5cWW1++T7XP12Cz5L2Tg7wr4PVGNUIp78M6pB
         KmwKP691nLdF4+qK5zeYPFMwBHLhPKlCUKW8fgBbvhH6Kscsv3PaJkxldatsSWr+XXbW
         6s0w==
X-Gm-Message-State: APjAAAVmAYjLiBZGLQmY1mJK7f35tWRlFzfQw6qnfc18ih1bJQ7azBmS
        YmCKh4w2iX63mhXy0rQB7KqXZJ2Coqd40g==
X-Google-Smtp-Source: APXvYqx4LgY3Bifx2WWcUqDQF6OEb5b1KO/8mC2D2/rhzxvLhUlN3+oeHCPBqOk0SzY56AOXTIDLrg==
X-Received: by 2002:a1c:eb0a:: with SMTP id j10mr5112091wmh.1.1562364268386;
        Fri, 05 Jul 2019 15:04:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o1sm11550629wrw.54.2019.07.05.15.04.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 15:04:27 -0700 (PDT)
Message-ID: <5d1fc96b.1c69fb81.a23b9.3bcb@mx.google.com>
Date:   Fri, 05 Jul 2019 15:04:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.184-95-g64da556388a4
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 110 boots: 2 failed,
 108 passed (v4.9.184-95-g64da556388a4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 110 boots: 2 failed, 108 passed (v4.9.184-95-g6=
4da556388a4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.184-95-g64da556388a4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.184-95-g64da556388a4/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.184-95-g64da556388a4
Git Commit: 64da556388a4d23ed15dc5b1f10a44b1123b76e2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 23 SoC families, 15 builds out of 197

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
