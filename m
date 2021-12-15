Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4276A475A2E
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 15:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbhLOOAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 09:00:40 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:43919 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230310AbhLOOAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 09:00:39 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id DD606320091B;
        Wed, 15 Dec 2021 09:00:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 15 Dec 2021 09:00:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=sV5o3T5HROcwm2zR5BnWYul3YIL
        mRQft/kreh5EUEtI=; b=dUfER0JUsdX2UtSBZEO2JXJV06mfEdV4jfmT6MM2yQj
        el+q1sYb8jtJ4cS6DEEbppvgttBCQ2G4AIBZ7xSFSfvjkfrk8KGvra6rfwzQEW/e
        MWo5i+tawkYGjl8aMNu2cgh03as7t0g+jcBtgx4Lgq6BDu1llu596nS9pki5oiR0
        0Iu9SZbUgQBOqPuzSjPyMXZPsZ5CqhfiT9lYq4cgze1cWWEG/aZz/TYYDkX5Tiou
        gU9+uJE/jGkJOkFIR2EeC07fKINHvU7AYPZnRzSlaKIVukCC1Lkfx8afizfkvKKz
        tIj7nEpkmBjK7rSe3VtO0Zk7sNiq9jmLW3t4oy900rg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=sV5o3T
        5HROcwm2zR5BnWYul3YILmRQft/kreh5EUEtI=; b=jMSG738XxGIQHOeatgWBrn
        v/rrqyU8PqasDByqfp3LGRViIL+aiHvrb6vQmxkEYiqJDyjmoLs5E3Ic6BWu6F7Z
        Gyf8aP3ubVdqMjETwWHgpazMMxsolhmmImritzGzPWlVFe1ZZ3YRTQFE4Jlhkgml
        UIyb9ImVuZkwcc+s3RvC2CiOc3k5AXoehRhiDiIcOQ/6AA+uDNEJ0iXx3JLAf6uT
        0+dKfWw4SFy+sW2g592jiAexwNEPj4IT0CuqMlgHYQRF/jSsMhMeQgkrqJfrsuMi
        YG5+A8ZQnwcBUqqyyxvR6Tmef4Ikw2tsQyj28+6YE/FzWvtT35lMKksJGWkErPyA
        ==
X-ME-Sender: <xms:BvW5YWjOin_Vd3Lk767B6BYWgcV0VOzK-6TPEwMGA8QcPSKZszd1rQ>
    <xme:BvW5YXBuYcNezyaY2Lu8FfWeUSzdvnDJ3TQXGlINNRKQTmnkxKRtfdAZTDvVAWpvq
    JfYABFu7ecOcQ>
X-ME-Received: <xmr:BvW5YeH9VKBm2IeYS_hNGgqTHz8-pbGZ4BNZomejsKLPTTi7N00IO0gBvk1hb5QpuDq6aMdJuT1cXmU0RrtXdoB0te95CbRs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrledvgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:BvW5YfSqlw46U38l8jNVkZecmhG6fYuop39UKqkzV-hMeVD0urXD3g>
    <xmx:BvW5YTzGXuf12KLEuYe-U-zffCc1qeINiQfZuGCNiIc54kulbL3EaA>
    <xmx:BvW5Yd7rqvF_hL5nJBFwLUomftcRUunVpgFJC4VJsP60ujqivreX2Q>
    <xmx:BvW5Ye_ezVdYAxLigBU8CJ97KEC3HH175uzvbGNqu5bWtR3fbaTnUA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Dec 2021 09:00:37 -0500 (EST)
Date:   Wed, 15 Dec 2021 15:00:36 +0100
From:   Greg KH <greg@kroah.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/8] perf intel_pt: Fixes for v5.10
Message-ID: <Ybn1BCaTb5fVwTeS@kroah.com>
References: <20211213154548.122728-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213154548.122728-1-adrian.hunter@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 05:45:40PM +0200, Adrian Hunter wrote:
> Here are some fixes backported to v5.10.
> 
> Adrian Hunter (8):
>       perf inject: Fix itrace space allowed for new attributes
>       perf intel-pt: Fix some PGE (packet generation enable/control flow packets) usage
>       perf intel-pt: Fix sync state when a PSB (synchronization) packet is found
>       perf intel-pt: Fix intel_pt_fup_event() assumptions about setting state type
>       perf intel-pt: Fix state setting when receiving overflow (OVF) packet
>       perf intel-pt: Fix next 'err' value, walking trace
>       perf intel-pt: Fix missing 'instruction' events with 'q' option
>       perf intel-pt: Fix error timestamp setting on the decoder error path
> 
>  tools/perf/builtin-inject.c                        |  2 +-
>  .../perf/util/intel-pt-decoder/intel-pt-decoder.c  | 83 ++++++++++++++--------
>  tools/perf/util/intel-pt.c                         |  1 +
>  3 files changed, 56 insertions(+), 30 deletions(-)

All now queued up, thanks.

greg k-h
