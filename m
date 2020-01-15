Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 531FB13C87C
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgAOPzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:55:14 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60561 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgAOPzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 10:55:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579103712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=ujV0JyilP8tZlry1RydNDIK15qlAZagPiNUh5Ki/kEo=;
        b=J8AoqM8kpkkZlIBruhzex+/z8bI/73djPCOwLo1+ET13suRKIi/pnb/Nq3VUno3VFJS32Y
        tTujEBFmDdYoOeSZHviDIZvGL96UKA74F4RJEF9GCqZrsGNVENoYu0QC3LOcYC9s2KlRF4
        5++3Q/ObUbValcFOJBGLclc4/JxVEFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-zTOom90qNqmIvNzvSsrj1g-1; Wed, 15 Jan 2020 10:55:04 -0500
X-MC-Unique: zTOom90qNqmIvNzvSsrj1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BE16194C252;
        Wed, 15 Jan 2020 15:55:02 +0000 (UTC)
Received: from [10.36.118.7] (unknown [10.36.118.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82E4960BE0;
        Wed, 15 Jan 2020 15:55:00 +0000 (UTC)
Subject: Re: [PATCH for 4.19-stable 00/25] mm/memory_hotplug: backport of
 pending stable fixes
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Baoquan He <bhe@redhat.com>
References: <20200115153339.36409-1-david@redhat.com>
 <20200115153927.GC3881751@kroah.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <4a09f161-e2f1-b506-f0fd-2d6c4ea1437c@redhat.com>
Date:   Wed, 15 Jan 2020 16:54:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200115153927.GC3881751@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.01.20 16:39, Greg Kroah-Hartman wrote:
> On Wed, Jan 15, 2020 at 04:33:14PM +0100, David Hildenbrand wrote:
>> This is the backport of the following fixes for 4.19-stable:
>>
>> - a31b264c2b41 ("mm/memory_hotplug: make
>>   unregister_memory_block_under_nodes() never fail")
>> -- Turned out to not only be a cleanup but also a fix

Took the wrong one. It's d84f2f5a7552 ("drivers/base/node.c: simplify
unregister_memory_block_under_nodes()")

>> - 2c91f8fc6c99 ("mm/memory_hotplug: fix try_offline_node()")
>> -- Automatic stable backport failed due to missing dependencies.
>> - feee6b298916 ("mm/memory_hotplug: shrink zones when offlining memory=
")
>> -- Was marked as stable 5.0+ due to the backport complexity,, but it's=
 also
>>    relevant for 4.19/4.14. As I have to backport quite some cleanups
>>    already ...
>>
>> To minimize manual code changes, I decided to pull in quite some clean=
ups.
>> Still some manual code changes are necessary (indicated in the individ=
ual
>> patches). Especially missing arm64 hot(un)plug, missing sub-section ho=
tadd
>> support, and missing unification of mm/hmm.c and kernel/memremap.c req=
uires
>> care.
>>
>> Due to:
>> - 4e0d2e7ef14d ("mm, sparse: pass nid instead of pgdat to
>>   sparse_add_one_section()")
>> I need:
>> - afe9b36ca890 ("mm/memunmap: don't access uninitialized memmap in
>>   memunmap_pages()")
>>
>> Please note that:
>> - 4c4b7f9ba948 ("mm/memory_hotplug: remove memory block devices
>>   before arch_remove_memory()")
>> Makes big (e.g., 32TB) machines boot up slower (e.g., 2h vs 10m). Ther=
e is
>> a performance fix in linux-next, but it does not seem to classify as a
>> fix for current RC / stable.
>>
>> I did quite some testing with hot(un)plug, onlining/offlining of memor=
y
>> blocks and memory-less/CPU-less NUMA nodes under x86_64 - the same set=
 of
>> tests I run against upstream on a fairly regular basis. I compile-test=
ed
>> on PowerPC. I did not test any ZONE_DEVICE/HMM thingies.
>>
>> Let's see what people think - it's a lot of patches. If we want this,
>> then I can try to prepare a similar set for 4.4-stable.
>=20
> What bug(s) are these trying to fix here?

All tackle memory unplug issues, especially when memory was never
onlined (or onlining failed), paired with memory unplug. When trying to
access garbage memmaps we crash the kernel (e.g., because the derviced
pgdat pointer is broken)


d84f2f5a7552 ("drivers/base/node.c: simplify
unregister_memory_block_under_nodes()")

->
https://lore.kernel.org/linux-mm/b2e31976-b07d-11e6-f806-f13f4619be4d@red=
hat.com/

"If the memory we are removing was never onlined,
get_nid_for_pfn()->pfn_to_nid() will return garbage. Removing will
succeed but links will remain in place. [...] We will trigger the
BUG_ON(ret) in add_memory_resource(), because
link_mem_sections() will return with -EEXIST."


2c91f8fc6c99 ("mm/memory_hotplug: fix try_offline_node()")

We might access garbage memmaps on memory unplug and trigger a crash on
memory unplug, when trying to offline the node.


feee6b298916 ("mm/memory_hotplug: shrink zones when offlining memory")

Memory unplug will access garbage memmaps (resulting in crashes) and the
zones might not get fixed up properly. Relevant when memory was never
onlined, when memory blocks of a DIMM were onlined to different zones,
or when memory blocks were re-onlined to different zones.


This backports the remaining "don't access uninitialized memmaps"-like
fixes. The other ones, were already backported.

>=20
> And why would 4.9 and 4.4 care about them?

The crashes can be trigger under 4.9 and 4.4. If we decide that we do
not care, then this series can be dropped.

--=20
Thanks,

David / dhildenb

