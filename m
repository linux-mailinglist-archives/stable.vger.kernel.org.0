Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAFF33D476
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 13:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbhCPM6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 08:58:07 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57411 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234670AbhCPM55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 08:57:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2364A5C00EA;
        Tue, 16 Mar 2021 08:57:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 16 Mar 2021 08:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=sXmsn7ETwn6KBKZULi5zANcmyJQ
        eNFX0um2z+uHMhg8=; b=KUEbD/DqR84PL/7PMww4Jf9q+uMS7ni9+Z031cTqHRw
        IAo88Uq1pvQ0xXQjGZpgwg/6WnZMOeZfQDfT917zsxrZ6Y+SD64klb/q9DIeWZ8F
        V3dGydpFq/CvJhp+1gJ8Ftv4gMt4Y1TEAwHltVKBly8eldx0i7N7MMvebywu8+dW
        VSpEbsLaMdgeATgwyFse7Ouf5X8kngFxKb2kDAUzHKRUQQ08Sj/G6LmgXzO9kY26
        CLRyj1jaizRaDTrqUh1EV+mCpzZ0hcxaO88O072Y3Q+nX32cwUOP6YqHlvvW5Qph
        7sGN3qZ17FspdrLEa/L9d+Va+gYYiZuIISX7Ivi/VBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=sXmsn7
        ETwn6KBKZULi5zANcmyJQeNFX0um2z+uHMhg8=; b=ok/fI9SjAyEbEMt8sNK8FD
        jg0qShLwpm8WI2HB3i02ItJZtOFXjW4sq9m9fmSzZtmDLoMzGYz3TTT8Lf4Bvl+f
        NNEl8LgPy6ayu5v9Zrf/L46p85Nxz5wxeP1eSeJmRxgXUOcuoaRV3N9mjywJKmZc
        qN4l7FjcugOUvUwo5goEdCxVCqYFowJj9TEoAcNyky8cAeWKKcsm92iTawp7O0Et
        vA++HBTSrZFG1VgOtEe7mI1fkGrj1aLLugg6+xz6W1RL6scJH1BTZSgtuYi2hTtl
        GElKuZUiAyxirblLFgokL1icICfSvJI5OrnmiwWQ9tRPNB3YkcoN/RvQ/rMALrEQ
        ==
X-ME-Sender: <xms:U6tQYAQKlch2MkZ2G2yC3cxFTVo_8GXePQZ9BZqmmify16xzFbQJXA>
    <xme:U6tQYNz3GkqRLHoMzWvBfuDfao7NviVvIZzA_lFrU0UKzzcXXYJcrHcogxlGyu3WK
    9Axb1gLWCSdMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:U6tQYN2IWwZ4q8ngz22B_WZe8CV31lhoGv4gHLxMTASB3tq6va1tDg>
    <xmx:U6tQYEBAjwiRctVUm7B-PY5-AzHIFL4uFs3CacuT5OtsGRkIo_lxjw>
    <xmx:U6tQYJif-08rKnemuzKLfUCL3syrF0jTVpgQIU0BEgoZ9spUbKMovg>
    <xmx:VKtQYJIEDN9PtrFd5rynbYirL_7jC7htZXXdiIHT2BFUsb4r5vARyQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB2D124005B;
        Tue, 16 Mar 2021 08:57:54 -0400 (EDT)
Date:   Tue, 16 Mar 2021 13:57:52 +0100
From:   Greg KH <greg@kroah.com>
To:     Ronald Warsow <rwarsow@gmx.de>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.11 000/306] 5.11.7-rc1 review
Message-ID: <YFCrUP3TPqVK57E9@kroah.com>
References: <ca67d634-3845-ef3b-1ffc-48471045f3b5@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca67d634-3845-ef3b-1ffc-48471045f3b5@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 01:34:31PM +0100, Ronald Warsow wrote:
> Hallo
> 
> 5.11.7-rc1 compiles, boots and works fine here (Intel i7-6700)
> 
> alas a fix doesn't made it in (correct english ?), but AFAIK it's known
> and queued in drm-next or so
> 
> bug/error (since 5.11.1 or 2):
> 
> i915 0000:00:02.0: [drm] *ERROR* mismatch in DDB state pipe A plane 1
> (expected (0,0), found (0,446))

What is the commit id here for the fix that you are looking for?

thanks,

greg k-h
