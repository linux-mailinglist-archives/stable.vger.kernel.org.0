Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4EB60569F
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 07:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiJTFJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 01:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJTFJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 01:09:37 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AB027B04
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 22:09:35 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 27BD23200977;
        Thu, 20 Oct 2022 01:09:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 20 Oct 2022 01:09:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1666242573; x=1666328973; bh=3UTEu9OHSr
        Czw+bwZ7Og5Eej5L5MzKXpuM4DGmbhp9Q=; b=So3UMqzT5rIJxDA+oGsA6yvgG3
        e0ebtUlfFy1f0WjQM11HNfGOCJyyoXin5R7+5i8fbAT2oFPeCZNebnkucrQu3rmF
        x1FzuKzGyeigt7lXENKqdtmPuLGi7YdA+ZWEEUYccwY4Co6IVruDA6lGjcnUde57
        ABxWKVux6pKna9Rp5XupolbPnGVlFPN6U7mSQQYkYYVqjllHLb+JEmb3WEXUcDKC
        5KY7lUfEBCWOsWE7fn53yil980OdGgIng2P81c+90QFU9QQ8NdKnb4cgdhfRCZ2s
        kzjSukKFHNzyvhANRKX3q+yz1e4DBDiFDU9dwfQyejk38+KFF0LbReb33DIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666242573; x=1666328973; bh=3UTEu9OHSrCzw+bwZ7Og5Eej5L5M
        zKXpuM4DGmbhp9Q=; b=IG+YRfOyEgD1rBO/CsjeR8CdaWQTYXTGW4f2dT6TdNjJ
        aZibeTsjO4SwBO35Y1zLvrUjgzre3lByXTgigBiClg1vH+XLk0Vd5MQsE2B9ncdV
        kJWAlVrKOmNKXgnM+QaHrWHmilXngiJ8sVd56azct7Dpn5cy4XIQw5bCstFOgpfu
        3/3zY2nKkygrEl3ujfGRx2B77C8yW/iPsKdRqrxZ3Hp44Vxz/JKz3+IA/sGgQXr4
        5rDhKeegP81mV0b5IeRa+lowbLO1Hy+zi7fpXxMcC5iV31M2RtSrRI5qCMCSYwgX
        XQxJu5iihxcHbgxe92Uk2cwW9ebporQCCSkRJ9YJiA==
X-ME-Sender: <xms:DdhQY_gHeUvF3f8HNISRC7EjDS3vNbZi2tbEW_izQQPa-rfsqEzz-A>
    <xme:DdhQY8BQR5CBj628UWSi1bxes7OXda7v1LRAIOgVxPiJvr8kRrZcbwl5Q6xmdojSY
    1n6w2RZvNzOQQ>
X-ME-Received: <xmr:DdhQY_E5SmlPKyXw6PHlPI89HUYmc9KwnYB5ghllRhU1Xw4nqxSDwufKs55b88IDKfSn88Y0emveKsv00nlcjSS3q5tCGyGN>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeelhedgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:DdhQY8SduDFZPrtzK0dyBp6cfks_sq7IRzGLmW-1QKRuzViCpK4XPQ>
    <xmx:DdhQY8wITa6EYBrAffNvr0rOHmaAljB_KTGW-aRrMMltar3orv-tdw>
    <xmx:DdhQYy6jqvGgKChOtauXpI5hg3rBagX9vunqfL9zvSujMrMsF12TLQ>
    <xmx:DdhQY7mALykqL8yaw3bvOsOK7wTBYGBjkVLcrDD9V3C3OiZ-oK-kfA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Oct 2022 01:09:32 -0400 (EDT)
Date:   Thu, 20 Oct 2022 07:10:21 +0200
From:   Greg KH <greg@kroah.com>
To:     Slade Watkins <srw@sladewatkins.net>
Cc:     kernel test robot <lkp@intel.com>, Jiri Olsa <jolsa@kernel.org>,
        stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH stable 5.10 5/5] kbuild: Add skip_encoding_btf_enum64
 option to pahole
Message-ID: <Y1DYPbYZ39vMnh/I@kroah.com>
References: <20221019085604.1017583-6-jolsa@kernel.org>
 <Y1Cgp/TOmE8scCvJ@b995051e45c0>
 <CA+pv=HPV0iG0NDe6K=7hBa1sVh-cWZZ8XZTVCrHZPDq7A1Z_2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+pv=HPV0iG0NDe6K=7hBa1sVh-cWZZ8XZTVCrHZPDq7A1Z_2g@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 09:35:23PM -0400, Slade Watkins wrote:
> On Wed, Oct 19, 2022 at 9:14 PM kernel test robot <lkp@intel.com> wrote:
> >
> > Hi,
> >
> > Thanks for your patch.
> >
> > FYI: kernel test robot notices the stable kernel rule is not satisfied.
> >
> > Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
> > Subject: [PATCH stable 5.10 5/5] kbuild: Add skip_encoding_btf_enum64 option to pahole
> > Link: https://lore.kernel.org/stable/20221019085604.1017583-6-jolsa%40kernel.org
> 
> Uh, this should be fine though, right? The stable list was the primary
> recipient and all show up for me in my stable folder.

Yes, this is fine, this bot is not that smart at times.
