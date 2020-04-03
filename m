Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C007819D6F3
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgDCMtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:49:55 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34844 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgDCMtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:49:55 -0400
Received: by mail-ed1-f66.google.com with SMTP id c7so1399531edl.2
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qQ4GjlaBNnkqjandRnDKumnjBIkctbwHxWdo0M4wsMI=;
        b=ASnR0E3twBUn3zFHPgwVLzGRCQDeCNzuma4SqK3MmSzZIdWWrXFg8pCBWD4epfIJ+z
         2OUBhBph32xan2QlF1RTOih+bc/LuuXJUQlq0iN2y5fu4d+/dnczuhRU9UUVpsoDdYuZ
         ydiEvmwy9d48th4OPl+a1yTfrR9RPceRVflsdsZkGlttu3jIYGOzb5T/GwGoBaIFpoNA
         k0KoH4qQBH7tOQ5AH4Xq8UCixq3wVjW29B7w90J3hbU3+JeFSJQhPhGXhAMsfueibgXa
         c6wfYcKAP/B9C1KT13N/Uqu/GulrAEMyeVQ/PVEvYV0LxhXv0DoqB1zwusHV3iCHBTiK
         OItw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qQ4GjlaBNnkqjandRnDKumnjBIkctbwHxWdo0M4wsMI=;
        b=XdOoghEtWPou6dNgVnKi197lOvvC4xUqo4JEpg/ECBnFNrt/f89NOq7m0W8iD2PKtR
         SvU4brObSjpq5Nj+9Bl4E6CjKhGD4VGt90XIPnI23tAqe7nW4PvaN2hNnzLlhE1DYBll
         l1IyElCmqj17LiwyXdFKLWQG0gOpUBgoPo37Jn6PxIu7kyK5+3m4D03kGTwe1j1sf/KK
         DT+yupIYWuph/DWh1Qp/Q+w7tWlDfHqQ8Y71FBR2vbQlY6CoAbvel6CoqeNZVnaKHTZV
         5t5tKndhIimHm6/azxL5i4GmWr0GBVxV34NuVOUbg0pm8iP7BZaq5tvCJqKvi/XKDBYB
         cgnQ==
X-Gm-Message-State: AGi0PuZwuwIMHiRKStbZyDBp1hWvZHywzY5nTB2SOxQxcRZRre5+JGXp
        872sus9l2wfnXmxW9TR6sC1tzQ==
X-Google-Smtp-Source: APiQypL5gP9d5L/YD06dpE9QuVApfFMy3N0f0Ub7xYKYv6KkNS8Zf7gkd/4JdkznDB02IeowhtMk2Q==
X-Received: by 2002:a17:906:7045:: with SMTP id r5mr8266254ejj.29.1585918193015;
        Fri, 03 Apr 2020 05:49:53 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id by25sm1649452ejb.16.2020.04.03.05.49.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2020 05:49:52 -0700 (PDT)
Subject: Re: [PATCH] ns: Fix time_for_children symlink
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc:     Andrei Vagin <avagin@openvz.or>, Adrian Reber <adrian@lisas.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrei Vagin <avagin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andy Lutomirski <luto@kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Containers <containers@lists.linux-foundation.org>,
        stable <stable@vger.kernel.org>
References: <a2418c48-ed80-3afe-116e-6611cb799557@gmail.com>
 <20200403123431.tsvj6alagg3ee356@wittgenstein>
From:   Dmitry Safonov <dima@arista.com>
Message-ID: <11460527-7d03-0966-508a-b67dc2bc8459@arista.com>
Date:   Fri, 3 Apr 2020 13:49:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200403123431.tsvj6alagg3ee356@wittgenstein>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/3/20 1:34 PM, Christian Brauner wrote:
> On Fri, Apr 03, 2020 at 02:11:39PM +0200, Michael Kerrisk (man-pages) wrote:
>> Dmitry, Andrei,
>>
>> Looking at the contents of the /proc/PID/ns/time_for_children
>> symlink shows an anomaly:
>>
>> $ ls -l /proc/self/ns/* |awk '{print $9, $10, $11}'
>> ...
>> /proc/self/ns/pid -> pid:[4026531836]
>> /proc/self/ns/pid_for_children -> pid:[4026531836]
>> /proc/self/ns/time -> time:[4026531834]
>> /proc/self/ns/time_for_children -> time_for_children:[4026531834]
>> /proc/self/ns/user -> user:[4026531837]
>> ...
>>
>> The reference for 'time_for_children' should be a 'time' namespace,
>> just as the reference for 'pid_for_children' is a 'pid' namespace.
>> In other words, I think the above time_for_children link should read:
>>
>> /proc/self/ns/time_for_children -> time:[4026531834]
>>
>> If you agree with this patch, then it should be marked for
>> stable@vger.kernel.org.
>>
>> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
> 
> Yeah, that just seems like an oversight.
> 
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

Thanks,

Reviewed-by: Dmitry Safonov <dima@arista.com>
Fixes: 769071ac9f20 ("ns: Introduce Time Namespace")
+Cc: stable # v5.6

-- 
          Dmitry
