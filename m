Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F8D6DF91C
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 16:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjDLOzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 10:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjDLOy4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 10:54:56 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574516EA1;
        Wed, 12 Apr 2023 07:54:30 -0700 (PDT)
Date:   Wed, 12 Apr 2023 16:54:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1681311251;
        bh=QQHeozy6rLbcCS3RN6ZgKpYVVhz3zwxTwiMIs9BJTco=;
        h=Date:From:To:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To:Cc:Cc:content-type:content-type:date:date:
         From:from:in-reply-to:in-reply-to:message-id:mime-version:
         references:reply-to:Sender:Subject:Subject:To:To;
        b=3mWvV1ec1bVzqPODjGeh5YUn8X0JwBr1Fg3XEJVL/cBNLDsXrrUMOG2AkNlLkFIoX
         vzgqXEo6kgZZsQfbHxEet68P8ujAHGjGyEU4qMpLu5Bt++ONF4WbYxhA4SPawTmZSp
         XvtTtlyn32Ihpa9Y7eHrz4bo0Ppe5LcFtqmBPNHLzZlgo7hOdgBKzmQkHN6yQI4ZcI
         t39iubO+epJQn2n+ullGyNtWBhIHYKJog34Q/yuwO0IhBcHcok7aoGFZEmcMF2pJ8o
         nbg5MvbAxC+yN2DO8gCwWSidSfYxNe/UTPtxIwm3VnMculWCdj3Zz64boNmHUmKKtB
         LnvYHIRDDc39Q==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1 000/164] 6.1.24-rc1 review
Message-ID: <20230412145410.GB3871@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230412082836.695875037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.24 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.

Hi Greg

6.1.24-rc1

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
