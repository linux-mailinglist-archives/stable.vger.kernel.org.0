Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB183C98A1
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 08:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfJCGvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 02:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbfJCGvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 02:51:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD0F220815;
        Thu,  3 Oct 2019 06:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570085499;
        bh=W5dJkXsDzpXwjuG7zgpasVf2qhcEzIu4Ln0A8dPBtb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QOMS54dgyl/G+XUMYIzow6Q8H4pWRyPs7bMgITMLl/hv2I/aDYf52AcMSkP0frJxS
         xsum4p8Il7AVA0EZYW9nCuRWSiD6ojxNeeFyRpd1jyBJH69/ybvNIrZ5qPEjCg7M1O
         kZOea36YBqcXxP1N1dsQ7JKE/lX1gLODQ5PYZoP8=
Date:   Thu, 3 Oct 2019 08:51:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dave Chiluk <chiluk+linux@indeed.com>
Cc:     Ben Segall <bsegall@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Phil Auld <pauld@redhat.com>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: Please backport de53fd7aedb1 : sched/fair: Fix low cpu usage
 with high throttling by removing expiration of cpu-local slices
Message-ID: <20191003065135.GA1813585@kroah.com>
References: <CAC=E7cUXpUDgpvsmMaMU6sAydbfD0FEJiK25R1r=e9=YtcPjGw@mail.gmail.com>
 <20190925064414.GA1449297@kroah.com>
 <CAC=E7cXcujmbwMnmXeH2=80Lkki+j_b=WE4KCWaM1mYafDaWSA@mail.gmail.com>
 <20190927131332.GO8171@sasha-vm>
 <CAC=E7cVyO=j8FKBKkdOU2KOM_O=3XmXZd0OoyYCDWez_twuk-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC=E7cVyO=j8FKBKkdOU2KOM_O=3XmXZd0OoyYCDWez_twuk-A@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 12:15:02AM -0500, Dave Chiluk wrote:
> @Greg KH, Qian Cai's compiler warning fix has now been integrated into
> Linus' tree as commit: 763a9ec06c409
> 
> Both de53fd7aedb1 and 763a9ec06c40 are now apart of v5.4-rc1.  Can you
> please queue up these fixes for backport to all stable kernels.

I need an ack from the scheduler maintainers that this is ok to do so...

thanks,

greg k-h
