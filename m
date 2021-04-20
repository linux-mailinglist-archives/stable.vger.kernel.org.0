Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F466365353
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 09:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbhDTHfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 03:35:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhDTHfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 03:35:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E65A2608FE;
        Tue, 20 Apr 2021 07:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618904083;
        bh=r+cA/OrtTzBmeNFjnkqOOZISaeJt82orbdUXr2bD89o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V8TO2vJO2w8Su9gYRcLCoLx/kJKfW8OJNKqbWKiz2uzOUGAZ2/v9Uc373ALk8ATfh
         eAEgs7CpFS3mnk+6QfsrY9gIMfRzNyU39+Q48vHGDNioSWcSttHJHGpI9xDryGOKtL
         rZ5sDofVWb8PIT+5gQHMhFM/tk4XXu21zBn61jYI=
Date:   Tue, 20 Apr 2021 09:34:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 043/103] net: tipc: Fix spelling errors in net/tipc
 module
Message-ID: <YH6EEBhAYD1wiJFY@kroah.com>
References: <20210419130527.791982064@linuxfoundation.org>
 <20210419130529.293126321@linuxfoundation.org>
 <20210419213247.GC6626@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419213247.GC6626@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 11:32:47PM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit a79ace4b312953c5835fafb12adc3cb6878b26bd ]
> > 
> > These patches fix a series of spelling errors in net/tipc module.
> 
> This should not be in -stable, it just cleans up comments.

Agreed, now dropped, thanks.

greg k-h
