Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C594A8A7B
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 18:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbiBCRoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 12:44:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52010 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240941AbiBCRoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 12:44:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C35AA61625;
        Thu,  3 Feb 2022 17:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04C2C340E8;
        Thu,  3 Feb 2022 17:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643910255;
        bh=D7NQSjJZpRsSLvsbJHJP+Yzuw0oCn6xFotku1iwBOTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ajcisHgz1y/w1ULL9aLMAldeWoi5Eh7h6WsnXCE1z/nypvcv49CRfVdWORRABbd5Z
         Ode3kH4puiBZD46l0p1ZJx1cItDT6/UDzbP7abDfIBwXlHe+aTJUTixClK/frB126L
         IpUQom1mVSGofMraxJnb0l5dNUpOz7fjas2x8teI=
Date:   Thu, 3 Feb 2022 18:44:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 4.14.y 0/2] netfilter: nat: fix soft lockup when most
 ports are used
Message-ID: <YfwUbNbE5ILR+a0w@kroah.com>
References: <20220203124155.16693-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203124155.16693-1-fw@strlen.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 03, 2022 at 01:41:53PM +0100, Florian Westphal wrote:
> First patch removes old rovers, they are inherently racy
> and cause packet drops/delays.
> 
> Second patch avoids iterating entire range of ports: It takes way
> too long when most tuples are in use.
> 
> First patch is slightly mangled; nf_nat_proto_common.c needs minor adjustment
> in context.

Both sets of backports now queued up, thanks.

greg k-h
