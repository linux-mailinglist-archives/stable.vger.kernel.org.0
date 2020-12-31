Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBF82E7EC5
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 09:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgLaIwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 03:52:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgLaIwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Dec 2020 03:52:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B977208B8;
        Thu, 31 Dec 2020 08:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609404685;
        bh=u4OL0C6HfJSTwkDj9X24/R+wFUqphXmsnWbsXVDnIRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B+fYLCy/lLzyquSPXkqs1qDum4spDmewYcY1ajGBZHXKQQd4E0w9Uj9mtc8vynYW6
         6R3LGlYWfIx56ipOKGWf/3mAw8SGjJ1Ky/ak89HgGxCey0TS69eWxyiDxL/JccJ0L4
         8eE5+cApPDmDcfgTv+bjrwIXfv9ofTmN0rwhZl9o=
Date:   Thu, 31 Dec 2020 09:51:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 134/717] spi: dw: fix build error by selecting
 MULTIPLEXER
Message-ID: <X+2RCc1I3LhFOkCc@kroah.com>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125027.369952724@linuxfoundation.org>
 <20201231084956.ckobqvr5mdpcdxkc@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201231084956.ckobqvr5mdpcdxkc@mobilestation>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 31, 2020 at 11:49:56AM +0300, Serge Semin wrote:
> Hello Greg,
> The next patch has been created to supersede the one you've applied:
> https://lore.kernel.org/linux-spi/20201127144612.4204-1-Sergey.Semin@baikalelectronics.ru/
> Mark has already merged it in his repo.

Ok, so should that one be queued up as well?  Let us know the git commit
id of it when it reaches Linus's kernel and we will be glad to take it.

thanks,

greg k-h
