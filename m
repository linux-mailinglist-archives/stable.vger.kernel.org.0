Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B1542659A
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 10:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhJHIHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 04:07:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53066 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233345AbhJHIHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 04:07:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633680340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TF4BujFSeQ5kOB+yaF3TDp1qX43Am50rZssymfHLv4g=;
        b=BALTjwHYUak61f0g1VNR5TpQqDHxuZGoj362MF3RrhB1eczwTIQXYpCVQIj1PZ5Qx0dhBd
        HSWMzThy6m8BZ1UMUrjxlU9S6Cvwe5q44Gy6FSFTBUDo4Yrj2uEK1zjdOSeFTscF4mTBNz
        fe484o5YmqlZ9Qf6Cc5Nb4jf1nnVMjU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-LNO8jgcNOHqjhkwBdvnGuw-1; Fri, 08 Oct 2021 04:05:39 -0400
X-MC-Unique: LNO8jgcNOHqjhkwBdvnGuw-1
Received: by mail-wr1-f71.google.com with SMTP id 75-20020adf82d1000000b00160cbb0f800so5895318wrc.22
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 01:05:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=TF4BujFSeQ5kOB+yaF3TDp1qX43Am50rZssymfHLv4g=;
        b=LNdh51tdniCDt+h4ZeaElJovinicBQxRIMFGkKHMT9d891e0LDFv39giZTgjl0YkPz
         Rv4Fc5zS+tCJTJhVJBqyJQqmlz7oZ739qsPsreiuAyL2VxB6AmS28zH6oA/7gnqgFsp7
         fNPEN0iwg8M2CdqeljcOn4X4hglpMIUiFDdYLwKhmsOVvAfL+Y6YglXf3dfGAWAgF283
         2ft7+naQ+Gswnj46KteLBBw0rbDRSAMxfqxQu/+vHy5NqJFptd5bioNTQzVjxgPFuIXU
         zvh78StbDhzFFRB9agSC4cygVVuVgmQIlQKRf8mMkfbNLYZOeSy7/Wjnjxg/7HWX+wUS
         +9Qw==
X-Gm-Message-State: AOAM531GZdfeSmD6DnOJioYbffaAl+5+hVpLAFbK9Xmf3YcvXxP0t947
        AobEI1WOi//VBXYD+0rgvbDL0MKAxkM1biB7iudSNZ20RQLtQZ8JeGQOLKi/kt88vceuJKZqKUS
        Dh6eCEZ9LVl1mbOeagbc71TuXum/61QnfrDqncHFYdfzXT48Nm3v0fgBIGAYeeToB
X-Received: by 2002:a1c:2b85:: with SMTP id r127mr834474wmr.134.1633680338086;
        Fri, 08 Oct 2021 01:05:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0n6ilNdp7Wy9iR8wZmeJdLnDy4XTbFxhcWRg9/5MjxxWYBVQf1jYwMpPIUJV3qF0MIQ1dOw==
X-Received: by 2002:a1c:2b85:: with SMTP id r127mr834441wmr.134.1633680337829;
        Fri, 08 Oct 2021 01:05:37 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c676e.dip0.t-ipconnect.de. [91.12.103.110])
        by smtp.gmail.com with ESMTPSA id r18sm1744195wrs.47.2021.10.08.01.05.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 01:05:37 -0700 (PDT)
To:     Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nadav Amit <namit@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
References: <20211007235055.469587-1-namit@vmware.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] mm/userfaultfd: provide unmasked address on page-fault
Message-ID: <d5a244e9-a04e-8794-e55f-380db5e8c6c4@redhat.com>
Date:   Fri, 8 Oct 2021 10:05:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211007235055.469587-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.10.21 01:50, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Userfaultfd is supposed to provide the full address (i.e., unmasked) of
> the faulting access back to userspace. However, that is not the case for
> quite some time.
> 
> Even running "userfaultfd_demo" from the userfaultfd man page provides
> the wrong output (and contradicts the man page). Notice that
> "UFFD_EVENT_PAGEFAULT event" shows the masked address.
> 
> 	Address returned by mmap() = 0x7fc5e30b3000
> 
> 	fault_handler_thread():
> 	    poll() returns: nready = 1; POLLIN = 1; POLLERR = 0
> 	    UFFD_EVENT_PAGEFAULT event: flags = 0; address = 7fc5e30b3000
> 		(uffdio_copy.copy returned 4096)
> 	Read address 0x7fc5e30b300f in main(): A
> 	Read address 0x7fc5e30b340f in main(): A
> 	Read address 0x7fc5e30b380f in main(): A
> 	Read address 0x7fc5e30b3c0f in main(): A
> 
> Add a new "real_address" field to vmf to hold the unmasked address. It
> is possible to keep the unmasked address in the existing address field
> (and mask whenever necessary) instead, but this is likely to cause
> backporting problems of this patch.

Can we be sure that no existing users will rely on this behavior that 
has been the case since end of 2016 IIRC, one year after UFFD was 
upstreamed? I do wonder what the official ABI nowadays is, because man 
pages aren't necessarily the source of truth.

I checked QEMU (postcopy live migration), and I think it should be fine 
with this change.

If we don't want to change the current ABI behavior, we could add a new 
feature flag to change behavior.

@Peter, what are your thoughts?

-- 
Thanks,

David / dhildenb

