Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6972AD1BD
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 09:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgKJIt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 03:49:56 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:33291 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726213AbgKJIt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 03:49:56 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2E8685803CF;
        Tue, 10 Nov 2020 03:49:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 10 Nov 2020 03:49:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=9s3HXA62aXEwuhDqThUDrB2tZR/
        QFmCSXDsh87Vt2VQ=; b=sTP4mDFQaTuABEN3HT4ghPaXmUs+3q36wIKNgmenbJC
        Thrv4yv9IBEmZSJ/GO1JXJ721q6Jq0Uhh63X151o/t7sulK4RmbrAs2jebzvHr96
        zwn0wuYRNIbkh8MLkJIpfLRs8P05bz7vGmNNp1fvqV7OjZvo8ecStqAPSCYWC6Kf
        4rkw1/5Y36NTJyoDeaurHSl7P2Lw3npS9zeuvAJ3j7NaXTfSdcIaQ9F0+rwrn9k6
        UGDZlUJ6j/fEN5663LqKqKLGQPP8Q3JkRlIv9s/YmxnrYzsanyCnj0F0ZMGcXs/n
        0y2wBAYvaAHD9AdUsHqVZ+7wWR88TScAiggD78Dvp6A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9s3HXA
        62aXEwuhDqThUDrB2tZR/QFmCSXDsh87Vt2VQ=; b=iD9hVFzRap+aS8KMlgoNbq
        6YTx0nZBuZ3vn7lC+1uOzxq2tEweH8CUoBkGFiMNJsI4LmLeE/FmcEsPnkcYXNZj
        wCcjGT8TSWrVBQbbYwYblOAQiPDUzy3ZvL9LOu7GNXrWNhDyLhP5WQPF56ne6G8J
        S0qA/8mM2A0JPpg7ZM/QVqSpyOxnJzGXbiZR6SDhUZIAWrOwRI9QGjuYZQses3y2
        VoforsK0qqCFYAno3aRB1FxGrXQYdonw6GqHVUGSCgZxSXG1xD1s3DKX6q1SajC6
        Tt2xDT/LuEwm8zE3oOEGGEfoO+mcfZ91NIlc3pGdZroBa7rvWGao+K8ANKo32rzg
        ==
X-ME-Sender: <xms:MVSqX1XaQGH6eE-Mp7CA-6tXEILG5jMedm8iQ-RkxrSr6LYgwMb5Gg>
    <xme:MVSqX1lwF_FyIBlwBTjkQO4Q93lBSdRh1r2ux7pxJbAk1Gz0kTKuV7XOLT6v0tunl
    cHWMtiNXyvkLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduiedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhephfduhe
    ffteefjeekvdffffevveelfeehhfeutedtgfeigeetvdfhvedvfefhjeeknecuffhomhgr
    ihhnpegthhgvtghkphgrthgthhdrphhlnecukfhppeekfedrkeeirdejgedrieegnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehk
    rhhorghhrdgtohhm
X-ME-Proxy: <xmx:MVSqXxYkV21P3H_SEpIh6oy7Bcz5rLphVsz76W69qlEDIiToY0R-1g>
    <xmx:MVSqX4WNsXWWrDiwvgISWbyXvuCU-s-D1wIzEalQcKjTEaCAa-dflg>
    <xmx:MVSqX_mDnqpPPnY_2u9RKSRaHPJG40wMtWmBaoA_hUrlAxZcPTDRtw>
    <xmx:M1SqXx0OiBo8aUsWe5OqJZDqDQIuum2sW_gtC_Tszc5CO-BDkMuycA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7CD553063081;
        Tue, 10 Nov 2020 03:49:53 -0500 (EST)
Date:   Tue, 10 Nov 2020 09:50:49 +0100
From:   Greg KH <greg@kroah.com>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
Cc:     Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexander Tsoy <alexander@tsoy.me>,
        Nicola Lunghi <nick83ola@gmail.com>,
        Christopher Swenson <swenson@swenson.io>,
        Nick Kossifidis <mickflemm@gmail.com>,
        alsa-devel@alsa-project.org, Ainge Hsu <ainge.hsu@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-mediatek@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] ALSA: usb-audio: disable 96khz support for HUAWEI
 USB-C HEADSET
Message-ID: <X6pUaatZ7aML4sKq@kroah.com>
References: <1604995443-30453-1-git-send-email-macpaul.lin@mediatek.com>
 <1604997774-13593-1-git-send-email-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604997774-13593-1-git-send-email-macpaul.lin@mediatek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 10, 2020 at 04:42:54PM +0800, Macpaul Lin wrote:
> The HUAWEI USB-C headset (VID:0x12d1, PID:0x3a07) reported it supports
> 96khz. However there will be some random issue under 96khz.
> Not sure if there is any alternate setting could be applied.
> Hence 48khz is suggested to be applied at this moment.
> 
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Signed-off-by: Eddie Hung <eddie.hung@mediatek.com>
> Cc: stable@vger.kernel.org
> ---
> Changes for v2:
>   - Fix build error.
>   - Add Cc: stable@vger.kernel.org
> 
>  sound/usb/format.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/sound/usb/format.c b/sound/usb/format.c
> index 1b28d01..7a4837b 100644
> --- a/sound/usb/format.c
> +++ b/sound/usb/format.c
> @@ -202,6 +202,7 @@ static int parse_audio_format_rates_v1(struct snd_usb_audio *chip, struct audiof
>  		fp->rate_min = fp->rate_max = 0;
>  		for (r = 0, idx = offset + 1; r < nr_rates; r++, idx += 3) {
>  			unsigned int rate = combine_triple(&fmt[idx]);
> +			struct usb_device *udev = chip->dev;
>  			if (!rate)
>  				continue;
>  			/* C-Media CM6501 mislabels its 96 kHz altsetting */

Did you run this patch through checkpatch.pl?

