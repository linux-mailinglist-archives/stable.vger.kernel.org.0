Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C402CDD90
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 19:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502089AbgLCSZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 13:25:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:54670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502049AbgLCSZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 13:25:28 -0500
Date:   Thu, 3 Dec 2020 19:25:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607019887;
        bh=7POOkLn/pGoxGwO2tQdCyFK5VE+L2sQPNH6OYXqq6sc=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=rylAs9dPfCHUKOsnHMEM9KUR4CMhPVNrvs3yV2m1x/YdJ2hstQweiFWD1YLchYbUt
         90OuedVL4/YwhfzxR+ySNpnLdeluzi9Fr3QROoxAYh61Z0zGo9cPmJsVP3kJMn3wzg
         3KzYzxT2GI+fUn0VTAdcskq9hMOkYaSEPBNaOXUY=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Scott Cheloha <cheloha@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/hotplug: assign hot added LMB to the right node
Message-ID: <X8ktsoAv4/h+p1/8@kroah.com>
References: <20201203101514.33591-1-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203101514.33591-1-ldufour@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 03, 2020 at 11:15:14AM +0100, Laurent Dufour wrote:
> This patch applies to 5.9 and earlier kernels only.
> 
> Since 5.10, this has been fortunately fixed by the commit
> e5e179aa3a39 ("pseries/drmem: don't cache node id in drmem_lmb struct").

Why can't we just backport that patch instead?  It's almost always
better to do that than to have a one-off patch, as almost always those
have bugs in them.

thanks,

greg k-h
