Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B785D307283
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 10:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhA1JVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 04:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbhA1JRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 04:17:55 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E97BC061574;
        Thu, 28 Jan 2021 01:17:14 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id p15so4598536wrq.8;
        Thu, 28 Jan 2021 01:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YfpJeU+y4GXJaEx6ZFQPSBL50F7o8221y4mYWygliKw=;
        b=tXnJQJvCXHk4nixwz8jy8I08rlCcJ2rziho0sjpf8e8roCzGzi3Ci4TssGlCkV5RC8
         E46A4c6f4tQdiUvIz3bkepFr+coSfA2qu/uVD8ZMZdtGKJh3tweM2q+hHQOR5oosD694
         DtFiJMstCxbKgXbcI2K6GTgs3falJinYhmsRPZtSb2WdhERXvy9l5nx9rpp0ul67v9RB
         Ih/77QPO9lb85XgMLsAljwfHLNJkybwRP7NHWim/gZlxh2qhdOQ4szX//uMDqqeGhk+f
         YoFeVXblBoC7JdtjCJONB3EyTwWc2xx3eZ7qeCK9Xr2UvL0uLF3g8ze9CmIsDdH5+zr7
         KFZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YfpJeU+y4GXJaEx6ZFQPSBL50F7o8221y4mYWygliKw=;
        b=mCZ1VZgrEGKwZsH9qun/C5pXxSn8PJfQs1so4HCK9RLWGbE+b2A4yISXASjWeLsBrU
         9sdu69VatzwEs077l/Pjf2IDw1UY5msxC+mH223WTkutQMRxBw19Z6d06C5rZShwN9x1
         HL5v+tshKaaSXFvGBTNpI5wynW+F//u+tVpCcz/dxkmLzxd5abHVihSwb5qI8rX+nqd8
         zFOmZWEKLd+hZRSaLyq+O3rwhRW2dfJdlE2+1e2fauGR9JCw1fXdMCLDDVGesFZD0w+b
         485tLDZMtX+G9rMgpTieDMQRfiqPtb6Iurus/0EBZwzHZE8YG0UNFUm0h+EcHSplk1vY
         mCTQ==
X-Gm-Message-State: AOAM530p092rz5e8YyUmvr00BLK6UAqIs+WgsOEh/et0Q/uk2jwp3W2h
        S7wt7lDNN/bma3AI+N2bRvH4shzShu8=
X-Google-Smtp-Source: ABdhPJwnpibKPBXY446pPygiIr5DiwXavFn6aSEXwVKMlq03MXyi3GJ7SuZuNN3Q2YEE14ldlLEypg==
X-Received: by 2002:adf:fb52:: with SMTP id c18mr14912024wrs.186.1611825432933;
        Thu, 28 Jan 2021 01:17:12 -0800 (PST)
Received: from [192.168.1.20] (5ec062a9.skybroadband.com. [94.192.98.169])
        by smtp.googlemail.com with ESMTPSA id m184sm5747703wmf.12.2021.01.28.01.17.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 01:17:11 -0800 (PST)
To:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Chris Clayton <chris2553@googlemail.com>
Subject: linux-5.10.11 build failure
Message-ID: <f141f12d-a5b9-1e60-2740-388bf350b631@googlemail.com>
Date:   Thu, 28 Jan 2021 09:17:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Building 5.10.11 fails on my (x86-64) laptop thusly:

..

 AS      arch/x86/entry/thunk_64.o
  CC      arch/x86/entry/vsyscall/vsyscall_64.o
  AS      arch/x86/realmode/rm/header.o
  CC      arch/x86/mm/pat/set_memory.o
  CC      arch/x86/events/amd/core.o
  CC      arch/x86/kernel/fpu/init.o
  CC      arch/x86/entry/vdso/vma.o
  CC      kernel/sched/core.o
arch/x86/entry/thunk_64.o: warning: objtool: missing symbol for insn at offset 0x3e

  AS      arch/x86/realmode/rm/trampoline_64.o
make[2]: *** [scripts/Makefile.build:360: arch/x86/entry/thunk_64.o] Error 255
make[2]: *** Deleting file 'arch/x86/entry/thunk_64.o'
make[2]: *** Waiting for unfinished jobs....

..

Compiler is latest snapshot of gcc-10.

Happy to test the fix but please cc me as I'm not subscribed


Thanks,

Chris
