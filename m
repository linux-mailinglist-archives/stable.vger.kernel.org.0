Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97473565423
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiGDLxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiGDLxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:53:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605AE30D
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 04:53:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E67AB80EEC
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 11:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E389C341CD;
        Mon,  4 Jul 2022 11:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656935581;
        bh=AXxClsAJ1zIdnPPcDVqVMm6Gh4CuzhAo5KQanPVK6Hk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KnowmJVpM7uR7k7l8F1uwFiwb/ECqq8yDEt02deGCy7RMrTUD/Kv/Sbzb9p1Se2G2
         dD44JW6Li7MIQGYdUMnaT0fxVb4ABviQIvc1oi8R04mxlJpu3d9wm2PS2gccFQjJZN
         MpcqY66Eog46v0UaYrx5bgufy3HA9r/1uRP9Hncs=
Date:   Mon, 4 Jul 2022 13:52:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     kuba@kernel.org, ppenkov@aviatrix.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net: tun: stop NAPI when detaching
 queues" failed to apply to 4.14-stable tree
Message-ID: <YsLUmyWeRHyTHelI@kroah.com>
References: <165693454242194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165693454242194@kroah.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 04, 2022 at 01:35:42PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Oops, nevermind, this is not supposed to go to 4.14.y, sorry for the
noise.

greg k-h
