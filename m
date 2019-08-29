Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A108DA1A07
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 14:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfH2M22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 08:28:28 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33052 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfH2M22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 08:28:28 -0400
Received: by mail-wr1-f67.google.com with SMTP id u16so3273278wrr.0
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 05:28:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Du+TnmHqsC6TFgCheCwfqRMCkNoxevUwJCRj9sWJH68=;
        b=P2kqb7irSoJnJJ90IchqbDmwaTOmr+SNWTycxEOFeJO5ebKAcGxy2Ta1Cr5w2CRZ1b
         aSvE7/Uy49S/PT1mC3Xp+1thHGfDDMPm7KhpV9OYf5l8a21QhEhinGhI9iEMeX4X9tqi
         the4E1uo/UzHDVZNpcPvq6Tp1vqZCtHbDujxpc6EZejrTlnzAxk06QsGXr2ep2VBOJc3
         YJ2Gw2wpv9fclBSls7XiegeHDSU2PzA07JRaO1cy8so1L8eXwPzsjIUc6KQlAy8LlWxy
         GYUOiNF7ZwEZHc70MmGYT7NS+JZVb13wE8dvjLj6yw1hN1KLi1LuXbGsOsIPkcHFeDY5
         CLew==
X-Gm-Message-State: APjAAAW0DZhBNTChx9eJwaTh4pPzZwLMiT1Yh2Pd8L727dBdSQeANicB
        MPZ/1HtpaJH0BvZvRey1MHY=
X-Google-Smtp-Source: APXvYqwbP7G8zplCAaabk8Op+7J8cZGm/0Jv3zNP66Np4pEjaLqTM2yPe4bIf9ig9B4X3MB5kOuX/A==
X-Received: by 2002:a5d:4b83:: with SMTP id b3mr11214924wrt.104.1567081705694;
        Thu, 29 Aug 2019 05:28:25 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id q3sm3153058wma.48.2019.08.29.05.28.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Aug 2019 05:28:25 -0700 (PDT)
Subject: Re: Kernel 5.2.11 dpes not compile
To:     =?UTF-8?Q?Fran=c3=a7ois_Valenduc?= <francoisvalenduc@gmail.com>,
        stable@vger.kernel.org, henryburns@google.com,
        sergey.senozhatsky@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>
References: <CACU-xRs6-oog+4gG-zsn-J9MCRS8xF3y-1Aw+yq_iv6PHP7d+A@mail.gmail.com>
From:   Jiri Slaby <jslaby@suse.cz>
Openpgp: preference=signencrypt
Autocrypt: addr=jslaby@suse.cz; prefer-encrypt=mutual; keydata=
 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
Message-ID: <015acb3e-6722-70c8-b0d5-822f1505fed2@suse.cz>
Date:   Thu, 29 Aug 2019 14:28:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CACU-xRs6-oog+4gG-zsn-J9MCRS8xF3y-1Aw+yq_iv6PHP7d+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29. 08. 19, 14:13, François Valenduc wrote:
> The following patch causes a build failure:
> 
> 
> Author: Henry Burns <henryburns@google.com>
> Date:   Sat Aug 24 17:55:06 2019 -0700
> 
>     mm/zsmalloc.c: fix race condition in zs_destroy_pool

So this is f6d997de0883 in 5.2.11 and 701d678599d0 in upstream.

> I get this error:
> 
>  CALL    scripts/checksyscalls.sh
>   CALL    scripts/atomic/check-atomics.sh
>   DESCEND  objtool
>   CHK     include/generated/compile.h
>   CC      mm/zsmalloc.o
> In file included from ./include/linux/mmzone.h:10:0,
>                  from ./include/linux/gfp.h:6,
>                  from ./include/linux/umh.h:4,
>                  from ./include/linux/kmod.h:9,
>                  from ./include/linux/module.h:13,
>                  from mm/zsmalloc.c:33:
> mm/zsmalloc.c: In function ‘zs_create_pool’:
> mm/zsmalloc.c:2435:27: error: ‘struct zs_pool’ has no member named
> ‘migration_wait’
>   init_waitqueue_head(&pool->migration_wait);

Obviously, as this is not protected by
#ifdef CONFIG_COMPACTION
...
#endif
as is its definition in the structure (and its other uses).

> ./include/linux/wait.h:67:26: note: in definition of macro ‘init_waitqueue_head’
>    __init_waitqueue_head((wq_head), #wq_head, &__key);  \
>                           ^~~~~~~
> scripts/Makefile.build:278: recipe for target 'mm/zsmalloc.o' failed
> make[1]: *** [mm/zsmalloc.o] Error 1
> Makefile:1073: recipe for target 'mm' failed
> 
> You can find my configuration file attached.

You forgot to attach it, but you have CONFIG_COMPACTION=n, I assume.

> Does anybody have any idea about this ?

Sure, this will fix it (or turn on compaction):
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -2413,7 +2413,9 @@ struct zs_pool *zs_create_pool(const char *name)
        if (!pool->name)
                goto err;

+#ifdef CONFIG_COMPACTION
        init_waitqueue_head(&pool->migration_wait);
+#endif

        if (create_cache(pool))
                goto err;

thanks,
-- 
js
suse labs
