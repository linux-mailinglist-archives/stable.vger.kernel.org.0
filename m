Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7617C115E34
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 20:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfLGTc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 14:32:59 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42101 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfLGTc7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Dec 2019 14:32:59 -0500
Received: by mail-wr1-f66.google.com with SMTP id a15so11524278wrf.9
        for <stable@vger.kernel.org>; Sat, 07 Dec 2019 11:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RwXqcGvxI98GyG2t/zkoVZqpm2qfBzZu2zM31Ej7CoE=;
        b=dd/xeDjLyJJKlQwwJdX7CXfJ73vPzA+mUPDIaK967V8RfIMh2+nswHWhK21lepxhCS
         lUQuMwzbvEtbMm2SgEXNdloxQ8A6GBXmAgI25Z35k58+sInjKCpVyF+U0UhBoiwZz5Ds
         5TLQ0Ti+3yN+qsS7Wmi2AERoo9TmdLWibOUCiYSpCSx4I24QpFvOlVEplL5/RMsxJXSF
         IzVvxWRPuCzNfgRcPFe4u2ZPBcghsJ0hc4ZbQxUfSDezQnxggeg7iTAEYYJ195Lp5iLZ
         scXt3nI7FRhSBD7flPSIvl8Y2T77hk/fxagMNLFdC39qF37JjbAEjXy4zLlkIF6mAk2R
         foaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RwXqcGvxI98GyG2t/zkoVZqpm2qfBzZu2zM31Ej7CoE=;
        b=B0T46jmECPUNJyoOuRIolF/mfoprSf9xuYUzrDbhWM0F9kMwciWBE6tr6zw35+naTS
         z1nBoJN5OcAgN2w4Ilkc0zCYIhVJ2nAU6UVtWbq5XkAPK/vZk3ur7Afav5Ah602dqb6/
         Uqg87K/tq9HxzG3CfNOtCYbo1AfdCVzGCIKAEPqDL8XmQUc8OCYBRkJ9Rh86GBabjhC4
         PTWwxhXWEiT2Q4S9jpFFnbUySzZblGfJXvkgBxIR9Hu7WYMUrwrprvqHyFnon4FV4e+T
         dOFI1kyBm+FRIYsLFHRMNx3wZAafw+EW50si/bTApiATBfc9Sfy0CxxJt+OjYFzUE1eS
         KPpg==
X-Gm-Message-State: APjAAAV284sp2mTViMu6HNamZt4OsAxV7YE10DG66Jxt0FinQGdY6zuF
        1XSSpegDirG8LyzeMcd6i1DzvEwIkNE=
X-Google-Smtp-Source: APXvYqwdNI4wqUtBMLypvuzLEracrRUSnWkoK4fSjf1aLQwMJjBrOhI/bF2+EM98AewNCBYA5MNt4w==
X-Received: by 2002:adf:de86:: with SMTP id w6mr22767457wrl.115.1575747177517;
        Sat, 07 Dec 2019 11:32:57 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s16sm20781966wrn.78.2019.12.07.11.32.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Dec 2019 11:32:56 -0800 (PST)
Message-ID: <5debfe68.1c69fb81.45272.2190@mx.google.com>
Date:   Sat, 07 Dec 2019 11:32:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.158-127-g4a1f1500dc87
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 34 boots: 0 failed,
 33 passed with 1 untried/unknown (v4.14.158-127-g4a1f1500dc87)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 34 boots: 0 failed, 33 passed with 1 untried/u=
nknown (v4.14.158-127-g4a1f1500dc87)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.158-127-g4a1f1500dc87/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.158-127-g4a1f1500dc87/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.158-127-g4a1f1500dc87
Git Commit: 4a1f1500dc872169163a9e850dff56e79368f234
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 25 unique boards, 8 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
