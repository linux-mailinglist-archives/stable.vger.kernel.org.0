Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B571CF69B
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 16:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgELONQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 10:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbgELONP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 10:13:15 -0400
Received: from localhost (unknown [73.114.22.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6EC5206F5;
        Tue, 12 May 2020 14:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589292795;
        bh=Zt7KzPe+KMVIGb1zkYSORWZUtVtEWE8iRbAwJNzbxXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U/rvJ7I2JUFGX/J00Odnz50UkVDoanNs5KDMJhhENG0pIoOx9FZtw9Em8pOUS+CbX
         7GggCD2zo8NBzxehPO6fig7EXv5tCilKoEw3dPPHiOgqXBQwZQR4le/rZzFDau/YCs
         jZmGGL4Kx0jWE58sJaGmEFNakvTcP2SIGcMONibM=
Date:   Tue, 12 May 2020 10:13:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Ritesh Harjani <ritesh.list@gmail.com>, stable@vger.kernel.org,
        "Theodore Y. Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH] ext4: Don't set dioread_nolock by default for blocksize
 < pagesize
Message-ID: <20200512141312.GP13035@sasha-vm>
References: <87pndagw7s.fsf@linux.ibm.com>
 <20200327200744.12473-1-riteshh@linux.ibm.com>
 <20200329021728.GI53396@mit.edu>
 <e61fe76d-687f-3e34-6091-c501071b8a9a@gmail.com>
 <20200512114533.GA54730@kroah.com>
 <61fb772b-75e2-f391-1a5f-044e573b38f7@gmail.com>
 <20200512125931.GA435853@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200512125931.GA435853@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 12, 2020 at 02:59:31PM +0200, Greg KH wrote:
>On Tue, May 12, 2020 at 06:20:05PM +0530, Ritesh Harjani wrote:
>> Hello Greg,
>>
>> On 5/12/20 5:15 PM, Greg KH wrote:
>> > On Mon, May 11, 2020 at 01:37:59PM +0530, Ritesh Harjani wrote:
>> > > Hello stable-list,
>> > >
>> > > I think this subjected patch [1] missed the below fixes tag.
>> > > I guess the subjected patch is only picked for 5.7. And
>> > > AFAIU, this patch will be needed for 5.6 as well.
>> > >
>> > > Could you please do the needful.
>> > >
>> > > Fixes: 244adf6426ee31a (ext4: make dioread_nolock the default)
>> > >
>> > > [1]: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=626b035b816b61a7a7b4d2205a6807e2f11a18c1
>> >
>> > This patch does not apply to the 5.6 kernel tree at all.  Please provide
>> > a working backport if you wish to see it present there.
>>
>> Sorry if that's the case.
>> I tried both "git cherry-pick" and "git am" with patch mentioned @ [1]
>> to apply on branch "remotes/linux-stable/linux-5.6.y" of tree
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>> and it applied cleanly.
>>
>> Also, just noticed this patch in the queue. Is it that maybe you are
>> trying to apply it twice?
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.6/ext4-don-t-set-dioread_nolock-by-default-for-blocksi.patch
>
>Odd, it didn't have the "upstream" commit id, which is why I didn't see
>that it was applied already.
>
>Sasha, something went wrong with your scripts, you didn't sign-off on it
>either :(

Crap, sorry. I'll fix it up.

I'm testing out a new script that integrates the dependency mappings I
have with the rest of the script, and it looks like there are some
quirks I need to deal with.

-- 
Thanks,
Sasha
