Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADAF660E3F6
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 17:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJZPBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 11:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbiJZPBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 11:01:06 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206D919C04
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 08:01:02 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id D52573200708;
        Wed, 26 Oct 2022 11:00:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 26 Oct 2022 11:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1666796458; x=1666882858; bh=R8SdYytk0Y
        AxsYDoG27dR+UZtI0e2P7IhwxUIVR0jco=; b=qaQGIiGWZcH/qyNAUaDFyVic73
        aLY70JB2MS8fzHfoAx+OiTWSefwcmZgy3EQkugFtCXpySKZt3kFOqaMK0YkXSbOz
        Ncsar8oikbCVPxMqEKJjI91EF0/S+EbDV7+X9PKvmzKb8S1WVNZft8WhL6+1geB3
        vEaodwPvUZR+QvC4Qya7eq01Pw70P1/Q9jcN6aOzM8lPtsjMxetcXl4jR0cBws8e
        Lxz3AJtqULvTEwRfGLO7OuTifgth4rHXb2ZL0gP0b4OzPs8aHKgVyRhHo0Wo0jOP
        kBrudCzTyp3FWd/p5lkMYfLXeLmGeXeLg9MXnXtLshk12fubE1iu44/KHThw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666796458; x=1666882858; bh=R8SdYytk0YAxsYDoG27dR+UZtI0e
        2P7IhwxUIVR0jco=; b=dXYc7kNCd7K49HRkhn41lB/waimnHZyns0K+QZHg/OW8
        YAgIIoURlsvgho3Wpr4AlMjmj4D6+CwReQajKpFC8VvispC5ORyxAKJabwCXINJ9
        hRbLH6/2AatC86tddu1Nt7oqxqSYk8eA+z0634cK/f5sPoDsg5mkkh//VBkLp4AB
        EYRaIrk8NN50JiD+CDmO0Ye7fOC4pyhO+8BcYpxQubYM77LPxkVTkesF/0ylkZjQ
        b1Kxl4y880+/3e+5U/Z9cvw4wZMgV93vvm1WLzo7dVTwEZXOosqWP61RBEkh/u7x
        vsugHJRUpUQgv2DQkUNmzH/lzCSm2gWe5AN547I3FQ==
X-ME-Sender: <xms:qktZYwRREunmMm7j7J0IXQtpL7m1X7a6j8wYpEkBjIrwcx9QnbJcsQ>
    <xme:qktZY9wyPCEWstqugxsw7Mdjh3jYcanXSM-__9vVAQcsgQc-DbqT8wM1E5S4NtGE3
    OM76jeYwCqHig>
X-ME-Received: <xmr:qktZY92ng96TxedgpyVXN59OmL1qCnoTShFS4dFHCJZjRCugMaws1iuaYkknn7JpIC5hDTtjrItoSogINRd-YDzAWqY22Tj2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtddvgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:qktZY0BzfrGFx1GBf5iyMO5hkDH_GkHAGd1_FXTHfPyPZdlO6raDGg>
    <xmx:qktZY5hWpikN4OctGvRL_2G1ZRyA6n2l69XRZuZb-KXWOWDJfkonOg>
    <xmx:qktZYwoLplKyO1UkD10tPdnico-oz0_zts-i6r6Ak0ddrRJuNPr98A>
    <xmx:qktZY5cg8XcuNGraPzIu1YHl6WwBv1J59F7kNdLi8k_I4M0SdASwQA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Oct 2022 11:00:57 -0400 (EDT)
Date:   Wed, 26 Oct 2022 17:00:56 +0200
From:   Greg KH <greg@kroah.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5.15] perf/x86/intel/pt: Relax address filter validation
Message-ID: <Y1lLqBySUDuUj28b@kroah.com>
References: <20221026120709.3866-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026120709.3866-1-adrian.hunter@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 03:07:09PM +0300, Adrian Hunter wrote:
> commit c243cecb58e3905baeace8827201c14df8481e2a upstream
> 
> The requirement for 64-bit address filters is that they are canonical
> addresses. In other respects any address range is allowed which would
> include user space addresses.
> 
> That can be useful for tracing virtual machine guests because address
> filtering can be used to advantage in place of current privilege level
> (CPL) filtering.
> 
> Now for stable because a side effect is that this also fixes
> address filter validation for addresses in kernel modules.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: https://lore.kernel.org/r/20220131072453.2839535-2-adrian.hunter@intel.com
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  arch/x86/events/intel/pt.c | 63 ++++++++++++++++++++++++++++++--------
>  1 file changed, 50 insertions(+), 13 deletions(-)

Now queued up, thanks.

greg k-h
