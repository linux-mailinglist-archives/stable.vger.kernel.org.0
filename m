Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6609F32924D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243612AbhCAUmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:42:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243353AbhCAUfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:35:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05B7B60234;
        Mon,  1 Mar 2021 19:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614625323;
        bh=wjOOTNxUw4aewCcWrfVu3BGsAKp4fF3xt3aMYtR6/8Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tlPzFlcXdUArl/TdnoJtOvoSL3nFKFLbIroJnF7bLgS4NKHJMnX5PwwOXWCFAF0Ki
         HALYKlPUydhLhJNbKO6xIulqWuADHKSIHeC0nK+2ASDF02+oTYFj66mHvUGz/6p9Th
         f1eDB/RXvNe6dhEfn8Q0pPoQ+GK6LmB29I+ugxU4=
Date:   Mon, 1 Mar 2021 20:02:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: sun4i-ss-cipher.c:139:4: error: implicit declaration of function
 'kfree_sensitive'; did you mean 'kvfree_sensitive'?
Message-ID: <YD06KUNX4wsWVTIr@kroah.com>
References: <CA+G9fYufUB394TpDuO5-m2GEi=1LDZvsVcHmp-HyWbWV1tYjkA@mail.gmail.com>
 <CA+G9fYtJOq0MaVMVNWusUPQeEE==9ArSfeMP=dwd=Mda3N+d9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtJOq0MaVMVNWusUPQeEE==9ArSfeMP=dwd=Mda3N+d9w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 11:55:47PM +0530, Naresh Kamboju wrote:
> On Mon, 1 Mar 2021 at 22:54, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On stable rc 4.19 arm build failed due to below error.
> > the config file link provided.
> 
> These build failures were also noticed on stable rc 4.14, 4.19 and 5.4
> for arm architecture.

Dropped from all of them, thanks.

greg k-h
