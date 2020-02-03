Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93635150872
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 15:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgBCOcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 09:32:48 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:60243 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727787AbgBCOcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 09:32:48 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 029583F4;
        Mon,  3 Feb 2020 09:32:46 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 03 Feb 2020 09:32:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=dVVz8f519a/6Wo8ts1nwJdClp2T
        55/rafW7s+KHqhnk=; b=SlBpQvhnkwxNQA5GVKfPFpQWwmfTPrXfHNdEIHnAsZW
        MtKJWd4jl8+GpHZ9UHOTUaTKxThh9mLda3lX64ofX0HmtqbYjTjoEDwBwtrNkMg7
        FHgT+xL8BwI3FOQxFMTiYn13EB3vtZV78dfjbw8NbDJuwZk5tefF9yQyFCouuRab
        adazfnEjP0k2+nhutWNM6OzdnlwnCaysFKxT5j/o5fgr3TcCCA6qJtphGJ9NHSW4
        kPCctvGJnMH6x2PjoYZ5Vj3nDSDLWl6JVXIM1Fv43YfJuuf2Lk0CRiYnvFMR0OX2
        n4eQermht+9JlBf+kIHfudvFrUMGiGjpjjbgnb/8f9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dVVz8f
        519a/6Wo8ts1nwJdClp2T55/rafW7s+KHqhnk=; b=NMP4CvD2dEKlRVY61F0dj7
        s+rS+cWGv64+D9GiMtiK/1nzLJ2EEsQVgDW8KEi58ThRygQV11QyxrW8DTKzK9t/
        55+I0pSxX9AR0W0XffGtkq+oGPSN+DDxuLcRujkLjL8X3uRaKrA8Yhtl4d7ckGGv
        5Y7H6rNz/T3pTl7Ib2mU8qg6+AfxAyKY+U4+y4/3aEysSH/8TbFXubKRnW03O83A
        xrFjyasRy7+OvJYhTbgHM/apBCc/rTsRVZOHZmEXWyoGtTm6k+CBrsdnynghXiDs
        h85BScVYvt7A9QAZH8F0KV1vKTjgWnWZjMb5T2uKhDoLHWuMbjffpsBZooBm08jg
        ==
X-ME-Sender: <xms:Di84XqpXYxZMELaRk04HUTZm9NHN_KOV8aBBX8CMmRuAVBKctR0KVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrgeejgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppedutdegrddufedvrdeghedrle
    elnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Di84XjK3grCZy77gWAA6kdg6_1Ss_WliCBZWb9E_jht_IrnA_hIz3w>
    <xmx:Di84XsKJfBy5uGKmA1wLtLu-K1tPTmjycah1esfDzv-IvY221vTnKQ>
    <xmx:Di84Xsm6D1vgV6651xG1lgonpuB82Guy32jcgrBxL_0nRj8W8Xf6nQ>
    <xmx:Di84XuYQxHkaQ7Cf3f8u6I4zZl4KF33PHopm_Mx9xK-f-GQJh51iVg>
Received: from localhost (unknown [104.132.45.99])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3919D3060272;
        Mon,  3 Feb 2020 09:32:46 -0500 (EST)
Date:   Mon, 3 Feb 2020 14:32:45 +0000
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] media: si470x-i2c: Move free() past last use of
 'radio'
Message-ID: <20200203143245.GA3220000@kroah.com>
References: <20200203132130.12748-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203132130.12748-1-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 03, 2020 at 01:21:30PM +0000, Lee Jones wrote:
> A pointer to 'struct si470x_device' is currently used after free:
> 
>   drivers/media/radio/si470x/radio-si470x-i2c.c:462:25-30: ERROR: reference
>     preceded by free on line 460
> 
> Shift the call to free() down past its final use.
> 
> NB: Not sending to Mainline, since the problem does not exist there.

It doesn't exist there because of a bad merge?  What commit caused the
problem?

thanks,

greg k-h
