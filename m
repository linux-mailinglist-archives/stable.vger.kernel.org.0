Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929F333A918
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 01:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhCOAc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 20:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhCOAc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Mar 2021 20:32:57 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E98CC061574
        for <stable@vger.kernel.org>; Sun, 14 Mar 2021 17:32:57 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id x78so32938657oix.1
        for <stable@vger.kernel.org>; Sun, 14 Mar 2021 17:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:autocrypt:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=AbQ2rCEm0FekWWmPiTAjRcc6KIyFhnyP/uBqst5gavA=;
        b=gKcaS5TT3Nwo4XQNStfQIpBqsOESiriui9bitrPfFFiV/jDGBIKm+/ey8PCCB8XwR3
         ARxR1E6b4eck6HwCFmvvShyc8jA0VskPAKWMAq+QkoP0/9MOC1Slk329iDfqjK0EBrYW
         XUQCFjsnzGrfY0fRGwtUiFKElKP+muyDq/dzMvaIMwGGmyO0xYDrEIt6Tns6YvU8xwB0
         siwj5G+jg/S1iCigkmVMizWc/aBNgXwjq7XejGPDIDR4Xor/pTxx2hb6VGgSiT3HQFFC
         mBUhtymnPrSDt5O9ij/a9SbqQy4OXSrIl5vF2pPkFtdENZUEBTOx/xtZi78YB76yuFzw
         rIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:autocrypt:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=AbQ2rCEm0FekWWmPiTAjRcc6KIyFhnyP/uBqst5gavA=;
        b=Kk30EI/7IQb9RFsGntBq/5ZHvAtCV5NGngb2C4dN9DlU8TmQzX1TKEqA4Es1GEeZkW
         /cz96xJfRc3i9Wy1GHhtitImuFF1ULE36BRnmMVQaiM6SDh5DPwyfAjpwoOfgoUp2LEH
         Q30nDwKdjYww2NfneDV8HajH44W/4GPX9OQCkmqV9/PvnScCyzJi9RyJzGw0xb/kFnSg
         z9xNVuAdgD4qxKqj8e6yrcn62eD3o2S5ISgex66/OPX5gluYkfXOwOL+fQEcY1pNdH+9
         wMpTr4VFEimDoRiw/vVWFv+qEMxmMdahGBHvQafSEH0c9almMw2kJwEk40kZh8SNcYHX
         IaoA==
X-Gm-Message-State: AOAM5328WC7rNVpGclyGYIEXG4Rz6j5LFp8afhVlBNDF2y0zEjmV2FRE
        r1Lc+R0vYZ6tdRjCJylgSDqweoItKK8=
X-Google-Smtp-Source: ABdhPJzHbNF2eszZ+2nehIZwhzo8vLo9V5r5sSonXkkrF8tqHndQqErDGqhw0Lv+rNGF2Xg9j7d+Qw==
X-Received: by 2002:aca:4b03:: with SMTP id y3mr16839511oia.162.1615768376759;
        Sun, 14 Mar 2021 17:32:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j72sm5868420oih.46.2021.03.14.17.32.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Mar 2021 17:32:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: v5.4.y-queue, v5.10.y-queue build failures
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <066efc42-0788-8668-2ff5-d431e77068b5@roeck-us.net>
Date:   Sun, 14 Mar 2021 17:32:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Building mips:allnoconfig ... failed
--------------
Error log:
WARNING: vmlinux.o(.text+0x9cd4): Section mismatch in reference from the function reserve_exception_space() to the function .meminit.text:memblock_reserve()
The function reserve_exception_space() references
the function __meminit memblock_reserve().
This is often because reserve_exception_space lacks a __meminit
annotation or the annotation of memblock_reserve is wrong.
FATAL: modpost: Section mismatches detected.
Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.
make[2]: *** [scripts/Makefile.modpost:66: __modpost] Error 1
make[1]: *** [Makefile:1100: vmlinux] Error 2
make: *** [Makefile:179: sub-make] Error 2
--------------
Building mips:tinyconfig ... failed
--------------
Error log:
WARNING: vmlinux.o(.text+0x9130): Section mismatch in reference from the function reserve_exception_space() to the function .meminit.text:memblock_reserve()
The function reserve_exception_space() references
the function __meminit memblock_reserve().
This is often because reserve_exception_space lacks a __meminit
annotation or the annotation of memblock_reserve is wrong.
FATAL: modpost: Section mismatches detected.
Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.
make[2]: *** [scripts/Makefile.modpost:66: __modpost] Error 1
make[1]: *** [Makefile:1100: vmlinux] Error 2
make: *** [Makefile:179: sub-make] Error 2
--------------

Bisect of allnoconfig in v5.4.y-queue:

# bad: [2bcbae06b8fb9030973ee996e1b8ed43f3bfd4ab] Linux 5.4.106-rc1
# good: [ce615a08404c821bcb3c6f358b8f34307bfe30c9] Linux 5.4.105
git bisect start 'HEAD' 'v5.4.105'
# good: [bd6952cc4634c2ce46d5c9615c4b9bc66049bab3] net: hns3: fix error mask definition of flow director
git bisect good bd6952cc4634c2ce46d5c9615c4b9bc66049bab3
# bad: [51eefc7c01fca6cbbae9a75850e32a05ce814698] crypto: arm - use Kconfig based compiler checks for crypto opcodes
git bisect bad 51eefc7c01fca6cbbae9a75850e32a05ce814698
# bad: [0f684432b233e1b11a3950e5da596575b24173ef] powerpc/64: Fix stack trace not displaying final frame
git bisect bad 0f684432b233e1b11a3950e5da596575b24173ef
# bad: [f45ae3c66aae2459e8b2208a31fffcccce4c9b8b] mmc: mxs-mmc: Fix a resource leak in an error handling path in 'mxs_mmc_probe()'
git bisect bad f45ae3c66aae2459e8b2208a31fffcccce4c9b8b
# bad: [353c41af24ecc267a0334a5e4b2c08e6e5f5fd64] net: phy: fix save wrong speed and duplex problem if autoneg is on
git bisect bad 353c41af24ecc267a0334a5e4b2c08e6e5f5fd64
# bad: [9f79af92045b80792a5f7aaa1f0612ddd4fcb6af] net: enetc: initialize RFS/RSS memories for unused ports too
git bisect bad 9f79af92045b80792a5f7aaa1f0612ddd4fcb6af
# bad: [d14e578414046982a7bb60c6ee8a46e6b73bd84e] MIPS: kernel: Reserve exception base early to prevent corruption
git bisect bad d14e578414046982a7bb60c6ee8a46e6b73bd84e
# first bad commit: [d14e578414046982a7bb60c6ee8a46e6b73bd84e] MIPS: kernel: Reserve exception base early to prevent corruption

Reverting the offending patch fixes the problem.

Guenter
