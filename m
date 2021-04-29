Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B29636F10E
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 22:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbhD2UbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 16:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234621AbhD2UbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 16:31:10 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FF5C06138B;
        Thu, 29 Apr 2021 13:30:19 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id l4so101789808ejc.10;
        Thu, 29 Apr 2021 13:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=OIk730EvbvFGRHoO6yMqeh9AReblTvmdaGxbR4h3GhY=;
        b=gw+Ba7LAD4c/2uZV2gWLmMKrztksAdAZX/t/jx/YtCYPTMuV/cNCIfov7qSl821JoT
         Rlco4GBJhK0uUrQVdmN+T6hGQ8G1bfo4jmH0Jv68jwIl6xV5IvkUi93FeLNQhqLQG3T3
         MQbjmeXeau7QVelXOuvmFOtS7qqNJ7av/4NB5R7OyYSSeDzN2ArR2mhdTpGKw7bW7E6X
         f3tO8pDr7BeRcgzmUgp9/gyEk3f9mZJQN6KVfZ/G/e3lpbLHlQOWHKvjM6yyknkXJ1NZ
         g6mhiR4wqM9jnKufsa4RTkGRNsnGXhVVw94ERANnywjMgwZ+PH/jAVFiC9ywxdoCgBBN
         QZ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=OIk730EvbvFGRHoO6yMqeh9AReblTvmdaGxbR4h3GhY=;
        b=WCQo7MJcelbfPLtzu4L3Y1QTEALw5To4/ZqIJosiaEuma1fkWLABqEeASU3yX4uDCI
         Wg/Jp8dkwUR0gGBWxxm3pczGWVFau0p1F1U509Vc+pHs1ynp6HiFtx3axU+VL5tshKxD
         uCi2tWEGfW5B8xNJl0EUlSQ5mS/dm+p40JtdNTfeL430l0+/M7xDsq809z+ap2TwXxPv
         fsExziwF1sDrFAkH552oVchJE3Z1Wxa6ih5IK5r9aBYX60rFsvJp0GLLOfikUCYHf8tl
         W1J1eN+lNOs+hw/GUiwfrxYCpeeI0kXFfvTzkp/YZd2zFvRShpDnCkmnUv2Y4i1su8YL
         SfMg==
X-Gm-Message-State: AOAM533ZC/dtkosBJp83K5ZI+r9Bec9bLzL19Yj/mxR/iBUWSPpKliIP
        qrvnRGhOKW33dkdS36YFEeY=
X-Google-Smtp-Source: ABdhPJzbpXYfaISf1Ln+2syhXmsv2TN/i7540aJihl9b/aMClGODWSMeb6iJHakSRLxlX/2R9QsC3Q==
X-Received: by 2002:a17:906:4a55:: with SMTP id a21mr317108ejv.215.1619728218547;
        Thu, 29 Apr 2021 13:30:18 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id x9sm3099123edv.22.2021.04.29.13.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 13:30:18 -0700 (PDT)
Message-ID: <9b7ecf8a74e7e04174181aed0c5f0e356d0ed280.camel@gmail.com>
Subject: Re: [PATCH v1 2/2] mmc: cavium: Remove redundant if-statement
 checkup
From:   Bean Huo <huobean@gmail.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     rric@kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "# 4.0+" <stable@vger.kernel.org>
Date:   Thu, 29 Apr 2021 22:30:17 +0200
In-Reply-To: <79ec60974875d4ac17589ea4575e36ec1204f881.camel@gmail.com>
References: <20210319121357.255176-1-huobean@gmail.com>
         <20210319121357.255176-3-huobean@gmail.com>
         <CAPDyKFrU591aeH5GyuuQW8tPeNc9wav=t8wqF1EdTBbCc9xheg@mail.gmail.com>
         <79ec60974875d4ac17589ea4575e36ec1204f881.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-03-19 at 16:42 +0100, Bean Huo wrote:
> On Fri, 2021-03-19 at 15:09 +0100, Ulf Hansson wrote:
> 
> > On Fri, 19 Mar 2021 at 13:14, Bean Huo <huobean@gmail.com> wrote:
> > > From: Bean Huo <beanhuo@micron.com>
> > > Currently, we have two ways to issue multiple-block read/write
> > > the
> > > command to the eMMC. One is by normal IO request path fs->block-
> > > > mmc.
> > > Another one is that we can issue multiple-block read/write
> > > through
> > > MMC ioctl interface. For the first path, mrq->stop, and mrq-
> > > >stop-
> > > > opcode
> > > will be initialized in mmc_blk_data_prep(). However, for the
> > > second
> > > IO
> > > path, mrq->stop is not initialized since it is a pre-defined
> > > multiple
> > > blocks read/write.
> > As a matter of fact this way is also supported for the regular
> > block
> > I/O path. To make the mmc block driver to use it, mmc host drivers
> > need to announce that it's supported by setting MMC_CAP_CMD23.
> > It looks like that is what your patch should be targeted towards,
> > can
> > you have a look at this instead?
> 
> 
> Hi Ulf,
> 
> Thanks for your comments. I will look at that as your suggestion.
> 
> The patch [1/2] is accepted, so I will just update this patch to
> 
> the next version.
> 
> 
> 
> Kind regards,
> 
> Bean


Hi Uffe,
Could you please firstly accept this patch? let the customer update
their kernel. As I tried to develop the next version of the patch
according to your suggestion, more changes will be involved. Also, no
matter how to make the change general, below mrq->stop checkup should
be deleted since it is obsolete. In the data transmission completion
interrupt, mrq->stop will be checked again.

-	if (!mrq->data || !mrq->data->sg || !mrq->data->sg_len ||
-	    !mrq->stop || mrq->stop->opcode != MMC_STOP_TRANSMISSION) {
+	if (!mrq->data || !mrq->data->sg || !mrq->data->sg_len) {


Kind regards
Bean

