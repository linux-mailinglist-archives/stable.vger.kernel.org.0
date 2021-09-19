Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E14B410AC2
	for <lists+stable@lfdr.de>; Sun, 19 Sep 2021 10:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhISIeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Sep 2021 04:34:02 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:36083 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229576AbhISIeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Sep 2021 04:34:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4154232003F4;
        Sun, 19 Sep 2021 04:32:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 19 Sep 2021 04:32:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=7
        w/ZWq7gPenuvosorXO4XO2Gurl/R2o7wsURVrUqYTA=; b=axyUE4+iMCX4utJK4
        ufk8Nr1RUed/UIvPeEqV94mzSTlilFgFR4KQqld6Zeu65UnicrTU7EIjSDh4WEI/
        nefYn3Kej3fSjPKb+sTCLk4GLUXM7UFNl7zdXNRQ6SPMTl4asK4ZnoyexhZdLBNA
        AWBcZN9CVyvbFAXr5wOwGYQk+xHKcyvJU9IorDHSbeAVLuSHdWED627rtqb+mLkI
        8bR+rW2iqKZtKZeH3FMv2su7aYy9twz0ZLyt6TDVSn8Wt57sWk+DEa673jQfX7Fn
        bvZxrvOp6P/v1V3wUa52PgmzyNbuEGII/Yasi2XPtuisE0/YSRv4jbQTvZqZEh4f
        CljlQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=7w/ZWq7gPenuvosorXO4XO2Gurl/R2o7wsURVrUqY
        TA=; b=k0kolvrLATyngwoYTcZ9FuoOS0svKXvIUeIyECWyb1tS9W1PYBrKzu+Rm
        NSQqepoB8Z3SuGx37FnEDfC2Y4caNLrPO5YL53ps8Kf+aVBxMLnMwy3WRSpGszWe
        YDiZ4LHH9mYmsJai+K7lt7otpv1l7OlFgnqcLwzZLtb+gXfoNft0AtF19IC0HjhH
        QY9DCe23C48SEsZpxVon4BDrkV+Ds+dbJ2b5SLgyMkQDqJfH8oD8ux47lCUj3n3H
        8XXJU6T0osFw3EhdkusvYdn8B4c30UXO6WhoJzXC/w1x3ypqE6iGpH/6FnrT6LgS
        7OeSZc28WJhAzCg2tBpiS0IwCekHw==
X-ME-Sender: <xms:o_VGYQ6FMVwSuQRQZ4eehuv24Bqw43gI6272KPHnNk61gI2bEVRFtQ>
    <xme:o_VGYR5XftN9tr-Si9GG3ab7vZWCC-xo9XhlyFlY7tX6S2-1zqjS_Y_GH73bPIVFJ
    6bPsi-LDUyvKA>
X-ME-Received: <xmr:o_VGYfdjGNr_MaXRg7GdDDLnLMro6cpuElobSdeH1qZuw49MCHRunNAVejdHSPFS5OQMVGHENf7rmYf3QhUJ-FLnmAforgA2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeitddgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvdffgf
    euieeuhfehveehtefghedvfeegkeefveeujeeffedtteduteeihfehffdvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:o_VGYVLmyWTTV_4isYcHCWIMYmb3jL7FH3w161SPJLbKLJvA1P5F5Q>
    <xmx:o_VGYUKBwPrHUq92JGd8S6BKk7kPeAh8LlAJJgJNoU7jpvqlgi8Kfw>
    <xmx:o_VGYWzx1p3B0CcfohTW3Rp6LEOrpRkeOJOb2BO9ULxPto4ikWUWww>
    <xmx:o_VGYbW0bUzprU9AnFZkzklW1xtC3NLk23aHZWLdv9CbglIohdWPwg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 19 Sep 2021 04:32:34 -0400 (EDT)
Date:   Sun, 19 Sep 2021 10:32:32 +0200
From:   Greg KH <greg@kroah.com>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     stable@vger.kernel.org
Subject: Re: net: qrtr: revert check in qrtr_endpoint_post()
Message-ID: <YUb1oP1S7WCeUIiW@kroah.com>
References: <2f3c9215-0211-0719-880d-080178e8755d@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f3c9215-0211-0719-880d-080178e8755d@kali.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 18, 2021 at 05:51:39PM -0500, Steev Klimaszewski wrote:
> net: qrtr: revert check in qrtr_endpoint_post()
> 
> 
> d2cabd2dc8da78faf9b690ea521d03776686c9fe
> <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d2cabd2dc8da78faf9b690ea521d03776686c9fe>
> 
> Applied to 5.14 if possible - Have tested it locally, and it applies
> without any issues.
> 
> 
> The reason for the request is that 5.14.4 had net: qrtr: make checks in
> qrtr_endpoint_post() stricter applied, and this breaks qrtr on at least
> my Lenovo Yoga C630 which means that it no longer has working wifi
> without the patch above.  I thought it had already been requested, but
> there have been 3 point releases of 5.14 since the break and it doesn't
> look like it's queued up anywhere.

I do not see it requested anywhere, do you have a pointer to it?

> 
> 
> Apologies if I did this incorrectly, I'm trying to follow Option 2 in
> stable-kernel-rules since it doesn't appear to have been CC'd on the
> initial patch.
> 

Now queued up, thanks!

greg k-h
