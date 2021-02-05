Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773ED310732
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 09:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhBEI4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 03:56:08 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:59649 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229771AbhBEI4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 03:56:03 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 1991AA92;
        Fri,  5 Feb 2021 03:54:58 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 05 Feb 2021 03:54:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=a8PzAVnU92Yi0Hkhb8v+lkxdfa7
        E/IWVUDkKmfUtRHg=; b=qNgMa2bXalXO9ZJIEC2/W/VLbZ3pwklA4kNfhnKxD5z
        hrV76MEUyIrBDje6TsXskIc+sakBAW8GDKVPDR+jA2oNgXLmKiXSMuXuEc3XfM5h
        BkD57tkNHDAyAsQS0piYQrSvjl/gajI4rcI1zQWjUVFWRQP91Ju4jmUZJ8yiiVNy
        Uy6q7+lxPLzuiX0SkOvLRCm2s1Krw+XT0+aaiYj+gPiRgOG8jwxvO5gqN1P6vgOk
        6INpJCoyWER1upTkJbT3XT1l5Y+sC+LO24GSqF4cZeu16x2wVJ+22+3L6emeMH9d
        PCvxccPTV6dLwaI8lZNEzjC5lj56KKQcu1XBJeQSlJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=a8PzAV
        nU92Yi0Hkhb8v+lkxdfa7E/IWVUDkKmfUtRHg=; b=ZA8pcCI379Dk1cEi+I+Bnu
        KOezeVe3CLSd64YDLMWdxt86KnEFlmq/BUdQu6+dGCy71+J7UuetqadHS6VhyPM4
        jxraS9IKu4U1PAQ2RLPuh90uFzac6mzWL5Lb+Ef63ZQN0+FrQJHerjEVL95G6g1J
        38qSRB499V/nmBG8PKl2uct3/wlB2FxnXV+mZyEouEzFtX1BHC2Z6F4UBQQ1xcaT
        o+OQwZM6JibzQ0wCl0v68z4wSPomqDuFgkDU+utfNUZXNK27hIrHDJUWZD5EkvAV
        /mghlvMrOhjqCItbFJolxZxi4HeWARl5ULe5nP9sNfKN+Q5dMF6cDe3XJ0qajAqQ
        ==
X-ME-Sender: <xms:4QcdYEUlnYAhJJTW1UJJUK9xqlOX4RzbUw4Pvp2tsT2LcMrEAK5c1w>
    <xme:4QcdYIn49mvSn4hCD5IBICSVDcqymkQdAjkoZo5g-U0dkQuyFgMiABDo-lnyIuWRw
    aaOhWtlxddtZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrgeehgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:4QcdYIZAH79g1xbw0MLmAfgLCTAEfIANSt60rWKpWvxvEldqOMz_2g>
    <xmx:4QcdYDVJsmi6I6-1IGsfK647F5vmpUnPYCL67uGnyYkMe-J5oCoaag>
    <xmx:4QcdYOmNznDklD_K2t4mCcnfgRA3375u_SQe3_igfypYslKCYNTksg>
    <xmx:4QcdYIRTxMENzgtPXAHMcCy7MxJkfKPUtl6o5Ds5DDmm_WJdjNb67w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1021A108005B;
        Fri,  5 Feb 2021 03:54:56 -0500 (EST)
Date:   Fri, 5 Feb 2021 09:54:55 +0100
From:   Greg KH <greg@kroah.com>
To:     David Sterba <dsterba@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: Some btrfs fixes for 5.4.x
Message-ID: <YB0H37t1LfzUuFzq@kroah.com>
References: <20210204203149.GI1993@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204203149.GI1993@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 09:31:49PM +0100, David Sterba wrote:
> Hi,
> 
> please apply the following commits to 5.4.x tree. They're fixing a problem with
> a long running transaction and there are users that have hit that. Other users
> from the community have been using the patches on 5.4 base so they can be
> considered tested.
> 
> All apply cleanly on top of current 5.4 tree. Thanks.
> 
> 7ac8b88ee668a5b4743ebf3e9888fabac85c334a
> ed58f2e66e849c34826083e5a6c1b506ee8a4d8e
> cfc0eed0ec89db7c4a8d461174cabfaa4a0912c7
> b25b0b871f206936d5bca02b80d38c05623e27da
> 
> Short ids with subjects:
> 
> 7ac8b88ee668 ("btrfs: backref, only collect file extent items matching backref offset")
> ed58f2e66e84 ("btrfs: backref, don't add refs from shared block when resolving normal backref")
> cfc0eed0ec89 ("btrfs: backref, only search backref entries from leaves of the same root")
> b25b0b871f20 ("btrfs: backref, use correct count to resolve normal data refs")

All now queued up, thanks.

greg k-h
