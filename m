Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0993DB9D88
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 13:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407530AbfIULIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 07:08:06 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:33747 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407437AbfIULIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Sep 2019 07:08:06 -0400
Received: by mail-wm1-f45.google.com with SMTP id r17so11312494wme.0
        for <stable@vger.kernel.org>; Sat, 21 Sep 2019 04:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nT8l5H5U5ZOSCD7gfiBr333et8R5BeYGqpkjuK0zw8U=;
        b=h6tzc93GJwDUl5xqTGnTP4UM1/FFCR3dV7SFdbJjgHz+11+FWGCHj3OOJ02CR/NSx+
         PWnhYmZ8fTg6eoMequg2oDhAxvQS8z4KV0UGhrj+LsJ4MjHAm/uFemP5QOCDWX7GbkFM
         91Uhpaod0BJtmM4YoJeFWA5R+0iHwdma1i+S4ZCtczF65xeZ1Hwu73lY2npUMjC5Dueq
         kbnk1E1R5BMu62+idSmgYcxyBkir++smip8UJUFPMRRZUeQ+fAuPy66Hc53k9+8SzqGm
         3Ke7xbE08Rc/ZqcSQ1ydErNBZya0/Snf46pzzXBVJMnD3p9QzhtweHYEltvWAO0kCZXJ
         aHiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nT8l5H5U5ZOSCD7gfiBr333et8R5BeYGqpkjuK0zw8U=;
        b=kzL5oSS0eFWCrJPw1ZIjSiUuuhie1+REZkqnt5Aaj/9z9oTWfc9AUsgg8AuU/Sfvoi
         46A5Powl958Bn6m69lJbGHyW5lpCT+aNJEPvMNuDDoy/SXm96a0fFcY98ycoR5cygwX4
         9GhCLfIKvTtqcvAyzG3F1XhA7Lm//5ZLLycAj5CCZQgopVWahWMd6lG2PWSbNzDTJugA
         XDDTiRNYoOzDX3cBiCjWSPqNpjzUY9CUUXetyDxxR6B0PX3Nr4+WGteTHXqHDLmf/8QT
         7uyBpLaJ4EO7Ei8iPOCwYWWjNLjxnAij8IzpmclyrzuT8rpIsteDrxxkJVyftgxH5Ub1
         kX2Q==
X-Gm-Message-State: APjAAAUY9x097XkYmmb+BNjR/TGvYBlL27GnCiqr22wnAehcRI+695Pp
        ByPumPBEbytyzl0/KEuCMwX/HAv1zCEFRQ==
X-Google-Smtp-Source: APXvYqzvUvJx87VtQtPMq3cDPD+cVZvPV95vIl25YEvpCPN1uGT1mbdSUqGKUMwSoJPBdoI+UBZG9A==
X-Received: by 2002:a1c:7902:: with SMTP id l2mr6777370wme.55.1569064082378;
        Sat, 21 Sep 2019 04:08:02 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e20sm9645892wrc.34.2019.09.21.04.08.01
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Sep 2019 04:08:01 -0700 (PDT)
Message-ID: <5d860491.1c69fb81.7617f.365b@mx.google.com>
Date:   Sat, 21 Sep 2019 04:08:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.146
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 76 boots: 0 failed, 76 passed (v4.14.146)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 76 boots: 0 failed, 76 passed (v4.14.146)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.146/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.146/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.146
Git Commit: f6e27dbb1afabcba436e346d6aa88a592a1436bb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 38 unique boards, 15 SoC families, 12 builds out of 201

---
For more info write to <info@kernelci.org>
