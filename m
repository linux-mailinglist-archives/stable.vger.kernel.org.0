Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF45A6140
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 08:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbfICGVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 02:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbfICGVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 02:21:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C31D215EA;
        Tue,  3 Sep 2019 06:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567491706;
        bh=1ZiYShXUFkvVmLr/wMiQ4vrgSsq5PSf4hcIuLlb3O1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YbrlZ788U3mwAqE5n2TWcQ5KJvtV6bLgMTDy353Y2n1K4PN2NS1ehZihy5X+BAOcD
         bb9QTw21j2OBfLGYGBD7vYIFQGVYPNw66Mo0GqeY0RZ2dtYH1aPMV2/3BK5z3ecN4a
         A4xtEPM+Woer/nMtSFA0TF4TucrUz+F8yKTZbqJw=
Date:   Tue, 3 Sep 2019 08:21:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     henryburns@google.com, akpm@linux-foundation.org,
        henrywolfeburns@gmail.com, jwadams@google.com, minchan@kernel.org,
        sergey.senozhatsky@gmail.com, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm/zsmalloc.c: fix race condition in
 zs_destroy_pool" failed to apply to 4.9-stable tree
Message-ID: <20190903062143.GA16647@kroah.com>
References: <156684443123212@kroah.com>
 <20190903031444.GE5281@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903031444.GE5281@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 02, 2019 at 11:14:44PM -0400, Sasha Levin wrote:
> On Mon, Aug 26, 2019 at 08:33:51PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I've backported it to 4.9, it is not needed on 4.4.

Thanks!
