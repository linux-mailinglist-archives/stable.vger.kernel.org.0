Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0D442308F
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 21:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhJETJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 15:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhJETJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 15:09:37 -0400
Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [IPv6:2a0b:5c81:1c1::37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E675FC061749;
        Tue,  5 Oct 2021 12:07:46 -0700 (PDT)
Received: from [172.16.24.131] (73-55.dynamonet.fi [85.134.55.73])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: tmb@iki.fi)
        by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 6293A1B001B4;
        Tue,  5 Oct 2021 22:07:43 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
        t=1633460863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JEWyRBhh3Ae6pPANgm7coVZ29Z0Zpt73cs/qEjDzOxA=;
        b=WEhsYjjvKfIfaJUGcM3VXgyhTp7UfVMNBnM8b3s1rmZemGS88oVYhjGGBt/M8p9Xvm++AY
        F24S3X9u3Xl7eMkAGFjcl5b9cd1j8iUf8koZZKgTJgJaqN6Uh7Ez+g0Eo7q4saiqdX/XjO
        jZ420AQP0EMKSm0cgCEHs+os61opnuciCww3yLBNNu5qzqK/xUVCYbJ90jVBsXyWIMin7r
        o6Snv0KW2AVz2g+L8wEG5SIzF6Hsda/CYXW8hvojzWFW/nV+Qyy5hX7CgMe4+CJvn+Px/C
        JR4Jot0KDi4Ylc79XCtbdviP9ZrLiRASbHDrHlVsxhtj+JDkojqjZ80kOn6oZA==
Message-ID: <4ecdfb07-4957-913a-6bd3-4410bd2cb5c0@iki.fi>
Date:   Tue, 5 Oct 2021 22:07:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH 5.14 000/173] 5.14.10-rc2 review
Content-Language: en-US
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211005083311.830861640@linuxfoundation.org>
 <20211005155909.GA1386975@roeck-us.net>
From:   Thomas Backlund <tmb@iki.fi>
In-Reply-To: <20211005155909.GA1386975@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
ARC-Seal: i=1; s=lahtoruutu; d=iki.fi; t=1633460863; a=rsa-sha256;
        cv=none;
        b=G0Fa8vg741Tj6T8nxLSD3BPjbi89O5yd3g3yMTrUgNBjZ33Ii2+cR9v4CHwNJlIUip+wA4
        /yYVKbwHPLLYkrKREzmz9zIbDvJxZF/Q9anL4oLYkSRW99RXeynjpJnZoubETn+u5QqXMt
        7qu8QZ+CRf4262OKsuxvDyTdNpzw4EGYEjt5YkCe1HFJ9BQ3SCsXh9DVZWc+DRy74oqASx
        FsrvzF3ps3JiJ3e+GrUtuaGGDLFPFbXmOc5KFC+ERwowsK6qWE8RWnu/QAxj+LEuRO6Wj+
        6ufJDq7CSvzJ4r6CE6mehBQ0j6ynMI6JD1nVcE/QSPcgblFHt8Qjfk+sOA10zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=lahtoruutu; t=1633460863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JEWyRBhh3Ae6pPANgm7coVZ29Z0Zpt73cs/qEjDzOxA=;
        b=tLy9r2K3PDCTag6b5XavBTNDKy3swqX+i1OruVXsNCQ4Tj4Jt7Ng6h/3KToNLgvQy2qumM
        FLMa+u1n5WA20dRgMkmHnX39WGMxAfJIA/8BPU++8Ds5MbcelpfB+u6zuLMUfI8VXcdYbl
        EB6tWymuqm7OoxL0m5/YNwo6tHrOI2YkpYSXgsF0t9oQtT5WeQQ+cxS+/F9X5SrLw7fFki
        w6O/zxYfjSwknpiNtXGsNFKZ8dPWGLvtgl8a8fD5ns//Ewjd9tAhreVwhmqvwjLq629642
        kdkoTl9D8yvAo5zSYf0VwELyqYOa6jJzSsWhm7gZLLM1JTQ50d4zeZrYiwXRhg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=tmb@iki.fi smtp.mailfrom=tmb@iki.fi
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 2021-10-05 kl. 18:59, skrev Guenter Roeck:
> On Tue, Oct 05, 2021 at 10:38:40AM +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.14.10 release.
>> There are 173 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
>> Anything received after that time might be too late.
>>
> 
> AFAICS the warning problems are still seen. Unfortunately I won't be able
> to bisect since I have limited internet access.
> 
> Guenter
> 
> =========================
> WARNING: held lock freed!
> 5.14.10-rc2-00174-g355f3195d051 #1 Not tainted
> -------------------------
> ip/202 is freeing memory c000000009918900-c000000009918f7f, with a lock still held there!
> c000000009918a20 (sk_lock-AF_INET){+.+.}-{0:0}, at: .sk_common_release+0x4c/0x1b0
> 2 locks held by ip/202:
>   #0: c00000000ae149d0 (&sb->s_type->i_mutex_key#5){+.+.}-{3:3}, at: .__sock_release+0x4c/0x150
>   #1: c000000009918a20 (sk_lock-AF_INET){+.+.}-{0:0}, at: .sk_common_release+0x4c/0x1b0
> 
> 


Isn't this a fallout of:

queue-5.14/net-introduce-and-use-lock_sock_fast_nested.patch
that has: Fixes: 2dcb96bacce3 ("net: core: Correct the 
sock::sk_lock.owned lockdep annotations")

BUT:

$ git describe --contains 2dcb96bacce3
v5.15-rc3~30^2~26

--
Thomas

