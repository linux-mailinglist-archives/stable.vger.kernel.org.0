Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0FF60708D
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 08:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiJUGzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 02:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiJUGzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 02:55:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2638664FC;
        Thu, 20 Oct 2022 23:54:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 167E8601D2;
        Fri, 21 Oct 2022 06:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E35C433C1;
        Fri, 21 Oct 2022 06:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666335297;
        bh=uooPe/iySsrY7FXo6a+KA1D4YXmIG5i0nJAQ+SQTDnY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XHk07/Z0TWZkyTjEXlfbwUqrwwQhmPSu9KKKW3jBW7+r8Dac+U89ln9FGNdQYwX7U
         lQWiRCGuMsjj2UNeXZtN61DQzYCWY1j3N/uxElkJgJmGOSbUUX2Q7mpUIbQnXfVaCV
         0Uyabg/4Xo5IdfWaUnymWMHRyHmV+UrH2hJteXxY=
Date:   Fri, 21 Oct 2022 08:54:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Pavel Machek <pavel@denx.de>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.19 10/11] arm64: dts: uniphier: Add USB-device
 support for PXs3 reference board
Message-ID: <Y1JCPp4yW43/eGhH@kroah.com>
References: <20221011145358.1624959-1-sashal@kernel.org>
 <20221011145358.1624959-10-sashal@kernel.org>
 <20221017112315.GA23442@duo.ucw.cz>
 <cc2cef78-52e1-4da5-8739-375dd7bfe499@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc2cef78-52e1-4da5-8739-375dd7bfe499@app.fastmail.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 21, 2022 at 08:29:30AM +0200, Arnd Bergmann wrote:
> On Mon, Oct 17, 2022, at 13:23, Pavel Machek wrote:
> > Hi!
> >
> >> From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> >> 
> >> [ Upstream commit 19fee1a1096d21ab1f1e712148b5417bda2939a2 ]
> >> 
> >> PXs3 reference board can change each USB port 0 and 1 to device mode
> >> with jumpers. Prepare devicetree sources for USB port 0 and 1.
> >> 
> >> This specifies dr_mode, pinctrl, and some quirks and removes nodes for
> >> unused phys and vbus-supply properties.
> >
> > Why was this autoselected? It is a new feature, not a bugfix.
> 
> It also caused a regression now according to the build bots. I 
> have not checked, but I assume there are some other patches that
> this depends on.

Ok, let me go drop this from all trees now, thanks.

greg k-h
