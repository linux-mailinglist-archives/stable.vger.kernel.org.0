Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486712E7A6E
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 16:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgL3Pj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 10:39:28 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57763 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726322AbgL3Pj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 10:39:28 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 2A3F85C0126;
        Wed, 30 Dec 2020 10:38:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 30 Dec 2020 10:38:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=InRV2t3SNNnx0dg/YV55vnEea55
        63XkQ8Wd0NGN+R3E=; b=GPBardpKLEh2z1uzWPRP+tgWvEqjk7ksnQyhmDVBoxj
        nW/wCS7TnLggbjCGqLQ/tfAG+TIxbCz17SG2wOO6Xty+4EELhGZc85EGSc9SX0cP
        bKlgrjakgKyZL9B99hxldJDV31AWHFKdEJV9Bbx8atatPCm2TtORKONcGfRMQ/ce
        RQvngOP2g9OfUFOFi9kttiExMDUuIu4X4CInI7KD4aVIELWr6y317ykEahC1vdsL
        +EwHXs3ypdA0OYjS9DR3ZGJZDa3GoHdWzyOHl0GX8Q/Tji3a6ueSfMCH5nXFW4Lf
        d9nA6w52aXITFTVEJdjmq/uCQ1g7ZxoC8Xom9OMK7cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=InRV2t
        3SNNnx0dg/YV55vnEea5563XkQ8Wd0NGN+R3E=; b=Jh7znz4k8pK638beSiZcKY
        hnbeW2eviCnEHu1uOqFEtJNLDZUSVQxyqbxMQXkCstNajXZpv+iLUE/wcS6dZ1we
        71SmL+0cbO5eUncCVlVC+x5R3QWFGL8mj8edd3pHGjCdIAijP5NpdHzbtT0jcsRs
        DymUiek1ZpJsuJ65TCqdk7OnJgYwuExnotDihq/9Gt9Di2cm9GJun8FSsuySo/WE
        QfIFWP4GTKmeBlmLVJOxyNeTs6fNMaSydcJ5aSGf7QhluWfUF+lV+vchPgkC6BbR
        M3XBM0wNlFH03yM4A7ImZE3UJ0gntKJdSpLvM7uFc8NKEptVxRSFiNSylsP31YcA
        ==
X-ME-Sender: <xms:7Z7sX7Nz4-L15lmALMZKoxMLm9S8QeKuMe_0LX7Bo74enEekjZ7cOg>
    <xme:7Z7sX16WREB5KyJl-UVokscOc0lz8BJm_2to6atX_Boj-IQdLcoMPQU5Nc-HywfRC
    wP_hLSfGDw7Hg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddvfedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:7Z7sX3JvGcDgzQudF61rzqfGkl0wyBPXWs09FV3tMJIAJrAZbM2qiw>
    <xmx:7Z7sX3fMt_9mKZI_ZCkgHhA_kxVFdzg4F80PLyxfidBCKxZqnA-WTQ>
    <xmx:7Z7sXycCqMHvvv7nrqXaeuG3Qxe1Rhy2NrPeVuG2wRN21TTGmT8yJw>
    <xmx:7p7sXzLc7QbMMgrw9FJSA2QwD7Nv5dz0f69hS-drTbzNMbNUbi6wQg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1E5BF1080057;
        Wed, 30 Dec 2020 10:38:21 -0500 (EST)
Date:   Wed, 30 Dec 2020 16:39:24 +0100
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH 5.4 0/4] fscrypt: prevent creating duplicate encrypted
 filenames
Message-ID: <X+yfLAyAw8kOcOGz@kroah.com>
References: <20201228185433.61129-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228185433.61129-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 10:54:29AM -0800, Eric Biggers wrote:
> Backport four commits from v5.11-rc1.  I resolved a conflict in the
> first one.  The rest are clean cherry-picks which didn't get picked up
> yet because they depend on the first one.
> 
> Eric Biggers (4):
>   fscrypt: add fscrypt_is_nokey_name()
>   ext4: prevent creating duplicate encrypted filenames
>   f2fs: prevent creating duplicate encrypted filenames
>   ubifs: prevent creating duplicate encrypted filenames
> 

All now applied, thanks.

greg k-h
