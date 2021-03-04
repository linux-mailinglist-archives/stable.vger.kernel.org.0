Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBD132D64D
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 16:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbhCDPRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 10:17:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:38682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233598AbhCDPRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 10:17:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 665FA64F6C;
        Thu,  4 Mar 2021 15:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614870989;
        bh=Z97hP4qI8l+ZLP5V4m30NSejwc4ssBLKW6NG4Wr1Kps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tpI3k0JE+PFEd8tLHcJK1mq/Nf1/bDli8ogMoIf9UsAD7XFBECRlEiT21u/6Ow6Rx
         8mnoFinhGT1oDnmlh/455VlI94uVb8q2PWRwPfea9Cck4X6hTSfavEmWxv5ijSljo8
         qt4pkPXYMG4aXSQ9nq2n3DDpULGT21ysV+X5wWow=
Date:   Thu, 4 Mar 2021 16:16:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH STABLE 5.10 5.11] swap: fix swapfile page to sector
 mapping
Message-ID: <YED5ypwsrExHWD7N@kroah.com>
References: <20210304150824.29878-1-ailiop@suse.com>
 <20210304150824.29878-5-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304150824.29878-5-ailiop@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 04:08:24PM +0100, Anthony Iliopoulos wrote:
> commit caf6912f3f4af7232340d500a4a2008f81b93f14 upstream.

No, this does not look like that commit.

Why can I not just take caf6912f3f4a ("swap: fix swapfile read/write
offset") directly for 5.10 and 5.11?  WHat has changed to prevent that?

thanks,

greg k-h
