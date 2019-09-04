Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C38EBA7AB8
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 07:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfIDF0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 01:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbfIDF0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 01:26:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5165A2339D;
        Wed,  4 Sep 2019 05:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567574808;
        bh=nX3gPPkIL8TJSohXVa0JIKl7grVeIePK6DugPul+PCY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aTPIZY9Ks7pjN6/hnenvP8Fmjc2R4DUv0jY9iqeTlgBNd8M290Q/SuKYxGBXpk2p8
         NzBadxaIbbMVw8Yt2qWy3Y/xfkiZy6T2VXDwvP6rxPwMJju8SrWWYvXgJudz1rpQcp
         U2QrPgfvAknuTbP6Sc94W1W9QJC75NFNIUjhBKJY=
Date:   Wed, 4 Sep 2019 07:26:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     aik@ozlabs.ru, paulus@ozlabs.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: PPC: Book3S: Fix incorrect
 guest-to-user-translation" failed to apply to 4.19-stable tree
Message-ID: <20190904052646.GC17236@kroah.com>
References: <156753601315657@kroah.com>
 <20190903202113.GK5281@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903202113.GK5281@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 04:21:13PM -0400, Sasha Levin wrote:
> On Tue, Sep 03, 2019 at 08:40:13PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I've fixed it up for 4.19 and 4.14. The issue was mostly due to missing
> 2001825efcea7 ("KVM: PPC: Book3S HV: Avoid lockdep debugging in TCE
> realmode handlers").

Thanks for fixing up all of these FAILED: reports and adding them to
the queues.

greg k-h
