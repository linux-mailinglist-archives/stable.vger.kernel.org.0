Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B915EAD08
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiIZQsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiIZQrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:47:53 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8341280E8D
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:41:00 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id rt12so6687834pjb.1
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=R6xIIeyfknRj+BENFppL2+zlJvdsaFm7N9qT3mT8M50=;
        b=wpgjeo7VwVGmvZXmpK88C8inKoNZSG8tQE/snp2n3Vfqn5PPOIkVayVh8Hzdm4vZ04
         HPrjAOkT0ImU5cZsVfSn8y6La2Ss107V1DVdOF80R4y3ZdrrOoVIW/flJA7MvohheAys
         PHBhK767VwqNc52PfduTH+9M/PCZZ/25WmMNMlEE3TjmfeDkMzlbeZ+KhQrqtR0i+Use
         n9cNZzu5+q4n1NA2x7zDn+1ugsbFe/fpCwc4wsAJjpGcPfKFOvjS2FMcmM+QPZny8t1S
         IKheQW7RlP/ePHmV6MKJO6xwZWEIqOHjMT0jPqfyEW/d1imnwr+bMakgsA+kTIgjmEM+
         NfwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=R6xIIeyfknRj+BENFppL2+zlJvdsaFm7N9qT3mT8M50=;
        b=IJiU5CoFAFA5165w6x4JU/28OoFkYGK7jtV7x45Y31/aM+Qjk0Y7elIYJhfkpgOShs
         lgDMfDOgc3R1PP15A0986abDBwXYeoyJfChIoYy4Ylm5EqLUUnX7k/LJ6unn3nPtE+2W
         ReaFCvDOwBurs5Ci21l0Wq1MC4+Kq/Tfe1EpDRzFrE7vwXBN8xXS14PJ5u5DF8t0b+DH
         dFyPlT2Ba62LKd3PhYidxhfeTJO7/DVe6ToRZMT4piZI9F6cn54d7y6tcgXRXvZD588p
         khWqng7h0HdGuFGROezKezxcvvL9CVlRBpsHQdJpmgjyMk7YdbHDoGftUQrW2psPzzns
         axDA==
X-Gm-Message-State: ACrzQf12jC0VYs8wwaAM3eg6y8aHTG0n8ynz4571ZMGDRotqXgnsnCE0
        O0r0VepXyrUSDhxZXKEr3RG/cvtLf4y4UZtJ
X-Google-Smtp-Source: AMsMyM7YqW+mbysqN4XekO+SqQGtprxEHFWai31RIR0hCG0lf0kLUS1S8iHwCtW3bs1+0ohNfhk2BA==
X-Received: by 2002:a17:902:e547:b0:178:43de:acac with SMTP id n7-20020a170902e54700b0017843deacacmr22862181plf.39.1664206859779;
        Mon, 26 Sep 2022 08:40:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o5-20020a170902d4c500b00176b66954a6sm11445362plg.121.2022.09.26.08.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 08:40:59 -0700 (PDT)
Message-ID: <6331c80b.170a0220.e6fa2.563b@mx.google.com>
Date:   Mon, 26 Sep 2022 08:40:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.214-121-gef5c94b48b06
Subject: stable-rc/linux-5.4.y build: 166 builds: 4 failed,
 162 passed (v5.4.214-121-gef5c94b48b06)
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

stable-rc/linux-5.4.y build: 166 builds: 4 failed, 162 passed (v5.4.214-121=
-gef5c94b48b06)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.214-121-gef5c94b48b06/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.214-121-gef5c94b48b06
Git Commit: ef5c94b48b0675b20346ca44973d0e4c5bf6ce20
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    ixp4xx_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
