Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3ACD31EDF5
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 19:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhBRSFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 13:05:04 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:13406 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbhBRRmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 12:42:51 -0500
Received: from localhost (pvp1.blr.asicdesigners.com [10.193.80.26])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 11IHfusH032269;
        Thu, 18 Feb 2021 09:41:57 -0800
Date:   Thu, 18 Feb 2021 23:11:56 +0530
From:   Krishnamraju Eraparaju <krishna2@chelsio.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>, bharat@chelsio.com
Subject: Re: backport of IB/isert commit to '5.10.y' stable release
Message-ID: <20210218174155.GA20270@chelsio.com>
References: <20210218071914.GA17349@chelsio.com>
 <20210218160857.GB2013@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218160857.GB2013@sasha-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thursday, February 02/18/21, 2021 at 11:08:57 -0500, Sasha Levin wrote:
> On Thu, Feb 18, 2021 at 12:49:16PM +0530, Krishnamraju Eraparaju wrote:
> >
> >Hi Greg,
> >
> >Could you please backport the below commit to "5.10.y" stable release.
> >
> >Looks like this commit was already pulled to "5.10.y" stable tree weeks
> >ago.
> >
> >This fix is required for Chelsio adapters. Without this fix the number
> >of connections supported by isert(over Chelsio adapter) will be significantly less.
> 
> This reads like a performane improvement rather than a bug?
Hi Sasha Levin,

This is not a performance improvement.
Earlier, commit:317000b926b07c has introduced a side effect, where no.of
supported isert connections, over Chelsio adapters, had come down to
9(prior to this commit it was 250).

And this side effect got fixed with commit:dae7a75f1f19bf

Hence, please apply this commit(dae7a75f1f19bf) to '5.10.y' stable release.

Thanks,
Krishnamraju.
> 
> -- 
> Thanks,
> Sasha
