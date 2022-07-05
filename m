Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4DE566A12
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 13:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiGELnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 07:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbiGELnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 07:43:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F109C1705A
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 04:43:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2F58B817AA
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 11:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AF1C341C7;
        Tue,  5 Jul 2022 11:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657021408;
        bh=T0Xy/YQDkdu6yp+K91iDPiGXcZnazmbrMlMCFLa7DeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V22rsX0g8hYSjinsyZD78fOWqnEo0S+t0aD1TunIAwj+0R2f32puem1q6x4eJQuEq
         yrbuwcX0fYNBtmc5Ye94tFydyl1CNnxn1lKdO93NgP4OfCx5Ri1dW51M7/P0dJ4KUd
         uUlNMn8mkNuZtPLuJGZlpfNHJ6qN0z0b+K02w1ng=
Date:   Tue, 5 Jul 2022 13:43:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fabio Porcedda <fabio.porcedda@gmail.com>
Cc:     stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        jorgen.storvist@gmail.com, Carlo Lobrano <c.lobrano@gmail.com>
Subject: Re: Backport support for Telit device IDs to
 5.15/5.10/5.4/4.19/4.14/4.9
Message-ID: <YsQj3dIMxZcGYb70@kroah.com>
References: <CAHkwnC9408BG+FBPM1NvrivxcPLf2+Sr_cZ74ir7SB5BrtFebw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHkwnC9408BG+FBPM1NvrivxcPLf2+Sr_cZ74ir7SB5BrtFebw@mail.gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 05, 2022 at 01:32:34PM +0200, Fabio Porcedda wrote:
> Hi,
> Can you please backport the following commits in order to support new
> Telit device IDs?
> 
> The following one just for 4.9:
> commit 1986af16e8ed355822600c24b3d2f0be46b573df
>   qmi_wwan: Added support for Telit LN940 series
> 
> The following one just for 4.9:
> commit b4e467c82f8c12af78b6f6fa5730cb7dea7af1b4
>    net: usb: qmi_wwan: add Telit 0x1260 and 0x1261 compositions
> 
> The following one just for 4.9:
> commit 5fd8477ed8ca77e64b93d44a6dae4aa70c191396
>     net: usb: qmi_wwan: add Telit LE910Cx 0x1230 composition
> 
> The following one for 4.9/4.14/4.19/5.4/5.10:
> commit 8d17a33b076d24aa4861f336a125c888fb918605
>     net: usb: qmi_wwan: add Telit 0x1060 composition
> 
> The following one for 4.9/4.14/4.19/5.4/5.10/5.15:
> commit 94f2a444f28a649926c410eb9a38afb13a83ebe0
>     net: usb: qmi_wwan: add Telit 0x1070 composition

All queued up now, but you REALLY should move off of 4.9.y at this point
in time as it is going to be dropped from support pretty soon and you
should not be using that for any new hardware types.

thanks,

greg k-h
