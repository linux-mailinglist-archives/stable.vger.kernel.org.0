Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E3C1EE598
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 15:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgFDNrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 09:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728664AbgFDNrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 09:47:03 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1385FC08C5C0
        for <stable@vger.kernel.org>; Thu,  4 Jun 2020 06:47:02 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bh7so2192687plb.11
        for <stable@vger.kernel.org>; Thu, 04 Jun 2020 06:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y9WKWKkyuRaTgGWeGW9OlNM9SLQ+kO/gz12YBkpAsPE=;
        b=JKKxbZPn4YtU7MJbrdlCDqw5NFuQIZ6R1qb3OpVn44hEIMuD9rVjdd1nj6WOieQjrU
         H0c7XBIqJ9NPOz4yckMoGt4Uk4n2NQfV+wpEEJGFyliHdHPEQ6ffBLEoU0aEFfVneJYL
         4XIrZ154dKk7ICuDUS58KyB451UEC1aBzJruAHzhxzmwzLDtcEeyAAXDggjG39lzShC3
         guPoA57PTYHwDHsf28Dnnxk0gc5IJlTNqCR7Fl1SMdQE+3IEM2uHxr97O6DxGyx/y3dC
         mKhSxVhMPqaabki8pKHxACIl6uFRZq7COeYXUzFIsXVPytDWm22/C8+fAgyA+aPgxJCE
         154w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Y9WKWKkyuRaTgGWeGW9OlNM9SLQ+kO/gz12YBkpAsPE=;
        b=jTtaaCztci7orPE/PQ0ZrJOPzeXDPUPrD4IwDdfJzLO1HzHi/FVi0GfdyzxsYAoppF
         4sE4KDzBjbLYH0s1tp+z33TLaUemM678Dugq6L9Yp542lTL61fsfpysCOET3Y9BuBQVr
         Hp6EX0Nly/3QciOUTw2WyVw1RwWw6/7fewNxZcDK+QQcYGPZfqyfbqDr8S9M732G6FSl
         ofS6GLIIRW2/wsljE0m8R1LtidtmxRz4nuIukSy3vD0jFR9D6zxYhN/Pfy4m06TI/Gqq
         M2lV0+/VqKj1j9MFxdDXa7Dvk7I3AQ6deDRXYnrh+vAMDvJR4pBz/Z/49M0J0Y4rsaGA
         ewgw==
X-Gm-Message-State: AOAM530QU0Mt/fgWg8xOKbp7lNz1kFXD06MXIROTCJ4PUOgxiL5mazWY
        bBlIA51amig8yN7brnNI0Wk=
X-Google-Smtp-Source: ABdhPJxSwFFYVnU2NebnH8LNYpU5SxXHUzh9dWvuZDznD6/45bpULsiBLdNDvW0MTSDr9z84HYovog==
X-Received: by 2002:a17:90a:34cc:: with SMTP id m12mr6213979pjf.123.1591278421518;
        Thu, 04 Jun 2020 06:47:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o62sm4216654pfb.219.2020.06.04.06.46.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 06:47:00 -0700 (PDT)
Subject: Re: Patches to apply to stable releases [6/3/2020]
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
References: <20200603202135.78725-1-linux@roeck-us.net>
 <20200604100929.GA550434@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <8af88326-ec7c-f4de-be13-160a506560f8@roeck-us.net>
Date:   Thu, 4 Jun 2020 06:46:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200604100929.GA550434@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/4/20 3:09 AM, Greg Kroah-Hartman wrote:
> On Wed, Jun 03, 2020 at 01:21:35PM -0700, Guenter Roeck wrote:
>> Hi,
>>
>> Please consider applying the following patches to the listed stable
>> releases.
>>
>> The following patches were found to be missing in stable releases by the
>> Chrome OS missing patch robot. The patches meet the following criteria.
>> - The patch includes a Fixes: tag
>>   Note that the Fixes: tag does not always point to the correct upstream
>>   SHA. In that case the correct upstream SHA is listed below.
>> - The patch referenced in the Fixes: tag has been applied to the listed
>>   stable release
>> - The patch has not been applied to that stable release
>>
>> All patches have been applied to the listed stable releases and to at least
>> one Chrome OS branch. Resulting images have been build- and runtime-tested
>> (where applicable) on real hardware and with virtual hardware on
>> kerneltests.org.
>>
>> Thanks,
>> Guenter
>>
>> ---
>> Upstream commit 0e0bf1ea1147 ("perf stat: Zero all the 'ena' and 'run' array slot stats for interval mode")
>>   upstream: ToT
>>     Fixes: 51fd2df1e882 ("perf stat: Fix interval output values")
>>       in linux-4.4.y: 7629c7ef5291
>>       upstream: v4.5-rc4
>>     Affected branches:
>>       linux-4.4.y
>>       linux-4.9.y
>>       linux-4.14.y
>>       linux-4.19.y
>>       linux-5.4.y
>>       linux-5.6.y
>>       Presumably also linux-5.7.y but not checked/tested
> 
> You are starting to catch patches that are now in Linus's tree, but have
> not shown up in a -rc release yet.  We really should wait for these
> until they do show up in a real release, unless there is a specific need
> otherwise.
> 
> Usually I require the maintainer of the subsystem to ask me to merge
> those patches, as it gives me someone to blame if things go wrong :)
> 
> So can you hold off on these types of patches until they show up in a
> -rc release?
> 
Sure, NP.

Guenter
