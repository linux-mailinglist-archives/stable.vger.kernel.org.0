Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB624EBDA3
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 11:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244817AbiC3J2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 05:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244814AbiC3J2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 05:28:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B912264573
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 02:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0BEF61174
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 09:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EF2C340EE;
        Wed, 30 Mar 2022 09:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648632408;
        bh=zktZ869RSfU3sIWtqngttY+BaeJoa7luFETcfI8UnYo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UzhFsaEGU2PiFy82sEIdLuYXqIJb83gOeZlqbBA+bmKbn5YaMdF0Q+P7CmLqy4OyO
         ahytu9LEzU7YqKUV+R6QrtxlYqmAkdTDJj8ObecFlMKrVKRCLa1htL4nWmQ9YLdJz4
         VvsBfu32HPPcFjXzhOFn4802h4y75YZxbhL4B8Ms=
Date:   Wed, 30 Mar 2022 11:26:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Miles Chen <miles.chen@mediatek.com>
Cc:     stable@vger.kernel.org, yf.wang@mediatek.com
Subject: Re: suggest commit 5b61343b50 to stable
Message-ID: <YkQiVV0M6bnyI9zn@kroah.com>
References: <20220330082157.3444-1-miles.chen@mediatek.com>
 <YkQV0OjQOoGV/QBg@kroah.com>
 <c317f485cee7925f43881058b3bb546d71895b85.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c317f485cee7925f43881058b3bb546d71895b85.camel@mediatek.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 05:22:25PM +0800, Miles Chen wrote:
> On Wed, 2022-03-30 at 10:33 +0200, Greg KH wrote:
> > On Wed, Mar 30, 2022 at 04:21:57PM +0800, Miles Chen wrote:
> > > Hi reviewers,
> > > 
> > > I suggest to apply the following patch to stable kernel 5.4.y and
> > > 5.10.y:
> > > 
> > > commit: 5b61343b50590fb04a3f6be2cdc4868091757262
> > > Subject: iommu/iova: Improve 32-bit free space estimate
> > > kernel version to apply to: 5.4.y and 5.10.y
> > 
> > What about 5.15 and 5.16 and 5.17?  Why skip them?
> 
> Sorry for missing that, please add them to 5.15, 5.16 and 5.17. (I saw
> you already added them, thanks).
> 
> I tested the patch(no merge conflict) and buld with Linux 5.15.32,
> Linux 5.17.1, and Linux 5.16.18

All now queued up, thanks!

greg k-h
