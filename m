Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B43344A983
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 09:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244412AbhKIIpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 03:45:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239433AbhKIIpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 03:45:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636447380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nt9J4fSLMdODsCSzLW6IzJ8wlO7x+msZNl8HGhlgsR4=;
        b=TWoEWksqC/U7RrMwCg9fFSdEhM+68keUXiGFrcEPuO0Aij6G36SS1v4g+4hXZjOL7Cr909
        eIfVAy0Nkec0CNFKVWmm9zYUel5pxv4jYBFpyfLYt6Jo+KfqJJIN8Q4mEHmt6I5zBxdShl
        PkJ+7bmOUoCHq4F9ixmEISthgvIndKE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-S6bL9EzcOuCCI_bDdwqTLg-1; Tue, 09 Nov 2021 03:42:59 -0500
X-MC-Unique: S6bL9EzcOuCCI_bDdwqTLg-1
Received: by mail-wr1-f72.google.com with SMTP id q7-20020adff507000000b0017d160d35a8so4648649wro.4
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 00:42:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=nt9J4fSLMdODsCSzLW6IzJ8wlO7x+msZNl8HGhlgsR4=;
        b=olMWdNtTi3w8jTmP//XqWWpwDknEgGjlph1MYtaANfiiltbz22VWqqxAY+zElizFsE
         Fz+FBI9VQHgAEfQ4hWLbADPjExz7RSuY7aShhFSGpjQ5zOCN6rJjFgwcIszXfDuXA8rH
         bSapxj/rTUgqQZGrbEDFAP3daohj2vUwnA0uVlzjLzPYc8jYMARv7DucM8G+pccPk7Zh
         53O6/iOIc6uYQtzx4kPghtqABtzgO4CW/Wq48e1LTPanjhddHUVxpzsRA1YqahaRlcOg
         8FeBX3mD2Ih1QmCySFflvW6l8plh4LlYhtNN6uAcb3ZTy/JeGAOh8McRf4zj4LCucw8g
         Ku0g==
X-Gm-Message-State: AOAM531+5AucZRdKYfXOfF1K7Bj6nTf3LyV0Mt7pdDb6ED04J3WRKM8w
        tkiqtc5swr0A4YW0gh7DwFMFm8AZaW+nq+kz+tHBmwbzra8WySHdg/gBrHjhge+nptSRENknYBz
        StXCnQWKRsCyPs6pB
X-Received: by 2002:a1c:4b0b:: with SMTP id y11mr5346833wma.9.1636447378081;
        Tue, 09 Nov 2021 00:42:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzMB1sjzQ+HNZw0Uz4mqMrEPdjYUCJm6Y7oZEMZ4cLwW68YXm/WhyrBj+TLfB5Fbie9DtRlCg==
X-Received: by 2002:a1c:4b0b:: with SMTP id y11mr5346808wma.9.1636447377873;
        Tue, 09 Nov 2021 00:42:57 -0800 (PST)
Received: from [192.168.3.132] (p4ff23c2b.dip0.t-ipconnect.de. [79.242.60.43])
        by smtp.gmail.com with ESMTPSA id h15sm1838544wml.9.2021.11.09.00.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 00:42:57 -0800 (PST)
Message-ID: <af7ab3ce-fed2-1ffc-13a8-f9acbd201841@redhat.com>
Date:   Tue, 9 Nov 2021 09:42:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: + mm-fix-panic-in-__alloc_pages.patch added to -mm tree
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org
Cc:     amakhalov@vmware.com, cl@linux.com, dennis@kernel.org,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        stable@vger.kernel.org, tj@kernel.org
References: <20211108205031.UxDPHBZWa%akpm@linux-foundation.org>
 <YYozLsIECu0Jnv0p@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <YYozLsIECu0Jnv0p@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09.11.21 09:37, Michal Hocko wrote:
> I have opposed this patch http://lkml.kernel.org/r/YYj91Mkt4m8ySIWt@dhcp22.suse.cz
> There was no response to that feedback. I will not go as far as to nack
> it explicitly because pcp allocator is not an area I would nack patches
> but seriously, this issue needs a deeper look rather than a paper over
> patch. I hope we do not want to do a similar thing to all callers of
> cpu_to_mem.

While we could move it into the !HOLES version of cpu_to_mem(), calling
cpu_to_mem() on an offline (and eventually not even present) CPU (with
an offline node) is really a corner case.

Instead of additional runtime overhead for all cpu_to_mem(), my take
would be to just do it for the random special cases. Sure, we can
document that people should be careful when calling cpu_to_mem() on
offline CPUs. But IMHO it's really a corner case.

-- 
Thanks,

David / dhildenb

