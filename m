Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704CF1CCCB5
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 19:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgEJRj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 13:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726744AbgEJRj0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 May 2020 13:39:26 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DA7C061A0C
        for <stable@vger.kernel.org>; Sun, 10 May 2020 10:39:25 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z1so3638924pfn.3
        for <stable@vger.kernel.org>; Sun, 10 May 2020 10:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i1+cm8dQA599xSxNT1bMu53gH0p/VZ1ybUBF4Dn6/Jg=;
        b=SvvaVjwHYCvf4tykege4wDBHVgJwlprcz+FsMly/QZYwXt/K0FAcPGwfoePKnz3XW5
         DUb9iHvLxtO0wyJdiCONlaCDCG+v38R/CTe7dgr+UKEpkCLhhu0AGhw4FTT8PmWSvQ9u
         tdQCl3yZ7npQ7nbPsj0hgBAMA6cGEeZTDadzqzwdgZxCd+kZk67qvG43c+nGGoRPrfwj
         BGbRG2fXjRQQhGkoBnrzV017gXxUcXzamjqEtABwrYCB2euOCU1UsCWzta/Vf9kwJWah
         mfsz3xsKZ0trB3lUswCDMM1lnh6yHaDlRpQzoMeqh+eGiBLqVmMzg3nVYjtJ5CNeKz/O
         YuwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i1+cm8dQA599xSxNT1bMu53gH0p/VZ1ybUBF4Dn6/Jg=;
        b=d/A6YwejD7kUHcS1/BUJ6Xn2QE5lrmiTTAMQDB6ooCEHrjEhfrBRFZXGGbRrwgWKdI
         gwtq5Abop1zt5CdF9kDNGgnClX+v6ZkReN1bAfKu6/niifpCI+1cACs53BwZ50GZCF4c
         FEktT9YBgKxIwAsWmZGR0cDQdjyjHrIjYnd799QwgD6DFwu/PBjd8APAIwIpVnNzAZOQ
         IJsJhev+RCaDfUw1mc9oO7f6P6RdF6/oUd8EpmOdBhMLJki20IydYJv7pW8smh9yFzwz
         LRn247jJ3zaHrS+yDISU70HnO0nVI/okDFWuryDM2W038sBbA1PV9nn3YfWla3i5S8sU
         rj4A==
X-Gm-Message-State: AGi0Pubn/7SGjBEwNDcWWXLdcApHJEQ7W9EtBU5kO7r3McLT0kjPHJ/9
        syB79FtdudkXVg18gEfiVhOys4LpyO8=
X-Google-Smtp-Source: APiQypL+SP4kis4zmH3aRcB52vnblfA2rCWgb09Y9llC2NDltpsLlW7WGN0siEH/1DFdKZ53CQB+KQ==
X-Received: by 2002:a63:3206:: with SMTP id y6mr11186182pgy.68.1589132365143;
        Sun, 10 May 2020 10:39:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e11sm5952913pgs.41.2020.05.10.10.39.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 10:39:24 -0700 (PDT)
Message-ID: <5eb83c4c.1c69fb81.7b590.3463@mx.google.com>
Date:   Sun, 10 May 2020 10:39:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.223
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.9.y boot: 67 boots: 1 failed,
 61 passed with 5 untried/unknown (v4.9.223)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 67 boots: 1 failed, 61 passed with 5 untried/unkno=
wn (v4.9.223)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.223/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.223/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.223
Git Commit: 270f791a316d650f70ff3737eab347088a1bd5f7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 12 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.222)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
