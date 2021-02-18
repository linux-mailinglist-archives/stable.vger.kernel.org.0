Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F4A31EDEF
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 19:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhBRSEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 13:04:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230469AbhBRQJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Feb 2021 11:09:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 248E864E6F;
        Thu, 18 Feb 2021 16:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613664539;
        bh=7nVEiGBqJcV1xdmSKRe6eH0E/vu9ME5Gw2AWg5dI76k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QF7a2d0YLYP7OdF2NHwxltB9qWe3Wy5Hhpj/aUCeCuclqJWfi8dyulFZ/zxQZo5WD
         zx90NZkNwA7sINGe/3FyNDrqytY8ceAlJDHpPKCnszSOGdSbsjl8EOysjWIbfx38DF
         qKySYwLmQV55uu1++CoJxcKDqMDYnrR5pxxb9F5EApZ7DUtAg6FchByQc4fb9Ci+4f
         rAlLwuOfTNv06l8j06Lmp/VO+V71sNIZn+r8Q8lXLs2RHy3u645mR/3zInotRb8RiV
         wJ5Ljjn5f0yGxfQpdtA1kcaBYIN8XHTaorQDoa3mb8zHXjQtmpWNnuWQvWKwsoBYZf
         +qn64OzFC0sAA==
Date:   Thu, 18 Feb 2021 11:08:57 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Krishnamraju Eraparaju <krishna2@chelsio.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>, bharat@chelsio.com
Subject: Re: backport of IB/isert commit to '5.10.y' stable release
Message-ID: <20210218160857.GB2013@sasha-vm>
References: <20210218071914.GA17349@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210218071914.GA17349@chelsio.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 18, 2021 at 12:49:16PM +0530, Krishnamraju Eraparaju wrote:
>
>Hi Greg,
>
>Could you please backport the below commit to "5.10.y" stable release.
>
>Looks like this commit was already pulled to "5.10.y" stable tree weeks
>ago.
>
>This fix is required for Chelsio adapters. Without this fix the number
>of connections supported by isert(over Chelsio adapter) will be significantly less.

This reads like a performane improvement rather than a bug?

-- 
Thanks,
Sasha
