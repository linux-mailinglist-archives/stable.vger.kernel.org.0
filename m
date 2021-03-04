Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC11232D469
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbhCDNov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238531AbhCDNoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 08:44:37 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D323DC061756
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 05:43:56 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lHoGh-0000kP-Bh; Thu, 04 Mar 2021 14:43:55 +0100
Date:   Thu, 4 Mar 2021 14:43:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Florian Westphal <fw@strlen.de>, stable@vger.kernel.org,
        pablo@netfilter.org, paulburton@kernel.org
Subject: Re: stable request: mips strncpy is broken
Message-ID: <20210304134355.GL17911@breakpoint.cc>
References: <20210303172336.GF17911@breakpoint.cc>
 <YEDf+XYB/dl5vx0u@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEDf+XYB/dl5vx0u@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> wrote:
> > I did not try earlier 4.4.y releases but I susepct they should also get
> > this patch applied.
> > 
> > I can send a 5.4.y backport if thats preferred.
> 
> Please do, that way I know it is done correctly and has been tested.

Will do, but note that I can't test this.
