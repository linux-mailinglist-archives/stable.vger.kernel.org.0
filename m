Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00512450626
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 14:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhKOOBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 09:01:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231937AbhKOOBR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 09:01:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEB5661A70;
        Mon, 15 Nov 2021 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636984702;
        bh=plwTQYmxhyR4flAWPcJ7SwYkhMbE3Q8x9XpPv1GxMns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m9xMZuWnFASV+ZoKKdlt3Ehaxt8+VL41/VpTAVmxrbrAaTxZ3QC3U7NKaYQpvLRnK
         8nO44dd1JCTCYUxrfOuDCNUqB72A3uWL471/oBjcQbmeGAgr2f0W1gWS6GAJPmzSK0
         oTDbWX0JsZ1JJiQz0ihs3ZhNuvBiFEtZT5mVtPEA=
Date:   Mon, 15 Nov 2021 14:58:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        syzbot <syzbot+579885d1a9a833336209@syzkaller.appspotmail.com>
Subject: Re: [PATCH 5.13 089/151] ovl: fix deadlock in splice write
Message-ID: <YZJne0oDsCc6M9gz@kroah.com>
References: <20210816125444.082226187@linuxfoundation.org>
 <20210816125447.013365592@linuxfoundation.org>
 <CAOssrKe5S4AGUD+TUT2AkeWo-7Cjfbw4vX-d3bPi6xfNOVY-CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKe5S4AGUD+TUT2AkeWo-7Cjfbw4vX-d3bPi6xfNOVY-CA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 02:54:35PM +0100, Miklos Szeredi wrote:
> Hi Greg,
> 
> Looks like upstream commit b91b6b019fd ("ovl: fix deadlock in splice
> write") needs to be added to linux-5.4.y.
> 
> The reason is that commit 82a763e61e2b ("ovl: simplify file splice")
> was backported to v5.4.155, and the above commit fixes this.
> 
> Applies cleanly and I reviewed that the backport is correct.

Now queued up, thanks.

greg k-h
