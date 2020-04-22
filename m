Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804731B33F3
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 02:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgDVAYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 20:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgDVAYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 20:24:21 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D06C0610D5
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 17:24:21 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o10so198563pgb.6
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 17:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a1Gg8wNneCphgtVp98HY4dBGj0YW5dFS2hfrl0OMNOk=;
        b=ulyODzxScszPlGTNXwT9Fa8rAzUwFLWHi0DhTkA/vEFvpoFwzUvI1c/yXgp7bVHBFr
         /8R5omGjhxxO6dGr3+Jc36MMitqbTT6/A4MFENaj2qBi4gxFzRCrf5JrYjszJ3kYsNnm
         jCE4RxRS+QrPlGgXcJ04Jad1kZzrD/Xn/2QWN3iyel1C9BFPHR59qfRM86EaXM1onmaP
         Xj8t6akAbKNJj5GZPvjuwIXOvTubZnRVtSnzwtBEetlVTIxBLU9VTLHN9pdgGmuEad6X
         NJJEqP4JlwIz0umCwDE4BRxb26s5WkFrySpPm5LHa07veD+nJEcZyXZTRvVgVAIS4P+1
         XLyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a1Gg8wNneCphgtVp98HY4dBGj0YW5dFS2hfrl0OMNOk=;
        b=N94vI/aIPJInvhuRRv1szylf0fQKwZVQ9+K9ExsFyHY75bjyEVLGUe2kvr65WiIAf2
         3FW3WV3KFscYPybWdRXNF8tVoyGmEE52hBWK6PGv9GX7JoMiG7BlW554y8F3HkpAT8uF
         y7fiaRaTRcPGVn7Shaeic4d1mtFixVUPwrM3Fvu1Wsgo6PH6HvX/J3L/fflcgyhfkJbg
         UGkyR1xgYyzLUG1uTg4S8hf6bYL1DskQwWn7x0rQvceHe7FIAT5rOBn2s0koeSkrpHtE
         NsVie5LfLkHgkGCttolzwF4a93tDWXUvDYf0uHZ8DBrqyc49AUjzDf+n4SaN9apoQC5X
         YIfQ==
X-Gm-Message-State: AGi0PuZ3eWIu8SW+yrFEvulKZdaYuyu4TLM+DN+eH7oOdbDqftk/qjBs
        eGZ03PVFEQyG/fQw55GmK0/wYe/78Q0=
X-Google-Smtp-Source: APiQypJavxGYCFXRTJS7EjvWkQwe/SczlXaHvj+Yi8VFXRxKKY1lPXb6FTt0Dz48qakZdhDc/c5gdg==
X-Received: by 2002:a62:144b:: with SMTP id 72mr24806745pfu.246.1587515060665;
        Tue, 21 Apr 2020 17:24:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q201sm3679124pfq.40.2020.04.21.17.24.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 17:24:20 -0700 (PDT)
Message-ID: <5e9f8eb4.1c69fb81.68ceb.d1c5@mx.google.com>
Date:   Tue, 21 Apr 2020 17:24:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.219
Subject: stable-rc/linux-4.9.y boot: 36 boots: 0 failed,
 33 passed with 3 untried/unknown (v4.9.219)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 36 boots: 0 failed, 33 passed with 3 untried/un=
known (v4.9.219)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.219/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.219/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.219
Git Commit: 5188957a315f664d46ff58fedecbc0f7503f1b22
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 8 SoC families, 14 builds out of 197

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.219-84-gd7b7a33b0=
609)

---
For more info write to <info@kernelci.org>
