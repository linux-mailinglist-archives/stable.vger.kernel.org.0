Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC03864DA96
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 12:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiLOLnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 06:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLOLnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 06:43:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB7B2C10E;
        Thu, 15 Dec 2022 03:43:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B56CEB81B84;
        Thu, 15 Dec 2022 11:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF120C433D2;
        Thu, 15 Dec 2022 11:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671104618;
        bh=Oh7qR3FqKNXC4yCGOLnMkkPDHqlsorxxWcum/D2kYSg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=addAOdAOJbgv/HjUd9rHl7Y8DJhOUktDJYvGf2S5HfPG0YRYHukY28mx8j5AdMhAk
         AbhpZ1gVXitHPYQSqyqC+dZI+GH2q0SStlZodKJYge9lfCtEAXkx6TbRD/4VEGC+Wg
         /j/75CrEg4TsZ4sG5aI0QR0HGKjJZhM0yWT94mJs=
Date:   Thu, 15 Dec 2022 12:43:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     ChiYuan Huang <u0084500@gmail.com>
Cc:     linux@roeck-us.net, heikki.krogerus@linux.intel.com,
        matthias.bgg@gmail.com, tommyyl.chen@mediatek.com,
        macpaul.lin@mediatek.com, gene_chen@richtek.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        ChiYuan Huang <cy_huang@richtek.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: typec: tcpm: Fix altmode re-registration causes
 sysfs create fail
Message-ID: <Y5sIZ3zC6o4ARDEn@kroah.com>
References: <1671096096-20307-1-git-send-email-u0084500@gmail.com>
 <Y5rsdo/SGHJM4UKG@kroah.com>
 <CADiBU3-iVLQf6Q5SzOB_pMCs2PGcFuWryjpDn5Qvz41WQ6C2RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADiBU3-iVLQf6Q5SzOB_pMCs2PGcFuWryjpDn5Qvz41WQ6C2RA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 15, 2022 at 05:53:44PM +0800, ChiYuan Huang wrote:
> Greg KH <gregkh@linuxfoundation.org> 於 2022年12月15日 週四 下午5:44寫道：
> >
> > On Thu, Dec 15, 2022 at 05:21:36PM +0800, cy_huang wrote:
> > > From: ChiYuan Huang <cy_huang@richtek.com>
> >
> > Why not send directly from this address so we can validate that this is
> > the correct email address of yours?
> >
> It's  the company mailbox policy. To send the external mail, there's
> the security text block at the bottom.
> Except this, some mail address are also blocked. To avoid this, I use
> my personal mail to send the patch
> and leave the SoB for the Richtek mailbox.
> It's lazy to fight for this.

Please fix it, otherwise your company's email address will be spoofed
and people can claim to be sending changes from their domain.

Please fix that up, abusing random gmail addresses like this is not ok,
sorry.

greg k-h
