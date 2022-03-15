Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51924D9783
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 10:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243406AbiCOJVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 05:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346455AbiCOJVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 05:21:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC171400E;
        Tue, 15 Mar 2022 02:19:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 164C46090B;
        Tue, 15 Mar 2022 09:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCCCC340E8;
        Tue, 15 Mar 2022 09:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647335996;
        bh=yx4yKHI6S3rMox+AKlamTaN5wGH6v4x0aRGSX8dAd9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YFmXzpE6Dg4so/0Fj03uDbmAQRlZIB7L4fUS7YjSM+IhUvwI+a3O7mGoaInn4sS/S
         hAx8d8dmedHqxxc1rJ0OZRahJIGXVqCciMYzinbTlExB+y7tCO5DMTovxB79s7rljG
         qV8TFUpBcnXTW49RrrbL34cQNo/V3a4k1P8FOQoY=
Date:   Tue, 15 Mar 2022 10:19:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jasowang@redhat.com
Subject: Re: [PATCH 5.15 015/110] vhost: fix hung thread due to erroneous
 iotlb entries
Message-ID: <YjBaOClDdNQkxtM8@kroah.com>
References: <20220314112743.029192918@linuxfoundation.org>
 <20220314112743.460512435@linuxfoundation.org>
 <Yi9p8xsrWV+GD9c3@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yi9p8xsrWV+GD9c3@anirudhrb.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 09:44:43PM +0530, Anirudh Rayabharam wrote:
> Mon, Mar 14, 2022 at 12:53:17PM +0100, Greg Kroah-Hartman wrote:
> > From: Anirudh Rayabharam <mail@anirudhrb.com>
> > 
> > [ Upstream commit e2ae38cf3d91837a493cb2093c87700ff3cbe667 ]
> 
> This breaks batching of IOTLB messages. [1] fixes it but hasn't landed in
> Linus' tree yet.
> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?h=linux-next&id=95932ab2ea07b79cdb33121e2f40ccda9e6a73b5

Why is this tree not in linux-next?  I don't see this commit there, so
how can it get to Linus properly?

thanks,

greg k-h
