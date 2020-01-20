Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD54A142826
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 11:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgATKVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 05:21:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48448 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726148AbgATKVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 05:21:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579515703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=67Jq//WKsjDLFPDEaYBVfnLMTqVMtRKgNH9ezxHhqMg=;
        b=KqQ4T0prMUyF2sn9KgAAu3rDEqiquTt1Z5WCtFWWxzn/1hXc4R1wXzUPxQSSIBfn68IOcc
        5f/Q4YXkOpws4HTsYMQC26/VbnTqKML1lNFuF0znoNhOIJrnfPD2oGWY5sKQaOgzWyRbQ0
        gp5gYrsDlEzeC05w+Esn7h/SEfFNwTo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-SNcj0_AwP-iM6JOG7sfFOw-1; Mon, 20 Jan 2020 05:21:42 -0500
X-MC-Unique: SNcj0_AwP-iM6JOG7sfFOw-1
Received: by mail-wr1-f69.google.com with SMTP id 90so13866533wrq.6
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 02:21:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=67Jq//WKsjDLFPDEaYBVfnLMTqVMtRKgNH9ezxHhqMg=;
        b=KC7vPozHs/q8MNNz00YXlId40KKux1Ao/psBGq9LsqqZ0YVju+YGGJdt8281nnH9UA
         WGsouRe4c/4dij29FfTBRsgufZ5L4wWNRD9/Kxr38F4EMFufWIqcp7SPhsVwIyfyh/wN
         gIEhxVHdEBM1JAJ1qSa0K+0HEWu5QtFXQbxloX7YKFLvmzWDkZznMtWju7fsbgqPNfLb
         N646lZbw5QIfZyg//BJE+1ZYdjfFzIir6WW0gdthnoZDH17CN+uslycjbE/DqorxPui7
         LZ0SuN5ajFc6OuVvjH3ke8MDlAlSacDc/lIOzN2EWqSowsPxqdoaxSMKzNCzndneCBNV
         8qqQ==
X-Gm-Message-State: APjAAAXpLZC4jonkQkj68M7jM1ak27oIQFQ/KrHKEhKnftbbXKiTxH8l
        dJw5OpTYTnkja8CReOyUdvVRmKhj2yzEdT9OsFhR9357Z3Sp7bslv3fowGL+ca9ZgUiMz3QMcal
        mTkacNe3XLwkVXP9p
X-Received: by 2002:a05:600c:2150:: with SMTP id v16mr17832472wml.156.1579515700323;
        Mon, 20 Jan 2020 02:21:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqwOmP+ELYrXivXo+i0W5sc55kAKNukW98pZAJ6186zbUwlTIDccyDsLIjkL0bVQpkRQKBr10g==
X-Received: by 2002:a05:600c:2150:: with SMTP id v16mr17832449wml.156.1579515700094;
        Mon, 20 Jan 2020 02:21:40 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f1sm21994131wmc.45.2020.01.20.02.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 02:21:39 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Michael Kelley <mikelley@microsoft.com>,
        "lantianyu1986\@gmail.com" <lantianyu1986@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal\@kernel.org" <sashal@kernel.org>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "linux-hyperv\@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH V2] x86/Hyper-V: Balloon up according to request page number
In-Reply-To: <MW2PR2101MB10520A27DC77E3B2F15EC75FD7300@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200116141600.23391-1-Tianyu.Lan@microsoft.com> <MW2PR2101MB10520A27DC77E3B2F15EC75FD7300@MW2PR2101MB1052.namprd21.prod.outlook.com>
Date:   Mon, 20 Jan 2020 11:21:38 +0100
Message-ID: <87v9p6fmx9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Michael Kelley <mikelley@microsoft.com> writes:

> From: Tianyu Lan <Tianyu.Lan@microsoft.com> Sent: Thursday, January 16, 2020 6:16 AM
>> 
>> Current code has assumption that balloon request memory size aligns
>> with 2MB. But actually Hyper-V doesn't guarantee such alignment. When
>> balloon driver receives non-aligned balloon request, it produces warning
>> and balloon up more memory than requested in order to keep 2MB alignment.
>> Remove the warning and balloon up memory according to actual requested
>> memory size.
>> 
>> Fixes: f6712238471a ("hv: hv_balloon: avoid memory leak on alloc_error of 2MB memory
>> block")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>> ---
>> Change since v2:
>>     - Change logic of switching alloc_unit from 2MB to 4KB
>>     in the balloon_up() to avoid redundant iteration when
>>     handle non-aligned page request.
>>     - Remove 2MB alignment operation and comment in balloon_up()
>> ---
>>  drivers/hv/hv_balloon.c | 12 ++++--------
>>  1 file changed, 4 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
>> index 7f3e7ab22d5d..536807efbc35 100644
>> --- a/drivers/hv/hv_balloon.c
>> +++ b/drivers/hv/hv_balloon.c
>> @@ -1684,7 +1684,7 @@ static unsigned int alloc_balloon_pages(struct
>> hv_dynmem_device *dm,
>>  	if (num_pages < alloc_unit)
>>  		return 0;
>
> The above test is no longer necessary.  The num_pages < alloc_unit
> case is handled implicitly by your new 'for' loop condition.
>
>> 
>> -	for (i = 0; (i * alloc_unit) < num_pages; i++) {
>> +	for (i = 0; i < num_pages / alloc_unit; i++) {
>>  		if (bl_resp->hdr.size + sizeof(union dm_mem_page_range) >
>>  			HV_HYP_PAGE_SIZE)
>>  			return i * alloc_unit;
>> @@ -1722,7 +1722,7 @@ static unsigned int alloc_balloon_pages(struct
>> hv_dynmem_device *dm,
>> 
>>  	}
>> 
>> -	return num_pages;
>> +	return i * alloc_unit;
>>  }
>> 
>>  static void balloon_up(union dm_msg_info *msg_info)
>> @@ -1737,9 +1737,6 @@ static void balloon_up(union dm_msg_info *msg_info)
>>  	long avail_pages;
>>  	unsigned long floor;
>> 
>> -	/* The host balloons pages in 2M granularity. */
>> -	WARN_ON_ONCE(num_pages % PAGES_IN_2M != 0);
>> -
>>  	/*
>>  	 * We will attempt 2M allocations. However, if we fail to
>>  	 * allocate 2M chunks, we will go back to PAGE_SIZE allocations.
>> @@ -1749,14 +1746,13 @@ static void balloon_up(union dm_msg_info *msg_info)
>>  	avail_pages = si_mem_available();
>>  	floor = compute_balloon_floor();
>> 
>> -	/* Refuse to balloon below the floor, keep the 2M granularity. */
>> +	/* Refuse to balloon below the floor. */
>>  	if (avail_pages < num_pages || avail_pages - num_pages < floor) {
>>  		pr_warn("Balloon request will be partially fulfilled. %s\n",
>>  			avail_pages < num_pages ? "Not enough memory." :
>>  			"Balloon floor reached.");
>> 
>>  		num_pages = avail_pages > floor ? (avail_pages - floor) : 0;
>> -		num_pages -= num_pages % PAGES_IN_2M;
>>  	}
>> 
>>  	while (!done) {
>> @@ -1770,7 +1766,7 @@ static void balloon_up(union dm_msg_info *msg_info)
>>  		num_ballooned = alloc_balloon_pages(&dm_device, num_pages,
>>  						    bl_resp, alloc_unit);
>> 
>> -		if (alloc_unit != 1 && num_ballooned == 0) {
>> +		if (alloc_unit != 1 && num_ballooned != num_pages) {
>
> Maybe I'm missing something, but I don't think Vitaly's optimization works.  If
> alloc_unit specifies 2 Mbytes, and num_pages specifies 3 Mbytes, then num_ballooned
> will come back as 2 Mbytes, which is correct.  But if we revert alloc_unit to 1 page and
> "continue" in that case, we will lose the 2 Mbytes of memory (it's not freed), and the
> next time through the loop will try to allocate only 1 Mbyte (because num_pages
> will be decremented by num_ballooned).  I think the original code does the right thing.
>

True, nice catch! What I meant to say is that we can avoid sending two
replies to the host and get away with just one. Unfortunately,
"num_ballooned != num_pages" modification is not sufficient as
alloc_balloon_pages() will overwrite bl_resp->range_array[] (as it
always starts from 0). I think we can still achieve the goal by
allocating bl_resp outside of the loop and filling it from
range_array[range_count] instead of range_array[i] but it seems to big
of a change for now particular gain. Let's just drop the idea.


> Michael
>
>>  			alloc_unit = 1;
>>  			continue;
>>  		}
>> --
>> 2.14.5
>

-- 
Vitaly

