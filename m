Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8CB63D3FB
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 12:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiK3LJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 06:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiK3LJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 06:09:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661071EAE8;
        Wed, 30 Nov 2022 03:09:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 016B461AEA;
        Wed, 30 Nov 2022 11:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A672C433D6;
        Wed, 30 Nov 2022 11:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669806572;
        bh=LyiWbFZONQrHnA1Hcw6g+friiSnfJKrN9MK3zQKS4jU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mWt8qMGUMDA+J1lynnUse4i+I0OEsjUbfiVnvWeHawGYbCDQsksC1USroebcr0Xiu
         ZZKU3vV+5vdNcfoEN6mrmge4Gg3tas+Jd5Xd7uuU/9i+3HAA3z7gaJfY/XER36zytJ
         q0t7XXh9VGNosPMtJuj7c9rfKfyK7V0jjzmg7g/8=
Date:   Wed, 30 Nov 2022 12:09:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ji-Ze Hong <hpeter@gmail.com>
Subject: Re: [PATCH] USB: serial: f81534: fix division by zero on line-speed
 change
Message-ID: <Y4c56VLgznt3Xo7C@kroah.com>
References: <20221129141819.15310-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129141819.15310-1-johan@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 29, 2022 at 03:18:19PM +0100, Johan Hovold wrote:
> The driver leaves the line speed unchanged in case a requested speed is
> not supported. Make sure to handle the case where the current speed is
> B0 (hangup) without dividing by zero when determining the clock source.
> 
> Fixes: 3aacac02f385 ("USB: serial: f81534: add high baud rate support")
> Cc: stable@vger.kernel.org      # 4.16
> Cc: Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
