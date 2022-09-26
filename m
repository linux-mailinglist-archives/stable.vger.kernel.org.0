Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64C55EAD18
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiIZQs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiIZQsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:48:08 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E31F82749
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:41:32 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id w10so6574197pll.11
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=XGdxjoguMsdRjyI5utxhWtZ5tb3QmKEXocbclyMsg0o=;
        b=g7OBQN9B6mIa4/j76Ivb4hUuW/fWZqEQFzPo+d/uN5RCz4EHCKLnQVWuUwfTceY23n
         F7NPvOMxT51Az75LdldA4wzRD4xIZ+pehe6CCizdJgiVfgvEWhnB1lpYQ37pHpQ8gJo1
         c2qr7frhYo0k8kdccYpXWoUMK2iKCHAxtfzG4F4FzDHw/Rgs+QKs4wpQCcSgyZ9ccZ8L
         anZXwslumeQGW7I0oBDp2ErUiHTP9oS5WvItQeGqMKiThu3yaMdQo+rWR2Z4dfnzGhZR
         qfwYozv9N74ren+Wp7wO/WakiP114Ck2JYeraILbTAWM18CeKz3NaQg23okjt5y68Pvt
         zlYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=XGdxjoguMsdRjyI5utxhWtZ5tb3QmKEXocbclyMsg0o=;
        b=XSCha89d5NagfeMdH3RiQ1MUNEdk+OXHiUE5rbYCb/ZxCgtG0LTPm4NHtf+C49EWmd
         OywmMB+4M3Iow55rGmdzvz+bxIcbyvd4Cgt2SpAVhGMpmPwqP9XVE3ETzKRTM/zrJHGW
         YJdU0HUXyVb8ai6nhPM/fmBerv9om8bWUOpP+krslCuK9bn+f+CD0kDdp1bhJ3vqULhw
         gdZE711z6s6lI/BjtYvNFnmLA0oglfmUHb1b3bzxq6Wc4H8LRyp7TyF/7+d6cC4b76rH
         o9qU1yBCV6S1LIYe1c4IfaTi2c0eFelQbSuy/Q2W/559/OoydIFtCeci3sN8kzCbPIuF
         cpPQ==
X-Gm-Message-State: ACrzQf1bXTAZ6DVAgloUVdHnVyYfoA92rikT3khht8cHOcf/siu4t0Ma
        pc5CZJNbp+kzCNjYkvZEe2OyLAM5i3FCuozS
X-Google-Smtp-Source: AMsMyM5L+jHEMC/TbImfRqIpsdodFihhTCl8QkukJttUTZHA7BiYIE1LNXP6GvI3fE2L01WTFP6e2g==
X-Received: by 2002:a17:90a:f291:b0:200:acc9:422d with SMTP id fs17-20020a17090af29100b00200acc9422dmr36075161pjb.21.1664206891485;
        Mon, 26 Sep 2022 08:41:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e13-20020a63db0d000000b0041cd5ddde6fsm10787252pgg.76.2022.09.26.08.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 08:41:30 -0700 (PDT)
Message-ID: <6331c82a.630a0220.bb3b9.35b0@mx.google.com>
Date:   Mon, 26 Sep 2022 08:41:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.329-31-g06c070482de70
Subject: stable-rc/linux-4.9.y build: 143 builds: 3 failed,
 140 passed (v4.9.329-31-g06c070482de70)
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

stable-rc/linux-4.9.y build: 143 builds: 3 failed, 140 passed (v4.9.329-31-=
g06c070482de70)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.329-31-g06c070482de70/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.329-31-g06c070482de70
Git Commit: 06c070482de70aff69961e1edcdcd930fb9cb887
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
