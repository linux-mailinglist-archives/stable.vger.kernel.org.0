Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6041518A5
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 11:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgBDKOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 05:14:02 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35275 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgBDKOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 05:14:02 -0500
Received: by mail-wr1-f66.google.com with SMTP id w12so11299315wrt.2
        for <stable@vger.kernel.org>; Tue, 04 Feb 2020 02:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FDmHlYgj+UPAbuow5nbDjn/XMMrPvHlSr6q0w5GwAvw=;
        b=TtmCmtbzGja10RDr58FUt04DMcTb//0MnB51ThkA9+m8qwTDxac2FpmVzH9M9TlCoL
         +vByx5MtQr9SLn8oUF87L6UW7bXLM12DvY+69jT0LB+8Bap4cF6Cl2aLJSGasBPBGy9L
         nYj79GF827BzYHAyNXJFxsG3UzyZBHJTnrtNPxQoqkDgzA+K9DFLxX53YlUlzKL+MSkT
         xCTb/fThyktkan1RzSduOOLarmV7YRiEVNkeN7MgeOAdZ+cvBHC9UMRfBaUVCdKf5bOi
         PLPr6X9MmyBfHCLJOPqMFpMcTe9rhzrM/RWTyvtOpJrjVlIEwZWnODxWnaLlVYo4TT0F
         aT3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FDmHlYgj+UPAbuow5nbDjn/XMMrPvHlSr6q0w5GwAvw=;
        b=RTnqCK9xeRjx5qIFMl/LSJwhXhBsksLtYhMJhkOeC+9Uwv5InMASEX3W+Wgj3tIN8H
         y/pA40aYJKgkn/bxAyH/LoCxiQ7cLXLDLlZOP3+CM1oi8bb1svYgNXNrTfwXbHOKAhnU
         p8tTX9tm8dXMQbaDI4bGeQ14gwz1Dv0GhJ9WrCbZzShtTgfKPGxZuQ/YUIFhaKOpLtBH
         tm5Xp8HNIM65Vswk0Uo/tPQIZoRvHOd86Kjd0VhvLROQNDZ1HRS31lk8/C5AQTZYoi2Y
         kQWoAGkpBm9oo2uwOGNpujL/bdQplLEyBEbLE0OBAI8Ygf9yrHw5KQiUcyoSpcsrW1Ah
         KYSA==
X-Gm-Message-State: APjAAAX2I6viwkYogRolB82IQHECyr2nNsEnYL42VoX7BTqkW+jggfq7
        XA+LufWuMkoJfOLMISa43qqw0jpWVvr33A==
X-Google-Smtp-Source: APXvYqzKjGVs382LpoWqqtdsVsjfcAWFgh87rasr7TKLk+L0ZJUdnPhaCfGGF9B7EZsdyBeL+A1FIQ==
X-Received: by 2002:a5d:4f8b:: with SMTP id d11mr20357633wru.87.1580811239127;
        Tue, 04 Feb 2020 02:13:59 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m21sm3156490wmi.27.2020.02.04.02.13.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 02:13:58 -0800 (PST)
Message-ID: <5e3943e6.1c69fb81.c13a5.de1c@mx.google.com>
Date:   Tue, 04 Feb 2020 02:13:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.212-56-g758a39807529
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 12 boots: 1 failed,
 11 passed (v4.4.212-56-g758a39807529)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 12 boots: 1 failed, 11 passed (v4.4.212-56-g758=
a39807529)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.212-56-g758a39807529/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.212-56-g758a39807529/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.212-56-g758a39807529
Git Commit: 758a39807529795c804023beb3dd12d9494760cf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 10 unique boards, 4 SoC families, 6 builds out of 149

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
