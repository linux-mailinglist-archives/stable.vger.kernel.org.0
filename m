Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFF84CE510
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 14:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiCENtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 08:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiCENtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 08:49:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4B045AFD
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 05:48:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5166B612A0
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 13:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A31C340EE;
        Sat,  5 Mar 2022 13:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646488102;
        bh=Lp47IerhBPzzTERIfiJkSmy3DDFA41oEJLDxKN56TQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0FyTxwreo2XHRAw/PxrAjMkMVUFL84M3bSqAaqooxCs/T8cak91ia5Y19qRFP6FS/
         u0pHPH8V3oPnD90xTczPotawfBmUF6A4mCdHA68S8Vy2eOu24Mp1lh+D8k0jZk0dF5
         HBMXmt8ionUZ5iB6pjusI6ZjTHKc1Y0t6+TnT8Jo=
Date:   Sat, 5 Mar 2022 14:48:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     lukas@wunner.de, bhelgaas@google.com, joseph.bao@intel.com,
        stuart.w.hayes@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: pciehp: Fix infinite loop in IRQ
 handler upon power" failed to apply to 4.19-stable tree
Message-ID: <YiNqIlR+EGJe8d/A@kroah.com>
References: <16429572572420@kroah.com>
 <Yh/mTMhOb9BgYtPg@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh/mTMhOb9BgYtPg@debian>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 02, 2022 at 09:49:00PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Sun, Jan 23, 2022 at 06:00:57PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

applied, thanks.

greg k-h
