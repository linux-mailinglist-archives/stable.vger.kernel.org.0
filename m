Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5594C44A4
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 13:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240392AbiBYMcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 07:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbiBYMcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 07:32:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E64F27CDB
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 04:31:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C8D2B82D7B
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 12:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A77C340E7;
        Fri, 25 Feb 2022 12:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645792302;
        bh=NSjuzdV5O/czCa2RcedDcUB+ilQmJXAbwILhPVpkf7I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v7YzLNWHvgCkWQHtbqmgHxgjnQj23f1d/r4MsFFWNlHShdavDZWHhAOzyTRJ2s/te
         SYC0V6ageEg3WqnakM2coQPA6LvjWWoHn8a67yQsJNhPtH29zT6X977wVj6F/8LkJo
         I7DJUoIpxYcVMNpOsQATljQUhFmTYabkCrB8uUt8=
Date:   Fri, 25 Feb 2022 13:31:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     robert.hancock@calian.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] serial: 8250: of: Fix mapped region size
 when using" failed to apply to 4.9-stable tree
Message-ID: <YhjMLJQB9vx3NnUS@kroah.com>
References: <16434717774226@kroah.com>
 <YhVaBJiGRUA7A5bF@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhVaBJiGRUA7A5bF@debian>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 22, 2022 at 09:47:48PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Sat, Jan 29, 2022 at 04:56:17PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport along with the backport of fa9ba3acb557 ("serial:
> 8250: fix error handling in of_platform_serial_probe()") which will be
> needed before this.

All now queued up,t hanks.

greg k-h
