Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEED4CE511
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 14:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiCENuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 08:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiCENuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 08:50:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E734C7A1
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 05:49:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56158B80B9E
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 13:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919EAC004E1;
        Sat,  5 Mar 2022 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646488164;
        bh=aSFl0W1nZmsLKc2mT6Tk8qbn8sC08xqQK4iuhDZXts0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=du4Zs0ZfOhdBGLGRSoJxOOTL7pc4KiihhO8Ftq/Uo/x8jvsO7P6FuAIDly3e+BNLR
         +1ZQwMXIFU7pQt1UOm+X9GmzMpIs/mjqHc8U1hINKe/8+C4oWwcwR4XgxbN1H/1BX+
         g0Ls1xxhZ25fWPi+qs6cWGy9vgpHKgAtOk70t1nU=
Date:   Sat, 5 Mar 2022 14:49:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     johan@kernel.org, somlo@cmu.edu, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] firmware: qemu_fw_cfg: fix kobject leak
 in probe error path" failed to apply to 4.14-stable tree
Message-ID: <YiNqYNoLYu7kqBRH@kroah.com>
References: <164249590460244@kroah.com>
 <Yh/sWZImSWjBAhwB@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh/sWZImSWjBAhwB@debian>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 02, 2022 at 10:14:49PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Tue, Jan 18, 2022 at 09:51:44AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport along with the backport of:
> fe3c60684377 ("firmware: Fix a reference count leak.") which was needed to
> make the backport easier. Both will also apply to 4.9-stable.

Now queued up, thanks!

greg k-h
