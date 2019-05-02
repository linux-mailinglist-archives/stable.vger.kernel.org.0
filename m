Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0111D118D2
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 14:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfEBMRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 08:17:09 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:42231 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfEBMRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 08:17:08 -0400
Received: by mail-wr1-f54.google.com with SMTP id l2so3024054wrb.9
        for <stable@vger.kernel.org>; Thu, 02 May 2019 05:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qcAuyEXDUupPQSrMTW1owQAH6Ui6j1tNPvDFfQPnbSo=;
        b=tDshAMt/UdM893iCDqudqAdqaO68WcO8nGJIitJWXQuVTQ5LoBqMb3T3/4AO5CFe2a
         yayZQ4cpeOJoBH2uLxsMVQ/8H64Rma2nbL7rQAlcfy5XxDORd7qh26xyBvVN9AJCgnoX
         aEMyPwILd1Js5Vwt1lrS6Mja3LFtY7WVTCNPXpbGGHxtjqeMxwHma6YWxVPGm+/8/t8j
         ieCH5/40kg9YsPTG+penbgQiqPnZVieStXxd/qEKSjzQZKJFQCo1eUJqmxiPe5+Ddi4p
         kwvjH45aHJvFxU8jqC7JkASMJELYesXuoxABBl57mBzsew+w8JEqJVQ8TzsS5EZyC1RO
         CeYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qcAuyEXDUupPQSrMTW1owQAH6Ui6j1tNPvDFfQPnbSo=;
        b=ZI+QNQcWwhYqXGlTIQEcuenR3sa1Topmtl65M6W8LLxqDgzQrc9FYXqVbCSmTXmPR5
         Wt+G1YuG2Pkd4Ufw63XMA+x3DqMdSFXdMLirVGb8t4N2JofxwInCD6g7OBhuh+ySBRew
         /vrY7fToGR+7ijs3SRG4ESxJK6JzNM36M17A9cZhHPSfpNDVZG6qD6Xu/HsWaCUrTdee
         y5X/2WG7pUF2q6H1LjcFFGNtDtXEM/2Um6/Slo8TySFX1Krrhq4MgaaDIhDCorc45GPs
         baT84amEO0W+ozPEIPj9qyBo/4ZsNaE/QBJ4xqswQVRPkB8jDDkf5oHNhBvojC0XshAV
         1Wng==
X-Gm-Message-State: APjAAAXHETsuGlG22yxyz/uxEX3Laq9EAOQcvHOPZv1sXF2VoC3JTBt4
        ubZvkDv/6CeTKzdjhHZJFtE9KF67mRjenQ==
X-Google-Smtp-Source: APXvYqyppWGr4wCJZn8jF41kMPTHd1yYAN+PuIehVsMBBOtzbm6808i0cvYaxd1q1lv2sJPR4gKX9w==
X-Received: by 2002:a5d:4492:: with SMTP id j18mr2438650wrq.212.1556799426764;
        Thu, 02 May 2019 05:17:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m22sm4311883wrb.15.2019.05.02.05.17.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:17:05 -0700 (PDT)
Message-ID: <5ccadfc1.1c69fb81.31d86.68f7@mx.google.com>
Date:   Thu, 02 May 2019 05:17:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.172
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y boot: 42 boots: 0 failed, 42 passed (v4.9.172)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 42 boots: 0 failed, 42 passed (v4.9.172)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.172/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.172/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.172
Git Commit: 5383785aaa49fc5f02adbd29fc01248895f477de
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 21 unique boards, 12 SoC families, 9 builds out of 197

---
For more info write to <info@kernelci.org>
