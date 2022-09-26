Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448CA5E9A60
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 09:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiIZHYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 03:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbiIZHYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 03:24:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF1B27B22;
        Mon, 26 Sep 2022 00:24:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C53A617BB;
        Mon, 26 Sep 2022 07:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B24CC433D6;
        Mon, 26 Sep 2022 07:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664177054;
        bh=iUARz4K4vsYG5ypEUw84VdL7hWCKORVwp5RyqMqkGY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NIcJ1nIQkE/9a4YGaIQhNQpWpy728Ssj42mgZgODhQgtJbfhjTbSnPpFJp6okdhih
         q+C4wlBXlGsOAm7g6/ZmDCdeN35T2CzhxQU+aFmEXYdW2/+47yXrZwGMMxB/JHlqM/
         DXDgl/oIIBm19rqmd30+fowuXZLdjyWf42tI3KLQ=
Date:   Mon, 26 Sep 2022 09:24:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dragos-Marian Panait <dragos.panait@windriver.com>
Cc:     stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Frank =?iso-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.14 0/1] media: em28xx: initialize refcount before
 kref_get
Message-ID: <YzFTnKWtlPUehoU6@kroah.com>
References: <20220926071128.140602-1-dragos.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926071128.140602-1-dragos.panait@windriver.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 10:11:27AM +0300, Dragos-Marian Panait wrote:
> The following commit is needed to fix CVE-2022-3239:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c08eadca1bdfa099e20a32f8fa4b52b2f672236d
> 
> Dongliang Mu (1):
>   media: em28xx: initialize refcount before kref_get
> 
>  drivers/media/usb/em28xx/em28xx-cards.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> base-commit: 4edbf74132a4c9b78dc2ee61d31abef15200a781
> -- 
> 2.37.3
> 

Now queued up, thanks.

greg k-h
