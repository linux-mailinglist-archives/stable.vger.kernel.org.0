Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5684BB6FC
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 11:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbiBRKhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 05:37:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiBRKhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 05:37:16 -0500
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EA2636A;
        Fri, 18 Feb 2022 02:36:59 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 94CA758034C;
        Fri, 18 Feb 2022 05:36:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 18 Feb 2022 05:36:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=2M482WJpspdP0M9aq+xDp/jCcE8RYRfd8264dt
        8riP0=; b=pigrYCz/nRvqvfe3fn19OseG2VmEVoVNogADzCWeFbHJqntvb9npCN
        Q2juAq5pDEkV+W2wyIE6fWSwISWwbB44m808ZnExf8LPwGaFFRQqU9xXdPEJqxuV
        +xZZKM7SsGUo1TyyWV0Np+Z7oq+FKExfu65Fc6uOBNz+h7s63Ye0HrSL1u5abnRi
        IGss5nnvD85rWMCHJtTgu3QyStCrkR8VBBGH6Ske+1dks3PIeekkQOM2QMLwxWdh
        h4QsAA4jEE49U/CnBe0nxCEX3xSEAGk8A/OL7JARVtpjlWKFbce81tzc2ftWxp4g
        maogHgZj4KJF1RyPAtMF9s47SqcRjvCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2M482WJpspdP0M9aq
        +xDp/jCcE8RYRfd8264dt8riP0=; b=W0/nDAEyRIqKnn+7YBCSBL+ZXoeoATo7h
        sBNlDhh9KHGE+k0rQK+HQqhWKIUk9kLs9cJTznqnsLRD/NNtbCgdQuR2TJ1tvo32
        jkNMtjnQw/pWWVWRoirccy6adtRhajb6pBrhw9p5Hmw8eW3+QZt+u0fTmtrOvYMh
        8vDoRkk2lE0CFzlrDbUQGPvc08hbRXAsbQcOxcT1XadIsZYrFozeRPFAfZFWF0CS
        qY05qXRBJIEPvCUV+BuxRTZ++0KJMZkaGdmE4z8w08et9BW33QVz8y+FBpaD3LrJ
        W1O/vu0yWBEKlas4JEibZr5PnVgcVG1jwZktq2zZhUk4UnyC2EJcg==
X-ME-Sender: <xms:yXYPYvw_79xaQ7rDh3VIqHE71u3E7mRt7vx2IQPIHZGWB9yA_PV1FA>
    <xme:yXYPYnTCoNFV_DAxPNjzayacJEhBaTR6wzBliNqGDpCtlYMcNIeadLIsBr0pLpKKi
    8WLhh7AYMNZ2Q>
X-ME-Received: <xmr:yXYPYpVbd4I1R7O9FSXCHf0Eu1C9149bR2uKY0pAYJV1OUPA8ULtuCgaLaow9vrGcwhrov0CiYhLEzvcUB4T_Tm2laiYNxJj>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkedtgdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:yXYPYphIWbHTxQjunp15iTygx62D3INsbUT7uL-XAnRrceBl4IsGbw>
    <xmx:yXYPYhA9oLLODIdQFs37gAqSNCTQ5UkfBY9FJy-oPkD13f4EGhtgSA>
    <xmx:yXYPYiL8vLAdomspPXXOgAe2ZUlP5h3Ekemau84jPazqxsq-vSwnvg>
    <xmx:yXYPYpbuPee_aQnaNDj5SosxVM50PdH0JxnJryNvfN6Ufjjh8tJmiQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Feb 2022 05:36:56 -0500 (EST)
Date:   Fri, 18 Feb 2022 11:36:46 +0100
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Su Yue <l@damenly.su>, David Sterba <dsterba@suse.com>,
        clm@fb.com, josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 16/27] btrfs: tree-checker: check item_size
 for dev_item
Message-ID: <Yg92voqmS9jz/rI+@kroah.com>
References: <20220209184103.47635-1-sashal@kernel.org>
 <20220209184103.47635-16-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209184103.47635-16-sashal@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 09, 2022 at 01:40:52PM -0500, Sasha Levin wrote:
> From: Su Yue <l@damenly.su>
> 
> [ Upstream commit ea1d1ca4025ac6c075709f549f9aa036b5b6597d ]
> 
> Check item size before accessing the device item to avoid out of bound
> access, similar to inode_item check.
> 
> Signed-off-by: Su Yue <l@damenly.su>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/btrfs/tree-checker.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index d4a3a56726aa8..4a5ee516845f7 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -947,6 +947,7 @@ static int check_dev_item(struct extent_buffer *leaf,
>  			  struct btrfs_key *key, int slot)
>  {
>  	struct btrfs_dev_item *ditem;
> +	const u32 item_size = btrfs_item_size(leaf, slot);
>  
>  	if (key->objectid != BTRFS_DEV_ITEMS_OBJECTID) {
>  		dev_item_err(leaf, slot,
> @@ -954,6 +955,13 @@ static int check_dev_item(struct extent_buffer *leaf,
>  			     key->objectid, BTRFS_DEV_ITEMS_OBJECTID);
>  		return -EUCLEAN;
>  	}
> +
> +	if (unlikely(item_size != sizeof(*ditem))) {
> +		dev_item_err(leaf, slot, "invalid item size: has %u expect %zu",
> +			     item_size, sizeof(*ditem));
> +		return -EUCLEAN;
> +	}
> +
>  	ditem = btrfs_item_ptr(leaf, slot, struct btrfs_dev_item);
>  	if (btrfs_device_id(leaf, ditem) != key->offset) {
>  		dev_item_err(leaf, slot,
> -- 
> 2.34.1
> 

This adds a build warning, showing that the backport is not correct, so
I'll go drop this :(

thanks,

greg k-h
