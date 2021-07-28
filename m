Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531953D94E8
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 20:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhG1SC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 14:02:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229565AbhG1SC7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 14:02:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4432860F02;
        Wed, 28 Jul 2021 18:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627495376;
        bh=43HUa4geHVcPhw85fd/FCxIDlhVnj0WVDMM5dm4B3Mo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HPQqj4rhTeQaLNa46t8ssF4u1jdErhjSCGcOumVdN3R8vpPp6H40KGieRY3BnAKyQ
         hvvzFQbrK1vSxKSI7WnDQnSv3Fr8YqqJDNtSVNEJ6GLiAJvYBhxLMufSLfxvfDhAhc
         6OEUf+KgtWUMTLTtDumlxxNlDFuZBMJCAwQVYDpY=
Date:   Wed, 28 Jul 2021 20:02:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Stable <stable@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com
Subject: Re: [PATCH] io_uring: fix link timeout refs
Message-ID: <YQGbzpZHtCw+XLL7@kroah.com>
References: <caf9dc2dc29367bb38fee4064b7d562d9837e441.1627312513.git.asml.silence@gmail.com>
 <6564af0e-72b0-5308-4561-706ec4026385@gmail.com>
 <CADVatmOa91JbMME8XpiN5ChFM_qUm5gNzPFfLaNxW4R1UZD1Sg@mail.gmail.com>
 <YQGCP8ct1ncB1oex@kroah.com>
 <bcd188e6-d849-524d-0ffe-5e1a6506f80e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcd188e6-d849-524d-0ffe-5e1a6506f80e@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 28, 2021 at 05:30:22PM +0100, Pavel Begunkov wrote:
> On 7/28/21 5:13 PM, Greg Kroah-Hartman wrote:
> > On Mon, Jul 26, 2021 at 06:07:52PM +0100, Sudip Mukherjee wrote:
> >> On Mon, Jul 26, 2021 at 4:22 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>>
> >>> On 7/26/21 4:17 PM, Pavel Begunkov wrote:
> >>>> [ Upstream commit a298232ee6b9a1d5d732aa497ff8be0d45b5bd82 ]
> >>>
> >>> Looking at it, it just reverts the backported patch,
> >>> i.e. 0b2a990e5d2f76d020cb840c456e6ec5f0c27530.
> >>> Wasn't needed in 5.10 in the first place.
> >>>
> >>> Sudip, would be great if you can try it out
> >>
> >> Applied on top of v5.10.54-rc2 and tested, issue not reproduced. Thanks Pavel.
> >>
> >> Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> > 
> > So this is all good in the latest 5.10.54 release, right?
> 
> Right. And you can either take this or revert 0b2a990e5d2f76d0,
> both ways are identical.

Ah, I missed this, for some reason I thought this was already address.
Ok, now queued up.  Hopefully this is now fixed...

greg k-h
