Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5428649E3C
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 12:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbiLLLzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 06:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiLLLzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 06:55:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCEFF5A1
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 03:55:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9EED60FE0
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 11:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB906C433F0;
        Mon, 12 Dec 2022 11:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670846137;
        bh=sGZpk5ZoQheEbXUi+zl4JQAZ3knvOBZ5XQZYV2YIbJE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=capT+4bmmrU7lFxpASnbheWQCzhBgw7AltWhPXxT19EN12ul1Q9R9O36TcFsiu6F7
         9aNHlJqQqslZ54oKY4rhtZWORGTA32W40amdHW0kVsGkZqTcCf1vBAsrjt4IrKUhgS
         ywX6eWZxrtKd3lsNq1r6w7An4VN3aOpMNFW1UYKo=
Date:   Mon, 12 Dec 2022 12:55:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     harperchen1110@gmail.com, mkl@pengutronix.de,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] can: af_can: fix NULL pointer dereference
 in can_rcv_filter" failed to apply to 4.19-stable tree
Message-ID: <Y5cWtLwRyrnOPG0I@kroah.com>
References: <1670752399185135@kroah.com>
 <e3b578a6-450b-11d6-caf9-33af7ad3cc3a@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3b578a6-450b-11d6-caf9-33af7ad3cc3a@hartkopp.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 11:15:58AM +0100, Oliver Hartkopp wrote:
> Just FYI
> 
> The longterm kernels before Linux 5.4 (4.9/4.14/4.19) are not affected by
> this issue as the netdev->ml_priv pointer is assigned within a netdev
> notifier for ARPHRD_CAN interfaces and this always assigns the data
> structure properly.
> 
> I tested the crash reproducer from the syzbot bug report which did not have
> any bad effect (as expected).

Wonderful, thanks for letting us know.

greg k-h
