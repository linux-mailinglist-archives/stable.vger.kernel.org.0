Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E80856CF72
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 16:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiGJOXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 10:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiGJOXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 10:23:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B04911817;
        Sun, 10 Jul 2022 07:23:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A54161241;
        Sun, 10 Jul 2022 14:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DB4C3411E;
        Sun, 10 Jul 2022 14:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657462991;
        bh=LsExIA4j36kEMKF4MN4iMALMVecFNvCu/sHY9ONaGJA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wUpp77ydgxqwesdXbxoL6rgN1L2QFgEwOE8oc+37Pwxp0Pho+S4T8l7SoUeFAW++2
         /27vHzwUf7hMNukmo0K9SKJcfcp0wSQitQMYGJqHnC8ODwPnQRIBN/HeRHJLz+y6YJ
         l977BUNClFWU2BGtHqppgP6ZDvzg1ovvGJZ2Ipdk=
Date:   Sun, 10 Jul 2022 16:22:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jimmy Assarsson <extja@kvaser.com>
Cc:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jimmy Assarsson <jimmyassarsson@gmail.com>
Subject: Re: [PATCH 4.9 1/4] can: kvaser_usb: Add struct kvaser_usb_dev_cfg
Message-ID: <YsrgtpoWZEKidumD@kroah.com>
References: <20220708184556.280751-1-extja@kvaser.com>
 <20220708184556.280751-2-extja@kvaser.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708184556.280751-2-extja@kvaser.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 08, 2022 at 08:45:53PM +0200, Jimmy Assarsson wrote:
> Add struct kvaser_usb_dev_cfg to ease backporting of upstream commits:
> 49f274c72357 (can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info)
> e6c80e601053 (can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression)
> b3b6df2c56d8 (can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits)
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
> ---
>  drivers/net/can/usb/kvaser_usb.c | 76 ++++++++++++++++++++++----------
>  1 file changed, 52 insertions(+), 24 deletions(-)

Same comment as on the 4.14 one.
