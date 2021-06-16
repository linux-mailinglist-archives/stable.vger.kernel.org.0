Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2133A9638
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 11:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbhFPJew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 05:34:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231316AbhFPJev (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 05:34:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D77CA61241;
        Wed, 16 Jun 2021 09:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623835964;
        bh=8AvXjBBFzxg5JlXwhHSwDMVbECZC5ojPWbVn4wgeFPE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=crjMNTpcpe6PqlbrwfRlT1BVL1hwmnl0jvXB4FW27BT+e9f8HHnS4zjBRSjujMVle
         Ny1Q0riWvwsn7V2om36BWUU9T9shxmjcXYw2mMlFSNiy8mc2JNZkZpj62DmS45UnE+
         srlDWCltiq/w8Ngfa+Ak/zEhqUBhFRCUvH9lg1WQ=
Date:   Wed, 16 Jun 2021 11:32:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amit Klein <aksecurity@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID
 generation
Message-ID: <YMnFOZKcr6JBnPSq@kroah.com>
References: <20210512144743.039977287@linuxfoundation.org>
 <20210512144748.600206118@linuxfoundation.org>
 <CANEQ_++O0XVVdvynGtf37YCHSBT8CYHnUkK+VsFkOTqeqwOUtA@mail.gmail.com>
 <YMmlPHMn/+EPdbvm@kroah.com>
 <CANEQ_++gbwU2Rvcqg5KtngZC1UX1XcjOKfPKRr3Pvxi+VyQX+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEQ_++gbwU2Rvcqg5KtngZC1UX1XcjOKfPKRr3Pvxi+VyQX+Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 12:16:52PM +0300, Amit Klein wrote:
> Here is the patch (minus headers, description, etc. - I believe these
> can be copied as is from the 5.x patch, but not sure about the
> rules...). It can be applied to 4.14.236. If this is OK, I can move on
> to 4.9 and 4.4.

I do not know "the patch" is here.

Please resend it in a format that I can apply it in.  Look at the stable
list archives for lots of examples of backported patches, they need to
have the original changelog description as well as the git commit id of
the patch you are backporting, which I do not see here at all.

thanks,

greg k-h
