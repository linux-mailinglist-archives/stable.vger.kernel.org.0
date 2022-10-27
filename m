Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4CB60F14D
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 09:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbiJ0Hmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 03:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbiJ0Hmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 03:42:39 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C595F138;
        Thu, 27 Oct 2022 00:42:37 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 0FB543200893;
        Thu, 27 Oct 2022 03:42:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 27 Oct 2022 03:42:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1666856552; x=1666942952; bh=TkFK/EKUIX
        lM4neSS5ApjH2yIOWWudfLztnHb/7W2EQ=; b=Y5hwI/vq7JMS2uABpMzEmXQb/D
        dHv2RYFYDmaG2PDVWfUa11uw8+UvxiixlvUhqGEf1lkTi4ZDYReTrmhSORnLqQkK
        jUldxszdqfwK4h0HjYAwvJZd9BXGVCpBPjlEMwCKJwg6IwIqr39l+QXXe7EcmSKB
        yheYeN9LWtnDfh6igDi0RcT+tdNOtjjAXjRmDK8zkQnhYCKynMtwftY5/supjvJR
        73qPxsEBauRPAXGpSBlLWlqW36dkA+X0XdDcf0+aNyv0QUesZRcvIGwfUiNbh+tw
        AI8iacfmaAeDEFBtNWOGysJb6uAV5O8xG4urBzzmyqRIvF9WMvGzB61M7cxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666856552; x=1666942952; bh=TkFK/EKUIXlM4neSS5ApjH2yIOWW
        udfLztnHb/7W2EQ=; b=MVxX5QAAt/jTXYozOC9N41C3IFzQcz5dQWkT9BV21cV4
        Qa2Er6L236ZIIVGS4XbIpjEBhWsW+zXYS7G5mHk5dVf7dGS5hOSITVI2Gz9/8WDS
        RgyN0rWiZ3HgtJSScFz+JtotxujqD5+BPO2F9AQbpb226RqHQliv8CfnSvWSybql
        5X8ItSD8J0eLdBHjlCaQ1UlEzBQM8QA5nbNDbdF+DpyrmRX4r36S19JHX1u1Ca5v
        bIREDLGqpdk+Y7ONQl2fHL0iJswEVeG046Jp5rpccfEvBVEG+TTsnnQTfqvs/R7d
        /9zb83xGLpSf27GReZhv2xOaEnEr0CHFgrfqy1xxgA==
X-ME-Sender: <xms:aDZaYyU56zTMq0vQOAeX8clQPVfLSfj5wWxW1sPQVmKg4x0BfhpIQg>
    <xme:aDZaY-mukOn0Mq1fDqgvXbIPa0oki-PufB7Vmgf5sgnyV724FyPY2KkcajBRLkPoF
    U1qKrM3w2REVw>
X-ME-Received: <xmr:aDZaY2Yn7LOsbq5j6UjZtX26N_eCJcooksuM9AaUYxtBXC7U1PHqA7CC0c3v0truIk7OCnd5i0qf4rE6l5QJ3EkFS0Rm47Ha>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdefgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:aDZaY5XW3dHhrdaKYcXYRvX1b0GnSEOZBCuojQVcFsdhGljcfT9-kA>
    <xmx:aDZaY8n_3e1sHTjeqxEQERcIUDUySZx6e22_DJy5ANUxs18dUOjlWg>
    <xmx:aDZaY-cah1fYyBYk5FmGUu5mvkIpXM89vSVqLCw2GsU2vzEEnOAVWA>
    <xmx:aDZaY261K9m8oUm8IhtF4iQEOcDdWM-AHJswEtejUXBAKZ4AqSaI9g>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Oct 2022 03:42:31 -0400 (EDT)
Date:   Thu, 27 Oct 2022 09:42:28 +0200
From:   Greg KH <greg@kroah.com>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: Patch "mmc: core: Support zeroout using TRIM for eMMC" has been
 added to the 5.15-stable tree
Message-ID: <Y1o2ZGe222FIv70a@kroah.com>
References: <20221027015309.384916-1-sashal@kernel.org>
 <Y1owQYlr+vfxEmS8@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1owQYlr+vfxEmS8@axis.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 09:16:17AM +0200, Vincent Whitchurch wrote:
> On Thu, Oct 27, 2022 at 03:53:08AM +0200, Sasha Levin wrote:
> > This is a note to let you know that I've just added the patch titled
> >     mmc: core: Support zeroout using TRIM for eMMC
> > 
> > to the 5.15-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      mmc-core-support-zeroout-using-trim-for-emmc.patch
> > and it can be found in the queue-5.15 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> > commit d3cc702e4a9f80cf1ae41399593d843d4c509e08
> > Author: Vincent Whitchurch <vincent.whitchurch@axis.com>
> > Date:   Fri Apr 29 17:21:18 2022 +0200
> > 
> >     mmc: core: Support zeroout using TRIM for eMMC
> >     
> >     [ Upstream commit f7b6fc327327698924ef3afa0c3e87a5b7466af3 ]
> >     
> >     If an eMMC card supports TRIM and indicates that it erases to zeros, we can
> >     use it to support hardware offloading of REQ_OP_WRITE_ZEROES, so let's add
> >     support for this.
> >     
> >     Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> >     Reviewed-by: Avri Altman <Avri.Altman@wdc.com>
> >     Link: https://lore.kernel.org/r/20220429152118.3617303-1-vincent.whitchurch@axis.com
> >     Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> >     Stable-dep-of: 07d2872bf4c8 ("mmc: core: Add SD card quirk for broken discard")
> >     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This patch is not stable material, please do not backport it.

Ok, now dropped, along with the commit that this was required for.

thanks,

greg k-h
