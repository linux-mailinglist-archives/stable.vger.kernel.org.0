Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4165472A0
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 09:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiFKHaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 03:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiFKHaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 03:30:00 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15CF120BA
        for <stable@vger.kernel.org>; Sat, 11 Jun 2022 00:29:58 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id e9so1286953pju.5
        for <stable@vger.kernel.org>; Sat, 11 Jun 2022 00:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=e/XVPREhbPgozSgfVH6FMg69KY86X1cUcC/0l9VFRDM=;
        b=RAx7i7oH8eNQdrJk0/dGZvkcY5A4xQ5Nm0Q7nf3qwEIezXfvDTN301JujrGnWi6Led
         4Eql0cYJc1BTcUygo4vQjbJGM+l/o+xL8X5dejvGeJzUx/TrK4/Xjy8i7REMMb9Sib1C
         69oU7y71qkOZX/1iNIYsEH9wnL25kyigPq3ljp+mZOGOBDdFaZl4WSkEFtRyLr1Fzyjl
         O41KWAGOaxlvUnt3A9p5wTiw52bcYQYBz9tEnkt1tJvwVxq13UeefJ0gpCNDnd3Gugnb
         uK1It3o+uirXNl9/bo6LcHQbqX6jwtoQQkYXKRBchkv43oemFyUvqXx8EfCIBaS547GT
         U7UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e/XVPREhbPgozSgfVH6FMg69KY86X1cUcC/0l9VFRDM=;
        b=xlSXWCJQv/7WJytl2nk/VCYmQZblZIab2r8dQX+c17gPDAqZOeSSe4d/pxWBj2dqX1
         2XIqD7HxFVz4WNajD0LtHCCn0YNDOgkUkMwN/p96peepvALdD1cFQ4ey+350Mv88CwL6
         zwuhiOdsd9zuWbrnm27EEkfb+mxuowiLoJqILn0EqcQ6UwsCvRjPzyAKXAkqTvjp1HVl
         NmemkdzndYyTX516ZM6KR8GP3XpJD+Dka1RXuzXxA+KU0obxZhqwlNnFKjl+475IQcZX
         WDYarkYep9YKQarLGalMxug16R16+T5OeHvtYav+x8VcNH7GPIgbkOu9zZmgwYpSnrKa
         OFRQ==
X-Gm-Message-State: AOAM533K05zsAUKIoKPxLLXBKdbJp94Vdpvt5uiMXLL8NIOXUgnxG2gt
        paSrboq/7/tCSwU+qVo9/lQ=
X-Google-Smtp-Source: ABdhPJxeT/gIC1leIWRF7gW0ilFF30cQ7MNS6Pj5HHn1JosCtVL8odQIIODqIWaIgUuPTddySgUtow==
X-Received: by 2002:a17:902:d702:b0:168:cfec:de55 with SMTP id w2-20020a170902d70200b00168cfecde55mr92228ply.63.1654932598251;
        Sat, 11 Jun 2022 00:29:58 -0700 (PDT)
Received: from [192.168.43.80] (subs28-116-206-12-39.three.co.id. [116.206.12.39])
        by smtp.gmail.com with ESMTPSA id v17-20020a17090a899100b001e2fade86c1sm2976149pjn.2.2022.06.11.00.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jun 2022 00:29:57 -0700 (PDT)
Message-ID: <819bb33c-bb9a-1da8-395a-67c9f4da798e@gmail.com>
Date:   Sat, 11 Jun 2022 14:29:53 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Build error on openrisc with CONFIG_CRYPTO_LIB_CURVE25519
Content-Language: en-US
To:     Jason Self <jason@bluehome.net>, stable@vger.kernel.org
References: <20220609162943.6e3bba4f@valencia> <YqLTecx7MGFPOvhw@kroah.com>
 <20220610182523.2f5620a2@valencia>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220610182523.2f5620a2@valencia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/11/22 08:25, Jason Self wrote:
> On Fri, 10 Jun 2022 07:15:37 +0200
> Greg KH <greg@kroah.com> wrote:
> 
>> On Thu, Jun 09, 2022 at 04:29:43PM -0700, Jason Self wrote:
>>> In building 5.15.46 & 5.10.121 with CRYPTO_LIB_CURVE25519=m I get
>>> the following. My workaround is to leave it as
>>> CRYPTO_LIB_CURVE25519=n for now.
>>>
>>> CONFIG_OR1K_1200=y
>>> CONFIG_OPENRISC_BUILTIN_DTB="or1ksim"
>>>
>>>   sed 's/\.ko$/\.o/' modules.order | scripts/mod/modpost    -o
>>>   modules-only.symvers -i vmlinux.symvers   -T - ERROR: modpost:
>>>   "__crypto_memneq" [lib/crypto/libcurve25519.ko] undefined!
>>> make[1]: *** [scripts/Makefile.modpost:134: modules-only.symvers]
>>> Error 1 make[1]: *** Deleting file 'modules-only.symvers' make:
>>> *** [Makefile:1783: modules] Error 2  
>>
>>
>> Is this a new problem, or has it always been there for these kernel
>> trees?
> 
> It's new; it began in 5.15.45 & 5.10.120, which is when make
> oldconfig first prompted about CONFIG_CRYPTO_LIB_CURVE25519.

What did you answer for that new config?

-- 
An old man doll... just what I always wanted! - Clara
