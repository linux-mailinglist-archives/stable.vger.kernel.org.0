Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A4713A3CC
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 10:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgANJaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 04:30:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43092 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725820AbgANJaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 04:30:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578994236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dyYkc635y3Mg5t3JufpcgcFgpvBk0l6C1aELJD+IZMY=;
        b=JJpTu3VIUqU1ALNdfZl8sz0BdGweW3CQpcZbp9jjsD7EbzPwnlWLFPd62rr5ZKzEJsUubh
        1F7eKLVaIBoCUIT7j3ED0oGoBRsXAWs+uBIZbXYPG8zhp9clC3uRXVzd1y6nEVbaw68xGj
        tkkoG5XXAYgSEK5nTKqkoBV8E4UVIUs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-mkFIE02ZM9yTtY4Oa--jdA-1; Tue, 14 Jan 2020 04:30:35 -0500
X-MC-Unique: mkFIE02ZM9yTtY4Oa--jdA-1
Received: by mail-wm1-f70.google.com with SMTP id t4so3323423wmf.2
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 01:30:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dyYkc635y3Mg5t3JufpcgcFgpvBk0l6C1aELJD+IZMY=;
        b=kPYVZqXAoy9jOPDV83FNhLbPZ+bX9petvvYzODoVpqvsRFYuEx0nhoH1CBdZAgyr9n
         wIdx9qb9WZfTrKIWX42igx9suo7+09MQZ0cq9lPS5AfvtIF1/fJnuNrGtNjZN6A0yFS/
         2cuv49C4oHN1Qc/ncycyRJ9Jq3NP43kmFU/tUnpnd09m3YX0WBYJQC5Az5i2gTT3DwMW
         ti5HS9quHQ5KadgkwutwlPv2R1ciWLsG3jAIwGqXs0AveWyaFaoJ9pd609uxQf3ovMCq
         m0DG5M6qclraMO/y2p4obCs72Ng5etQ4TV84YEuFr58Cxv1q7XvfU6PTO8aRi5mMIsLB
         +0jw==
X-Gm-Message-State: APjAAAW7cfNXEMny6fja0CY3unjxqZNRCQC7d/CgfqiNBjMp5jkdW2eM
        x3jP5KK3JzfzKspDJdeisLQXZ0N5OUKJ8Jn/ffo3hIrO8xyNxM9Is7A4xT0IlUYtv5nBarcfQbj
        +n7f1kCSNSGv0sxNu
X-Received: by 2002:a5d:528e:: with SMTP id c14mr24834943wrv.308.1578994234013;
        Tue, 14 Jan 2020 01:30:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqyXeNav3h0jnfLrMNE1EGG4ZAk69SUcIbBWsZFpH1FAmt3/buT/FqY5AJA8v3Z60j/pDg7DlQ==
X-Received: by 2002:a5d:528e:: with SMTP id c14mr24834881wrv.308.1578994233668;
        Tue, 14 Jan 2020 01:30:33 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id p17sm17848989wmk.30.2020.01.14.01.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 01:30:32 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     lantianyu1986@gmail.com
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, akpm@linux-foundation.org,
        michael.h.kelley@microsoft.com, decui@microsoft.com
Subject: Re: [PATCH] x86/Hyper-V: Balloon up according to request page number
In-Reply-To: <20200114074435.12732-1-Tianyu.Lan@microsoft.com>
References: <20200114074435.12732-1-Tianyu.Lan@microsoft.com>
Date:   Tue, 14 Jan 2020 10:30:32 +0100
Message-ID: <87blr6pepz.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

lantianyu1986@gmail.com writes:

> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>
> Current code has assumption that balloon request memory size aligns
> with 2MB. But actually Hyper-V doesn't guarantee such alignment. When
> balloon driver receives non-aligned balloon request, it produces warning
> and balloon up more memory than requested in order to keep 2MB alignment.
> Remove the warning and balloon up memory according to actual requested
> memory size.
>
> Fixes: f6712238471a ("hv: hv_balloon: avoid memory leak on alloc_error of 2MB memory block")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  drivers/hv/hv_balloon.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> index 7f3e7ab22d5d..38ad0e44e927 100644
> --- a/drivers/hv/hv_balloon.c
> +++ b/drivers/hv/hv_balloon.c
> @@ -1684,7 +1684,7 @@ static unsigned int alloc_balloon_pages(struct hv_dynmem_device *dm,
>  	if (num_pages < alloc_unit)
>  		return 0;
>  
> -	for (i = 0; (i * alloc_unit) < num_pages; i++) {
> +	for (i = 0; i < num_pages / alloc_unit; i++) {
>  		if (bl_resp->hdr.size + sizeof(union dm_mem_page_range) >
>  			HV_HYP_PAGE_SIZE)
>  			return i * alloc_unit;
> @@ -1722,7 +1722,7 @@ static unsigned int alloc_balloon_pages(struct hv_dynmem_device *dm,
>  
>  	}
>  
> -	return num_pages;
> +	return i * alloc_unit;
>  }
>  
>  static void balloon_up(union dm_msg_info *msg_info)
> @@ -1737,9 +1737,6 @@ static void balloon_up(union dm_msg_info *msg_info)
>  	long avail_pages;
>  	unsigned long floor;
>  
> -	/* The host balloons pages in 2M granularity. */
> -	WARN_ON_ONCE(num_pages % PAGES_IN_2M != 0);
> -
>  	/*
>  	 * We will attempt 2M allocations. However, if we fail to
>  	 * allocate 2M chunks, we will go back to PAGE_SIZE allocations.

This looks correct but I've noticed we also have 

	/* Refuse to balloon below the floor, keep the 2M granularity. */
	if (avail_pages < num_pages || avail_pages - num_pages < floor) {
		pr_warn("Balloon request will be partially fulfilled. %s\n",
			avail_pages < num_pages ? "Not enough memory." :
			"Balloon floor reached.");

		num_pages = avail_pages > floor ? (avail_pages - floor) : 0;
		num_pages -= num_pages % PAGES_IN_2M;
	}

in balloon_up(). If 2M granularity is not guaranteed in the first place
we can't keep it.

Also, when alloc_balloon_pages() is called with 2M alloc_unit and the
region is not 2M aligned, it will return someething < num_pages, the
next condition, however, only checks for 0:

                if (alloc_unit != 1 && num_ballooned == 0) {
                        alloc_unit = 1;
                        continue;
                }

we will proceed to sending a response to server and try doing next
iteration by calling alloc_balloon_pages() with 2M alloc_unit again,
this will finally return 0 and we will switch to 4k. I think we can
optimize this to:

                if (alloc_unit != 1 && num_ballooned != num_pages) {
			alloc_unit = 1;
		        continue;
		}

-- 
Vitaly

