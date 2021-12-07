Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CB046BB12
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 13:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhLGMcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 07:32:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53819 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231795AbhLGMcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 07:32:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638880115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U86KNIlXWBU0MTv/F9LU3y5IqrvBGqYEtNBS3ySXeBs=;
        b=cagfr5xiejTCKvKcT1eoE8t5fFgtJiRBP779AAta8HP7tHNcCKFrSs3JIAroAfpjnEj+EG
        Ksr+hTHPitgaTwzAgI43IrtejUBSIsjta87a4cKUZIyjmpwgH8s77qfmM8wQEKMcGiX3U5
        KM/oUYcwMq3aOkEZz0mzONGg7sKiI9U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-v2Ck_YIOOj2c4l0ySPYrng-1; Tue, 07 Dec 2021 07:28:34 -0500
X-MC-Unique: v2Ck_YIOOj2c4l0ySPYrng-1
Received: by mail-wm1-f71.google.com with SMTP id 187-20020a1c02c4000000b003335872db8dso7662511wmc.2
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 04:28:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=U86KNIlXWBU0MTv/F9LU3y5IqrvBGqYEtNBS3ySXeBs=;
        b=GkuQS7xx/S/rLhP5UgwBzB006wkaCUkwaK3e5+r34Hg76VqpsNfZI6hbviy0MCND2F
         V/iclhWKD6/snNaIfaxs7iRJS2jNPFOGKBVnDSvrPoSQyTT+pW1ZzQEXR4m1J1XwzU7M
         gmJNEU+axVdC1RqluaxCLORXr3Vr0yDTN+nsUojd7jdoFbv/U7u2FxfNUqq7VHeccl/L
         kueuJE6xPat6MxMEZoJyaj+djzSLdKegloHhtsCTlho9bkpouFc0n8OcJqD0zXN3XwRM
         TFtSTk/C+og4jvo/oYk0Dp/VeGixyB/Qjzbn08jKDn1Plj4sndTjAYDGckGX6XI7zD7k
         MVHw==
X-Gm-Message-State: AOAM533qiNyLYQVrlMVAZGelFTlXK6TmUi3usQ9AHjy4TgQDSnCYAiIC
        unnxvvUDV4rA8//XTFhO0eQGUe+tRNc3i/2DrfhXnf8fdNmcC1YZVOtEsMNc0fRj7LrZ+ukIwyS
        mCoh5zkQC5j2ivq+m
X-Received: by 2002:a05:600c:1e8b:: with SMTP id be11mr6643923wmb.40.1638880112897;
        Tue, 07 Dec 2021 04:28:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyueHJH/VSBXoMRrxMAPOq/Sw7KkduJI/w9KW7Jk8hxAx8dqCJ+QrFIwPfr2gfiIEu/otuukA==
X-Received: by 2002:a05:600c:1e8b:: with SMTP id be11mr6643882wmb.40.1638880112674;
        Tue, 07 Dec 2021 04:28:32 -0800 (PST)
Received: from [192.168.3.132] (p4ff23e57.dip0.t-ipconnect.de. [79.242.62.87])
        by smtp.gmail.com with ESMTPSA id o25sm2537500wms.17.2021.12.07.04.28.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 04:28:32 -0800 (PST)
Message-ID: <ab5cfba0-1d49-4e4d-e2c8-171e24473c1b@redhat.com>
Date:   Tue, 7 Dec 2021 13:28:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <2e191db3-286f-90c6-bf96-3f89891e9926@gmail.com>
 <YYqstfX8PSGDfWsn@dhcp22.suse.cz> <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz> <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <1043a1a4-b7f2-8730-d192-7cab9f15ee24@redhat.com>
 <Ya9P5NxhcZDcyptT@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
In-Reply-To: <Ya9P5NxhcZDcyptT@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>>> +			free_area_init_memoryless_node(nid);
>>
>> That's really just free_area_init_node() below, I do wonder what value
>> free_area_init_memoryless_node() has as of today.
> 
> I am not sure there is any real value in having this special name for
> this but I have kept is sync with what x86 does currently. If we want to
> remove the wrapper then just do it everywhere. I can do that on top.
> 

Sure, just a general comment.

>>> +			continue;
>>> +		}
>>> +
>>>  		free_area_init_node(nid);
>>>  
>>>  		/* Any memory on that node */
>>>
>>> Could you give it a try? I do not have any machine which would exhibit
>>> the problem so I cannot really test this out. I hope build_zone_info
>>> will not choke on this. I assume the node distance table is
>>> uninitialized for these nodes and IIUC this should lead to an assumption
>>> that all other nodes are close. But who knows that can blow up there.
>>>
>>> Btw. does this make any sense at all to others?
>>>
>>
>> __build_all_zonelists() has to update the zonelists of all nodes I think.
> 
> I am not sure what you mean. This should be achieved by this patch
> because the boot time build_all_zonelists will go over all online nodes

"Over all possible nodes", including online and offline ones, to make
sure any possible node has a valid pgdat. IIUC, you're not changing
anything about online vs offline nodes, only that we have a pgdat also
for offline nodes.

> (i.e. with pgdat). free_area_init happens before that. I am just worried
> that the arch specific node_distance() will generate a complete garbage
> or blow up for some reason. 

Assume you online a new zone and then call __build_all_zonelists() to
include the zone in all zonelists (via online_pages()).
__build_all_zonelists() will not include offline nodes (that still have
a pgdat with a valid zonelist now).

Similarly, assume you online a zone and then call
__build_all_zonelists() to exclude the zone from all zonelists (via
offline_pages()). __build_all_zonelists() will not include offline nodes
(that still have a pgdat with a valid zonelist now).

Essentially, IIRC, even after your change
start_kernel()->build_all_zonelists(NULL)->build_all_zonelists_init()->__build_all_zonelists(NULL)
won't initialize the zonelist of the new pgdat, because the nodes are
offline.

I'd assume we'd need

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c5952749ad40..e5d958abc7cc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6382,7 +6382,7 @@ static void __build_all_zonelists(void *data)
        if (self && !node_online(self->node_id)) {
                build_zonelists(self);
        } else {
-               for_each_online_node(nid) {
+               for_each_node(nid) {
                        pg_data_t *pgdat = NODE_DATA(nid);

                        build_zonelists(pgdat);

to properly initialize the zonelist also for the offline nodes with a
valid pgdat.

But maybe I am missing something important regarding online vs. offline
nodes that your patch changes?

-- 
Thanks,

David / dhildenb

