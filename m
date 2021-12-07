Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A693346B9E8
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 12:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhLGLVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 06:21:32 -0500
Received: from verein.lst.de ([213.95.11.211]:55823 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230523AbhLGLVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 06:21:32 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id D37CD68AFE; Tue,  7 Dec 2021 12:17:58 +0100 (CET)
Date:   Tue, 7 Dec 2021 12:17:58 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 0/5] aio: fix use-after-free and missing wakeups
Message-ID: <20211207111758.GB18554@lst.de>
References: <20211207095726.169766-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207095726.169766-1-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 07, 2021 at 01:57:21AM -0800, Eric Biggers wrote:
> This series fixes two bugs in aio poll, and one issue with POLLFREE more
> broadly.  This is intended to replace
> "[PATCH v5] aio: Add support for the POLLFREE"
> (https://lore.kernel.org/r/20211027011834.2497484-1-ramjiyani@google.com)
> which has some bugs.
> 
> Careful review is appreciated; the aio poll code is very hard to work
> with, and I don't know of an easy way to test it.  Suggestions of any
> aio poll tests to run would be greatly appreciated.

libaio has a test for aio poll (test 22).
