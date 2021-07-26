Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602493D5844
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 13:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbhGZK2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 06:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232572AbhGZK2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 06:28:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E41460BD3;
        Mon, 26 Jul 2021 11:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627297721;
        bh=+YUacWV6Bm+T3Vuv48gsRHEwGKTw9i9ieqXKemVKYRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LLFz9IFnHsoqD6Z1k9j00Ww12RASdnDXjqJVLci0P5P4tg4Vzzr7GmxgiEorKkeph
         nwh2lNKEFeT/cW0inPkRFRcviy0qCHrdzxVtoVFY99W/ififpayxaW3iaISF18NfQp
         B5/O4MbPiSh6QZgyYn2rWtioF6z4XHjePlGuQlu8=
Date:   Mon, 26 Jul 2021 13:08:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: use-after-free" with v5.10.y caused by backport of a298232ee6b9
 ("io_uring: fix link timeout refs")
Message-ID: <YP6Xtjg3Eu4UfTxF@kroah.com>
References: <YP6OkehtVdkjKikL@debian>
 <d1ff5d9c-2e13-acc2-fd8f-a8f4f180a8bb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1ff5d9c-2e13-acc2-fd8f-a8f4f180a8bb@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 11:57:22AM +0100, Pavel Begunkov wrote:
> On 7/26/21 11:29 AM, Sudip Mukherjee wrote:
> > Hi Pavel,
> > 
> > We had been running syzkaller on v5.10.y and a "use after free" is being
> > reported for v5.10.43+ kernels.
> 
> "... # 5.12+", weird, but perhaps due to dependencies.
> Thanks for letting know.
> 
> 
> Greg, Sasha, should be same as reported for 5.12
> 
> https://www.spinics.net/lists/stable/msg485116.html
> 
> Can you try to apply it to 5.10 or should I resend?

I just tried applying those patches and they did not work.  So can you
provide some new backports?

thanks,

greg k-h
