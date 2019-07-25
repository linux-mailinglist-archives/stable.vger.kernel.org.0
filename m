Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7129174793
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 08:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbfGYG7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 02:59:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbfGYG7N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 02:59:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E01E12070B;
        Thu, 25 Jul 2019 06:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564037953;
        bh=uQuQ96hVzj6wwcH5JvjI2+Q5onAAbFJiJ6TWsAXNvWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nG572jkH/2I9ooGy82VphpyM/IcVtwRZqH3fCLtpnFXuMT7L3OnVFMFMLuC9hG7HE
         ux6yXy/e6aUqdbcVwMeJI1i2pjCe1DdxZaFg+vdJAp2UsRyqWWSsC1+vWyU7BFvWGC
         B/Cz+xHq1wJYe/1Nljny0kpMm2zvvGKvlKmWYX6U=
Date:   Thu, 25 Jul 2019 08:20:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Steve French <smfrench@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>,
        Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [PATCH 5.2 038/413] signal/cifs: Fix cifs_put_tcp_session to
 call send_sig instead of force_sig
Message-ID: <20190725062021.GC31256@kroah.com>
References: <20190724191735.096702571@linuxfoundation.org>
 <20190724191738.345725184@linuxfoundation.org>
 <CAH2r5msp4h4+gR6MC0ciO7X9w8cTWh5DD_W1teWpxHfooc5tsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msp4h4+gR6MC0ciO7X9w8cTWh5DD_W1teWpxHfooc5tsA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 03:49:32PM -0500, Steve French wrote:
> Note that this patch causes a regression (removing cifs module fails,
> due to unmount leaking a thread with this change).
> 
> We are testing a workaround to cifs.ko which would be needed if this
> patch were to be backported.

I've now dropped this from all of the stable queues.  If you all figure
this out, please let us know and we will be glad to queue this up, along
with the fix.

thanks,

greg k-h
