Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002534DDDBE
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238447AbiCRQIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238911AbiCRQIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:08:24 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A08950B15
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:07:06 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id bx5so7759500pjb.3
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7HDcnRKd+ZAxmGHrOq8N4w48Boq4SOoKD9R1o5yjze4=;
        b=lcCxsb/3vKwKDx00WFtLxt85Ot77DvIfWRW9hxjvWCkOs/LaxCUJUBgMHGrOriOK+j
         AKNGhsusMxGhLO4MgQINRUB0HQoPy86Z7TgriiTestB52Qfssz3GOiPQMT6t9oFpTsHd
         bJ8UOB/v5t0srSqug9wL/vL+0Dw8EIh2gWMY5euulhOo/iiyXBAEVSIhBurgVRV7agw+
         Dt2XKOzZB6ZedRqYcRzzHzrf//C84JyWi+fYheRmGYpgzeGEWl1t4PtqJmRxaTxJ3fyC
         7eBVNvySv5JV0J0YPsVR3UfWlUGrpQOJjoWGzpCZPpzKzsFWeJ8x/GrAkdnijSOUKdRy
         hA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7HDcnRKd+ZAxmGHrOq8N4w48Boq4SOoKD9R1o5yjze4=;
        b=LTBIx2TjnLMknc7Z7YvgCzDmFKobrmpVp5MwA31Czqdbp8iT/ceHm08E/V0vLG+O3N
         K5e4OmST8WTAXKLXTJVAd/cKVtRlhLLXowJ9UogTnmGnYPwXAo7MrAGrx7/7zaxuq2Fg
         4Bh1GDxMD4oEV6N8iKRKOpwyniE5sBwIa+MaCoG/0wdTrjEB014FIK6zxrIsbHGvZPfX
         +wX2HKnp3xJdKpFPjERAJxaVNgz2/87z6/rIr134hWZXHhYhjT0IIE6UOIOyynnwP3fP
         1hH4OnDxk2ZchdaWfe0AJrAMdLVyGauQJRAftrJ3ij8FOoQt0FzIntEY9Q+T20qCwAyL
         R4vA==
X-Gm-Message-State: AOAM533nHKU27mQaGzFi4Y/6OVO8tIqGaD0Q1ozUvUaxRRKsoITByUxJ
        4pxpBjiHbHIAgbfhfWYzqorN9HLBgkKIYnldpbc=
X-Google-Smtp-Source: ABdhPJzQAQt9EnZg0ubUTYmKj3TYKGDSuUAOcsBOD6DELo1XPwwrZUIyO1BVnz8wxwNUxkCKx3awAg==
X-Received: by 2002:a17:90a:4306:b0:1b9:80b3:7a3d with SMTP id q6-20020a17090a430600b001b980b37a3dmr22336045pjg.66.1647619625709;
        Fri, 18 Mar 2022 09:07:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 2-20020a631342000000b0037487b6b018sm7729804pgt.0.2022.03.18.09.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:07:05 -0700 (PDT)
Message-ID: <6234ae29.1c69fb81.ddca6.532d@mx.google.com>
Date:   Fri, 18 Mar 2022 09:07:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.14.272-14-g545838981be88
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 build: 182 builds: 3 failed,
 179 passed (v4.14.272-14-g545838981be88)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 build: 182 builds: 3 failed, 179 passed (v4.14.272-14-=
g545838981be88)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.1=
4/kernel/v4.14.272-14-g545838981be88/

Tree: stable-rc
Branch: queue/4.14
Git Describe: v4.14.272-14-g545838981be88
Git Commit: 545838981be88944910c34aa01304b62f6518b3d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
