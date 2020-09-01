Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3B9259621
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730664AbgIAP6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:58:43 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.1]:56831 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731348AbgIAP6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 11:58:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1598975916; i=@ts.fujitsu.com;
        bh=Xkolpc8jHB/1HZe6pLzZF7mSlQPAALkBIh4tRiywMWA=;
        h=From:Subject:To:Cc:References:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=M1K0w/oX4KT1c83xacXKuhDthdGInMnXXjnTRccStrYi9EEekig6pJptuv1oXeGP6
         oFXn7Qdjsp4ruSrY/LJfsLTsP0eMVYMamxQUWY9AEtUqtV09Ac9NLCyO6zsaKBOAvc
         BJ/dB1kJHD5CT8LL9q8P6dP13/NH/lZPJCXA6sO/q9s7FuIogUSD7maaNWN9N7qsei
         crGjZi7Zu9L8PjcSMCcvD1zjnCR+zKfM6/UarglPAxIRxIRsnP8oNV8c6dD2flBS0y
         2slbcMPEd6CSQ1VmWuPU5Yv40wX8j1Tjgb6aLXe9FWtgOuXJ8/OPJqxRkCMv97xjWb
         LPsGhyGo2Z4CA==
Received: from [100.113.2.80] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-a.eu-central-1.aws.symcld.net id 10/9A-07993-BAF6E4F5; Tue, 01 Sep 2020 15:58:35 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRWlGSWpSXmKPExsViZ8MxRXd1vl+
  8wdsWBYvmxevZLLqv72CzWH78H5PF+iMbGC0WbHzEaNG69C2TA5vH/rlr2D0+Pr3F4vF+31U2
  j8+b5AJYolgz85LyKxJYM3rPXGYp6JGq6Hj5gL2B8ZRIFyMXh5DAJEaJy5/es0A4/YwSbf92s
  3YxcnKwCRhIrJh0nwXEFhYIk3jx/SMTiC0ioCHx8ugtsAZmgT2MElseHmaD6O5ikni66BMzSB
  WvgKPEjN9fwWwWARWJvf8eANkcHKIC4RLPVvhDlAhKnJz5BGwBJ9CyKX+ms4PYzALqEn/mXWK
  GsMUlbj2ZzwRhy0tsfzuHeQIj/ywk7bOQtMxC0jILScsCRpZVjJZJRZnpGSW5iZk5uoYGBrqG
  hsa6hrpGRmZ6iVW6iXqppbrJqXklRYlAWb3E8mK94src5JwUvbzUkk2MwJhIKWR8tIPx9OsPe
  ocYJTmYlER5K9P84oX4kvJTKjMSizPii0pzUosPMcpwcChJ8EbnAuUEi1LTUyvSMnOA8QmTlu
  DgURLhZQLGqBBvcUFibnFmOkTqFKMux4urixcxC7Hk5eelSonzLs4DKhIAKcoozYMbAUsVlxh
  lpYR5GRkYGIR4ClKLcjNLUOVfMYpzMCoJ86qBTOHJzCuB2/QK6AgmoCPOOPiCHFGSiJCSamBy
  FzR4FyLm9YlxJztLZO0NF5fnl7u5G0NWbjy01PXLtCc/zt/ODBJWrHxieOWc98aM6IKQR81l5
  lyHp10/ccb82YYJfFL//iauYu3Z9Wl/0k5GvXMllqs2WLZ4rqsxvJCf95Ln2AbV6zX2xokH1Z
  /oxNxZ0H6q4B5XyvXkZzpFv+I+Z566WbriQ6j87TU9BWx8HGcPVnO1797x7e12CWNla/slIgZ
  c78wVJ85m7uzc1Stmdpqns6fY2u96xNr0Hq0nm17X1B9W5JPon/vKi19A4Gr7h78eO7MKXp83
  fvRDhJfRbHbTX3HlvE/+r4KVLvswBNxv42HczXFXUGfVrm9SepPnbps68+pkTRel9kglluKMR
  EMt5qLiRACqrTXQkAMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-3.tower-232.messagelabs.com!1598975914!373349!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 30013 invoked from network); 1 Sep 2020 15:58:35 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-3.tower-232.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 1 Sep 2020 15:58:35 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 081FwVAR013797;
        Tue, 1 Sep 2020 16:58:31 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id D025E202FA;
        Tue,  1 Sep 2020 17:58:28 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: Re: [PATCH] scsi: target: tcmu: fix size in calls to
 tcmu_flush_dcache_range
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Mike Christie <mchristi@redhat.com>, stable@vger.kernel.org
References: <20200528193108.9085-1-bstroesser@ts.fujitsu.com>
 <159114947916.26776.943125808891892721.b4-ty@oracle.com>
 <79f7119f-fda7-64cc-b617-d49a23f2e628@ts.fujitsu.com>
 <28862cd1-e7f2-d161-1bab-4d2ff73cf6a1@ts.fujitsu.com>
 <20200901140212.GE397411@kroah.com>
Message-ID: <8ced4335-dcae-96c8-7c14-3eeb5c97324b@ts.fujitsu.com>
Date:   Tue, 1 Sep 2020 17:58:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200901140212.GE397411@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-09-01 16:02, Greg KH wrote:
> On Fri, Aug 28, 2020 at 12:03:38PM +0200, Bodo Stroesser wrote:
>> Hi,
>> I'm adding stable@vger.kernel.org
>>
>> Once again, this time really adding stable.
>>
>> On 2020-06-03 04:31, Martin K. Petersen wrote:
>>> On Thu, 28 May 2020 21:31:08 +0200, Bodo Stroesser wrote:
>>>
>>>> 1) If remaining ring space before the end of the ring is
>>>>       smaller then the next cmd to write, tcmu writes a padding
>>>>       entry which fills the remaining space at the end of the
>>>>       ring.
>>>>       Then tcmu calls tcmu_flush_dcache_range() with the size
>>>>       of struct tcmu_cmd_entry as data length to flush.
>>>>       If the space filled by the padding was smaller then
>>>>       tcmu_cmd_entry, tcmu_flush_dcache_range() is called for
>>>>       an address range reaching behind the end of the vmalloc'ed
>>>>       ring.
>>>>       tcmu_flush_dcache_range() in a loop calls
>>>>          flush_dcache_page(virt_to_page(start));
>>>>       for every page being part of the range. On x86 the line is
>>>>       optimized out by the compiler, as flush_dcache_page() is
>>>>       empty on x86.
>>>>       But I assume the above can cause trouble on other
>>>>       architectures that really have a flush_dcache_page().
>>>>       For paddings only the header part of an entry is relevant
>>>>       Due to alignment rules the header always fits in the
>>>>       remaining space, if padding is needed.
>>>>       So tcmu_flush_dcache_range() can safely be called with
>>>>       sizeof(entry->hdr) as the length here.
>>>>
>>>> [...]
>>>
>>> Applied to 5.8/scsi-queue, thanks!
>>>
>>> [1/1] scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
>>>          https://git.kernel.org/mkp/scsi/c/8c4e0f212398
>>>
>>
>> The full commit of this patch is:
>>       8c4e0f212398cdd1eb4310a5981d06a723cdd24f
>>
>> This patch is the first of four patches that are necessary to run tcmu
>> on ARM without crash. For details please see
>>       https://bugzilla.kernel.org/show_bug.cgi?id=208045
>> Upsteam commits of patches 2,3, and 4 are:
>>     2: 3c58f737231e "scsi: target: tcmu: Optimize use of flush_dcache_page"
>>     3: 3145550a7f8b "scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range
>> on ARM"
>>     4: 5a0c256d96f0 "scsi: target: tcmu: Fix crash on ARM during cmd
>> completion"
>>
>> Since patches 3 and 4 already were accepted for 5.8, 5.4, and 4.19, and
>> I sent a request to add patch 2 about 1 hour ago, please consider adding
>> this patch to 5.4 and 4.19, because without it tcmu on ARM will still
>> crash.
> 
> I don't see such a request, and am confused now.
> 
> What exact commits do you want backported, and to what trees?
> 
> thanks,
> 
> greg k-h
> 

Sorry for the confusion.

The subject of the request I mentioned is
    "Re: [PATCH v2 0/2] scsi: target: tcmu: fix crashes on ARM"
because it is for the first patch of a small series of two.

Please backport to kernels 4.19 and 5.4 (it is part of 5.8 from beginning):
  8c4e0f212398 "scsi: target: tcmu: fix size in calls to tcmu_flush_dcache_range"

Please backport to kernels 4.19, 5.4 and 5.8:
  3c58f737231e "scsi: target: tcmu: Optimize use of flush_dcache_page"

Backporting to 4.14 or earlier AFAICS would need more work, especially testing.
I don't think that its worth it.

Thank you,
Bodo
