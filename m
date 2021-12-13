Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08E34732E0
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 18:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241310AbhLMRY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 12:24:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59538 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236018AbhLMRY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 12:24:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB241B811E0;
        Mon, 13 Dec 2021 17:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E403C34602;
        Mon, 13 Dec 2021 17:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639416295;
        bh=sb0MvNrSORCLQFaBLBkUnz6crCYZ7ga2CwkWso4TfW8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b8W591K813BG47h6LlTFVEqZtJijk76LEhgC4GRuU0elgH6H7Y6LHTsCHjyV5V6YY
         oQB264X/8mG1uC5yESyBIJPkG2Re7h4MlNd6ROTYED90qi3hrVEW7qLOLLep9o+pF1
         Q6AQIqMBRdlprEqNPQPqSiUyl6E0Dxd6L8OV3LP7AArE98us7DEjB+f78vch9nAi9d
         eceXaIGHmEAjeOCEkamTd2DMvxDfj6cDJyuPkiJ/imNa55kVy0vCqqxylWOOkuRMds
         7VkVRKsQg3CIuHot2cf755jwNau6yZRJXCyyKUhPJH8/RZskBF9oy86F2n06EzfSiu
         //ItGLzNASnYA==
Date:   Mon, 13 Dec 2021 09:24:42 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ramji Jiyani <ramjiyani@google.com>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] aio: fix use-after-free and missing wakeups
Message-ID: <YbeB2jueI86NBthA@sol.localdomain>
References: <20211209010455.42744-1-ebiggers@kernel.org>
 <CAHk-=wjkXez+ugCbF3YpODQQS-g=-4poCwXaisLW4p2ZN_=hxw@mail.gmail.com>
 <YbJM6H2wOisBY6gU@sol.localdomain>
 <20211213072339.GB20423@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213072339.GB20423@lst.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 08:23:39AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 09, 2021 at 10:37:28AM -0800, Eric Biggers wrote:
> > I was hoping that Al would review and apply these, given that he's listed as the
> > maintainer for this file, and he's worked on this code before.  I was also
> > hoping for review from Christoph, since he added IOCB_CMD_POLL originally.  But
> 
> I was planning to get to it,  but it seems like it got merged over this
> weekend?

There weren't any indications that anyone else was going to review it, and it
wasn't appropriate to wait any longer.  If you'd still like to review it, please
do so; if you find any problem I'll fix it in a follow-on fix.

- Eric
