Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1FE44BCCF
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 09:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbhKJI2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 03:28:46 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:49399 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229582AbhKJI2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 03:28:45 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id E229A580858;
        Wed, 10 Nov 2021 03:25:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 10 Nov 2021 03:25:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=cIlTsNIIT4hbZQLMjkWIVkOUHBh
        6DMvakfyjAaD2FGI=; b=doOdTkxxbaubdu18iLGj2O7vLD8n8e3leX9yK468G5B
        dZBRs6MuvzZWx4FXNxkN3gZUDxSAGkoYsQqpYNkOAjRXOLlF0jfbikX2GvBomP3z
        WNLXza81DD2qmJPiHLaZyn07Ydz0b6xlRzTkWqdRbWcsPskoh1Mz7boocEAF/G98
        DpO7YoO0oLREqcITLCS/0/5qQmq4jS6wsUVMr2k93YpJfB7pLZmhksfurCT/9V90
        Woj4iTBeDLZlVgE53FM8SBYex0Qpmu5WwIjF1lHmQ0YiesCZ40NnlHXwFEzfKhKr
        L2TVHu6bud5/ADLIpk4CSZtdsLOm/s+pUunKFELY0qQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cIlTsN
        IIT4hbZQLMjkWIVkOUHBh6DMvakfyjAaD2FGI=; b=aUX0lzxXZ7hWZd78tWQ1lD
        Thp2VbC8z5R3TRmNzebAwML+Id3Bz+oXwcE+w4wICvvMuanqPXh52F9vOKO+zxPn
        LLL+FTehNZYaH48zEyUbou6DyUkjBDxqNbrGstKGjF9stLgrKt0wOQIu0YZoffY7
        HTIipwBrYvJx1QKjxcCkAN9DGosaN7BPAopv1vZCTWIQtkSpJL4vdXvHeFzBM/CQ
        0HE0lZTUS/SCORWrLh3ErIm0cz7Vfhv5OS3xAaoNS96hfIkyBP5xMZ2deiaSZl0z
        qXendacbMCabdWVCDqCfLY+1SCRnAovCb6reLN7ehTidpuDEvErUY8ixWQABvMcw
        ==
X-ME-Sender: <xms:FYKLYavL0M_ssBC5HfcmdPNtEFylslOhOD_wRoIN8lmPhKWYKB_PkQ>
    <xme:FYKLYfd1fGaM6KHRCdrjeSd5zHb8bn-amb-GaTZFSouKFmKK4lyzDOItgRMYa-AkN
    rnEw3ZHK0LWmw>
X-ME-Received: <xmr:FYKLYVx8Dl4IJ4igt9s6J-8kear2_niRuMfBO2k1lvUY-WippNBgoJAjbsaNif86GtZnEmyBJbsujvdUBC3fhKl283UBpMVx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrudeigddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:FYKLYVMHmcFYSThEVV9tob9DUbCZa9UMN7kwgv7HCYZQXAFimbuVyg>
    <xmx:FYKLYa90hOFB5kV5JI2s93n9Pq3hRX-4wdnOmHkSFEm3uDNKOYZ1mg>
    <xmx:FYKLYdWEddoJsE3qcF1A0uNAzw-4OhDtXudB4UEhhOe0423afLyC5g>
    <xmx:FYKLYVV6jvmke-9SbwMUQi-iYdAAZFDrlLbzpJD68SLOqQiyyUDB4Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 10 Nov 2021 03:25:56 -0500 (EST)
Date:   Wed, 10 Nov 2021 09:25:55 +0100
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andreas Kemnade <andreas@kemnade.info>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Johan Hovold <johan@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.9 1/2] net: hso: register netdev later to avoid a race
 condition
Message-ID: <YYuCE9EoMu+4zsiF@kroah.com>
References: <20211109093959.173885-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109093959.173885-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 09, 2021 at 09:39:58AM +0000, Lee Jones wrote:
> From: Andreas Kemnade <andreas@kemnade.info>
> 
> [ Upstream commit 4c761daf8bb9a2cbda9facf53ea85d9061f4281e ]

You already sent this for inclusion:
	https://lore.kernel.org/r/YYU1KqvnZLyPbFcb@google.com

Why send it again?

confused,

greg k-h
