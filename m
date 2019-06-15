Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E172A47095
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 17:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfFOPBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 11:01:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38658 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfFOPBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 11:01:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id d18so5442394wrs.5
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 08:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oBkMJfeGQ/YleJzovi2qzvvBeTarHQ5u9A8Dq6zLzDY=;
        b=enX+s2uNiS2WTokeVt3+QkcIcM2A7/5YrpPzImpIDTSBi/XKgonXKtilQ/stzC75ir
         VBP2gcjUZSTpwF6I287Y0BIDJcu+diof+wk7Gz8B5big5sGFqTqjPriYvABA/UN0+3Np
         Cv1ojOfKWzwriibJ63ajkP0S1mNavngWFBdM4xQAKG4/0BW40CTh6xKLPNddIF2N0InY
         JIfYiG5GDMs39UC1+6Vh2TAYyHdRsvM8Pa6dEbxqFebsZqitqSudSiHRnDQFlHRzQHEl
         DHkaqKjdBsiUEP3jX1nx1EAfgKOYmLDcUalZuqSblA8l4NG617cESmlsHQXNvvRMcX5d
         vJFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oBkMJfeGQ/YleJzovi2qzvvBeTarHQ5u9A8Dq6zLzDY=;
        b=uJAsgyxXbKe3ETWgEuW1Nqls1kbOyrcojkY7keEsBY/kWC24AFM2bqu1FaK8IQEHbG
         6hrAoXowTJRtUABlDZX9iRbqdoPyvO30/DTWdkCCaUteVGqqmzU95J/4GW/hFbI1Sr7U
         hR9NHkrCG4dxb0goxIvoxzJo+zoqrv9rMWBrKI4vDZ5Q9ZO9HdMsvJSf4aoCZZABOtO/
         x+E8zDmBeCA9DE8Zu/S6cLWXDM37mXGtHtd36rgdPEhe2uIZ1IIKgaQ+B2UM+mMrEhFn
         mA7Otg71pAy12angZHUWsfksetCeDsbJO5Fl7XGHZlWIhl/drb/Xzok//+Fp1fjUavqS
         P1YA==
X-Gm-Message-State: APjAAAWmRdIzs5MFvBnn6OANxDROnn8WmqNAucRvSldcNH1rKjaVlwTn
        BY5WzSuhvSG6mqR+Y+3vWoTQ4TrJi7U4IQ==
X-Google-Smtp-Source: APXvYqxo/lFL1P0A8+s7o1hrWkhvCZynMDTBK2qJypgd7uf2l7FK15uy/UDLJqY3aRIZmTWqAEjr6g==
X-Received: by 2002:adf:f8cf:: with SMTP id f15mr54320609wrq.333.1560610875498;
        Sat, 15 Jun 2019 08:01:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 74sm7769534wma.7.2019.06.15.08.01.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 08:01:15 -0700 (PDT)
Message-ID: <5d05083b.1c69fb81.734b6.9f2d@mx.google.com>
Date:   Sat, 15 Jun 2019 08:01:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.51
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 53 boots: 0 failed,
 52 passed with 1 untried/unknown (v4.19.51)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 53 boots: 0 failed, 52 passed with 1 untried/unkn=
own (v4.19.51)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.51/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.51/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.51
Git Commit: 7aa823a959e1f50c0dab9e01c1940235eccc04cc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 15 SoC families, 10 builds out of 206

---
For more info write to <info@kernelci.org>
