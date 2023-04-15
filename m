Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DC56E3332
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 20:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjDOSfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 14:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDOSfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 14:35:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBB52134
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 11:35:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AE5260A52
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 18:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40650C433EF;
        Sat, 15 Apr 2023 18:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681583712;
        bh=s6DtTj1DrMd0tN2/E2PvAPkgoaCLFuSXLjxP2BgPvwo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=toy5hTogmFa158ceZQGhUyj83ts0RU3KnO1cNqTSVRe0/TJ/6ZNYZt7KVdNNqf6Iw
         YBXLkEbFe8T7K5aovnKYPx/5lqnU6ujzcXM3OFVVCCiy2QvNLfJbkl4uLPOESmH5Xc
         o5N256EJXSe37ZW7OtBNTpbdG5Y5awO37Pfz6xUw=
Date:   Sat, 15 Apr 2023 20:35:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Richard Weinberger <richard@nod.at>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        stable <stable@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        chengzhihao1 <chengzhihao1@huawei.com>,
        Nicolas Schichan <nschichan@freebox.fr>,
        George Kennedy <george.kennedy@oracle.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        yi zhang <yi.zhang@huawei.com>
Subject: Re: Request to pick "ubi: Fix failure attaching when vid_hdr offset
 equals to (sub)page size"
Message-ID: <2023041544-unending-glowing-e5ce@gregkh>
References: <ZDrmsnX5BHxtBNwf@makrotopia.org>
 <288240559.69421.1681583177740.JavaMail.zimbra@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <288240559.69421.1681583177740.JavaMail.zimbra@nod.at>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 15, 2023 at 08:26:17PM +0200, Richard Weinberger wrote:
> ----- Ursprüngliche Mail -----
> > Von: "Daniel Golle" <daniel@makrotopia.org>
> > An: "stable" <stable@vger.kernel.org>, "linux-mtd" <linux-mtd@lists.infradead.org>
> > CC: "Hauke Mehrtens" <hauke@hauke-m.de>, "richard" <richard@nod.at>, "Miquel Raynal" <miquel.raynal@bootlin.com>,
> > "chengzhihao1" <chengzhihao1@huawei.com>, "Nicolas Schichan" <nschichan@freebox.fr>, "George Kennedy"
> > <george.kennedy@oracle.com>, "Sascha Hauer" <s.hauer@pengutronix.de>, "yi zhang" <yi.zhang@huawei.com>
> > Gesendet: Samstag, 15. April 2023 20:02:26
> > Betreff: Request to pick "ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size"
> 
> > Hi,
> > 
> > please pick
> > 
> > 1e020e1b96afd ("ubi: Fix failure attaching when vid_hdr offset equals to
> > (sub)page size")
> > 
> > from linux-next to stable trees.
> 
> FYI, the fix is not yet in Linus' master. But I guess it will be very soon.
> The pull request is on the mailinglist.

Any specific reason why it wasn't tagged cc: stable@ if it was known to
be fixing a regression so that we would pick it up automatically?

thanks,

greg k-h
