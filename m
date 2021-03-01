Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A1A32872C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237969AbhCARVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237845AbhCARNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 12:13:32 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5B4C061756
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 09:12:50 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ci14so10618325ejc.7
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 09:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ayu9AHyZhIABG1EhmEXigbQRPEQI/pM8e7EiHDOXPhU=;
        b=f0qv2OATTMI00a0bd7X8pHQ0Fung7NNhgJYQ5HhDXtscW2IfLMkXtlPJkP7sbEOvJJ
         o/zucH+B98SrIVI+d9pezmnvn5YQz6CpGpMC5BpOjGgUA0NPs8YW23RlBeni5EZz4cU8
         vvigTLe52sG2wushiqV+0+JPdIXtaEPDAsr1AyF8ij0P3anbZiEOJuOYCg7e6Fd+v59s
         oZ6QyNSx+/uY69wIS5o7mkKXmI0SeIsDwlfty0FjeEJLnMXuKFeLeI4KxD1qv/nptm+R
         +qso1heXlgx+512EOlJ14rEPMifUPfUB0uYEwuTLlDZQlpwEJlgbZN0V8eXOHRF4VL6c
         BvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ayu9AHyZhIABG1EhmEXigbQRPEQI/pM8e7EiHDOXPhU=;
        b=LYzjJutrfSLjlg+45vivQqZzrPstrW4+khXdpGt3KXvRxaZw3C7Ln9iocceXHkBqLV
         qIjfbRi7OkHXTKSNAEa5kk/xl+e+ch1WerXVPx1fXuHbCZWVK8KENYL8kVkyTq5De0aI
         zTPqoBeem97UCAtqwxzZxoSLkEGFOl6rCYhWoXR8xmtspARObtJ9xZCwnyQAXdb4WU27
         d1gLdjh8lcKYC41qyAqCkPAk+Q6+8nPVXxRFavXVKilM78RKCgf1i25sPcdqSIvlDxMG
         UUmrKnFgaMTEeo8G2Q5groMI4HQVRvCdveAXFg1SebMr/72++v9+o774JhCsh/drgGsl
         SDFQ==
X-Gm-Message-State: AOAM532vq9lKEgSxlX6yIDUhelLjIl4pkcLqNwqxHFSuso683n9habt7
        GlrO2J08ktn2aqkzoYzM+OO8XBpVIVSDBEj2z4YJ7Vk0FyrUNJ3i
X-Google-Smtp-Source: ABdhPJyiBHloAF1n20TBHbeTdXanBvBLVL+njrFYN2hbpRNrGfWQhkRDItfp/g+lBhewiKXHaVyOsYu/4BU+6dOAJek=
X-Received: by 2002:a17:906:444d:: with SMTP id i13mr16504670ejp.170.1614618768068;
 Mon, 01 Mar 2021 09:12:48 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 1 Mar 2021 22:42:34 +0530
Message-ID: <CA+G9fYvxM8ECmog5rGSesSUmw3NsmXYZfdg957-37B_BDm=R9Q@mail.gmail.com>
Subject: sparc: icmpv6.h:70:2: error: implicit declaration of function
 '__icmpv6_send'; did you mean 'icmpv6_send'? [-Werror=implicit-function-declaration]
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sahaj Sarup <sahaj.sarup@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On stable rc 5.11 sparc allnoconfig and tinyconfig failed with gcc-8,
gcc-9 and gcc-10.

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=sparc
CROSS_COMPILE=sparc64-linux-gnu- 'CC=sccache sparc64-linux-gnu-gcc'
'HOSTCC=sccache gcc'
<stdin>:1335:2: warning: #warning syscall rseq not implemented [-Wcpp]
In file included from include/net/ndisc.h:50,
                 from include/net/ipv6.h:21,
                 from include/linux/sunrpc/clnt.h:28,
                 from include/linux/nfs_fs.h:32,
                 from init/do_mounts.c:22:
include/linux/icmpv6.h: In function 'icmpv6_ndo_send':
include/linux/icmpv6.h:70:2: error: implicit declaration of function
'__icmpv6_send'; did you mean 'icmpv6_send'?
[-Werror=implicit-function-declaration]
   70 |  __icmpv6_send(skb_in, type, code, info, &parm);
      |  ^~~~~~~~~~~~~
      |  icmpv6_send
cc1: some warnings being treated as errors
make[2]: *** [scripts/Makefile.build:304: init/do_mounts.o] Error 1

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Ref:
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1064179275#L62

-- 
Linaro LKFT
https://lkft.linaro.org
