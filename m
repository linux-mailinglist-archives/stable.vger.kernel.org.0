Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4EF56F36A
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 15:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfGUNcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 09:32:32 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:46736 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfGUNcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 09:32:32 -0400
Received: by mail-wr1-f48.google.com with SMTP id z1so36619320wru.13
        for <stable@vger.kernel.org>; Sun, 21 Jul 2019 06:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LTTTP2nWaJTFqf90+YLAubZ551IUi2oDM8+Vpm5aEZY=;
        b=ZFfJknKLQ7jFwRY2oANJV8dsjx3QvTaHtQGrVkHEB6QQujf76iGpk7QL3X2ybLjYp+
         TxRKGVYBEviU6OjNymPlVFe/SJgcFWMd+eveYC7/LE9xxVpnMKnDZ3Hj1wdt7el2z8ct
         uvupjFbdc7yunhsV1iGjj06nCVZh9qIXEqkKCxtTYzGWPtm09AqJ4AVZYLmrn9sQ/4D9
         S68kkWX+TMtnagbgAlwT8h/ZZ/LODAjh0/cVH4DEQIAsTZQy+AeBTpVS9ty3nzSepTda
         uZ07dLRaCI7NBG08Tv8fgpvwNGkPBVx9AqKthZ6Vuj5zmZA9RGu6v1/Z3NbpjP7r5h/R
         cUAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LTTTP2nWaJTFqf90+YLAubZ551IUi2oDM8+Vpm5aEZY=;
        b=Vrm2pwzatlPalk44wv8Pf9k1yQ1ukcT3G0n+ljSsuRpxFaETmOu0oHq9+FpabQ2og/
         GHrP45JrQ56jUmTruy1Da2wvRhmB4MpV35Q+wtjw4D7lVClyiTglckZTkubpxImBnr9Y
         2oqNbS7JIypAzFpphke7Lkbyl7WDyFe/FHruLovKUUsa4d3jOZgYT0YLESHB4nZAA3w+
         Dzn0JG0z1uo1JauglkGuyfIuZq0t+x6Ip9hcPdOdf72osqrLO+z2aS40pOPXHUYqumPf
         n/80EMLKbbsFnr7zewPMGKSEp3DaaLSPrfWvQP37OhpN+mpl2HV3FO1lSFBy2czNPLX0
         X0NA==
X-Gm-Message-State: APjAAAWJxMGb6dPU3Opo5q1wzYoEAK9L/Km6D1Wn4AyDLBtDeVQDoEHm
        TCZtiD8+AvjN67LhmpOncinkA/tF
X-Google-Smtp-Source: APXvYqycNvdGPo8CXxkswmVCWdUIhhEMlOsLRMCMXdq8y+bNG0cOmd9M+00atuWiGPTIqL0NgSSJxg==
X-Received: by 2002:adf:cc85:: with SMTP id p5mr65378989wrj.47.1563715949860;
        Sun, 21 Jul 2019 06:32:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c6sm34281805wma.25.2019.07.21.06.32.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 06:32:28 -0700 (PDT)
Message-ID: <5d34696c.1c69fb81.bb736.fb27@mx.google.com>
Date:   Sun, 21 Jul 2019 06:32:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.60
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 40 boots: 0 failed, 40 passed (v4.19.60)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 40 boots: 0 failed, 40 passed (v4.19.60)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.60/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.60/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.60
Git Commit: be9b6782a9eb128a45b4d4fce556f7053234773d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 22 unique boards, 12 SoC families, 7 builds out of 206

---
For more info write to <info@kernelci.org>
