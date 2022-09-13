Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF635B77B8
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbiIMRVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbiIMRUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:20:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB3799B7F
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 09:07:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F6B7B80EFA
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 16:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B85C433C1;
        Tue, 13 Sep 2022 16:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663085235;
        bh=NxeEHkz6ULQjBKTvgfsYkrqBfDp0ENRRSwJHL9fbTaM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=shsExA4MRDVtwjoCX6yQaB51B7TIWFwvh3e5JSxcHYN0NCttsNx6Uf8viBusIIHHO
         dV4jSP4vzwso77aby83FUqZ72/PBNtTOC5sUYUCUOI5IGlcAuMcwwwU5SCOHWaLri3
         TKapz1FbDF++CadJJclL8afO9Z0fTiTHVjeOT0BI=
Date:   Tue, 13 Sep 2022 18:07:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.19 000/192] 5.19.9-rc1 review
Message-ID: <YyCqyoa6C4dVIuDD@kroah.com>
References: <20220913140410.043243217@linuxfoundation.org>
 <3f43e609-ac83-f1e0-e991-5e7870bd1e6f@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f43e609-ac83-f1e0-e991-5e7870bd1e6f@applied-asynchrony.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 05:20:04PM +0200, Holger Hoffstätte wrote:
> On 2022-09-13 16:01, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.19.9 release.
> > There are 192 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.9-rc1.gz
> 
> 404: no popcorn
> 
> Some of the others are available, some are not. Mirrors acting up again?

Nope, my fault, sorry, new laptop, had to add another perl dependency
that I had missed.  I'll go upload them all again...

thanks,

greg k-h
