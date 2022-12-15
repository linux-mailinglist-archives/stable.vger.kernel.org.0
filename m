Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4512864D8D2
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 10:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiLOJo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 04:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLOJo1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 04:44:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869FDE0F9;
        Thu, 15 Dec 2022 01:44:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3087B61D49;
        Thu, 15 Dec 2022 09:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DB6C433EF;
        Thu, 15 Dec 2022 09:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671097465;
        bh=MMFP0Qh0UNXei9PjTaXEfX0hjLkcSnnELk7yPU6xj80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b2MRkv18dLS+pz4h2ZcqRd7gbL4s3Qq2E/6onXSNqcEvIfbywVQlo1BrI/FyJToqp
         /AsYkGFblxSLiYBTmeHrLrGLWozT7UNCPRB2/f+yRqgQm8m+Ke1k0gE8ZKuDCkCEQ2
         tSUEoMghBAhRWTPVm60CkcJJDyxGELe+n5o1t9As=
Date:   Thu, 15 Dec 2022 10:44:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     cy_huang <u0084500@gmail.com>
Cc:     linux@roeck-us.net, heikki.krogerus@linux.intel.com,
        matthias.bgg@gmail.com, tommyyl.chen@mediatek.com,
        macpaul.lin@mediatek.com, gene_chen@richtek.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        ChiYuan Huang <cy_huang@richtek.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: typec: tcpm: Fix altmode re-registration causes
 sysfs create fail
Message-ID: <Y5rsdo/SGHJM4UKG@kroah.com>
References: <1671096096-20307-1-git-send-email-u0084500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1671096096-20307-1-git-send-email-u0084500@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 15, 2022 at 05:21:36PM +0800, cy_huang wrote:
> From: ChiYuan Huang <cy_huang@richtek.com>

Why not send directly from this address so we can validate that this is
the correct email address of yours?

thanks,

greg k-h
