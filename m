Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFD138E6D7
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 14:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhEXMrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 08:47:04 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54927 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232424AbhEXMrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 08:47:04 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7A1F75C00EF;
        Mon, 24 May 2021 08:45:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 24 May 2021 08:45:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=EzFtBpP525q5g7mlAsVWgU+hNyW
        sublIX8sanLuAJq0=; b=SVKZ7N2eLcPuHizzFXiF0PSLngtbMsi474q3Y+ms2Z0
        f5zaks+Y5jX7gOVBKVnxletog5/+o8nLCDOfjt5b5aROfVp5co27wOfLFHV7TZ5e
        eLySO1m1HufcHrH9xUa0uLbEp8ytRpymfY6REk4u5uhJPVHKf706mgaR72aTQF/Q
        20tg+9hhzdwCz0UrVPndAyed8GfWuSt5WYQd6MokKeEgOhR4zmXyodQFxVys7VQy
        NjJuIJlvwn2X5k7d6MXUlkStoPPvhqEBIOiOGRhzG8L61dI5HMuiaxzwM4aNSvcA
        ynaDFomrjErvKPhv0Eu0so7lyYm0KLwaJDIHBBiqkQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EzFtBp
        P525q5g7mlAsVWgU+hNyWsublIX8sanLuAJq0=; b=SL5/XeExODXwRjE9HH+sh/
        9KEqzeq5USwcuVSaVF+5rbhDQdykiSTmKuopKt8q6hswt3KpdNIQ2UHTq0rJr7XT
        H0XHEuaMK5xTWVy6UQKU+27gqPEfG5xHyeI7Ob9NUDkFdMXcCPbQe4oX+2o08ADf
        uxVS9VJt6I0iIknPosboW722TjYDzSyxogl0G/Di/b2UpIykEZ+ZIWIXCcdTnnqg
        38KTpP7IECY07wL0y76mqXm6rIT0497OU4/GWoU816FPvJitUqRKTsC5MC/3e2KD
        o/ilewhIuUluqOswrS6T4LfeNyi1xc3JrfHPiqQFX/SJR+rcAAj1hSJfvy/aCLNw
        ==
X-ME-Sender: <xms:7p-rYFZywHBSh3RT9dafrTzgsaJPApdlwsk6U5ra6nBXFTUtlpBsmA>
    <xme:7p-rYMYO6Cty12hHt6lgkmytANaPXQ-GBbbN3GCNpm3DT6I9RXJvljMVTc2nq1Dnu
    Az4u91YPa2r2Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledgheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:7p-rYH-G_HiKzXAuG9_SufXWazcQ-2l_vQ_1iSRsEcrBW1yEczQ8lg>
    <xmx:7p-rYDrKUsjNbCRlA-yF3ijSLK9fq69ixPAsc0dM1H3NLJsn8euDLw>
    <xmx:7p-rYAr7q6IchIPrEj-MpCHtpsvRjsSitd3X-V9ScFYIcRCI4_46lA>
    <xmx:75-rYILWKtpCwvROIQdHp4-kUivnAnlABo7WwVnFv-JpezK1WLbIvw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 08:45:33 -0400 (EDT)
Date:   Mon, 24 May 2021 14:45:31 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-ext4@vger.kernel.org,
        Yunlei He <heyunlei@hihonor.com>, Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5.4] ext4: fix error handling in ext4_end_enable_verity()
Message-ID: <YKuf6zSQayzoDoxQ@kroah.com>
References: <20210521222725.812825-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521222725.812825-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 21, 2021 at 03:27:25PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit f053cf7aa66cd9d592b0fc967f4d887c2abff1b7 upstream.
> [Please apply to 5.4-stable.]

Now queued up, thanks.

greg k-h
