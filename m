Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501A83C684
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 10:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404389AbfFKIuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 04:50:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35637 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391372AbfFKIuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 04:50:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id m3so12049073wrv.2;
        Tue, 11 Jun 2019 01:50:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=F8t7+CXyU3zpeUeJufO2uaoKIunmBcywDp3iB8C1DIQ=;
        b=ErZi4NeMHqMQgccvmpfskEbY/C3fQ2BJqGsv+AbnDv2IkGlHfoR0JPBzAmqR68WwvR
         J1qmt9J+yllEaeiurfmLWQSdJhqoCUACErn0ar7fOsa/2ftTqXj2HsEmYBFqzPpetM2O
         UdrsZ0ppPRiBMFIRHZPMOJryWUv00QfVnR9N4WsWz8reOpUiZlnQXUe35IzUtUYBGZX1
         1zMJGmKumKHDNbpKstLUz/rSormbisgJS86H3XtYSZ9cOICSxs4qAXsTAXuabnRUUoVC
         8qkK2AYG4MJqEhGWSAs+Njj6bo+PRr8Vf5mwnRetXWrt8vuhBLtLJfSCAcksd3q+8T2j
         p7og==
X-Gm-Message-State: APjAAAVzkVLAhzkLH4pxpH1vR74axUo1ryN3vnAYilGotAMZqPVHYH3r
        9dDEoQ/3J6grXQs26A5TxSy9GMtm
X-Google-Smtp-Source: APXvYqxDX0xMv+h9F75hcEEL59Orr0isbslVaACCHb5BoK31VG3WHQWjNRI0l5wS8CecEeo/PVKf9Q==
X-Received: by 2002:adf:afd0:: with SMTP id y16mr49552774wrd.22.1560243015581;
        Tue, 11 Jun 2019 01:50:15 -0700 (PDT)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id z5sm1529415wma.36.2019.06.11.01.50.14
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 01:50:14 -0700 (PDT)
Subject: Re: [PATCH 5.1 56/85] doc: Cope with the deprecation of AutoReporter
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Backlund <tmb@mageia.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20190607153849.101321647@linuxfoundation.org>
 <20190607153855.717899507@linuxfoundation.org>
 <1fbb40df-d420-9f10-34a9-340b3156eb7c@suse.cz>
 <20190610073119.GB20470@kroah.com>
 <f20b3005-53f8-607a-e995-741836b3f5f0@suse.cz>
 <20190610074840.GB24746@kroah.com> <20190610063340.051ee13b@lwn.net>
 <20190610140528.GA18627@kroah.com>
 <f53d2786-a857-d69c-2ead-6e4c19708d6c@mageia.org>
 <20190610143918.GA31086@kroah.com>
From:   Jiri Slaby <jslaby@suse.cz>
Openpgp: preference=signencrypt
Autocrypt: addr=jslaby@suse.cz; prefer-encrypt=mutual; keydata=
 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
Message-ID: <64bac6d9-3a2d-058b-9b08-9bf4dc82a692@suse.cz>
Date:   Tue, 11 Jun 2019 10:50:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190610143918.GA31086@kroah.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10. 06. 19, 16:39, Greg Kroah-Hartman wrote:
>>>> The fix for that is 551bd3368a7b (drm/i915: Maintain consistent
>>>> documentation subsection ordering) which was also marked for stable.  Jiri,
>>>> do you somehow not have that one?
>>>
>>> It's part of this series, which is probably why it works for me.  Don't
>>> know why it doesn't work for Jiri, unless he is cherry-picking things?
>>>
>>
>> Actualliy it is not.
>>
>> This patch Jiri responded to / points out to break stuff is part of 5.1.8,
>> but the fix in in review queue for 5.1.9 :
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/diff/queue-5.1/drm-i915-maintain-consistent-documentation-subsection-ordering.patch?id=29167bff7a1c0d79dda104c44c262b0bc4cd6644
> 
> Ah, that makes more sense, and is why my build works for me :)
> 
> Jiri, wait a few days and this will get fixed...

No problem. I just pushed this one and 5.1.9 will dispose it later.

thanks,
-- 
js
suse labs
