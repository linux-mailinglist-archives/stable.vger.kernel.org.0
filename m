Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A41747224D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 09:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhLMIWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 03:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbhLMIWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 03:22:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218DFC06173F
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 00:22:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDDABB80DD9
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 08:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B35C00446;
        Mon, 13 Dec 2021 08:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639383730;
        bh=37KO0kpWYRxJWrgwSFey803Bypbw3R/esWP/W9oe+1I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CGJ+yQz71yHu4ZYZs3HeXgRg7GjH6Vs5fgMkUPLXDq/zyQW6fNIL+wJS73Gkxkt8k
         Fmdz4PqMY7doiGcCKbJz+0b1DoPL44Db2jVcMkooogw6mzA9HUK3MQkJqrK/3GuIqM
         yig5wGROizLjif2j/zhXFvTtX2M/YhAaXAomAxEs=
Date:   Mon, 13 Dec 2021 09:22:08 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "dsterba@suse.com" <dsterba@suse.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] btrfs: zoned: clear data relocation bg on
 zone finish" failed to apply to 5.15-stable tree
Message-ID: <YbcCsD5riWyioUyI@kroah.com>
References: <16393188751463@kroah.com>
 <PH0PR04MB74161D8CF905FE235521373E9B749@PH0PR04MB7416.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR04MB74161D8CF905FE235521373E9B749@PH0PR04MB7416.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 07:34:37AM +0000, Johannes Thumshirn wrote:
> On 12/12/2021 15:21, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> 
> Hi Greg, 
> 
> this patch doesn't need any backporting to stable. The failure can only 
> happen on v5.16-rcX.

Really?  The Fixes: tag says otherwise:
	Fixes: c2707a255623 ("btrfs: zoned: add a dedicated data relocation block group")
as that commit id is in 5.15.4.

Perhaps that tag is incorrect?

thanks,

greg k-h
