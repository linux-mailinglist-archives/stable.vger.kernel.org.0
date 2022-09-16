Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B795D5BA973
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 11:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiIPJcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 05:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiIPJcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 05:32:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A100AAA359;
        Fri, 16 Sep 2022 02:32:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F408CCE1D3D;
        Fri, 16 Sep 2022 09:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DBFC433D6;
        Fri, 16 Sep 2022 09:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663320733;
        bh=qIpPtXLE+jDdeNfuDY5kzoH7tb0gFYA1PUXnCdxlRnQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kiUi4IFRdZ3MPhJiLgazUDeGNR0z00SvE1fsE/Q/SUbOIb0S4UCK3dEJkqXZcnofh
         /VKyEiOkyMta9b8vSrQPoE/cVmUl7LQM6QjOhe7rGFYiFIXicgSaKp9sg1au94bSc6
         xmdkgyujOAQLa0wvGAuV8O5NgJDZOK5+WEc0EHUA=
Date:   Fri, 16 Sep 2022 11:32:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     sean.wang@mediatek.com
Cc:     stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Deren Wu <deren.wu@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 5.19] wifi: mt76: mt7921e: fix crash in chip reset fail
Message-ID: <YyRCtrOtPqu2oEPj@kroah.com>
References: <404d2f5ec663128342541fa392a47226a46e5634.1663219530.git.objelf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <404d2f5ec663128342541fa392a47226a46e5634.1663219530.git.objelf@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 15, 2022 at 01:32:35PM +0800, sean.wang@mediatek.com wrote:
> From: Deren Wu <deren.wu@mediatek.com>
> 
> commit fa3fbe64037839f448dc569212bafc5a495d8219 upstream.

This is already in the 5.19.9 kernel release, right?  Do we need it
again?

thanks,

greg k-h
