Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326894D959E
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 08:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242750AbiCOHwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 03:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345651AbiCOHwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 03:52:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD37A4B87A;
        Tue, 15 Mar 2022 00:51:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 418D161466;
        Tue, 15 Mar 2022 07:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89B2C340E8;
        Tue, 15 Mar 2022 07:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647330665;
        bh=WIiE5/Y8InLMDxSnOFGgcjcEamhcDTf2E4cGNCrfJIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AiRZtNq/KPPzYbiB4dZ/JZFPOoEoitkPYehdbuZxxfVrTv273vcA+98PRkhhW52eh
         rNOojssfryS72K3iFabfsw1VcgD8oLIUEo2tDjn6bMm6uaPRlC834j9ZVydRIcJvkW
         9QpEaFFAbCJsdoebJ7/TZvzZLBY0Bdhk10sE+JXo=
Date:   Tue, 15 Mar 2022 08:51:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     Maxime Ripard <mripard@kernel.org>,
        Bastien =?iso-8859-1?Q?Roucari=E8s?= <rouca@debian.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, stable@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "ARM: dts: sun7i: A20-olinuxino-lime2: Fix
 ethernet phy-mode"
Message-ID: <YjBFZm496HUnvBgQ@kroah.com>
References: <20220308125531.27305-1-ynezz@true.cz>
 <20220315072846.GA9129@meh.true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220315072846.GA9129@meh.true.cz>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 08:28:58AM +0100, Petr Štetiar wrote:
> Petr Štetiar <ynezz@true.cz> [2022-03-08 13:55:30]:
> 
> Hi Greg,
> 
> one week has passed and as I didn't received any feedback, I'm providing more
> details in a hope to make it more clear, why I think, that this fix is wrong
> and should be reverted in LTS kernels 5.10 and 5.15.

Why not reverted in Linus's tree first?  Shouldn't that be also broken
here?

thanks,

greg k-h
