Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1914000D9
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 15:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348814AbhICN6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 09:58:15 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:46573 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348778AbhICN6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 09:58:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id B69662B01266;
        Fri,  3 Sep 2021 09:57:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 03 Sep 2021 09:57:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ou2miFBf0Z/Mek7c6HsqgdNghxW
        0xkCyTnhz5o626Y8=; b=ujmvwFns1pMZ57Jl79UjlA3tREURGfhBIfb9nj7Xna8
        LCCZ4jAIls9dKj64uPgX3j6A2Eqhimi6wKQd7yXicr4bCgyWDkekkceVCjekx1dC
        jp4tQ35JTalEpBdn5S45k9r2kj9vQC/AMThtr6El6uKjz16BImd8xbkJxvh6G0KF
        tP5xUPYQwkOLrM5E8P/0cdcJFRhjWy8atNaLCsv9QR+l7ncMX2moOETnG1KEvRUF
        JLwPxYuGJl3aht2U4Y1hXwpUQreodEgTww7BsW+aO6Yn2lZB8vTDySnB38ZzdPBg
        7o+P2417ibAdq7D/ZU9xjjFfK5WhN8NccSoRwNh7qYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ou2miF
        Bf0Z/Mek7c6HsqgdNghxW0xkCyTnhz5o626Y8=; b=RfSgwpmViTbjmEQiDkUbqM
        DEU0pQCf+sDaSdLie8qCH3a8qkxA6uxumJlPny74Hcky7774It0TMrK2dWn1TFrw
        RN9Ny50Scw0acuFxJuKA2/cUokR27N3FdtP+Aa0nH093PSgzs500eYQDyYxXLTT1
        D618M0GTgjc3LgwgPsk6Gkdkp2NT09Fd2dp1uZ2lPYltQfaVM8jyqihPSmxM5lbu
        iDpbI0Ww7P2RdLt8fQTAQjLK960k+Amvp1i+xLzI3Jhigl770Pew4po6sZ7jAdU+
        jj7YzYU1I6EQlSpcIuKSOCcbq820bD6IHGF1fia4LzR5lZPGv2HyUf5ymCJYCkOg
        ==
X-ME-Sender: <xms:uCkyYf2a-zGiwsDzkrR3pjixUG_0I4bNcs-yKnPgre8rucTh6CI9ZA>
    <xme:uCkyYeFnkuRkQ1h0YchVeS7JfWgXtEwjUOid2OhnPiPcD-RuH7UrDJZ1y7TqJl-rB
    sZd60JpLJiBLg>
X-ME-Received: <xmr:uCkyYf64drTwrzWB2BXX4CBR3jP-q084OGpy4fMYNxakIQXbrBYuDQ2wTZnN72ejEoqIS0BuZwf8NjgG_8uM8izUzW6IzvcW>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvjedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:uCkyYU1kzJNRa0MFr0hspEjs0xuHuRuWYFVgrO2V9_Suo-8TN3gMQQ>
    <xmx:uCkyYSGnYwl5Q2AUUcgPJpO1bLT4Y_12Xx1PdiNVjtrlovwLoKz3fw>
    <xmx:uCkyYV9r6Lh_cUyVg9LJ62hfOuhpPJKeW69cXZlEIfnBdepf5V_-yQ>
    <xmx:uSkyYa9D9tQwAWiYU1pcksmD8tEVt3tsODE05e5cKq4_ViO9j_q-6qpGz6A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Sep 2021 09:57:11 -0400 (EDT)
Date:   Fri, 3 Sep 2021 15:57:09 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH 5.4 0/4] backport fscrypt symlink fixes to 5.4
Message-ID: <YTIptf2dFHf9sSIY@kroah.com>
References: <20210901164041.176238-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901164041.176238-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 09:40:37AM -0700, Eric Biggers wrote:
> This series backports some patches that failed to apply to 5.4-stable
> due to the prototype of inode_operations::getattr having changed in
> v5.12, as well several other conflicts.  Please apply to 5.4-stable.
> 
> Eric Biggers (4):
>   fscrypt: add fscrypt_symlink_getattr() for computing st_size
>   ext4: report correct st_size for encrypted symlinks
>   f2fs: report correct st_size for encrypted symlinks
>   ubifs: report correct st_size for encrypted symlinks
> 
>  fs/crypto/hooks.c       | 44 +++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/symlink.c       | 11 ++++++++++-
>  fs/f2fs/namei.c         | 11 ++++++++++-
>  fs/ubifs/file.c         | 12 ++++++++++-
>  include/linux/fscrypt.h |  7 +++++++
>  5 files changed, 82 insertions(+), 3 deletions(-)
> 
> -- 
> 2.33.0
> 

All now queued up, thanks.

greg k-h
