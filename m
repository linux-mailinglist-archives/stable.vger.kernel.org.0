Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A409B4E89B0
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 21:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbiC0T0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 15:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiC0T0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 15:26:44 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE17DE01A;
        Sun, 27 Mar 2022 12:25:04 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 3548632007F9;
        Sun, 27 Mar 2022 15:25:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 27 Mar 2022 15:25:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=animalcreek.com;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; bh=HasCxMsdY3sivfE+or7HaqLHWRxJki
        KaDq90gjx6H0I=; b=ZwSnWxl7jcXn+641XqZnpD50/fvaMMcghJQPvJRTbQBNfU
        O0MSCiv+v/rcHhWvisrThtgpx21yhl3U4ELo7k4DborSnolwubmJOe0SuAR7O/dO
        jFACICVJC0BOVU81OPDmdpndQIGtiIm2si2jlOicj5DrCmnIPbgJVywsr4t9s7M7
        Rjj2/eoB1Ub1y3Xcpg+FQeFhd8XoYhfS5FNFDM/5OHjMIyBurSfS5BNl/q0ECRCN
        FY7dSziiJ6CeX0rn22nfoBsQIIsdAXmcQcPzewPGnDHSRmO8LqkeJ9nKGCVA7Rgg
        A6LQx/9ozqCN/3fUZAp/P3YFKFLx0H+6RQHlp03w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=HasCxMsdY3sivfE+o
        r7HaqLHWRxJkiKaDq90gjx6H0I=; b=MkPhGsM2Vml+HKd9dRvlKVuef8E9l9AFp
        cHMcrX4GFxG2uCzX+X2bKcGN0CboclTtma3d5N0rarMuRXzLWchBOIlVsrrpI+Nl
        IiFIUrZUbltVNMfqFf2zNQYNWKAlvnToBmF9LSZWHDRf4hTweOjP4GqaA338OJzA
        vaGNasdxJfAKsAWiE3p1s2Eaz6ETPqcm4P9CbqAsxUiVKcpsOE1qCfCg9yarL5IC
        qToFtAa0Uaqi5rBDgb9kBxhhLBxljA1aUmZFADeW8K40DefpxU48RNGCLLCor42D
        QBpQlnDYBOaBwQc7PBqQ9V0mpRf6AHkzx8wlHVFNHunwg1ibHhS5A==
X-ME-Sender: <xms:DLpAYtS8N5HV83csVbkIJxskoA1GVhiNmoeckUMWpF_4sUsXc2N1Iw>
    <xme:DLpAYmz6xxssY5WnRJ_UdvkaR4iMljTmlqN1b8tpjCKhuZ2LTR88aLri8sLISSiKy
    ZlWhvZ-Pb3UCdAyuA>
X-ME-Received: <xmr:DLpAYi0AE_px8uFgwoATu6CYZ5l3oZD_j_XZ5petAqbq0S-_RmRBwQ5kjXykpaDVJXvned7xY6ken9CQvTI4Q6CCuqCLaqQB_9R4r2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudehhedgudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujghosehttdertddttddvnecuhfhrohhmpeforghr
    khcuifhrvggvrhcuoehmghhrvggvrhesrghnihhmrghltghrvggvkhdrtghomheqnecugg
    ftrfgrthhtvghrnhepieeugfdutdefiedtvdfftedufedvjeehgfevveefudfgjeffgeei
    teetjedufffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepmhhgrhgvvghrsegrnhhimhgrlhgtrhgvvghkrdgtohhm
X-ME-Proxy: <xmx:DLpAYlDtngA--QZXRI9WU3rDL_1X4zC1kZfO_fVoSOJCspAANzI0xw>
    <xmx:DLpAYmiv5G4dzgrvmqktEsmwWRq0wmcs4DryuBsJlfl-8XCaSsxAHw>
    <xmx:DLpAYpq7vBGR1fDr5IckjT40JfsEDZlZNsZM24tahOkVqzJroLRdCA>
    <xmx:DLpAYvVN5tBewVHAlS_VU89N3ejAmbOpo5NdGTLhQHBk5CTJAMZqQQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Mar 2022 15:25:00 -0400 (EDT)
Received: by blue.animalcreek.com (Postfix, from userid 1000)
        id 9EDD813601FE; Sun, 27 Mar 2022 12:24:59 -0700 (MST)
Date:   Sun, 27 Mar 2022 12:24:59 -0700
From:   Mark Greer <mgreer@animalcreek.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     vaibhav.sr@gmail.com, mgreer@animalcreek.com, johan@kernel.org,
        elder@kernel.org, gregkh@linuxfoundation.org,
        greybus-dev@lists.linaro.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] greybus: audio_codec: fix three missing initializers for
 data
Message-ID: <20220327192459.GA220029@animalcreek.com>
References: <20220327060120.4316-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220327060120.4316-1-xiam0nd.tong@gmail.com>
Organization: Animal Creek Technologies, Inc.
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 27, 2022 at 02:01:20PM +0800, Xiaomeng Tong wrote:
> These three bugs are here:
> 	struct gbaudio_data_connection *data;
> 
> If the list '&codec->module_list' is empty then the 'data' will
> keep unchanged. However, the 'data' is not initialized and filled
> with trash value. As a result, if the value is not NULL, the check
> 'if (!data) {' will always be false and never exit expectly.
> 
> To fix these bug, just initialize 'data' with NULL.
> 
> Cc: stable@vger.kernel.org
> Fixes: 6dd67645f22cf ("greybus: audio: Use single codec driver registration")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  drivers/staging/greybus/audio_codec.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/greybus/audio_codec.c b/drivers/staging/greybus/audio_codec.c
> index b589cf6b1d03..939e05af4dcf 100644
> --- a/drivers/staging/greybus/audio_codec.c
> +++ b/drivers/staging/greybus/audio_codec.c
> @@ -397,7 +397,7 @@ static int gbcodec_hw_params(struct snd_pcm_substream *substream,
>  	u8 sig_bits, channels;
>  	u32 format, rate;
>  	struct gbaudio_module_info *module;
> -	struct gbaudio_data_connection *data;
> +	struct gbaudio_data_connection *data = NULL;
>  	struct gb_bundle *bundle;
>  	struct gbaudio_codec_info *codec = dev_get_drvdata(dai->dev);
>  	struct gbaudio_stream_params *params;
> @@ -498,7 +498,7 @@ static int gbcodec_prepare(struct snd_pcm_substream *substream,
>  {
>  	int ret;
>  	struct gbaudio_module_info *module;
> -	struct gbaudio_data_connection *data;
> +	struct gbaudio_data_connection *data = NULL;
>  	struct gb_bundle *bundle;
>  	struct gbaudio_codec_info *codec = dev_get_drvdata(dai->dev);
>  	struct gbaudio_stream_params *params;
> @@ -562,7 +562,7 @@ static int gbcodec_prepare(struct snd_pcm_substream *substream,
>  static int gbcodec_mute_stream(struct snd_soc_dai *dai, int mute, int stream)
>  {
>  	int ret;
> -	struct gbaudio_data_connection *data;
> +	struct gbaudio_data_connection *data = NULL;
>  	struct gbaudio_module_info *module;
>  	struct gb_bundle *bundle;
>  	struct gbaudio_codec_info *codec = dev_get_drvdata(dai->dev);
> -- 
> 2.17.1

Those changes appear to fix real bugs.  Thanks Xiaomeng.

Reviewed-by: Mark Greer <mgreer@animalcreek.com>
