Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F2553CAB6
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 15:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiFCNfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 09:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiFCNfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 09:35:17 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629286324
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 06:35:14 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 9C0AA3200786;
        Fri,  3 Jun 2022 09:35:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 03 Jun 2022 09:35:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1654263310; x=1654349710; bh=czuzKFvG8S
        gmbDba3ODvPM6gtP8MGcfwCAIw+R+iMVc=; b=XK1z2q/Qfldq3lwN5yNrniItpR
        x7xCBHSYDO0mvTzZjB9MBxVXE0LNZDnUzRi3OQrB39YQAO82Mv5h3Yo0SQPVBwNa
        cD8dIZ0PnAv97MPnbLH/Ox65ezOILEm1EmuEbenLRylBFRT21wmj55/jaOiD4NVo
        iKjlv3dX66keC9gES5GEkwqfRNMWtXX3dXrftY8CtO5LdFhsFFobRAUqhM3P0x0C
        Syh8kdQRghdkFMwtgv0u8epwX3tCFf5ZNfny3zDtL8aP/+ZWNKRPlyGpd0tsK5Je
        A/86VaG6IKsoUNrdWH8ZP10aotoaA1dkgqBvcPzbHIlRUN6oZ4/1dhGsyFPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1654263310; x=1654349710; bh=czuzKFvG8SgmbDba3ODvPM6gtP8M
        GcfwCAIw+R+iMVc=; b=nqGfuyXnjxPLeerj+L2xEGUGRFUWZJiIv0HHIrY5tj5V
        0m94n4X54WWh3tCku1UU+6rTIES4VWjfvfIfdnMBC02zy6jc+wknQVR6NU+qgIV2
        UKxDg9DHvW4MyH1pF6yvISMoLrncIBNu59yVDftkzb6R7ktcXPSntl1e+IyGp2Zj
        QRTjAPKTkfeq/b12t46ZSRQFAJtleOu4uP2d+qEuZP+2c5YwfzMy4P7M66if5ZNU
        92/T+9n/TqrzrnaSoQVexkZQR5MBWmsYRfU5JFtVsnD4FjO3KA7XLEMi3fr03Y3J
        HNLf0uFH8vxxsg0uMAHEFdiZS7SfwoGBbmScnj7b5Q==
X-ME-Sender: <xms:DQ6aYl7qYL4QrXQsp40bWWKVJxhIg0FLcQTCFgFBJnw3iYototPO0A>
    <xme:DQ6aYi5acvwf4IcOa3RfmYe0Ngx-jsDF2femA8S0DrMTw9ssEXHq2iq78rbgsCQDp
    IQXV7qVN3A5zA>
X-ME-Received: <xmr:DQ6aYscRfjcjWFFG_3fwJJ9d2hHSysvAKmSk0Nkraq3_BXIeJCi0q_WJ_z71GFG5VLH7MlWe1587FSe9yD46a866Er-C3GR1>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrleeigdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:DQ6aYuLH_R4MlPKULpeIAApFNQpsgpNbY4OZUfjQDSe_MtKX0jDtcQ>
    <xmx:DQ6aYpLrPrBvZeK_KbEgtdBw3N84J7qXhRkP-4Sd4369HFk3LroCaQ>
    <xmx:DQ6aYnwV7tkocGTFEN3OiR-Cvx_D5KefH-ZP7Bn2wK0s1au0PGwWVA>
    <xmx:Dg6aYmGGHVG9HWyjfRVlJFeLnxiYoMc40MpcT7rVjqzNwAlyD1pYBA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jun 2022 09:35:09 -0400 (EDT)
Date:   Fri, 3 Jun 2022 15:35:06 +0200
From:   Greg KH <greg@kroah.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     stable@vger.kernel.org,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: Re: [PATCH 4.19] cfg80211: set custom regdomain after wiphy
 registration
Message-ID: <YpoOCocHULdcz+7B@kroah.com>
References: <20220527091151.45581-1-johannes@sipsolutions.net>
 <YpD3k0yXx6d7So7W@kroah.com>
 <a134637840677d99b83bf624c8e514f1d224948a.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a134637840677d99b83bf624c8e514f1d224948a.camel@sipsolutions.net>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 27, 2022 at 06:17:59PM +0200, Johannes Berg wrote:
> On Fri, 2022-05-27 at 18:08 +0200, Greg KH wrote:
> > On Fri, May 27, 2022 at 11:11:51AM +0200, Johannes Berg wrote:
> > > From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
> > > 
> > > commit 1b7b3ac8ff3317cdcf07a1c413de9bdb68019c2b upstream.
> > > 
> > > We used to set regulatory info before the registration of
> > > the device and then the regulatory info didn't get set, because
> > > the device isn't registered so there isn't a device to set the
> > > regulatory info for. So set the regulatory info after the device
> > > registration.
> > > Call reg_process_self_managed_hints() once again after the device
> > > registration because it does nothing before it.
> > > 
> > > Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
> > > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > > Link: https://lore.kernel.org/r/iwlwifi.20210618133832.c96eadcffe80.I86799c2c866b5610b4cf91115c21d8ceb525c5aa@changeid
> > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > > ---
> > >  net/wireless/core.c | 7 ++++---
> > >  net/wireless/reg.c  | 1 +
> > >  2 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > What about versions for 5.4.y and 5.10.y as well?  We can't just fix an
> > issue in an older kernel tree and ignore it in newer ones, right?
> > 
> 
> Huh, good point. I hadn't checked, people complained about it on 4.19.

All now queued up, thanks.

greg k-h
