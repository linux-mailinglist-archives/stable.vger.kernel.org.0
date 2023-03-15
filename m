Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4134A6BAA47
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 09:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjCOIBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 04:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjCOIBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 04:01:22 -0400
X-Greylist: delayed 543 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Mar 2023 01:00:51 PDT
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49C7769D2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 01:00:51 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailnew.nyi.internal (Postfix) with ESMTP id B77E8581D4B;
        Wed, 15 Mar 2023 03:51:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 15 Mar 2023 03:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1678866677; x=1678873877; bh=aNNQwQzVCna7Ns3n6BIaF6xnV4h5OB3sXJx
        Eet6WtvI=; b=AoX0YRtx60/GyCP5Pl5C/3NEAIrDfj6bVizZsn+iolVqge4yWWq
        3ly8MZ1OepeqQpI1D11wYodztO4Pk/bukfJuj72xH5loKvfG6GM9kR2QN6tnBVem
        UYv5uo4eABD+teMpY6x6ZRLw+V1aCZToFAbGndPQE9aDnwqJm3vAp8IXPfx0wrUP
        TrKsH2fLXCtzbURBMsf2+ffnv00YBDm2unZJ92Kq2Ov5p2ZOJWdocrOzyaQNipmf
        CSjH+i56xnuT3wV2CcjaDdJ0+TeF2bplcQTACgi2Uv+y7UpqQ2UE0YBI8lSynK5g
        GanOwJSFGIZahM9Jx1KxTkwnu9Rj785Qe7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1678866677; x=1678873877; bh=aNNQwQzVCna7Ns3n6BIaF6xnV4h5OB3sXJx
        Eet6WtvI=; b=e4+sFXbrYfNrq6Md3CAaUb2PMMRL1BkxB/dBHXE8GvzTfOngDQZ
        MjQXj2w+xhNaypZh4CxSi2SOFxw0XsmcVXrBq/0PRihnGnsJ9MoPvoadfmYl3LVj
        KrvogBkdfg+o3cCE/lthP8+Xb4ryXUAOU7qq65cb3RUM9PN06ofNPPcZI6cNalXg
        syiYce7tdSduPq66/2uOwp1kJBxLGeeA9jU75XBh2BRv7sZuGz1jSKncvgq5cOej
        7Caad7oS+1ZExNu9o6Do+4Mx/RcmBQNNWgJ3qkuF/DjLiH3hB1mMw43rns58NtPJ
        hbtQlV0omJtvEn7z3rr01cbSIgVA30LLDcg==
X-ME-Sender: <xms:9XgRZMKtJ-4oUMtaqFIgifUHkyjJAOKRPPpEQrQVIAnBq00LAThz-g>
    <xme:9XgRZMJjz7_SH7I0Oe0R0lK2VrelxMH5EltcHhIGvG5WaPFJ9N9rDpIoTmXy9TlUk
    MrKoHpDo2SYZg>
X-ME-Received: <xmr:9XgRZMsdJinBK9ycCAMqAoynT1Abt707Vz7mzpALRqtU5Fg_XAvtBCX11_4vtILANiFErgEFF1LBL94f3Ir0KAXWQdwbG1hySdGyVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvjedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhr
    vghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepge
    evleehjedtgfethfetveetheejtdeugeekgeevleetkeehvefghfdtueegteeknecuffho
    mhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:9XgRZJZ9BoqNsCIyjg5o3OsRmy3UhDDy173YN7pwk9V9AmhGN-971A>
    <xmx:9XgRZDYBJLCuvpZhgh1I5iXmjKkcNiKpcPsW8_jr0D9_6lV2tqRQcg>
    <xmx:9XgRZFCkGcu8y2N9E-OFeKSpSsox9fC2LnQhw0JwIZJdpOuKKEcaXQ>
    <xmx:9XgRZNZGkAhjP33C3wk_SE8g33GP8FQpz0b2ieWDTqt2MNAz8QIqnQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Mar 2023 03:51:16 -0400 (EDT)
Date:   Wed, 15 Mar 2023 08:51:14 +0100
From:   Greg KH <greg@kroah.com>
To:     John.C.Harrison@intel.com
Cc:     stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org,
        Jouni =?iso-8859-1?Q?H=F6gander?= <jouni.hogander@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH 5.4.y] drm/i915: Don't use BAR mappings for ring buffers
 with LLC
Message-ID: <ZBF48kVhFmXIsR+K@kroah.com>
References: <167820543971229@kroah.com>
 <20230314022211.1393031-1-John.C.Harrison@Intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230314022211.1393031-1-John.C.Harrison@Intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 13, 2023 at 07:22:11PM -0700, John.C.Harrison@Intel.com wrote:
> From: John Harrison <John.C.Harrison@Intel.com>
> 
> Direction from hardware is that ring buffers should never be mapped
> via the BAR on systems with LLC. There are too many caching pitfalls
> due to the way BAR accesses are routed. So it is safest to just not
> use it.
> 
> Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
> Fixes: 9d80841ea4c9 ("drm/i915: Allow ringbuffers to be bound anywhere")
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v4.9+
> Tested-by: Jouni Högander <jouni.hogander@intel.com>
> Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20230216011101.1909009-3-John.C.Harrison@Intel.com
> (cherry picked from commit 65c08339db1ada87afd6cfe7db8e60bb4851d919)
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> (cherry picked from commit 85636167e3206c3fbd52254fc432991cc4e90194)
> Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
> ---
>  drivers/gpu/drm/i915/gt/intel_ringbuffer.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Also queued up for 5.10.y, you forgot that one :)

thanks,

greg k-h
