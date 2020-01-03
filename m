Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D36FF12F9FC
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 16:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgACPsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 10:48:53 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46671 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbgACPsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 10:48:53 -0500
Received: by mail-pg1-f193.google.com with SMTP id z124so23577048pgb.13;
        Fri, 03 Jan 2020 07:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4841VwPNpkn9wbZnO4BJL9lu8LuOyQW8ecW89W7VNVc=;
        b=Pa8jbl7NgH9la/TweVO32qWWwqzMuJNgzm8nH7knLfbRtYW9QE6qaXLJ2/1dCij4nW
         Ux8yY1QF/sDJIAih9Ef5Hhi799FQtwTcYELpqRcb1hX1ave09efKfCyUFTB1/S7SmMX5
         PMa0Axr1Dzu+JxBEgMPZiVDvskx4a3XBW6c7lfxGJnSyWloTCTijtHizbakiD35zFiZK
         v+P8WEnSE6cAxvu+3qoG8SnvmrnlSXzhd8FwOipZjt5le5YDgJ6LB1177ZRktCSCbOys
         osFZKTpD8GkzDsv7Q/vJSqDXC4BFGVAD1OjwGd6/ZaiUGH9TdgAleWzq/LezF4F1xvjo
         9J2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4841VwPNpkn9wbZnO4BJL9lu8LuOyQW8ecW89W7VNVc=;
        b=lDjzK9Ufr5MLWXgtP52XBidVD2Jpxdtr4sgcAzbdIPpNFhaeUfpOim4FbA4949C/4w
         Gnvcu1N0SiwBHjGTfZ0st0D6R534QwTH32lDEgY7FGxbB4JIIDB/NzfFRbsGVcHAmvuq
         Q0TBwr0AMa+cXUqbBZaFUQNzR3qg2lBmxH6Btzcmxwj+sGU0XVL7aGaKCcQ8f2udCBtj
         ocau/5vEXBjtY2RNtWIibGpPFEGX8YykTxBXGqtmUQDtGIfbeCCv4i2u94Eo69GtH/6E
         mGtF5prQq7QIMyM9/uvJEwGLf0RSaumPGROGx6NG+/4R0i6px/sDzvcrZw3gcVG42Bny
         Z4jQ==
X-Gm-Message-State: APjAAAUAro3NLIea1x9x9hpnEIwR1C6+XxSED+KKcVVFaYuyJGymMbY3
        EuBMi/3oD2EG2/efA0SK7+4=
X-Google-Smtp-Source: APXvYqyfy6Tr7QCeoOvv+AXrziEDm9uVlHL+x6axpvgqGKFvrxVuIPtwM1hrAiXqYJWCcCLRyDTVDA==
X-Received: by 2002:a63:2ac2:: with SMTP id q185mr97770833pgq.417.1578066532263;
        Fri, 03 Jan 2020 07:48:52 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k5sm14922486pju.5.2020.01.03.07.48.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2020 07:48:51 -0800 (PST)
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
To:     Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, LTP List <ltp@lists.linux.it>,
        Jan Stancek <jstancek@redhat.com>,
        John Stultz <john.stultz@linaro.org>
References: <20200102215829.911231638@linuxfoundation.org>
 <CA+G9fYuPkOGKbeQ0FKKx4H0Bs-nRHALsFtwyRw0Rt5DoOCvRHg@mail.gmail.com>
 <CAK8P3a1+Srey_7cUd0xfaO8HdMv5tkUcs6DeDXzcUKkUD-DnGQ@mail.gmail.com>
 <CAK8P3a24EkUXTu-K2c-5B3w-LZwY7zNcX0dZixb3gd59vRw_Kw@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <180c36d7-336b-f7a9-66d4-49703eca2aa9@roeck-us.net>
Date:   Fri, 3 Jan 2020 07:48:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAK8P3a24EkUXTu-K2c-5B3w-LZwY7zNcX0dZixb3gd59vRw_Kw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/3/20 7:29 AM, Arnd Bergmann wrote:
> On Fri, Jan 3, 2020 at 4:25 PM Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> On Fri, Jan 3, 2020 at 4:03 PM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>>>
>>> On Fri, 3 Jan 2020 at 03:42, Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> wrote:
>>
>> -ENOENT is what you get when hugetlbfs is not mounted, so this hints to
>>
>> 8fc312b32b2  mm/hugetlbfs: fix error handling when setting up mounts
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.4.y&id=3f549fb42a39bea3b29c0fc12afee53c4a01bec9
> 
> I see that Mike Kravetz suggested not putting this patch into stable in
> 
> https://lore.kernel.org/lkml/befca227-cb8a-8f47-617d-e3bf9972bfec@oracle.com/
> 
> but it was picked through the autosel mechanism later.
> 

I think autosel is way too aggressive. This is an excellent example.

Guenter
