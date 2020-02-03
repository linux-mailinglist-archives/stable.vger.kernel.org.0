Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD9CC15107F
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 20:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgBCTuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 14:50:12 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:56215 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgBCTuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 14:50:11 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A39E5814;
        Mon,  3 Feb 2020 14:50:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 03 Feb 2020 14:50:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=3qGwQTwRO0ezqdl7FLjdG1jrWTZ
        MrVEjYdKA0OodWKE=; b=DF6xMlafHDYL4k2RShD/bCe0GHk/D4Me9MdDldVicR5
        vGaGjZ+TH9TL3/Fj1Aid60LMs8EVK3pwyXXZwxKT2hMHN/VclNCb63jJ6sf2lsLC
        DSnp/LE5nmeKTUICFLQbzRyg+niyH0WzrJLhnzsgDmiP9Hp9cJXXxkmQJrKxzw4z
        6Xxm9YBcmQu+hv6sN2o1gz6lc9NIf/tK9uvht+cvZn19LM56gT4EbAtgbVR42qXM
        NijnWGorv6SZuHoyNCzpA4/ijboNT6lqpJNZHoQb0LwoD9l/R5dWZZZ2zX+RdLar
        1FdIZ/LZ76kyQ+WyiP4iZR4bjP+q5bF1HQiDOa/893g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=3qGwQT
        wRO0ezqdl7FLjdG1jrWTZMrVEjYdKA0OodWKE=; b=StKQZ0wUD3d6JP95UFFcjb
        b6QcuQL8YEqSiODB/RW5Nokc9qAb/MrVBKnMDyNQtYKp7HRJUujJbkTJETpreIgQ
        eegZ+Jc0kTSmfL+771RXJSGLl9mY8hUxyDNuyKLmzRfKAy0q5cJqNHYcDCvDKdwA
        hXcBNU9yT7k/pphNSQLJ2SjsQm9dUeyjLHSTrpl/CTB3Qvv1Y6EQOfFgbRTDbb55
        VdMcNjd9PRFIv+jUR9NvAtkfIHDBt2Ngk2nAPsowymlid19hA3o4HZuaXBl+R7fk
        iOp4AVavpY/QbrRErcLivzOHP4rPtKLWapxerCz0nNqqEf4+DGHO0J7XOQqIC6ww
        ==
X-ME-Sender: <xms:cXk4XvqIA3l_waWzhn5YZoX9gSqa1aD0Q4Qi5w-fUvRPhKZr7GkZkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrgeejgdduvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necukfhppedukeehrddutdegrddufeeirddvleenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:cXk4Xlrswab9pYZTK2ook7T2KY-oF7IfcI2NGJHVgjvpN1LtKRfM5w>
    <xmx:cXk4XubOpawCEqMWBAO3DE23GnXy3RXsm75nHHUVBXivUzMNypxPvg>
    <xmx:cXk4Xj-cN90Q7w5FZ50Dr1uSVwbZ8yF6gEuM1v4_fBB95lDzwH6OJw>
    <xmx:cnk4XitiEMy6wApGH6H76ZtBFhXYdzT_x632xcjWcInLG22G9XIQew>
Received: from localhost (unknown [185.104.136.29])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4006030605C8;
        Mon,  3 Feb 2020 14:50:08 -0500 (EST)
Date:   Mon, 3 Feb 2020 19:50:07 +0000
From:   Greg KH <greg@kroah.com>
To:     dsterba@suse.cz, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: Please add d55966c4279bfc6 to 5.4.x and 5.5.x
Message-ID: <20200203195007.GA3853072@kroah.com>
References: <20200203182949.GD2654@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203182949.GD2654@twin.jikos.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 03, 2020 at 07:29:49PM +0100, David Sterba wrote:
> Hi,
> 
> I'd like to ask the stable team to add the patch
> 
> d55966c4279bfc6a0cf0b32bf13f5df228a1eeb6
> btrfs: do not zero f_bavail if we have available space
> 
> to 5.4 and 5.5 stable trees as early as possible.
> 
> I'm not familiar with your release schedules but I saw the large patch
> sets for review and I hope I could squeeze that one in the upcoming
> release.
> 
> The commit fixes a problem in 'df' that causes false alerts and there
> are a lot of users hitting it. The patch itself is a one-liner, but
> with a high impact on usability.

I've snuck it in now, and if you could provide a backport for 4.4.y,
that would be great as I think it's also needed there.

thanks,

greg k-h
