Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28DC1557EEA
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 17:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiFWPuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 11:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiFWPuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 11:50:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C9541626
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 08:50:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95A5161ED2
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 15:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FA8C3411B;
        Thu, 23 Jun 2022 15:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655999406;
        bh=Z1PBj+Xn4K6lid6mVeDJ8CzLXCeCjl+jQ/f5RZRvtoA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bvp5a8d70HfPkVyLkqoVKlV7jGx44mEZXbmCWvq0JvTBc/yYLZpetPM41exZa0n/g
         ep+AhfVk+GldhLm3SWwT1MErKyXYGMsc4i9A1rbDw6xuC44XK6G25zuTUHK0iCIhV+
         aWsP2Hm+teLy4FC9PN7J/e613gA8WvHSamGqpPIA=
Date:   Thu, 23 Jun 2022 17:50:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Jorgen.Hansen@wdc.com, hch@lst.de, johannes.thumshirn@wdc.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] zonefs: fix zonefs_iomap_begin() for
 reads" failed to apply to 5.18-stable tree
Message-ID: <YrSLrJKER13K+y7y@kroah.com>
References: <165572740210477@kroah.com>
 <4f4b8d59-6d10-6244-21c7-296475f2200a@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f4b8d59-6d10-6244-21c7-296475f2200a@opensource.wdc.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 21, 2022 at 09:59:32AM +0900, Damien Le Moal wrote:
> On 6/20/22 21:16, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.18-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Greg,
> 
> I just sent you the backported patch in replyu to this email. The same
> patch also applies to linux-5.15.y. 5.10 backport is different. Sending
> that one separately.

All now queued up, thanks.

greg k-h
