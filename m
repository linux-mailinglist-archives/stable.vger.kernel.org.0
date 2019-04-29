Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAB00E1AD
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 13:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfD2L44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 07:56:56 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57151 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727943AbfD2L44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 07:56:56 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44t36Z4BWlz9s6w;
        Mon, 29 Apr 2019 21:56:54 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linuxppc-dev@ozlabs.org,
        diana.craciun@nxp.com, msuchanek@suse.de, npiggin@gmail.com,
        christophe.leroy@c-s.fr
Subject: Re: [PATCH stable v4.4 00/52] powerpc spectre backports for 4.4
In-Reply-To: <20190429070357.GA3167@kroah.com>
References: <20190421142037.21881-1-mpe@ellerman.id.au> <20190421163421.GA8449@kroah.com> <87o94qac1z.fsf@concordia.ellerman.id.au> <87a7g99viy.fsf@concordia.ellerman.id.au> <20190429070357.GA3167@kroah.com>
Date:   Mon, 29 Apr 2019 21:56:36 +1000
Message-ID: <877ebd9g97.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:
> On Mon, Apr 29, 2019 at 04:26:45PM +1000, Michael Ellerman wrote:
>> Michael Ellerman <mpe@ellerman.id.au> writes:
>> > Greg KH <gregkh@linuxfoundation.org> writes:
>> >> On Mon, Apr 22, 2019 at 12:19:45AM +1000, Michael Ellerman wrote:
>> >>> -----BEGIN PGP SIGNED MESSAGE-----
>> >>> Hash: SHA1
>> >>> 
>> >>> Hi Greg/Sasha,
>> >>> 
>> >>> Please queue up these powerpc patches for 4.4 if you have no objections.
>> >>
>> >> why?  Do you, or someone else, really care about spectre issues in 4.4?
>> >> Who is using ppc for 4.4 becides a specific enterprise distro (and they
>> >> don't seem to be pulling in my stable updates anyway...)?
>> >
>> > Someone asked for it, but TBH I can't remember who it was. I can chase
>> > it up if you like.
>> 
>> Yeah it was a request from one of the distros. They plan to take it once
>> it lands in 4.4 stable.
>
> Ok, thanks for confirming, I'll work on this this afternoon.

Thanks. If there's any problems let us know.

cheers
