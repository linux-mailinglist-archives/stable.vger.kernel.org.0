Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E35528DA12
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 08:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgJNGys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 02:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgJNGyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 02:54:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8F7E2222A;
        Wed, 14 Oct 2020 06:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602658487;
        bh=CYCTvLft7EuscmHtaKH0AX7Z0ZbTnFcKn6jsV4mDXfs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qxewTeZtO3iCbtRinyhP0odEb8dvDqDTVpoPx7POE//Uj98CZ8rUVzwZ731dYfNw7
         Ki7GgS1Ds23+J/pYQEoNxfJEwgwcVliXQy2HTmr3KeXR6kjU9rLJ9jWkc3E6L6JrBl
         /NtehPR59JGYN1/yBWNQRgw8obCpTxPEOdFlRzDs=
Date:   Wed, 14 Oct 2020 08:55:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Roland Scheidegger <sroland@vmware.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.8 050/124] drm/vmwgfx: Fix error handling in get_node
Message-ID: <20201014065522.GA2762376@kroah.com>
References: <20201012133146.834528783@linuxfoundation.org>
 <20201012133149.276124624@linuxfoundation.org>
 <703ec8e7-f036-948d-f155-73f0c946aeba@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <703ec8e7-f036-948d-f155-73f0c946aeba@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 13, 2020 at 05:55:31PM +0200, Roland Scheidegger wrote:
> Hi,
> 
> this commit should NOT be applied to 5.8.
> It fixes a regression introduced by
> 58e4d686d456c3e356439ae160ff4a0728940b8e (drm/ttm: cleanup
> ttm_mem_type_manager_func.get_node interface v3) which is part of 5.9
> but not 5.8.
> Applying this to 5.8 will very likely break things. I don't know why it
> ended up as a candidate for 5.8.

Now dropped, thanks.  And it was probably picked up due to the wording
in the changelog text, along with a lack of a "Fixes:" tag that pointed
at the exact change it fixed up, which would have shown that this is a
5.9-only thing.

thanks,

greg k-h
