Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218814A8927
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 17:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344946AbiBCQ6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 11:58:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53322 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbiBCQ63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 11:58:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86D196155C
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 16:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432F3C340E8;
        Thu,  3 Feb 2022 16:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643907508;
        bh=pcXjAVsYZ5TdoNfCUGIckB0xBtK6kowygtY3w3SmTxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G3MeZS1fXOsljkxJ7cOQJobkuiEjOLwZLIMRXJojFIvRpEz89MCFED0gWhx7uUAVS
         a+zFXcrnuxd7gtjgEJHSKLJwPJOFSvFR6MFjeW08HiXxyM/wqPN7gGnYerTSaN7OAb
         qA+E0ePR82x3WReIczJ9bb6TdhlxUs9C/ampxdgE=
Date:   Thu, 3 Feb 2022 17:58:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net: ipa: prevent concurrent replenish"
 failed to apply to 5.16-stable tree
Message-ID: <YfwJsqAo4VgbD3b7@kroah.com>
References: <1643031462146216@kroah.com>
 <d1ed0879-0555-254e-7255-d6442bf940c3@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1ed0879-0555-254e-7255-d6442bf940c3@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 05:39:08PM -0600, Alex Elder wrote:
> On 1/24/22 7:37 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.16-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Sorry about that.
> 
> Unfortunately, the commit in question:
> 
>   998c0bd2b3715 net: ipa: prevent concurrent replenish
> 
> 
> has one predecessor commit as a prerequisite:
> 
>   c1aaa01dbf4ce net: ipa: use a bitmap for endpoint replenish_enabled
> 
> 
> I find that I can cleanly cherry-pick the two commits on top of
> tag "v5.16.4" cleanly.  I.e.:
> 
>   git reset --hard v5.16.4
>   git cherry-pick -x c1aaa01dbf4ce 998c0bd2b3715
> 
> 
> Is that an adequate solution?  If not, I can supply patches that
> do essentially that.
> 
> This works on tag "v5.15.18" as well.

Great, now queued up.

thanks,

greg k-h
