Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC4E6BBB8A
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 18:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbjCOR6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 13:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbjCOR6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 13:58:07 -0400
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7850311D1
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 10:58:00 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 82BDF582166;
        Wed, 15 Mar 2023 13:57:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 15 Mar 2023 13:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1678903078; x=1678910278; bh=sr5VBwSlqkYKlrOEPGOlyRiFVAY5hrqp8Fq
        xt+ATTUw=; b=sOsASEdO+ZXgxCTqzuntK95Lm+6jLimXxV3hy0lCHZqFivl1QlG
        FlwO1oSPzp9Kr9+qhk3ZZ5/TSqqAjuhVlYK7MW2tKz/EH40CRYPDaFpmm3Hk66eT
        zXdrn/YwylprLX7YpDWcYG92IXcVMLhIsB37B4FUiqUpyVnvHoYWTyKAYght+QPQ
        olfEyplMIoHBP8Ak7XWEF8J+j/jCHP61vdVCZJxBp8X2aGiAwJebqZ9HH3zMSH3g
        5zy6amoSPfXlYSXXIcotKn2uzlhl8D7nOgf22p9EVSQmnZCKxAkyiKolT1D/6eyM
        bcRzH6W9kcMEUEbb3pAZV8315QX5bJU2Akw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1678903078; x=1678910278; bh=sr5VBwSlqkYKlrOEPGOlyRiFVAY5hrqp8Fq
        xt+ATTUw=; b=lt2NdHkQ84eidOxHihp18H6i9ZZribXpCsykNYUZqXmraIp0HTf
        1DDK+pfy8asT9QBY6Bupy8m9Z/S+ONmcFCDVTh1K3FZfYMcVgODUHMRGkXUNhgFL
        n7HKH12dWg5t/iSU7aqMHoQdGvruOxamZNoHI/w7A0HnCuxSjro4IVvJ7NvKfXzB
        lanaEChtvOj/p0H/pOCosIkgHo0PHOD0twQCZWcOaRYDTZs7Ip9wxPQ3+S8K5O3R
        sGX27MnK49126p2JCPoOwVq7q12F5CyxNycIJ0/zbwSyedYwHdt1Taz0WrCH3xSB
        MsyE6xIJr2MRZ93NMd7K9Ttk7LVcBAyyEkA==
X-ME-Sender: <xms:JQcSZGOkkdUG7-SpqOBtu4-VABj3s2OlAXRCydvu6MZJFay7zeRzFg>
    <xme:JQcSZE8M7nWVtmihUpXj5E1beZBqHjIjZmCCTOjXDU2rJt7BD4H1Ycd7WoTDn2Sed
    BQdwPe5PUY12A>
X-ME-Received: <xmr:JQcSZNSPnueiYL92hmwV_sea6RWoANBxCSJriBeur-dLskV4WeLwr5vx_XrANegTOJ9iPfwwTiBJw1T18RNdkTTFpEyuMnNZEjj7Qg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvkedguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhr
    vghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepge
    evleehjedtgfethfetveetheejtdeugeekgeevleetkeehvefghfdtueegteeknecuffho
    mhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:JgcSZGshD8gmxxzJS-5VeH0SLcI9zmNx6kXhdtrfYWb1SOu0jcEj3A>
    <xmx:JgcSZOcgX5tOai488cVg3SuTtdbHL43N2mQdD0YyMMwmUDZaI3GeJg>
    <xmx:JgcSZK0o68Z3UCdHJ3OZfb9FhGHlYphP_FapKR9CsAefCA7iUY8qlg>
    <xmx:JgcSZM_KoRld3MoO6Yk-eG9Ajzx8Ya9yF_jffPPrXcwLjJxt33ygyg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Mar 2023 13:57:57 -0400 (EDT)
Date:   Wed, 15 Mar 2023 18:57:56 +0100
From:   Greg KH <greg@kroah.com>
To:     John Harrison <john.c.harrison@intel.com>
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
Message-ID: <ZBIHJD5FkxiammjB@kroah.com>
References: <167820543971229@kroah.com>
 <20230314022211.1393031-1-John.C.Harrison@Intel.com>
 <ZBF48kVhFmXIsR+K@kroah.com>
 <a5cf5572-4160-3efb-4f80-aaf53aa06efe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a5cf5572-4160-3efb-4f80-aaf53aa06efe@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 10:07:53AM -0700, John Harrison wrote:
> On 3/15/2023 00:51, Greg KH wrote:
> > On Mon, Mar 13, 2023 at 07:22:11PM -0700, John.C.Harrison@Intel.com wrote:
> > > From: John Harrison <John.C.Harrison@Intel.com>
> > > 
> > > Direction from hardware is that ring buffers should never be mapped
> > > via the BAR on systems with LLC. There are too many caching pitfalls
> > > due to the way BAR accesses are routed. So it is safest to just not
> > > use it.
> > > 
> > > Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
> > > Fixes: 9d80841ea4c9 ("drm/i915: Allow ringbuffers to be bound anywhere")
> > > Cc: Chris Wilson <chris@chris-wilson.co.uk>
> > > Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> > > Cc: Jani Nikula <jani.nikula@linux.intel.com>
> > > Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > > Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> > > Cc: intel-gfx@lists.freedesktop.org
> > > Cc: <stable@vger.kernel.org> # v4.9+
> > > Tested-by: Jouni Högander <jouni.hogander@intel.com>
> > > Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
> > > Link: https://patchwork.freedesktop.org/patch/msgid/20230216011101.1909009-3-John.C.Harrison@Intel.com
> > > (cherry picked from commit 65c08339db1ada87afd6cfe7db8e60bb4851d919)
> > > Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> > > (cherry picked from commit 85636167e3206c3fbd52254fc432991cc4e90194)
> > > Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
> > > ---
> > >   drivers/gpu/drm/i915/gt/intel_ringbuffer.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > Also queued up for 5.10.y, you forgot that one :)
> I'm still working through the backlog of them.
> 
> Note that these patches must all be applied as a pair. The 'don't use
> stolen' can be applied in isolation but won't totally fix the problem.
> However, applying 'don't use BAR mappings' without applying the stolen patch
> first will results in problems such as the failure to boot that was recently
> reported and resulted in a revert in one of the trees.

I do not understand, you only submitted 1 patch here, what is the
"pair"?
