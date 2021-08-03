Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EC43DF162
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 17:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbhHCP11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 11:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236616AbhHCP11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 11:27:27 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A77C061757;
        Tue,  3 Aug 2021 08:27:14 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id x15so28528441oic.9;
        Tue, 03 Aug 2021 08:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pFZLhwf8uWtcoFg6OfsbtxXzjUjvk0s3pcwcMmfspy0=;
        b=ni3iNbITXEYEyCTXCxrlMZen+f7/t4wpiwd3sXfLn+H4GebKXwRulbPoh5qXFILWcE
         1F4J6eS7SDQ4KZFZ2v0V4Dadtc6qFFQJ4BkFhEbbLf/uPgAGLMaBFpsYt8VaJhNVQtoS
         XY5HviP+PGT8ayMYiarLdzcJVbh4ilO+kIA/EYW4aqH7IBMYkgqCJISMPvakCGN5729N
         /pF2bqYh2HSVXLurw/12eKdoLq/loO5HeM1BESS3fE+zQBE/btM6qdLZ5SJeWLztHuAX
         z/obhYGfen9a7Ke9Iej4P0fo6lFXQIgYHjEMggmXUQP4wGvWC5li+12Hy/YVb8T7HKL4
         UuWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pFZLhwf8uWtcoFg6OfsbtxXzjUjvk0s3pcwcMmfspy0=;
        b=ZlgowPs0hNdbEdRhgqCiYvFjllRwdEshV2cBXxTuSMB7WxYf5SVdDC+L4UnUA+N7K7
         MZJX3Atv4mUp+Xh8bEr+6STXwmDXRpAPpH2Iqp2zeJX846EjtbTCLDxy3IV8W0v9tv3M
         lDbiaFdPsOh4NuEMvbzu5h7HWfbEvE+Mc4hAyWWS92BdBJS8Nj4odLvmSjcVEvufL9/d
         9ZMD0cn+37uBfM4F7hPzPOgvTH0v7LwPiOWxGDZFvc19pRuyaGcSuZy53z4UmINmLTfY
         G9aT/Xh2a5ygyS+T1QyKWomuqvLibkSWylQnSgOIAVLHirhmVtDXnj2DdbALjngxAzzU
         FulQ==
X-Gm-Message-State: AOAM531oW7OMoJQYTInicMRIhKn+cHFizVu4RlTfAMKiO4H8iNPNMZeq
        1AL+PX3O92elz2SpqgJZptA=
X-Google-Smtp-Source: ABdhPJzyv9fwUlGn+ncWIpH5NywzojqyMhKAAI0QZZ4oVryaoqVD0LqTAYzCtgBIff8stPTX63tAFQ==
X-Received: by 2002:a05:6808:1d6:: with SMTP id x22mr14906323oic.8.1628004434089;
        Tue, 03 Aug 2021 08:27:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j30sm2543937otc.43.2021.08.03.08.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 08:27:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Jan Kiszka <jan.kiszka@siemens.com>,
        Jean Delvare <jdelvare@suse.de>,
        linux-watchdog@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Cc:     Wim Van Sebroeck <wim@linux-watchdog.org>,
        Michael Marley <michael@michaelmarley.com>
References: <20210803165108.4154cd52@endymion>
 <e13f45c4-70e2-e2c2-9513-ce38c8235b4f@siemens.com>
 <67815219-7226-1a90-4599-5649e9bbc861@siemens.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: Faulty commit "watchdog: iTCO_wdt: Account for rebooting on
 second timeout"
Message-ID: <2dae7010-f375-ecbe-c477-0bbd28b92aac@roeck-us.net>
Date:   Tue, 3 Aug 2021 08:27:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <67815219-7226-1a90-4599-5649e9bbc861@siemens.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/3/21 8:01 AM, Jan Kiszka wrote:
> On 03.08.21 16:59, Jan Kiszka wrote:
>> On 03.08.21 16:51, Jean Delvare wrote:
>>> Hi all,
>>>
>>> Commit cb011044e34c ("watchdog: iTCO_wdt: Account for rebooting on
>>> second timeout") causes a regression on several systems. Symptoms are:
>>> system reboots automatically after a short period of time if watchdog
>>> is enabled (by systemd for example). This has been reported in bugzilla:
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=213809
>>>
>>> Unfortunately this commit was backported to all stable kernel branches
>>> (4.14, 4.19, 5.4, 5.10, 5.12 and 5.13). I'm not sure why that is the
>>> case, BTW, as there is no Fixes tag and no Cc to stable@vger either.
>>> And the fix is not trivial, has apparently not seen enough testing,
>>> and addresses a problem that has a known and simple workaround. IMHO it
>>> should never have been accepted as a stable patch in the first place.
>>> Especially when the previous attempt to fix this issue already ended
>>> with a regression and a revert.
>>>
>>> Anyway... After a glance at the patch, I see what looks like a nice
>>> thinko:
>>>
>>> +	if (p->smi_res &&
>>> +	    (SMI_EN(p) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN | GBL_SMI_EN))
>>>
>>> The author most certainly meant inl(SMI_EN(p)) (the register's value)
>>> and not SMI_EN(p) (the register's address).
>>>

Yes, shame on me that I didn't see that.

>>
>> https://lkml.org/lkml/2021/7/26/349
>>
> 
> That's for the fix (in line with your analysis).
> 
> I was also wondering if backporting that quickly was needed. Didn't
> propose it, though.
> 

I'd suggest to discuss that with Greg and Sasha. Backporting is pretty
aggressive nowadays.

Guenter
