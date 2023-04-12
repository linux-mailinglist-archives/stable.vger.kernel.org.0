Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC52D6DED10
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 09:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjDLH5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 03:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDLH5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 03:57:42 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CD11BDA
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 00:57:41 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id DA53F3200950;
        Wed, 12 Apr 2023 03:57:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 12 Apr 2023 03:57:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1681286257; x=1681372657; bh=WmkHcZRTGtB6jkXxSxv2JVs8qUDKxOapllo
        cf5kvOV0=; b=QtzUh+Pmyt8iXQnqEbPjJRR0n5CyudwuRpdlbuugImC3iZwtzEb
        x4Frg50shpXF+PtYFUCwpaYCZdQDBcggEkZq0hJlz5EHepmYxS31JDtcZGOX9Ow/
        X2N4UNLs9PTvf033njTY0vbWkTWZaRv7WAvauX8lyHpr40PwU2krjDOsROYpg63A
        /1upTuvYaC7Epv+uhPX0kcmTC3HFjB8TXLGBClF8Vi4qxSfRrsNhW8DvBHVq6lhE
        CCRujvdlsBVU7EAz2uQZVX9yJc91bLzuG5lDdSWHQ2cYfpkC3xz0QpcGLQk4aOER
        T+7OoEnW2zgpt1eiT58reNfvdLFkUCyqAkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1681286257; x=1681372657; bh=WmkHcZRTGtB6jkXxSxv2JVs8qUDKxOapllo
        cf5kvOV0=; b=OAIwRyia6VW9cYfjmTsMB/8iBvMtxayI+SrtWdW7bubVducGnjL
        bO4YEAAtjJJdobpf/0NXVttaBqf5hgN8wPB94mJwq30a/8gS5YrfrQpuA274rk2A
        LLYH767pB18yU1PaI9Ntv1Bu9P1Ino0Fs/RvwdS3x/i91WAbqoIt1NGm7TieIcXR
        kVUBLAKsD8uc1mIqWZDqgjQGyooVKco8BnxdMXwOPuMtGhFwAPuj948J/XVzSEMp
        pI6cSi6x7B5G1q43ewasiYuv6Gz44guYgzRHbEPtj8vU0HKVHoq1Tt4Ar7VhV48c
        Mb0plSZG4P+odpAzPyVNlxWLRJQonofp5rg==
X-ME-Sender: <xms:cWQ2ZJyrvGSmBI06qeHq9PDqknWFx3gIVGdbj0_XxZ2BO-xAEP09uA>
    <xme:cWQ2ZJRVSSqAdvpTENBDh7OMZOjtDjfSQrucMBleo5vfICe7udVc-NPYXAj8UhMB2
    xkr8FlHgvA10A>
X-ME-Received: <xmr:cWQ2ZDXA7BeM8KgDBFBvf2VuEStQhbyl4liTJVJrOYNQlH-hHwLoco869mExJesy09a8xZOjIpVg2pL7heMD1PVIDudOD0-A_e1Tcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdekhedguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhr
    vghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepge
    evleehjedtgfethfetveetheejtdeugeekgeevleetkeehvefghfdtueegteeknecuffho
    mhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:cWQ2ZLjgPFDLhO3Hj-S6YqZhAISMgWTRLjSEBj_p8PBFW8m3p4HwVA>
    <xmx:cWQ2ZLDCtNFeCrsaDhlT92ZeugqFSW8-hTj3G0wlLziV8h8nU0nQ3g>
    <xmx:cWQ2ZEKhB0x6e9naslAk_GolkghDb7U3mGvn0HwEOhle527ncrSgEg>
    <xmx:cWQ2ZP5gkXAzKj8QbG0r2yS-E6xEgydlRyOF2pGm0bEPh1V011dp0Q>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Apr 2023 03:57:36 -0400 (EDT)
Date:   Wed, 12 Apr 2023 09:57:33 +0200
From:   Greg KH <greg@kroah.com>
To:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     stable@vger.kernel.org, Manasi Navare <navaremanasi@google.com>,
        Drew Davenport <ddavenport@chromium.org>,
        Imre Deak <imre.deak@intel.com>,
        Jouni =?iso-8859-1?Q?H=F6gander?= <jouni.hogander@intel.com>
Subject: Re: [PATCH 2/3] drm/i915: Add a .color_post_update() hook
Message-ID: <2023041254-wok-shine-8aaf@gregkh>
References: <20230403162618.18469-2-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230403162618.18469-2-ville.syrjala@linux.intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 07:26:17PM +0300, Ville Syrjälä wrote:
> We're going to need stuff after the color management
> register latching has happened. Add a corresponding hook.
> 
> (cherry picked from commit 3962ca4e080a525fc9eae87aa6b2286f1fae351d)
> (cherry picked from commit c880f855d1e240a956dcfce884269bad92fc849c)
> 
> Cc: <stable@vger.kernel.org> #v5.19+
> Cc: <stable@vger.kernel.org> # 52a90349f2ed: drm/i915: Introduce intel_crtc_needs_fastset()
> Cc: <stable@vger.kernel.org> # 925ac8bc33bf: drm/i915: Remove some local 'mode_changed' bools
> Cc: <stable@vger.kernel.org> # f5e674e92e95: drm/i915: Introduce intel_crtc_needs_color_update()
> Cc: <stable@vger.kernel.org> # 4c35e5d11900: drm/i915: Activate DRRS after state readout
> Cc: Manasi Navare <navaremanasi@google.com>
> Cc: Drew Davenport <ddavenport@chromium.org>
> Cc: Imre Deak <imre.deak@intel.com>
> Cc: Jouni Högander <jouni.hogander@intel.com>
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20230320095438.17328-4-ville.syrjala@linux.intel.com
> Reviewed-by: Imre Deak <imre.deak@intel.com>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_color.c   | 13 +++++++++++++
>  drivers/gpu/drm/i915/display/intel_color.h   |  1 +
>  drivers/gpu/drm/i915/display/intel_display.c |  3 +++
>  3 files changed, 17 insertions(+)

This patch fails to apply:

checking file drivers/gpu/drm/i915/display/intel_color.c
checking file drivers/gpu/drm/i915/display/intel_color.h
Hunk #1 succeeded at 16 (offset -2 lines).
checking file drivers/gpu/drm/i915/display/intel_display.c
Hunk #1 FAILED at 1252.
1 out of 1 hunk FAILED

Can you rebase this, and 3/3, against the next 6.1.y release (which
contains other patches for this driver) and resend just the two missing
patches?

thanks,

greg k-h
