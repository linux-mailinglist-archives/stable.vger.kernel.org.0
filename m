Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1241F3A1C
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 13:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgFILyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 07:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgFILyK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 07:54:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D0152078C;
        Tue,  9 Jun 2020 11:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591703650;
        bh=iBfG8GxVDEIxnY8D2Kh7owDOzMhOq6bQ5SzIneuMYjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J+sqT7bdhNIDVrjMarERxKXkEhlWo3nXW3Cd2b2m5yZibqU60GLguzzZ1jO0jOg09
         hIKcRS2S/wk99pxINvF4QexufSwZgKkFwn4TwR3Mke9sZLuLgPH3LeibDyj7KEGSph
         CkFCou5GXBGF9F9YtQ+DFn9AfDf+mwUe9InkW+ng=
Date:   Tue, 9 Jun 2020 13:54:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Daniel Axtens <dja@axtens.net>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Gow <davidgow@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH AUTOSEL 4.14 72/72] string.h: fix incompatibility between
 FORTIFY_SOURCE and KASAN
Message-ID: <20200609115407.GA819153@kroah.com>
References: <20200608232500.3369581-1-sashal@kernel.org>
 <20200608232500.3369581-72-sashal@kernel.org>
 <87ftb5t933.fsf@dja-thinkpad.axtens.net>
 <20200609112025.GA2523@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609112025.GA2523@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 01:20:25PM +0200, Pavel Machek wrote:
> On Tue 2020-06-09 09:46:08, Daniel Axtens wrote:
> > Hi Sasha,
> > 
> > There's nothing inherently wrong with these patches being backported,
> > but they fix a bug that doesn't cause a crash and only affects debug
> > kernels compiled with KASAN and FORTIFY_SOURCE. Personally I wouldn't
> > change a core header file in a stable kernel for that. Perhaps I'm too
> > risk-averse.
> 
> You are in agreement with existing documentation -- stable is only for
> serious bugs.

No, lots of people run KASAN on those kernels when they are testing
their devices, this patch is fine.

thanks,

greg k-h
