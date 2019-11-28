Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71B9E10CFB3
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 23:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfK1WQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 17:16:09 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:40992 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbfK1WQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 17:16:09 -0500
Received: by mail-wr1-f50.google.com with SMTP id b18so32783470wrj.8
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 14:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rHRpWOHeNj1aYoKmYgA3IBfJGV7S6v4uWOij8cW8Od0=;
        b=bijpeWzxBFmqcICNVaTpsk22dzFWNShZMa9s8EhfyLXTiK0OvdefTeGG8eAWyvshCo
         BR7EDLbdvRcTGM3OEuPLXUXA3ARd0aCfDOG7XuYNprZzvIPX7YpCvZMgp8wcHJWecZek
         8dP/dlgmz4xBzFRRrJXi22itSNY1SFTc7C5BAVPGudAd9T53jZpDGf4iajL2OFiNR2Hv
         d3Qi+7BviRo/XkFttEl6br1j9lmoq4pPC9cYLC1ili3gxtf07bnKt8rgLugTgwEHxLKc
         RY5L39zShy1CWb/qkRa0bSC4+2+voPJvggUxI4dJEAwYl0ihrueS2OxDOQ1qkfsmAAkr
         FNGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rHRpWOHeNj1aYoKmYgA3IBfJGV7S6v4uWOij8cW8Od0=;
        b=qE1Yt0TocO/EXaRbmkbYhp3m9RJST+KzW/VrPMmB55iW9nKoQAg92QryDMONV0dzPS
         yPVp8lIJWVcNdYwm9soHB6dalxTQGodwp1zGwmJUMWCpQLULVmmgpz9mRIAGuv7UJJL3
         lPnlDO6BfQxq+/icTSIOFo1Tq3APiwASlx7tZrEFNJixGtUnyMVtVXaxkCfWD3tAi/MS
         cbl+xa7FJKBU2nuFr8aiSXP0S6BugBsk0RCZKYrjU+H5dcR9zkUJCjo2WtPegbhsI3dl
         06qs54vPhIoceQH0J9mcnZZV7P1H8CGcFP14s4TWu6x+wNMLhU1L9X3IYKsvsIW2UD+H
         jm+g==
X-Gm-Message-State: APjAAAWGA/Ob/Y1f2ZdG7sYS1ZLx/91N82YKOx2fsEvTlbOTBbX2+beX
        +vpHeugf9J0N+Zgo0TIrtG3uxUP4aKmLPQ==
X-Google-Smtp-Source: APXvYqyWY3fmxzm1hdN4VYvZFQlSFJSmE9dCYHuzoKYzWO40sCd04ZbuaYthzTv0oRDvEn9GdBvPig==
X-Received: by 2002:adf:82f3:: with SMTP id 106mr5226942wrc.69.1574979365396;
        Thu, 28 Nov 2019 14:16:05 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v19sm26564389wrg.38.2019.11.28.14.16.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 14:16:04 -0800 (PST)
Message-ID: <5de04724.1c69fb81.f9ebf.9182@mx.google.com>
Date:   Thu, 28 Nov 2019 14:16:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.204
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.9.y boot: 55 boots: 0 failed, 55 passed (v4.9.204)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 55 boots: 0 failed, 55 passed (v4.9.204)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.204/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.204/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.204
Git Commit: 95e55e41e655bff0de5abed850a951ff0631ea01
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 14 SoC families, 10 builds out of 197

---
For more info write to <info@kernelci.org>
