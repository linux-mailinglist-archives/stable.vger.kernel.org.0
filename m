Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794AC4721A2
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 08:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbhLMHXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 02:23:42 -0500
Received: from verein.lst.de ([213.95.11.211]:46379 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhLMHXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 02:23:42 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8B96968AA6; Mon, 13 Dec 2021 08:23:39 +0100 (CET)
Date:   Mon, 13 Dec 2021 08:23:39 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] aio: fix use-after-free and missing wakeups
Message-ID: <20211213072339.GB20423@lst.de>
References: <20211209010455.42744-1-ebiggers@kernel.org> <CAHk-=wjkXez+ugCbF3YpODQQS-g=-4poCwXaisLW4p2ZN_=hxw@mail.gmail.com> <YbJM6H2wOisBY6gU@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbJM6H2wOisBY6gU@sol.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 10:37:28AM -0800, Eric Biggers wrote:
> I was hoping that Al would review and apply these, given that he's listed as the
> maintainer for this file, and he's worked on this code before.  I was also
> hoping for review from Christoph, since he added IOCB_CMD_POLL originally.  But

I was planning to get to it,  but it seems like it got merged over this
weekend?
