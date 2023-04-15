Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F29F6E331E
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 20:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjDOSYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 14:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjDOSYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 14:24:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D4B44AE
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 11:24:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57EC460BC1
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 18:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E03C433D2;
        Sat, 15 Apr 2023 18:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681583051;
        bh=YF72SfoF2pTzrbXRltpXexbRMU/SGC3inSWNoNP0npw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2U1e5EcjDh1nVnWsiufxZSUgcSW0h0oOztc1dQ9mAdqWX0eA/rqFhUVEdjtU8xOUV
         ZmUiLM6TLXXBOba6iWUqESujkiMWhmk0BiF29An0b2yYHiY9HMbp104a/aW6zXWjwP
         dGVQEDnU5+kLyYrZUgQVqS76R6NcZ06GpbUo9Cgk=
Date:   Sat, 15 Apr 2023 20:24:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     stable@vger.kernel.org, linux-mtd <linux-mtd@lists.infradead.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        chengzhihao1 <chengzhihao1@huawei.com>,
        Nicolas Schichan <nschichan@freebox.fr>,
        George Kennedy <george.kennedy@oracle.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        yi zhang <yi.zhang@huawei.com>
Subject: Re: Request to pick "ubi: Fix failure attaching when vid_hdr offset
 equals to (sub)page size"
Message-ID: <2023041516-delegate-usual-5880@gregkh>
References: <ZDrmsnX5BHxtBNwf@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDrmsnX5BHxtBNwf@makrotopia.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 15, 2023 at 07:02:26PM +0100, Daniel Golle wrote:
> Hi,
> 
> please pick
> 
>  1e020e1b96afd ("ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size")
> 
> from linux-next to stable trees.

We need to have it hit Linus's tree first.  Any reason why it isn't
there yet?

thanks,

greg k-h
