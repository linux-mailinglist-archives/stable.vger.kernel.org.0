Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6795E10E1EA
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 13:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfLAMmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 07:42:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbfLAMmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Dec 2019 07:42:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 476F22146E;
        Sun,  1 Dec 2019 12:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575204119;
        bh=dw6QpCyxo08pa16wmHwJITs72I9cNl+h81Yux79GtZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RGhlo6wOYelehatHS7M0YI5DZHI8G54FjilkggAQIhqC29J1HvwkJlY5QytQgj+5v
         t+wckkcRKhfctneWtoasxCr/y0uQ460Cx2lyOQdMKhkFuRtoTW6XlhfeD99NxBBZhk
         pssikJYaOlUHIlGU2NdDKBTkdNl3Zh9p/+grINU4=
Date:   Sun, 1 Dec 2019 13:41:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tilman Schmidt <tilman@imap.cc>
Cc:     Johan Hovold <johan@kernel.org>, Sasha Levin <sashal@kernel.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Hansjoerg Lipp <hjlipp@web.de>, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: gigaset: fix general protection fault on
 probe
Message-ID: <20191201124156.GA3836284@kroah.com>
References: <20191129101753.9721-2-johan@kernel.org>
 <20191201001505.964E72075A@mail.kernel.org>
 <7cfa2ada-d1ea-aafe-6ac1-f407e3bd558d@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cfa2ada-d1ea-aafe-6ac1-f407e3bd558d@imap.cc>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 01, 2019 at 01:30:42PM +0100, Tilman Schmidt wrote:
> Hi Johan,
> 
> this is probably caused by the move of the driver to staging in
> kernel release 5.3 half a year ago. If you want your patches to
> apply to pre-5.3 stable releases you'll have to submit a version
> with the paths changed from drivers/staging/isdn/gigaset to
> drivers/isdn/gigaset.

That's trivial for me to do when they get added to the stable tree(s),
no need to worry about it.

thanks,

greg k-h
