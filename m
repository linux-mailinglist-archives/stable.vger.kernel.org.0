Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A11B641724
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 14:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiLCNyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 08:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiLCNyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 08:54:16 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59CC193EE
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 05:54:15 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 1CC2D5C008B;
        Sat,  3 Dec 2022 08:54:15 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sat, 03 Dec 2022 08:54:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1670075655; x=1670162055; bh=rdHWpMfyLZ
        eZ52MSgHqHAxJ9DigDJysCkWXhK1bneyY=; b=m3bvd9JlIp6ewfz/aqLzdvLcOZ
        BxhkHFQQFlt+d/5XRt30OjYCq0IO2nLhlF+8FPrPA4ft/GA9qujz+0UPimDPUoOk
        OvK5sgUlleSDUs4ELU+ko9gh7TiOA+ZAHasDNNIfjPq2hn68UgAEcAqTbc9rxee4
        URZ2NB3RyAORCcI9rsU76B1TeekIoFkCRxRuZP8KQzlupHyIrKI9GdaTHSL8CNou
        DLnmvmn8j5vPue4IdbDS+OPDi+LLHwnfFdEVHIL90HCsEwQtWSEtdVw5aCc9SrKt
        ACRRUWDg4lTt+AHJ6w1q5qw7l6r15u4h6GEN8kQx3XWoJnFrlObj/Xp/4CDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1670075655; x=1670162055; bh=rdHWpMfyLZeZ52MSgHqHAxJ9DigD
        JysCkWXhK1bneyY=; b=Dx6NVllpAYgHXGfy1lYgMh3wXkqF5zb8RQe47LLq6S/a
        Umyh6/yrTVmV07YmMNIUOz3eiL+GWlKiggkShkZBFkHVG0mMysOxgEs6aac6ZqYj
        hPOjP+ScO31no6PpenTmWXxFutkOUfHuE9yATfTI7MbhYrseEUpPhfb5NZcTWfXf
        TFNkmIFUFZ+kJzqTt97MVgPtNu47Ww0VtZL74cNtQ9SZ6GV/OnoLIHZbBgAcKTHE
        CeKfLbXzX8G014LL1FQIUBPYNb7hvOnAu3kcFlYq5gk1WQxSl/4iKn1a5u4oF7Rg
        Bym2A9yNblNyZc8jEKyi71Q7zx4RovEVbN9gRA2kbQ==
X-ME-Sender: <xms:BlWLY1-RXHyCti_cozIb6b7L5rmzAAzIQR4c6EZXpJmBpbN-96Di6A>
    <xme:BlWLY5tbj8t9Jqi4UQcT9Q9L7qCofgao5dwKfLHc5Pmh9QavjPDP3thkj0aR6mtWX
    IHDYA7SzAjypw>
X-ME-Received: <xmr:BlWLYzCbm0xxmZhtyjZrx8LvxgUHbJi0c5__zurk23JsyvPuRfEi9f3KoRdGOczEhVa5a3Xfx_O9EvFPv1AVSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddtgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:BlWLY5ef0WCVo0YjE10J6PUCGEOLYiWG6_MdWAaDJawZWHOB54W_DQ>
    <xmx:BlWLY6NhGtxTEzU7Yk279RVjiJ04yJ6SMl0gHipuO4uKIoE1ZP_vMw>
    <xmx:BlWLY7mgHkhl6X_K5wlxk5zhPEl_XTzDXL-PBT9pwmZ39wF9RGWZyg>
    <xmx:B1WLY7GiuAWQn7mSC1ldcS9EAzsHZazecUPl_8m_H_PQMlEGXwrxHw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 3 Dec 2022 08:54:14 -0500 (EST)
Date:   Sat, 3 Dec 2022 14:54:12 +0100
From:   Greg KH <greg@kroah.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.14] efi: random: Properly limit the size of the random
 seed
Message-ID: <Y4tVBCLUz6N36rtT@kroah.com>
References: <Y4frikbdKtF5V1WU@decadent.org.uk>
 <eadb1fd5a181975bcf63b742b02207a2f347dd57.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eadb1fd5a181975bcf63b742b02207a2f347dd57.camel@decadent.org.uk>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 01, 2022 at 12:53:03AM +0100, Ben Hutchings wrote:
> On Thu, 2022-12-01 at 00:47 +0100, Ben Hutchings wrote:
> > Commit be36f9e7517e ("efi: READ_ONCE rng seed size before munmap")
> > added a READ_ONCE() and also changed the call to
> > add_bootloader_randomness() to use the local size variable.  Neither
> > of these changes was actually needed and this was not backported to
> > the 4.14 stable branch.
> > 
> > Commit 161a438d730d ("efi: random: reduce seed size to 32 bytes")
> > reverted the addition of READ_ONCE() and added a limit to the value of
> > size.  This depends on the earlier commit, because size can now differ
> > from seed->size, but it was wrongly backported to the 4.14 stable
> > branch by itself.
> > 
> > Apply the missing change to the add_bootloader_randomness() parameter
> > (except that here we are still using add_device_randomness()).
> [...]
> 
> This made me wonder: shouldn't commit 18b915ac6b0a ("efi/random: Treat
> EFI_RNG_PROTOCOL output as bootloader randomness") be applied to these
> older stable branches?  Without that, the EFI RNG can't be distrusted
> if necessary.

Makes sense, want to send a backport on top of this one as the original
will not work?

greg k-h
