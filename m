Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF0394E8CC
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 15:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfFUNUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 09:20:44 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49577 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbfFUNUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 09:20:44 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7D3722216E;
        Fri, 21 Jun 2019 09:20:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 21 Jun 2019 09:20:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=gFw1o09izVXNlusSWNvyOBEz+mi
        9KMY//ltxGghUQDs=; b=Q91/YEztYMQm+78z6+GuAJhJDmqw+tXZBjrhE+jxpfn
        3cftDN0EpiiS+qcFQbr3HhGo0bBuVKMgr16D/wtXgfCxymtENYSy/oYUN1hzx2Cv
        NCW3ytNe5upBVEYAmBfOlKf6p0ZdPwBep0clkMlXenSQ6PkNJ+pkikHxW8EUIrL6
        9HyE/lwuDeJrv2O4JUSbG3pTdajqSYQ6z/ep5EDytQISkbM1dw7uRWtqNBGiAMU2
        rEaNOFI/uvx+q5wbsXCUZTR5vlXmbDkrnLHVKZqfUsclLBMRGdbN7dthty2JUu+W
        2DbWj7x/Md2FZnOBgBbB3QVdfgam1BUEzrLW8cYdffA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gFw1o0
        9izVXNlusSWNvyOBEz+mi9KMY//ltxGghUQDs=; b=iuKedUAq3P0LQXAoJa0CCq
        RiNqsR928oqFfNkHKrl4zoquMx1KwMkF+A2fxSbksGvbHNWcy2ztrSyzu1FZMy84
        sOddy4tXLYHKNQ/rlnSrnO85qMfyF5h1AdRH2/XkaUHpaDoJUItIcuvgBOqG9jbc
        /DWjljeOYvJw9IlpPyeBh8ADITm5LuMva65gUHuSw0V8EsgMZYPtCobmX3dXYRsf
        AhwHphbO2oj/Hp2FdfjW0DdUDnzmGaqmFq49d83sW7o0EMe0occrdXNLhJO5jgmY
        93j58hDUvcoPWOn90Ce5EIqgODBrGoY4XWEaFxwUvQaq6I2gljnjnvJfYZSaUoew
        ==
X-ME-Sender: <xms:qtkMXTCq3f9ydvMFnhF1M-fgENTm0o_zMCZMShgYB-y2ABSAprekZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtdeigdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:qtkMXV2DM14tMs85e_MtZ2mQOgsvFU7U6Dx6itGu_nYW96RJy17Mgw>
    <xmx:qtkMXRWGrzLnPIk-ZtbFyfIdCliUDILKhQCodUWgHO2kTkB4EJZNwQ>
    <xmx:qtkMXXmUIvFqa35EwyPVA25vxxRtRx9JrZ8fXYRNb0jARIYY71GqVg>
    <xmx:q9kMXbRNbVbh-jluUxvGRnZ18b5O315JSCnAG4RL2ZF7r5cl-1Ab-A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 897C980060;
        Fri, 21 Jun 2019 09:20:42 -0400 (EDT)
Date:   Fri, 21 Jun 2019 15:20:40 +0200
From:   Greg KH <greg@kroah.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ASoC: core: Adapt for debugfs API change
Message-ID: <20190621132040.GA10459@kroah.com>
References: <20190621113357.8264-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621113357.8264-1-broonie@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 21, 2019 at 12:33:56PM +0100, Mark Brown wrote:
> Back in ff9fb72bc07705c (debugfs: return error values, not NULL) the
> debugfs APIs were changed to return error pointers rather than NULL
> pointers on error, breaking the error checking in ASoC. Update the
> code to use IS_ERR() and log the codes that are returned as part of
> the error messages.
> 
> Fixes: ff9fb72bc07705c (debugfs: return error values, not NULL)
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  sound/soc/soc-core.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
> index c510da2d4af6..6d5c09493f4b 100644
> --- a/sound/soc/soc-core.c
> +++ b/sound/soc/soc-core.c
> @@ -165,9 +165,10 @@ static void soc_init_component_debugfs(struct snd_soc_component *component)
>  				component->card->debugfs_card_root);
>  	}
>  
> -	if (!component->debugfs_root) {
> +	if (IS_ERR(component->debugfs_root)) {
>  		dev_warn(component->dev,
> -			"ASoC: Failed to create component debugfs directory\n");
> +			"ASoC: Failed to create component debugfs directory: %ld\n",
> +			PTR_ERR(component->debugfs_root));

Why warn on this?  You will _never_ see this message :)

>  		return;
>  	}
>  
> @@ -219,18 +220,21 @@ static void soc_init_card_debugfs(struct snd_soc_card *card)
>  
>  	card->debugfs_card_root = debugfs_create_dir(card->name,
>  						     snd_soc_debugfs_root);
> -	if (!card->debugfs_card_root) {
> +	if (IS_ERR(card->debugfs_card_root)) {
>  		dev_warn(card->dev,
> -			 "ASoC: Failed to create card debugfs directory\n");
> +			 "ASoC: Failed to create card debugfs directory: %ld\n",
> +			 PTR_ERR(card->debugfs_card_root));
> +		card->debugfs_card_root = NULL;

Same here.

And keep card->debugfs_card_root to be the error pointer, that way no
further files are created for that directory.

thanks,

greg k-h
