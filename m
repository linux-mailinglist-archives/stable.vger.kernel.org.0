Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5B92FEEA0
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 16:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbhAUP2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 10:28:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731745AbhAUNYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 08:24:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36A7120691;
        Thu, 21 Jan 2021 13:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611235432;
        bh=xNjfT8OzMFBVJCXKGHOA1k06cnzT9LSR2qGDk3ScTlA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZMvfiGUYdKVnl/pU/CLCgE6GDbBHxmOLFQAcM2Lry1XNrmW313JCdmOjuAcUVtzN6
         5Bsl3TfoS0scS3T0aAbjQw+wM67ogd4vX0B3MB8D8rJ33tMsbu5n44Tn/H9AuIs3lE
         9kF1B41sdVJvL1pcrScKFnpg05KeMZylLsJMDmcg=
Date:   Thu, 21 Jan 2021 14:23:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     lukas@wunner.de, broonie@kernel.org, stable@vger.kernel.org,
        tmaimon77@gmail.com
Subject: Re: FAILED: patch "[PATCH] spi: npcm-fiu: Disable clock in probe
 error path" failed to apply to 5.4-stable tree
Message-ID: <YAmAZXunjxf1YuOu@kroah.com>
References: <160915322711352@kroah.com>
 <20210120202441.foyzperafwmqmsrh@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120202441.foyzperafwmqmsrh@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 08:24:41PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Dec 28, 2020 at 12:00:27PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport along with 4c3a14fbc05a ("spi: npcm-fiu: simplify the
> return expression of npcm_fiu_probe()") which makes backport easier.

Both now queud up, thanks.

greg k-h
