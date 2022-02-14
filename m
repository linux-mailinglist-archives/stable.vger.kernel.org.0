Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220374B4289
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 08:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238303AbiBNHJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 02:09:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbiBNHJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 02:09:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30A8583B9
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 23:09:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DE66B80B7F
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 07:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FD6C340EB;
        Mon, 14 Feb 2022 07:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644822564;
        bh=SMYfiBjbGqevOYcp88HzSYfxxO0yv1waumGOBqu8rmw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hm/eQ6pRyvyVHK1P2ZOwTJCjBAZg5KYXVDT0QP8QLyUxBu918+et+rKsrp1zXboGE
         OqrvQwNjpgoTZeXxWpuMNY0kQDeUxLCw8Hk7EU9mQxHJb1ctO/G4WyF4gy97IPCq5f
         HbFN4EQ3ttG9sWPSaxoOgQ1O56XDhxmuCTvgrzfw=
Date:   Mon, 14 Feb 2022 08:09:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     mkl@pengutronix.de, william.xuanziyang@huawei.com,
        stable@vger.kernel.org
Subject: Re: [PATCH Backport 5.10-stable] can: isotp: fix error path in
 isotp_sendmsg() to unlock wait queue
Message-ID: <YgoAIXJojyv+aDcA@kroah.com>
References: <20220213195940.5146-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220213195940.5146-1-socketcan@hartkopp.net>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 13, 2022 at 08:59:40PM +0100, Oliver Hartkopp wrote:
> Upstream commit 8375dfac4f68
> 

Now queued up, thanks.

greg k-h
