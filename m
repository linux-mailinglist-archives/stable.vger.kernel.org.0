Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58081115C16
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 12:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfLGLpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 06:45:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:57056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbfLGLpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Dec 2019 06:45:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0174B21835;
        Sat,  7 Dec 2019 11:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575719119;
        bh=FOYQ6ouHOEcuSu4aQB/qektJkynkIMl+UPmNxWSr04Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i9SmdmLfpTCsp3ukr7y+sMYwY3dDS2wcZ47yIkW8fiGd8q5K2n/eZXn1oneqAQjFD
         qvUx+TCU5N2XLbhB9Y/cgeA/HrsUxE/TYz1p6uEYZ4C7Zv2fIZNj1wKref6V2WVrOD
         ZTPrHZB0Vqq1e/10CrEdfARkUo15KgCP7gziTIhM=
Date:   Sat, 7 Dec 2019 12:45:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: MAINTAINERS updates in stable trees
Message-ID: <20191207114517.GA323212@kroah.com>
References: <20191207023802.GY5861@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191207023802.GY5861@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 06, 2019 at 09:38:02PM -0500, Sasha Levin wrote:
> I just saw an update to the MAINTAINERS file fly by on stable@ and
> figured we might want to be grabbing all of those into our stable trees?
> 
> Unlike documentation, it's not something the case that it can diverge
> from the code, and it's also very unlikely that someone wants to keep
> recieving mails as a result of someone who runs get_maintainers.pl on
> older kernels after he has removed his name upstream.
> 
> Any objections to taking these updates? It'll grow our patch count, but
> that's one of the rare cases where I don't see a way for it to cause
> regressions...

It's going to be a hodge-podge of acceptance and non acceptance here,
and in reality, it doesn't matter at all.  MAINTAINERS is to list where
to send problems to for the current development tree, not for the stable
trees.  So it's not going to be good to try to keep something up to date
when you need to make a patch against the development tree anyway.

Also, you will end up with file patterns and such getting out of date
and not matching up over time with older kernels, so I would just ignore
these entirely.

thanks,

greg k-h
