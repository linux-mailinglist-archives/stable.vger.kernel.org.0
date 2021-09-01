Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910AC3FD543
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 10:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243129AbhIAIVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 04:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243005AbhIAIVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 04:21:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E7C461053;
        Wed,  1 Sep 2021 08:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630484414;
        bh=v9Y83i2Qo6SVuU+7tZnVKoFUoqLTBnfwMlGWaNsUoSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W6hSpP1Cs1f0gT77azVMtLYsk+2kDoQePr625O8r/HshV4ofoFMayNUYQFO5N0mn9
         JkIbGWo4Sc4zC+dm+7szL3r9LIiznKfLWOQPlp3MetRz1ys+LkugxtiSse2b4YlzKn
         3gF3A+9yD0Jyptlo6r2GKCGf6TEhglmtiGOBRPns=
Date:   Wed, 1 Sep 2021 10:20:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paul Gortmaker <paul.gortmaker@windriver.com>
Cc:     stable@vger.kernel.org
Subject: Re: TIPC fix 7387a72c5f8 needed for v5.10.x and v5.13.x
Message-ID: <YS83vBNj7ztIyiGh@kroah.com>
References: <20210823041340.GD144129@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823041340.GD144129@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 23, 2021 at 12:13:40AM -0400, Paul Gortmaker wrote:
> A bad "Fixes" SHA in mainline 7387a72c5f8 references a non-public
> SHA, instead of referencing f8dd60de1948 -- see:
> 
> https://lore.kernel.org/lkml/20210817075644.0b5123d2@canb.auug.org.au/
> 
> This matters to -stable since the broken commit is here:
> 
> stable-queue$git grep -l f8dd60de1948
> releases/5.10.56/tipc-fix-implicit-connect-for-syn.patch
> releases/5.13.8/tipc-fix-implicit-connect-for-syn.patch
> 
> and hence those releases will need mainline 7387a72c5f8 applied but
> I suspect automatic Fixes: parsing won't "see" it.

Now queued up, thanks.

greg k-h
