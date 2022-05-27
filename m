Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23CE65365BB
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 18:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240468AbiE0QI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 12:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349586AbiE0QI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 12:08:56 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C1F149AA0
        for <stable@vger.kernel.org>; Fri, 27 May 2022 09:08:55 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 845425C0160;
        Fri, 27 May 2022 12:08:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 27 May 2022 12:08:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1653667733; x=1653754133; bh=+LG5GA3lAZ
        eElUCc4Ayvw2qVrlFAamKWOzRGaAyF2qQ=; b=OGCcoUpQXTcsXjA46Ui3jCq8Ze
        P7QwmW6ckLROfayTMCj3raccWDwLugDVfQzp5pohHQcg1LP/bz0R7iTwoAux/SG7
        sdrpSXp63UuaricUnoaGRdIf63t4FhUd1nVZvafU0mNRoFrnU3jQemkeidOMJ4NA
        RbFdsRcFpek4d4bn4CSVskW0vNx7Cdod5KepS1Cbux2DSNzgIYfGrzJhpu5fCB0G
        aEMpGGgN5as81njZ3gVYv3MW5+yd4Xo83etal+m3iJmMQd5GjpbzdQrOEsIr8xR7
        3YNUx7CGzF9Ebx7iEqIGzSLX3mEW27UAnop8/ik1nZJS+FkYeoBcxUxP27UQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1653667733; x=1653754133; bh=+LG5GA3lAZeElUCc4Ayvw2qVrlFA
        amKWOzRGaAyF2qQ=; b=FK2KKw5lIdu/HmWwoFa/JikTQJeSF1MBYJrcEr+8BFuK
        7t6vSzjEzTJMTH1snSmUHETPqGf1NZ4xUFdmt7eFgNMPH2SSsTBBycY71t3yYCZa
        /BHLAkFwnLh4CMwI3D4/lIJL9trroW4FfMUZT+kGnAfRnYMyjKx3+A1Po4kOeCAS
        tsN5kcLtFodQ17pnkqNsipG4g1eJ7kXfvRWh9fi7OlK5wYq4kDYbSHljGTXPMXY1
        50jXHZAqCIYrTtrHz7lpMh1ySCd4WpRKxEHFQxTiJMt1t3lEUX+s4uT+E7zTiHYW
        vBDSEun9EgWq6NAMBTc2fhUdVIOSHGSc1uQ7PUiYTA==
X-ME-Sender: <xms:lfeQYqR75Z-9l_IXM1Fgy9pyT272qkvry8afDsOtNHwSVql1W1I-1g>
    <xme:lfeQYvwY8bzmme2FibNLG0NAs6jZaCLdFKJl39gQLAQM0Pwj4cMyqkll0dRe0OyOs
    dxyIl7sX6M9Qg>
X-ME-Received: <xmr:lfeQYn1jypYRNCA7sibXIIyS3kLbMNZ4JqZB19yCet0g_Ap7y5c5aG6YbA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrjeelgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:lfeQYmAWrmu74P7elR6mSu2393Lm_P_7fs9xC3vhJDONjajFrXN0PA>
    <xmx:lfeQYjiL_V0pYC5A06AbBzrgw6eXTb3tfDR81IN_G1vlKhPA0sBA8w>
    <xmx:lfeQYiozjzj5UtMgQdFvlC2arWFc4NUUlHe4ThSu3XqysW7UmDHJ1w>
    <xmx:lfeQYjcK7UBhMkZTLAzwlZoOXSDHfLf_hwlJMm2TAwPm844iXCwm2w>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 May 2022 12:08:52 -0400 (EDT)
Date:   Fri, 27 May 2022 18:08:51 +0200
From:   Greg KH <greg@kroah.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     stable@vger.kernel.org,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: Re: [PATCH 4.19] cfg80211: set custom regdomain after wiphy
 registration
Message-ID: <YpD3k0yXx6d7So7W@kroah.com>
References: <20220527091151.45581-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527091151.45581-1-johannes@sipsolutions.net>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 27, 2022 at 11:11:51AM +0200, Johannes Berg wrote:
> From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
> 
> commit 1b7b3ac8ff3317cdcf07a1c413de9bdb68019c2b upstream.
> 
> We used to set regulatory info before the registration of
> the device and then the regulatory info didn't get set, because
> the device isn't registered so there isn't a device to set the
> regulatory info for. So set the regulatory info after the device
> registration.
> Call reg_process_self_managed_hints() once again after the device
> registration because it does nothing before it.
> 
> Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Link: https://lore.kernel.org/r/iwlwifi.20210618133832.c96eadcffe80.I86799c2c866b5610b4cf91115c21d8ceb525c5aa@changeid
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/core.c | 7 ++++---
>  net/wireless/reg.c  | 1 +
>  2 files changed, 5 insertions(+), 3 deletions(-)

What about versions for 5.4.y and 5.10.y as well?  We can't just fix an
issue in an older kernel tree and ignore it in newer ones, right?

thanks,

greg k-h
