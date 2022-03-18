Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41034DDDE0
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237963AbiCRQKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238603AbiCRQKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:10:13 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5F08CCEB
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:08:41 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o6-20020a17090a9f8600b001c6562049d9so8688224pjp.3
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k3RgUMLK2+fdBuKpHpqxs4dV/8GH2Ivwfa5ieD8KGuc=;
        b=qGUoWbevyWtMN9yM3wmGzs0VPtpOoT5YNQMgF7QU6PEvqlMAj3aFju7/cjnYuNxaiM
         NKCZO3OuzlRajAhhmmfcxQOWqWJiaUkqWxeTOFlkSTroaiHr+ie3vTmzlkVDjzdeSLXl
         WuxLVAlHRWAJGcVS4RB6Y7q2qfAFrBo0PzNGUhuUYX57OS2ebo5TAax9kf/WHEPOC3H7
         ubLj/Z0FFWjqKpHyJR4VwvNiKIMCk2LL6aDJQHbA2YMpmSYthpcqmkjxw55p3qjYUAkG
         QHmBe4JJmoqDsdTPCNEr2UOLrnmSYTTP0qt1zzoCCE4NWUEbeMBdjVDy+bY7ZP/aamTj
         5x3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k3RgUMLK2+fdBuKpHpqxs4dV/8GH2Ivwfa5ieD8KGuc=;
        b=oL7V8fW+GCwYk5HK+yXecWa+nOZ2MLDa7oA8qrGeXeNagXFIPqmsjDib8q/Z38oQxG
         uNS/druEL5mrcfxH2xZ+P0UXH6har9LuZ+Md9I2zSkBtFvuO8z8cWA4UjcblYlEHmGuw
         +ezRj6IlIlDfkYXZssZPybKrlv/lkP3z/mbUqNaovHMQ6YVEHY242m3e1OBVU3zL+Rwf
         VF18H8y+tC3MjGYj6WT71YaMIH0u7fVzGqkCT6LnDm7R8aEwvEK73lr3JFaAQM9cBxnZ
         0mw1RBONzX7eYuKc/f/s/dBniEcv2QkRVPrah0/ITyGlIsyjIhS/0gUKeOpbVXf+MjPf
         PDAg==
X-Gm-Message-State: AOAM530fnS34214NRRJkE4bhPg8rYOo2ynY1zaGYRbPGd26q5Zs8Wh6z
        ixCOJexCrBWd90VHviBC4f9BE1qYbUOGp0rVjHI=
X-Google-Smtp-Source: ABdhPJy9sCrK5BCUzSSfqo9hSalGHlS3n/kBMTZO3ld6I7r2a8B6WFxVbmaOU9ox13qBFWaqlv9+Zw==
X-Received: by 2002:a17:902:ab08:b0:154:192:40ab with SMTP id ik8-20020a170902ab0800b00154019240abmr170793plb.80.1647619720753;
        Fri, 18 Mar 2022 09:08:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i187-20020a62c1c4000000b004f78c98bc57sm11114683pfg.106.2022.03.18.09.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:08:40 -0700 (PDT)
Message-ID: <6234ae88.1c69fb81.b0652.dec9@mx.google.com>
Date:   Fri, 18 Mar 2022 09:08:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.4.185-44-g4eb765392859
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y build: 169 builds: 5 failed,
 164 passed (v5.4.185-44-g4eb765392859)
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

stable-rc/linux-5.4.y build: 169 builds: 5 failed, 164 passed (v5.4.185-44-=
g4eb765392859)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.185-44-g4eb765392859/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.185-44-g4eb765392859
Git Commit: 4eb765392859512cee9488eb5831d73f5b47b4ac
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    mvebu_v7_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL

mips:
    fuloong2e_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
