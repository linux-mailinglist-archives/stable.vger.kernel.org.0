Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B604D153F09
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 08:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgBFHB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 02:01:29 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54393 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725895AbgBFHB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 02:01:29 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0259121F1E;
        Thu,  6 Feb 2020 02:01:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 06 Feb 2020 02:01:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=IwQWOy+Iu2IfRMziDhxspW5Av3b
        a8fSvDsJWs2NkdYM=; b=KuHqfahTbCF3F4fA6HS+cDJkbuTlruLKcEpFARDMDPT
        e1hAYR8dlVe6j1pCjtu46DXDKMEPtcbZvmCdP3ydqyxnBOLZcIWT7VHOLHcCehVL
        ahia96hVrNH9P6mtotQA4PdI4Pd1dPa+bKVuysFRB3r368MU9wHbI1pfVKRwqBr2
        a8oMhfRhJ9KsbUiwYctiWpgtsAM/TNy85AQE4kHCyjv4QamB1oi7qtAF1LHbCIk5
        X6SCjYa8rgQZ/tElYhVFy5A5UZvBJNRw8TbKPEn3Kzuk3701sw0gT3AgB3nQMgLV
        F3HgPN3dSaYbUdaHrnHdTabBoO4BKOpxsloBW91xoBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IwQWOy
        +Iu2IfRMziDhxspW5Av3ba8fSvDsJWs2NkdYM=; b=mM7Wpqsuh5b9Q/6FETD8LW
        HqqXz/y7LCJuYsTHUhrGcek+74loIaO9Ywoe/EMXBr6N7i3Fv1aw3ssQ58PAGG5U
        1rmtF1fxV43bk0H5p5tfsxGOvlee1vF1zZPYIg5zTdGiy3SpYWm+1O7zJaZU5HG7
        zoeEWREYy0muKw1w+oYgkAyHnagcnBy0ISk3ML40/+1EFQrED7ATJQixIVRra79K
        XrM0esBzKItrKIiI6pNyi2UOH1Fk0I+Ls9X347AuE8siMIZPjAzlAVTfDdAN61i0
        nqxm41y9IqKzOXmlifhi2AvGO0sgfd6JVrq1ha6rEzeFyvF+Z+SQXtrxK3KkbfXQ
        ==
X-ME-Sender: <xms:yLk7XkbyEIQJvJCBsNoRskpW7hWM8P0jhPMxHk9jGNDrrRGPtd0e8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrhedvgddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepvddufedruddvfedrheekrd
    duudegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:yLk7XjPgHslzl2fdTpzcMDNZVM1-cpF88mZ6PxKfD4LQ_sYk0GT6KQ>
    <xmx:yLk7XoCn5JoZ2TAjK0lkS-4W3gpKewsAJpzQc8VEtJfjoIrrbhgcqA>
    <xmx:yLk7XiKtsj9oCBnPGsu8XVgi15L4JryLN05srFvuvv9wVogMuhtS3g>
    <xmx:yLk7XrVREy4LuCbupxhrzvC3mNt7jXzSGsiUgDhwW3pm-gezbP6QzA>
Received: from localhost (unknown [213.123.58.114])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D62C3280063;
        Thu,  6 Feb 2020 02:01:28 -0500 (EST)
Date:   Thu, 6 Feb 2020 07:01:27 +0000
From:   Greg KH <greg@kroah.com>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] ASoC: qcom: Fix of-node refcount unbalance to
 link->codec_of_node
Message-ID: <20200206070127.GA3264238@kroah.com>
References: <20200206033611.10593-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206033611.10593-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 12:36:11PM +0900, Nobuhiro Iwamatsu wrote:
> [ This is a fix specific to 4.4.y and 4.9.y stable trees;
>   4.14.y and older are not affected ]
> 
> The of-node refcount fixes were made in commit 8d1667200850 ("ASoC: qcom: 
> Fix of-node refcount unbalance in apq8016_sbc_parse_of()"), but not enough
> in 4.4.y and 4.9.y. The modification of link->codec_of_node is missing.
> This fixes of-node refcount unbalance to link->codec_of_node.
> 
> Fixes: 8d1667200850 ("ASoC: qcom: Fix of-node refcount unbalance in apq8016_sbc_parse_of()")
> Cc: Patrick Lai <plai@codeaurora.org>
> Cc: Banajit Goswami <bgoswami@codeaurora.org>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>

Now queued up, thanks.

greg k-h
