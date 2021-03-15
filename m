Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1760833A909
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 01:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhCOAZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 20:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhCOAZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Mar 2021 20:25:40 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88ED6C061574
        for <stable@vger.kernel.org>; Sun, 14 Mar 2021 17:25:40 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id d16so23600535oic.0
        for <stable@vger.kernel.org>; Sun, 14 Mar 2021 17:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:autocrypt:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=HQJKUCYp8WmIil9nihWN4GizMGy3XzcqL+H48j70rMY=;
        b=WSyIk5RY9Rdwnr7BNB59ABg+pjWBhqzvUzRkIIBx3YOrsTUXqvNDVsFYiL1cjn8kHv
         oIU1E5do4tFy4Y16nRFPCUW43a489NBsJ9vTVzIveYiAJk6k86APagYIdSEZlTOzCKro
         hY9MIM5u4+SN1ab49BYFSQ4JMasqD1898N3ue0Wzd9uvPJHv+NZOimIHRzSt2pkIhfVq
         ixQlrPa35nmCc8RdttuC3qHuplYPMFWMvpyLrKC/+aMwpeqV/BCPYOuB7dd6cOo1CnL3
         ZufSXknXidoMKRxNOxZ+b0QrHE+zxNX5O7yUYXk3j6JiHXF7Iffkaa1/TxOr+NCuqpBV
         AkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:autocrypt:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=HQJKUCYp8WmIil9nihWN4GizMGy3XzcqL+H48j70rMY=;
        b=qgjhCOmCkzfjnNELxiOl7kDkhWajNRq78vuJd6xgeNK+b3v74wt35e3inP/zfDFEwo
         b1Eo2j0CICs0BokCCRwMd0+ImnSD+SyRbZv1s6E9+TA3AjnyYyR/9imGQrv0l0jNKyhn
         Z6RDKzioVJTpjKFB+FnmfZ/6CIyM4R96QrAJc0feEx9pzsTdgJHzhjVm0DCyXxCT63Vg
         Z2JwLd/rOYlG1MqSGV1gIwO2idZYe4DU3CrYoKsiuPw4+pQiS1Gsg1qzD0OgXGFU0+v+
         8whyefss/f/gMwyVvLba4PIUKGhhJ7/zaOqN3+bSD/aFsBbHplgMvFlwAWr+EcKWctfD
         DYkA==
X-Gm-Message-State: AOAM5313ppAIExhMF2Rbnmp2K2T8kGNAepQblKczpKsTwNhs9Rmju2I4
        9v8SlCwTQ/wollNYdEoLN8qcm4rfydY=
X-Google-Smtp-Source: ABdhPJw8QZ7SvBCgXRj45VYzN4HL7UiWFCNnmIVCfj5475X00GlMAK5LfEDTS56pECLoJygA2WJGcg==
X-Received: by 2002:aca:c44b:: with SMTP id u72mr16801096oif.33.1615767939967;
        Sun, 14 Mar 2021 17:25:39 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s191sm5946142oie.0.2021.03.14.17.25.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Mar 2021 17:25:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: v4.19.y-queue, v5.4.y-queue stable rc build failures
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <be846d89-ab5a-f02a-c05e-1cd40acc5baa@roeck-us.net>
Date:   Sun, 14 Mar 2021 17:25:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Building arm:axm55xx_defconfig ... failed
--------------
Error log:
/tmp/cc2ylxxJ.s: Assembler messages:
/tmp/cc2ylxxJ.s:87: Error: co-processor register expected -- `mrc p10,7,r7,FPEXC,cr0,0'
/tmp/cc2ylxxJ.s:103: Error: co-processor register expected -- `mcr p10,7,r3,FPEXC,cr0,0'
/tmp/cc2ylxxJ.s:537: Error: co-processor register expected -- `mcr p10,7,r7,FPEXC,cr0,0'
make[3]: *** [arch/arm/kvm/hyp/switch.o] Error 1
make[2]: *** [arch/arm/kvm/hyp] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [arch/arm/kvm] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [sub-make] Error 2
--------------

I didn't find an obvious candidate so I bisected it.

# bad: [a233c6b3f6de88ca62da8fde45f330b104827851] Linux 4.19.181-rc1
# good: [030194a5b292bb7613407668d85af0b987bb9839] Linux 4.19.180
git bisect start 'HEAD' 'v4.19.180'
# good: [ecee76d4b15b8431827e910589edfb4c12a589f9] powerpc/perf: Record counter overflow always if SAMPLE_IP is unset
git bisect good ecee76d4b15b8431827e910589edfb4c12a589f9
# good: [722ce092b23ae91337694d40e6ac216b16962788] ARM: 8929/1: use APSR_nzcv instead of r15 as mrc operand
git bisect good 722ce092b23ae91337694d40e6ac216b16962788
# bad: [2e6919206bb0bcac507b7905fc7c9b3dd861ab4b] ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN depends on !LD_IS_LLD
git bisect bad 2e6919206bb0bcac507b7905fc7c9b3dd861ab4b
# good: [831e354481111c30d68c980434e2cfe42590f189] kbuild: add CONFIG_LD_IS_LLD
git bisect good 831e354481111c30d68c980434e2cfe42590f189
# bad: [9b99f469087843c9216976865a97da96f9cdcbbc] ARM: 8991/1: use VFP assembler mnemonics if available
git bisect bad 9b99f469087843c9216976865a97da96f9cdcbbc
# good: [41ad45cb9ecb66f76abc77d938b3693839fb5e20] ARM: 8990/1: use VFP assembler mnemonics in register load/store macros
git bisect good 41ad45cb9ecb66f76abc77d938b3693839fb5e20
# first bad commit: [9b99f469087843c9216976865a97da96f9cdcbbc] ARM: 8991/1: use VFP assembler mnemonics if available

Reverting the offending patch from v4.19.y-queue fixes the problem.
I didn't check v5.4.y-queue.

Guenter
