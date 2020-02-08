Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C61B215648F
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 14:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgBHNdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 08:33:12 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54775 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgBHNdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 08:33:12 -0500
Received: by mail-pj1-f66.google.com with SMTP id dw13so2147157pjb.4
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 05:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+TgtRglFPsKGoYDV5FVYpCFpV4d7G0dQ7Cix7b6Bqk0=;
        b=vIb4SvpRDowmcRdTYVCHl/f7UwYplg9r04yFXdD6JXyHoS7eidx5tGEQTDd3GdqDjG
         BSKckCMFzbefljnHbaSj6qvwBv72dvfRIXSPQNvP+wj97SBE9xzZDpwtoNAWuHZc8rxC
         1pL3V/F25nWOib+7oiDVYyASMH0Vf6Yto4myfmKcWO3pN/7ccfKKdIv0KQLHdpLm7IKp
         OC/U0BT6yuW/J3E71XdQdGwUnjICeKoX/nn7Rl32iKhYPlRhF2qlFF7zKfMaXUaKJPCx
         3TuIrjaVLH+vQ31pEAlTDyO+PH/r7PqyKBqoiGlOARWYKuk8yu/25C2lrZY6ru5p/rP/
         xjhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+TgtRglFPsKGoYDV5FVYpCFpV4d7G0dQ7Cix7b6Bqk0=;
        b=J8H2x5kMyRPNes0Dtek9YlsLevURvuQQBe8O3lbka4wqyKIlq/1M9OgnQKC/MbGsYu
         HDUDljaculdOkY/lGQnS9w7pTBBiTZbZZ4/GeAtV3tMKWeweVOWq/oST7dwVOZIE7a8/
         HFuZoDkxCKaY0/uhI+Xw/xFZgWeuD8u04k54QmAEguaxqhTAXuShU3jKwMRxmPJ4/FtS
         jP2ib10irQoZ0YW5FkQ3wUG3KTIeKgxlAlou8ehgGVHjirBUcyK6+0a9kARKEFCMRehw
         HAH94NaukJrBtxW3UnjIPpOzJwDOZd3SUwF4dEG50KfQBCRqSERoizCubVi5s7+lmMPN
         4QVw==
X-Gm-Message-State: APjAAAWbWPYYjwgLSMRjsmgxRCPkK63DEqPbyOwvUr1/pXfup3Rn8WpN
        5L3VC87pBw0l5+8NeLjx3jHGHCUq
X-Google-Smtp-Source: APXvYqx9aPUGCmOXCmFcNk83m0sIn+DYYe/RY3AjBNjAPcHlslywCjcKUrgopOnvObW0wM6qcMgIvw==
X-Received: by 2002:a17:90a:d985:: with SMTP id d5mr10594425pjv.73.1581168791550;
        Sat, 08 Feb 2020 05:33:11 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i68sm6502006pfe.173.2020.02.08.05.33.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2020 05:33:10 -0800 (PST)
Subject: Re: v4.9.y.queue build failures (s390)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
References: <e63c50d7-68c0-1ada-dc05-86452d17a76a@roeck-us.net>
 <20200208132823.GA1234618@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <8a9d90ac-7510-dee2-d9d1-bc77cdeeb55d@roeck-us.net>
Date:   Sat, 8 Feb 2020 05:33:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200208132823.GA1234618@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/8/20 5:28 AM, Greg Kroah-Hartman wrote:
> On Sat, Feb 08, 2020 at 05:15:43AM -0800, Guenter Roeck wrote:
>> For v4.9.213-37-g860ec95da9ad:
>>
>> arch/s390/mm/hugetlbpage.c:14:10: fatal error: linux/sched/mm.h: No such file or directory
>>     14 | #include <linux/sched/mm.h>
>>        |          ^~~~~~~~~~~~~~~~~~
>> compilation terminated.
>> scripts/Makefile.build:304: recipe for target 'arch/s390/mm/hugetlbpage.o' failed
>> make[1]: *** [arch/s390/mm/hugetlbpage.o] Error 1
>> Makefile:1688: recipe for target 'arch/s390/mm/hugetlbpage.o' failed
>> make: *** [arch/s390/mm/hugetlbpage.o] Error 2
>>
>> Guenter
> 
> Thanks for letting me know, I'll try to guess and pick "sched.h" instead
> here and push out an update.
> 

Then you'll get:

arch/s390/mm/hugetlbpage.c: In function 'hugetlb_get_unmapped_area':
arch/s390/mm/hugetlbpage.c:320:8: error: too many arguments to function 'crst_table_upgrade'
   320 |   rc = crst_table_upgrade(mm, addr + len);
       |        ^~~~~~~~~~~~~~~~~~
In file included from ./arch/s390/include/asm/tlbflush.h:7,
                  from ./include/linux/hugetlb.h:21,
                  from arch/s390/mm/hugetlbpage.c:12:
./arch/s390/include/asm/pgalloc.h:57:5: note: declared here
    57 | int crst_table_upgrade(struct mm_struct *);

Guenter
