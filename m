Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1B05EACFD
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiIZQsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiIZQrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:47:41 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8808A4D4E3
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:39:54 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id l65so7071155pfl.8
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=L9ReruiBM+PhMwh7ECaMfNGtSvP32AN+nfwAE1bOSOM=;
        b=tSm9GTEJWw8A2zNRQNe7AoxHZx8v6jWagMyACYf+tLj2S+kWjMk4uOMU+Q9//bfNOe
         62L2d/1wHTzotyat+2FldjUBPkGVJhjVSDgmDpx7F8ySZh5qtF1tzALOeWyohhdrIpL5
         /ek61uieCYkWtiGyIlRAheo0ArqSoMKQn8Me/VV4KIg9lSc9hU5OmqVF3+ogI8LMONZ3
         Kuu4FnHw0zg5dLezhnsHqyW0TnLUmjZ5HuOCop/CyPrx0B/nvY+GimUTO+ZbRYKBHuxL
         vXO9Llk9C1F5JZ+36bJZNvIV5lvE8VMwQqEkiTgh9RdKoLxZPX7YDEPVjnpHF2CfUVSH
         JQ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=L9ReruiBM+PhMwh7ECaMfNGtSvP32AN+nfwAE1bOSOM=;
        b=kXyI/RhE1fCz7SGDA4AyJDQv8GKpNquBLjVJGtFdIDQziHf1+z4saie1xjpMB5TdUt
         andeCaPTdp4RUwqIR1CFp+YokC1+YGnpTa7jQXHnMsTRHw1PBRVZ4hkfoqrG4HgGZ1TH
         KCJjwiK0/QEA+kaILrS4unxDKtIJTMNLB32WGzzdr6HKF46eecHMmZjta1zEK+t3I9bE
         gcLBajS7pr/xfRSzia7BGx6JuyA/EmkUA7jOcTB11K7aC7HfxlYYVxbyCNR8DS+yE+9t
         DbWspE+AxOoi9u/6DAkIeVhsvu39XcbQHxr4YLHCoBiII/y7j7ZqK/bXWcsNNmhK3AzZ
         HXjA==
X-Gm-Message-State: ACrzQf2UFyS6wEGXOeSey/8dm0tmv/t7bS4dWWXAvxZ8BC8DmSzKMdWd
        RDsuUGqgt83tWdb2UVl4uvdHF6JliuENYL4w
X-Google-Smtp-Source: AMsMyM6RwEVPGfx1qNFe93g1qNJoDelUPA+FR4iwjp5B/hWbQqGHcz3ydND4tFXJt8dEZ7evFdJGIg==
X-Received: by 2002:a05:6a00:10c4:b0:542:a69c:fe9a with SMTP id d4-20020a056a0010c400b00542a69cfe9amr24657180pfu.6.1664206793764;
        Mon, 26 Sep 2022 08:39:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d80-20020a621d53000000b0053e6d352ae4sm12410420pfd.24.2022.09.26.08.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 08:39:53 -0700 (PDT)
Message-ID: <6331c7c9.620a0220.d42d9.631f@mx.google.com>
Date:   Mon, 26 Sep 2022 08:39:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.294-40-g35ed75d1c045
Subject: stable-rc/queue/4.14 build: 118 builds: 2 failed,
 116 passed (v4.14.294-40-g35ed75d1c045)
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

stable-rc/queue/4.14 build: 118 builds: 2 failed, 116 passed (v4.14.294-40-=
g35ed75d1c045)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.1=
4/kernel/v4.14.294-40-g35ed75d1c045/

Tree: stable-rc
Branch: queue/4.14
Git Describe: v4.14.294-40-g35ed75d1c045
Git Commit: 35ed75d1c0454f2c70a5d1077cee6ab8c207456e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
