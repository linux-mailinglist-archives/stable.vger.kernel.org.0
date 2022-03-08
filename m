Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41C74D1F26
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 18:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbiCHRcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 12:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbiCHRcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 12:32:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA2B55778
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 09:31:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB21DB81B90
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 17:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C025C340EB;
        Tue,  8 Mar 2022 17:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646760682;
        bh=DPaHHODJw37ZjDh+BSPlItIzqNKqgIIACjIGnEaa5a8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EdjAvS9vBfEV6MfOfeSOjtG1h8Mgq0tbFDNqJx7NqMxTpChlWhrRZFiSrMPOqreag
         QhMlMJ80iK5EhoB9ZFgNOBx7aQfnRO6ynrvrdhFWohCv0yVoZT4VpqAT3oZObYR7Pp
         +ne6782yQqgOsDCxhTcvP0t8UPL7Sp5KTr43trDc=
Date:   Tue, 8 Mar 2022 18:31:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jocelyn Falempe <jfalempe@redhat.com>
Cc:     dri-devel@lists.freedesktop.org, michel@daenzer.net,
        lyude@redhat.com, tzimmermann@suse.de, stable@vger.kernel.org
Subject: Re: [PATCH] drm/mgag200: Fix PLL setup for g200wb and g200ew
Message-ID: <YieS530V0nGYydGa@kroah.com>
References: <20220308171111.220557-1-jfalempe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308171111.220557-1-jfalempe@redhat.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 08, 2022 at 06:11:11PM +0100, Jocelyn Falempe wrote:
> commit f86c3ed55920ca1d874758cc290890902a6cffc4 ("drm/mgag200: Split PLL
> setup into compute and update functions") introduced a regression for
> g200wb and g200ew.

No need for all those digits in the sha1, see below:

> The PLLs are not set up properly, and VGA screen stays
> black, or displays "out of range" message.
> 
> MGA1064_WB_PIX_PLLC_N/M/P was mistakenly replaced with
> MGA1064_PIX_PLLC_N/M/P which have different addresses.
> 
> Patch tested on a Dell T310 with g200wb
> 
> Fixes: f86c3ed55920ca1d874758cc290890902a6cffc4

As per the documentation that line should read:

Fixes: f86c3ed55920 ("drm/mgag200: Split PLL setup into compute and update functions")

thanks,

greg k-h
