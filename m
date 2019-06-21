Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760B74E8DD
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 15:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfFUNWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 09:22:25 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39099 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbfFUNWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 09:22:25 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D157522114;
        Fri, 21 Jun 2019 09:22:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 21 Jun 2019 09:22:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=j2yp05g5qDYVNwtcnROr99uPzOS
        RalFOaQ4HvtAIMIA=; b=EG56U/jbXzULxT28b/phGRsCWHmuR1ZdgKId0cAwd20
        Y7ov5N/XHnG6Fb3ZUucSeN1HF0xG7Rt277e8nQ0XQLfN3vVfxqtjbs2ahRuaWNJl
        MBWTCDSnqGISwjrgM3l+qo0MkFn/0/l+NQJy9rxYXQq9HQZZU1ptzGHyYo7Bx/le
        NZBG9uKvuacp0uaSjiLb3LjLZo6ZQe1cqzo3W9cSfd2YgLvry0nGP6okz2iYKslv
        ZnbtY5TCSXRiYueZQE4jXVFvDqyWDzf4Q/KEELeFD/vF1qzgIUaCujBTrQ8h9h44
        XiJ1p4xkkLMidQM6Y+rp+rBUh2qu5bQTS1ZWFwK5ROw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=j2yp05
        g5qDYVNwtcnROr99uPzOSRalFOaQ4HvtAIMIA=; b=GHUSNjtjqsEm6lqCXDNlUh
        k3l6jiYurctCnFxopabUQyHaCx5qsY5WdKDueK2l9OGrbFT2KTDRnHutRREHNfd1
        OOfMHmW/bX8Q711uuoY3Yq1gsK2xOPCjq4bIOkZjwags3zKwC/KOvSHM2V7hoSoP
        /iJ52OL+16OJOdEWGwt25dLKx08E6q01EqczOkKhZp4FJFg/SmyQSGkxFBgCEw+s
        Kk6/gBIhelZD3K6j4GAes8887dwDFrPYkVdJwNkd3vNwX7Cg5UFPL0pWQluyMsKU
        gCR/4kxd2rd4gUAx1rk8xhozTcIRvlLbweZxX/jS1FFFxOF5pwP2Wx68tI3/076A
        ==
X-ME-Sender: <xms:ENoMXX09UFveOIfAKVS5RVZk8Uz2_iesQJoi_qZhBYgoZMTp09uEdg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtdeigdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:ENoMXRCb1JwPzzG-77Cbsp_VlCbYBh-q-VhisoTzA60qfLOgl3iXWA>
    <xmx:ENoMXW7cnqpFU1EmC41lwptpqfbmRQV0al6qc6GC1PUzefXluL72fQ>
    <xmx:ENoMXSKz5Pd_dHoOv3T1BAX5C0IGPiz_B2AYf-oNbHBuEMUeab3Eyg>
    <xmx:ENoMXaq1XSLf09y7XYjmf-SAbWq6Mf7h-CHzTHgxNWOFa5EPI6WM_g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F246B80063;
        Fri, 21 Jun 2019 09:22:23 -0400 (EDT)
Date:   Fri, 21 Jun 2019 15:22:22 +0200
From:   Greg KH <greg@kroah.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ASoC: dapm: Adapt for debugfs API change
Message-ID: <20190621132222.GB10459@kroah.com>
References: <20190621113357.8264-1-broonie@kernel.org>
 <20190621113357.8264-2-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621113357.8264-2-broonie@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 21, 2019 at 12:33:57PM +0100, Mark Brown wrote:
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
>  sound/soc/soc-dapm.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
> index 6b44b4a78b8e..f013b24c050a 100644
> --- a/sound/soc/soc-dapm.c
> +++ b/sound/soc/soc-dapm.c
> @@ -2156,23 +2156,25 @@ void snd_soc_dapm_debugfs_init(struct snd_soc_dapm_context *dapm,
>  {
>  	struct dentry *d;
>  
> -	if (!parent)
> +	if (!parent || IS_ERR(parent))
>  		return;

How can parent be NULL?

>  
>  	dapm->debugfs_dapm = debugfs_create_dir("dapm", parent);
>  
> -	if (!dapm->debugfs_dapm) {
> +	if (IS_ERR(dapm->debugfs_dapm)) {
>  		dev_warn(dapm->dev,
> -		       "ASoC: Failed to create DAPM debugfs directory\n");
> +			 "ASoC: Failed to create DAPM debugfs directory %ld\n",
> +			 PTR_ERR(dapm->debugfs_dapm));

Same comment as before, no need to print anything.

>  		return;
>  	}
>  
>  	d = debugfs_create_file("bias_level", 0444,
>  				dapm->debugfs_dapm, dapm,
>  				&dapm_bias_fops);
> -	if (!d)
> +	if (IS_ERR(d))
>  		dev_warn(dapm->dev,
> -			 "ASoC: Failed to create bias level debugfs file\n");
> +			 "ASoC: Failed to create bias level debugfs file: %ld\n",
> +			 PTR_ERR(d));

Again, no need to warn, no one will see it :)

I am trying to make it so that debugfs doesn't return anything for when
a file is created.  Now if that will ever be possible or not, I don't
know, but I am pretty close in one of the branches in my driver-core
tree...

thanks,

greg k-h
