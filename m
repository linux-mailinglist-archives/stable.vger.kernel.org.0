Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1A667DE99
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 08:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjA0Hgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 02:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjA0Hgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 02:36:42 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4145663877;
        Thu, 26 Jan 2023 23:36:41 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 1D2AE3200B6B;
        Fri, 27 Jan 2023 02:36:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 27 Jan 2023 02:36:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1674804999; x=1674891399; bh=rETtIYYD4R
        iqaRot0MHTUxsTJNC1XKTMshNgkOW45e8=; b=fkbpeKFT/GO6rOGyn3qkOTZLte
        dwG29w41vg/8NsNeA0HMf2uWGSUooKhLOTU+LAzPgbPt/GquLQw9iMsnAJGmbudO
        Ej54MEXYStdOiliGmubxyijyxW0eCuMWhKfJzER9FE1bJE+zxAsDmR8ft5Y2LQYp
        EbukhPWq4KcRmdubFXvaiV6MnBRWmQDeMBzWuO+IuS+rt1lHIzRPfxlKK+cPzVjZ
        Ro4aVDF3ZRTanF39IvsS0iSWqDbYIhsRMOAynqrGsIm7ad5th59y6Kt61BnQtk68
        WztdPg7vKKtuGEHPETPfdUBTWW8bEow7MBS15EzzKKbWoRBHsaKkcOS/yY4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674804999; x=1674891399; bh=rETtIYYD4RiqaRot0MHTUxsTJNC1
        XKTMshNgkOW45e8=; b=Y2X1FmM3xtEa24mJYoYPZ6muZEaOgeqQGYh+s+WkVDlf
        ftVVGQFj+nlqxYOV40xpW1uuGfVr9PCF6RC+6u77jK1x9/aE20QAslLqeFBxtbe8
        A9uxbGl/s7fvclswpJKeWHgsNNFX9Yl4JqhoYX/cChOfgUTAmAbVbatAlkshQpHr
        WlpMBQxgALGwdP1dJuqWrsIoxk4sN4O6N8AYMSj+j/8rCc4WiS95DD94Co7AR/9G
        +BM4/43VdChvyLbfMo6lVtM49bU8FRdxIxtngNeFRW2m6p/w6XY/ktRzB/j2hNn4
        OqGpwUDf0okE+tPzfLlAz079nyvtcUcE5YuE9jcTwQ==
X-ME-Sender: <xms:B3_TY75mjwt4dXWkb1aNpU_mT8RDOzUKuhk6Mtq7reaa2L6eb5pmlg>
    <xme:B3_TYw6Pe4XISm7v8zKzwWs8sX8RXTw2b6O1kAuV3Plvv6Y4vPRiDTRpPFmmm5s9R
    zp9iq-DKwZCxA>
X-ME-Received: <xmr:B3_TYyfVatR0nt6imwWFHz5qwQoN_4vSfJlWjyvS9vSOGQD-6qSFRKOM5992PBb94U34FP-o_4anTlXKCyLG8oIlEAIUnrQB0iRWHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvhedgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeghe
    euhefgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhm
    rghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:B3_TY8I31QM50VxB3qihoh53IOVihcw64aOQt8udLpQlSSI4KrYeGw>
    <xmx:B3_TY_LN_BC47yggh4PW49lRyJH6QiKPbn5rnobKiMBA7Pr78qwuHA>
    <xmx:B3_TY1y4qZQKpLDBJVwy7BfwkKi0uY1ghY1KcyCNl_asu9iJUJziRg>
    <xmx:B3_TY3_3u4d2JDSvtBfpP9b9wIC4jGcURWiRsOjhuP2fURbZSgRzcA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Jan 2023 02:36:38 -0500 (EST)
Date:   Fri, 27 Jan 2023 08:36:37 +0100
From:   Greg KH <greg@kroah.com>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        stable@vger.kernel.org
Subject: Re: [stable v6.1 2/2] wifi: mac80211: Fix iTXQ AMPDU fragmentation
 handling
Message-ID: <Y9N/BQpu/2xC1v1t@kroah.com>
References: <20230121223330.389255-1-alexander@wetzel-home.de>
 <20230121223330.389255-2-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230121223330.389255-2-alexander@wetzel-home.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 21, 2023 at 11:33:30PM +0100, Alexander Wetzel wrote:
> This is a backport of 'commit 592234e941f1 ("wifi: mac80211: Fix iTXQ
> AMPDU fragmentation handling")' from linux 6.2.
> 
> mac80211 must not enable aggregation wile transmitting a fragmented
> MPDU. Enforce that for mac80211 internal TX queues (iTXQs).
> 
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20230106223141.98696-1-alexander@wetzel-home.de
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> ---
>  net/mac80211/agg-tx.c |  2 --
>  net/mac80211/ht.c     | 37 +++++++++++++++++++++++++++++++++++++
>  net/mac80211/tx.c     | 13 +++++++------
>  3 files changed, 44 insertions(+), 8 deletions(-)

This backport fails to apply to the 6.1.y tree:

Applying patch wifi-mac80211-fix-itxq-ampdu-fragmentation-handling.patch
patching file net/mac80211/agg-tx.c
patching file net/mac80211/ht.c
patching file net/mac80211/tx.c
Hunk #2 FAILED at 3726.
Hunk #3 FAILED at 3739.
Hunk #4 succeeded at 3744 (offset -7 lines).
Hunk #5 succeeded at 3797 (offset -7 lines).
2 out of 5 hunks FAILED -- rejects in file net/mac80211/tx.c


Try again?

thanks,

greg k-h
