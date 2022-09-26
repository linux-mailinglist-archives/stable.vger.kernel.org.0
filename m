Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3C85EAD0B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiIZQs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiIZQsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:48:06 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE37682627
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:41:26 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o99-20020a17090a0a6c00b002039c4fce53so12848412pjo.2
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=T+tpHwnVdcynfgzT9LjfAIKy4U9JlMvTyWMXFx1In74=;
        b=N3U1U2cARRqOnYcjNbRRwrdiBFBCQSku4sy4iST8SGgcwXuXMRfp3erznXwkzHtgD/
         HRXJJcQX7JjDyX2/2TjEYkHe4i2GdgWQMiqbT94WWjj522WOiTwvQwUAWFqULatY8hQO
         8gbu7HRlTTCDZxlsMUrEIxNq/1S7HDqppDnW0+5Kahe+AHK7equA892EOLLRloqMBw4h
         wThJj0eAlgfqy4MUohVM7+zGIq7demG6acxvDXLffQhWoCHpyouEk3VpRQ+sXk0hgRNg
         K/DNGfZe/+/ln9qEb8a2j+snTdfN97nPZgIKNb4siP/qFBr3jIsjB2OijD2i0i9FzhD+
         DEsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=T+tpHwnVdcynfgzT9LjfAIKy4U9JlMvTyWMXFx1In74=;
        b=EgTh0hIw+VWzlLeVqRrCjX8nIRXXwZcOTV2pMRbqADIf5dsFDRdHXG3Is0MviRSLRU
         vABDOq30mEmgIEvEypsRoePe0Cd/R6M+EQ95nnN8aqvFdpg45WnuEFOc9d5i9UShAgNa
         ZQvnIv+i/GyukPe527hNzNjUbXCCXw96iaxdhzbLxlrWU4ZtmYCRdgznYQ9Z8vDS+N/9
         AUB33nN3TO7y3++pvxXtsCM0MC4lE+p2E7s/8lcG22UkMFAMI64IlR02X5VKPUiaE1LH
         p5nf5zIQV2f/sn9AfstJdorCPv+UMyN4f2r5UrcCjGamdhppU18XDAoWFj9y156whvuH
         F4ew==
X-Gm-Message-State: ACrzQf3oCKzzhAhKrdM0yasDbmXlpe/jeYMvOdzkKMAxnUJtU6v4E1Ya
        TBSuuJPM2y04X7gbHG3maHGyVF3uNiD5pibu
X-Google-Smtp-Source: AMsMyM4lUZ1Orwt8GK2tCXXJ+g3fAoXhxaFdCATctZuE6JHR8cyk625pByPfN6zEZnzp5kG1/fhd7w==
X-Received: by 2002:a17:902:6bc8:b0:178:81db:c6d9 with SMTP id m8-20020a1709026bc800b0017881dbc6d9mr22903109plt.56.1664206885971;
        Mon, 26 Sep 2022 08:41:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w3-20020aa79543000000b0052e6c058bccsm12356374pfq.61.2022.09.26.08.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 08:41:25 -0700 (PDT)
Message-ID: <6331c825.a70a0220.3b691.6181@mx.google.com>
Date:   Mon, 26 Sep 2022 08:41:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.145-142-g958deb58efc95
Subject: stable-rc/linux-5.10.y build: 146 builds: 4 failed,
 142 passed (v5.10.145-142-g958deb58efc95)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y build: 146 builds: 4 failed, 142 passed (v5.10.145-1=
42-g958deb58efc95)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.10.=
y/kernel/v5.10.145-142-g958deb58efc95/

Tree: stable-rc
Branch: linux-5.10.y
Git Describe: v5.10.145-142-g958deb58efc95
Git Commit: 958deb58efc95bf50ed88022e576486883107baa
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arm:
    ixp4xx_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
