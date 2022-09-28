Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C605ED461
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 07:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiI1FyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 01:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbiI1FyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 01:54:16 -0400
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B071114C5;
        Tue, 27 Sep 2022 22:54:12 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id k3-20020a05600c1c8300b003b4fa1a85f8so416680wms.3;
        Tue, 27 Sep 2022 22:54:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=e/AxR92fdMvUsRyAOs75fsOhkSKpfOoOSKYmQf8bTLo=;
        b=JtgnxWRSnhvXes6SsrrqNkWwEso+BLSyEbs2EM9Mfvi0Xvh+vCHMFZpFWIiPWx+s18
         41zIjBNBypP+x30p56tekhO6T1ZDktq85sLrrYLuhZEKBnHWmySFvbIgVqQkxf0OjeKd
         RlBH8tqoRtlOHSUW19k/zh61N5ztsGU1d28pIS50BtvF2Vla6Uugt38Ihi+d8R39ydJG
         2PDJjgGjFAkmAfMe3Lasd/rGNJIPR6vaQo85FpaJqe96lyBgJ2Oe5Z0xaHOVSMrxJkQl
         MyuNESN1nJTBMoLSYI/lCIooB5Tet9P3zasi1HQBWMoJcRb5kU0iKrA7ykDMazbWAQCl
         zu1g==
X-Gm-Message-State: ACrzQf0pRFMahkmFIDKW+3M1zGak1MtuR3f1e6CxYrg9AimHuptojpMF
        YOwq4GLpTH4g+o4cTXT3vVDdTT4dPnA=
X-Google-Smtp-Source: AMsMyM6zK1/H4LnUiov2C5PfNfRh9udSn6XGNZwDn8ijZ9XDjs4PnlinRbO6FUmDwN3rwvhxTm+BEQ==
X-Received: by 2002:a05:600c:2118:b0:3b4:76ce:d274 with SMTP id u24-20020a05600c211800b003b476ced274mr5365517wml.95.1664344450908;
        Tue, 27 Sep 2022 22:54:10 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id s2-20020a5d4ec2000000b00228d67db06esm3270829wrv.21.2022.09.27.22.54.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 22:54:10 -0700 (PDT)
Message-ID: <d62fb82c-99fb-1f22-cf44-28d72953f055@kernel.org>
Date:   Wed, 28 Sep 2022 07:54:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 5.19 014/207] Revert "usb: add quirks for Lenovo OneLink+
 Dock"
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.com>,
        Jean-Francois Le Fillatre <jflf_kernel@gmx.com>,
        stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20220926100806.522017616@linuxfoundation.org>
 <20220926100807.118539823@linuxfoundation.org>
 <d9d9651b-2561-03ce-8076-5b471929ff2d@kernel.org>
 <YzKOdhT7jTXwCaG8@kroah.com>
 <5ce2a0bd-d39a-71d7-2327-3850dfdd646c@kernel.org>
 <YzKYyDaTsoX1RliA@kroah.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <YzKYyDaTsoX1RliA@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27. 09. 22, 8:31, Greg Kroah-Hartman wrote:
> On Tue, Sep 27, 2022 at 08:18:26AM +0200, Jiri Slaby wrote:
>> On 27. 09. 22, 7:47, Greg Kroah-Hartman wrote:
>>> On Tue, Sep 27, 2022 at 07:23:46AM +0200, Jiri Slaby wrote:
>>>> I wonder, does it make sense to queue the commit (as 011/207) and
>>>> immediately its revert (the patch below) in a single release? I doubt
>>>> that...
>>>>
>>>> The same holds for 012 (patch) + 015 (revert).
>>>
>>> Yes it does, otherwise tools will pick up "hey, you forgot this patch
>>> that should have been applied here!" all the time.  Having the patch,
>>> and the revert, in the tree prevents that from happening.
>>
>> It'd be fairly easy to fix the tools not to pick up reverted commits, right?
> 
> Not really as they are usually quite "far" away from the original
> commits.

Yes, but you need to deal with this only in a particular release (a 
revert has to be applied if the commit is already in some previous 
release, of course).

> But hey, if you have some scripts that can find all of that, I'm all for
> it, the ones I have right now don't account for this.

I don't know your/Sasha's scripts. But they are apparently able to find 
the revert as can we see above. So instead of direct:
   cherry-pick revert-patch-for-commit-X
it would be:
   if (PATCH=`git grep -l "[Cc]ommit X" queue-RELEASE/`)
     git rm PATCH
   else
     cherry-pick revert-patch-for-commit-X
   fi

Or am I missing something?

thanks,
-- 
js

