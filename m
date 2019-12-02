Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237DD10ECEC
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 17:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfLBQRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 11:17:14 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:47935 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727418AbfLBQRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 11:17:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 2846FDC5;
        Mon,  2 Dec 2019 11:17:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 02 Dec 2019 11:17:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=+MFXI1x02+aZts39kOcY3SCgTEe
        tODd37lVRwlaM7uQ=; b=RqDguWs48SPl46O63jVOAwOUhRxN1JaZiGYcpANchGN
        Q/cXqsaCReZvKSF8lww3ykNTuC2WwUTgqQY1ga3Fdp6rru7vG52DCPbEpQp39H+V
        TfJU3kowBTlE9lutnJi8OifZqPtutf/c9Wh21vo9VdzLs8l9yp2csXmtYvGqFZIt
        iuLNT5PO7mZd3q+D2ICvyvV+cqcDdBcN532WdXCj9NWk1G8FT2SXBe3edoEpaXT6
        F5ji48+TQMgyvYDa+Zo6lQ+Qu+7cVnXLyak3ClZ+nXnjSflyp7s+6ztrKki4oteS
        BI2F4+9QoZETUIYYE1GLeK5YDPDml5wiP3L4YZxwtAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+MFXI1
        x02+aZts39kOcY3SCgTEetODd37lVRwlaM7uQ=; b=QHiWbnxPxarexocaImivEs
        nUCMftchWRfzqJrON96MH/4uwk88IH1pPnyi5AintaOudjvb54mrxFQ/b5gRBpP2
        yW+ZHfvrdsqOni2Ajb5dpzLY6QDK4oKIuQ5gWIWYA+DST1wNJKmuymODR7M9XJ9i
        vVwBzQy0zPu8tIuT5TaqBAGZZyRIGqPWM7+F/coIGp5kBne5ThO2bKWY+G9mIRQ+
        6WOGHbKYufrTlMLs6tTjxN2beWShO8olwac9Er9YHqfKc2HuIKmcnVfmruGhZS4l
        hsmWU14pL1NZHkwC9PPeUlnYvK3YyQ4p/h/t53aGd3tLpue6l9NyR34W5Qx/4PCQ
        ==
X-ME-Sender: <xms:CDnlXTyjmVyQFLLZJEUzoKtdpoana_9G5r-I33DGYVIUupR2iv7uPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudejhedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeegrddvgedurdduleeirdejfeenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:CDnlXfhdh5pwRmMtmJxGJXeZiaMII8JdbWfw_acN3wwvWhvRqc65vg>
    <xmx:CDnlXYW_WtyDW8uaBf9jNYu9TvZyq8aGmJINNuyUUDMbZMx_9lN3Pw>
    <xmx:CDnlXR0TUE5Sb3A8QGrsoshd9wnXHvSTJ8fFu8T0zYdEq8BjkaWPEA>
    <xmx:CDnlXY9sgRnhBmKDBsjfhZOx9pGTdsuJeKlA5E6qC3hSkviZMpq-Yw>
Received: from localhost (unknown [84.241.196.73])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1E64C80062;
        Mon,  2 Dec 2019 11:17:12 -0500 (EST)
Date:   Mon, 2 Dec 2019 17:17:09 +0100
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.3 1/1] clk: at91: fix update bit maps on CFG_MOR write
Message-ID: <20191202161709.GA701632@kroah.com>
References: <20191202105809.4227-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202105809.4227-1-lee.jones@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 10:58:09AM +0000, Lee Jones wrote:
> From: Eugen Hristev <eugen.hristev@microchip.com>
> 
> [ Upstream commit 263eaf8f172d9f44e15d6aca85fe40ec18d2c477 ]
> 
> The regmap update bits call was not selecting the proper mask, considering
> the bits which was updating.
> Update the mask from call to also include OSCBYPASS.
> Removed MOSCEN which was not updated.
> 
> Fixes: 1bdf02326b71 ("clk: at91: make use of syscon/regmap internally")
> Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
> Link: https://lkml.kernel.org/r/1568042692-11784-1-git-send-email-eugen.hristev@microchip.com
> Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/clk/at91/clk-main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

queued up everywhere, thanks!

greg k-h
