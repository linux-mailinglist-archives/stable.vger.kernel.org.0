Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76BFFA5C01
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 20:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbfIBSBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 14:01:50 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42200 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfIBSBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 14:01:50 -0400
Received: by mail-ed1-f68.google.com with SMTP id y91so4385128ede.9
        for <stable@vger.kernel.org>; Mon, 02 Sep 2019 11:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=BrP/Cua0sAsAwuFplkfhqRXEnNhP5zBP5uMdtN1qO58=;
        b=nh/ftsDxj53klW7WIpGelZJe2EQQGqunaI93y13IvVNKAXMrGZhhwjHPcZcFfzde+G
         TFb+I10orl4T5ES+mGdKdzJr8tbdxRFcaYqZtBWYXedDwiroGvO5VcByXIPIDrTkERk1
         sUQ7QAiNyJJKRiiUUUuRjtz1cRJ1+Ms+mEHQkRoViDRYv8EsUpeSoF76HphoRr8IuI8C
         vO55c8hiWnhBavU5mXMNirTYloe0uqDlLyRTZloo28X5IxY5cc9Umm93wpd9GKsKATzN
         bYAVLiJqFNUDaGoD4y+XxaVVdkEEBjsGHT9OH+bvmtFCPimssmXSUdbZJqxslsFQ1XmR
         SfvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BrP/Cua0sAsAwuFplkfhqRXEnNhP5zBP5uMdtN1qO58=;
        b=H6MMu9nc1yhWrHVRYC7H+j9Ovx9S5lf4yfT1cdOzbJasZeHtKJSOtmnagWCfbPdMT1
         Ote9wrqXleBGF3OpNJg80B7t3FwyDNB7dUgPBWDWkedMsexMQfsA+9KG8bAr/0AQp1iX
         7zf8dEd5GFmw8lQgKAXMa0JbUGMmy5XahwPJMdIzNpd7c60gITWHLLwhd/zbbtmw/KSX
         FHe/FxwcVUzpmVSK/q+gkBzZGuP5BBHPX8/Fg/Q9x0m/FT+/DzlMD5EoetWR78KJZ8Qp
         0n4espDbMfTp8YLCydwaYIyfnse1WOS9/4LIqulZ5aks1J174aT788uMJcGtP1cdQtXG
         W2TA==
X-Gm-Message-State: APjAAAXPDsR/7mRFG0xc4SoQMiqmD9itwMxcBeYtNyrG8GCvSEGgJqn+
        93TmPYLmhBB38hOmJG7s3BBXG3YCeXEg3w==
X-Google-Smtp-Source: APXvYqz5v6GPAPP//3xC8O43Si92UL/EsYywpqUWb9bEEJw9xnkez3674Ud+9JfxfNZN+h93cPYQcA==
X-Received: by 2002:aa7:c74e:: with SMTP id c14mr31341514eds.223.1567447308573;
        Mon, 02 Sep 2019 11:01:48 -0700 (PDT)
Received: from [192.168.1.3] (host-109-89-151-97.dynamic.voo.be. [109.89.151.97])
        by smtp.gmail.com with ESMTPSA id d3sm2033554ejp.77.2019.09.02.11.01.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Sep 2019 11:01:47 -0700 (PDT)
Subject: Re: Kernel 5.2.11 dpes not compile
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Cc:     stable@vger.kernel.org, henryburns@google.com,
        sergey.senozhatsky@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>
References: <CACU-xRs6-oog+4gG-zsn-J9MCRS8xF3y-1Aw+yq_iv6PHP7d+A@mail.gmail.com>
 <015acb3e-6722-70c8-b0d5-822f1505fed2@suse.cz>
 <20190829123257.GA8726@jagdpanzerIV>
From:   =?UTF-8?Q?Fran=c3=a7ois_Valenduc?= <francoisvalenduc@gmail.com>
Message-ID: <0d340d5b-5495-c66f-eff3-b12c016ed927@gmail.com>
Date:   Mon, 2 Sep 2019 20:01:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829123257.GA8726@jagdpanzerIV>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: fr-moderne
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Le 29/08/19 à 14:32, Sergey Senozhatsky a écrit :
> On (08/29/19 14:28), Jiri Slaby wrote:
> [..]
>> as is its definition in the structure (and its other uses).
>>
>>> ./include/linux/wait.h:67:26: note: in definition of macro ‘init_waitqueue_head’
>>>    __init_waitqueue_head((wq_head), #wq_head, &__key);  \
>>>                           ^~~~~~~
>>> scripts/Makefile.build:278: recipe for target 'mm/zsmalloc.o' failed
>>> make[1]: *** [mm/zsmalloc.o] Error 1
>>> Makefile:1073: recipe for target 'mm' failed
>>>
>>> You can find my configuration file attached.
>> You forgot to attach it, but you have CONFIG_COMPACTION=n, I assume.
>>
>>> Does anybody have any idea about this ?
>> Sure, this will fix it (or turn on compaction):
>> --- a/mm/zsmalloc.c
>> +++ b/mm/zsmalloc.c
>> @@ -2413,7 +2413,9 @@ struct zs_pool *zs_create_pool(const char *name)
>>         if (!pool->name)
>>                 goto err;
>>
>> +#ifdef CONFIG_COMPACTION
>>         init_waitqueue_head(&pool->migration_wait);
>> +#endif
> The fix is correct. I believe Andrew already has the same patch
> in his tree.
>
> 	-ss

No reaction of the stable team on this ? Meanwhile, the fix is in the
mainline tree (commit 441e254cd40dc03beec3c650ce6ce6074bc6517f).
Hopefully it can be included in the next stable releases. However, if I
read the config text, memory compaction should always be enabled, even
if it is disabled by default.

Thanks in advance,

François Valenduc


