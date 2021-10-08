Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849D7426651
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 11:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhJHJHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 05:07:35 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:35437 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230045AbhJHJHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 05:07:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AE10E3201C48;
        Fri,  8 Oct 2021 05:05:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 08 Oct 2021 05:05:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=o5sKXanmwtFn92cf8nVFHHik8Lm
        FaCA4h7YdLKp3bFI=; b=YYpKOb1V6oXVs7i0AhuA1yyq/JSTuyFjx8iotJz1kZy
        MDnsysc4amP8M+gJjjqY0p1LxiOrn5Tbjyw4cedd5QGGhAR0rSumVHGUCVuP6hMq
        /SFoHXgSO/+Uy1VVNEwBfs/NEMizTjnFmI1mghE0tzEyIhW9V+i8bQ0kR/jrWnVP
        P89uCl35wYaxw7dAlHEgmrnjdfxaGFE40Ww1HRfGJPPKLoTgZfPLdl8avYbKJspi
        5IS3Lc0A2zJeKM2sFePFFhJ05dF4TngG3r5wcgZWnHFelRt9+bmd4zt1Jc4up31K
        sJHwQDOOsjJzgGt1MkTnmlNZB61Z5+mAodzmV8gYPfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=o5sKXa
        nmwtFn92cf8nVFHHik8LmFaCA4h7YdLKp3bFI=; b=oBRjMJztA9MOKwo/eAn8xw
        +lpuHfBi1MjOkd0Natw6FWSJR3lr/xEh6dwqg1+a0r7fYol+zaHSKy4l8afJRaqb
        wM3Ygj2bhHUCsMfG7OgkwsIUcPgZ/JJrTEzxRHRLkT2om2IV1+d82nDMsyxK+kWS
        xvk83t34XtqOw7EeXqYErTA681YP/9B/HzLd9TlxJcP5ELbZ/UZ3ac/cU/JFf8ti
        16i2nkF4VHT2BGfOGImuMbvb/Pt849G6al+f5FlegQX4AOq/3MWebNcX1LbMkH5j
        hJPno94bY487lcYmjqnDD7sgexweU3EQSOV4+B9cvR001haz+CzVEI9YeoJQULPg
        ==
X-ME-Sender: <xms:4glgYUw6Pl4ftpy-cxQSkWub0qVFWndjR9C_-t6dtHmjD5ziuwjdEA>
    <xme:4glgYYQ25fbFRyLzgtQSP1zJc9liltReM6grJzU7mn7n3P5UT0W1nFz6Xky8QnkEi
    FgS1L0BPMkSdA>
X-ME-Received: <xmr:4glgYWUmo7_OXVUZHjzuH2OFR8jGFb_RVKPp5-zq2yVyHdw9c-nBKCCKXo4WT2ULXs2AkKCNc10ZXDp1sFrFD67reqT_VnFd>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddttddguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:4glgYSiD9WygpOT-mTQO3Aspku8lVf-K7jUKj0gAPiZakCUdSBqHXw>
    <xmx:4glgYWCMgs3Z6u0rV4wBi5Ff7689tTSQcVwwCLGFiZcUMA42uz0vBQ>
    <xmx:4glgYTKhGvRvI4ps9dJyr2e8K7RyGbKvgO1ka6Y-WksLQ8v2WfozXw>
    <xmx:4glgYZPFrjkhJKXxODZuR6-swUzaXaE21LWL9jbtQwhTlnVxhcT7YA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Oct 2021 05:05:37 -0400 (EDT)
Date:   Fri, 8 Oct 2021 11:05:35 +0200
From:   Greg KH <greg@kroah.com>
To:     "Anand K. Mistry" <amistry@google.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Requesting stable merge for commit
 02d029a41dc986e2d5a77ecca45803857b346829
Message-ID: <YWAJ3yWI3HJimMX9@kroah.com>
References: <CAATStaPx9tLmkUKAn4R82MKKzr1i3sL-ivgHvFUjf4qf=eSLbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAATStaPx9tLmkUKAn4R82MKKzr1i3sL-ivgHvFUjf4qf=eSLbw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06, 2021 at 11:01:26AM +1100, Anand K. Mistry wrote:
> I'd like to request commit 02d029a41dc986e2d5a77ecca45803857b346829
> ("perf/x86: Reset destroy callback on event init failure") be merged
> to the 5.10 stable branch.
> 
> This fixes a bug which was exposed by commit f11dd0d80555
> ("perf/x86/amd/ibs: Extend PERF_PMU_CAP_NO_EXCLUDE to IBS Op") merged
> into 5.10.65 (as commit bafece6cd1f9), and partially broke perf on AMD
> StoneyRidge systems.
> 
> I've tested this patch locally on 5.10.70 on an AMD StoneyRidge
> (A4-9120C) system.

Also applied to 5.4 and 5.14 trees, thanks!

greg k-h
