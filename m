Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7789A797
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 08:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404242AbfHWG24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 02:28:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731346AbfHWG24 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Aug 2019 02:28:56 -0400
Received: from localhost (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 591102070B;
        Fri, 23 Aug 2019 06:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566541735;
        bh=9PxnY8Syeoj7fi5pKhNT+lx69maAv5KdABpLie9J16c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qRSqFtCKIik3YToJrPmUn4Tp32SCfcVNZktYnVlExOv5BdFMEF2WCrC537mlIdIDq
         s6Cwp4VKpru2rOz4RXrkx4oqH67/b+g2BMYrldRxh52Ah9+MRl6t7UhL3JTx1p6wbS
         55X6m8v5Lc/e3K5m30ltZZCs+b8TJyuTOUPtncs0=
Date:   Fri, 23 Aug 2019 02:28:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/135] 5.2.10-stable review
Message-ID: <20190823062853.GC1581@sasha-vm>
References: <20190822170811.13303-1-sashal@kernel.org>
 <20190822172619.GA22458@kroah.com>
 <20190823000527.0ea91c6b@mir>
 <20190822233847.GB24034@kroah.com>
 <20190823024248.11e2dac3@mir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190823024248.11e2dac3@mir>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 23, 2019 at 02:42:48AM +0200, Stefan Lippers-Hollmann wrote:
>Hi
>
>On 2019-08-22, Greg KH wrote:
>> On Fri, Aug 23, 2019 at 12:05:27AM +0200, Stefan Lippers-Hollmann wrote:
>> > On 2019-08-22, Greg KH wrote:
>> > > On Thu, Aug 22, 2019 at 01:05:56PM -0400, Sasha Levin wrote:
>[...]
>> > It might be down to kernel.org mirroring, but the patch file doesn't
>> > seem to be available yet (404), both in the wrong location listed
>> > above - and the expected one under
>> >
>> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
>[...]
>> Ah, no, it's not a mirroring problem, Sasha and I didn't know if anyone
>> was actually using the patch files anymore, so it was simpler to do a
>> release without them to see what happens. :)
>>
>> Do you rely on these, or can you use the -rc git tree or the quilt
>> series?  If you do rely on them, we will work to fix this, it just
>> involves some scripting that we didn't get done this morning.
>
>"Rely" is a strong word, I can adapt if they're going away, but
>I've been using them so far, as in (slightly simplified):
>
>$ cd patches/upstream/
>$ wget https://cdn.kernel.org/pub/linux/kernel/v5.x/patch-5.2.9.xz
>$ xz -d patch-5.2.9.xz
>$ wget https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
>$ gunzip patch-5.2.10-rc1.gz
>$ vim ../series
>$ quilt ...
>
>I can switch to importing the quilt queue with some sed magic (and I
>already do that, if interesting or just a larger amounts of patches are
>queuing up for more than a day or two), but using the -rc patches has
>been convenient in that semi-manual workflow, also to make sure to really
>get and test the formal -rc patch, rather than something inbetween.

An easy way to generate a patch is to just use the git.kernel.org web
interface. A patch for 5.2.10-rc1 would be:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.2.y&id2=v5.2.9

Personally this patch upload story sounded to me like a pre-git era
artifact...

Thanks for the testing effort!

--
Thanks,
Sasha
