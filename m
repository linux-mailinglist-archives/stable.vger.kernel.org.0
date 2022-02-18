Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF8F4BB576
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 10:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbiBRJYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 04:24:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbiBRJYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 04:24:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0979029834
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 01:23:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAF61B825C1
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 09:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C83C340E9;
        Fri, 18 Feb 2022 09:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645176228;
        bh=BxQwm8MRkr3j9UXNL0ITkzp98BnRugryAcuxBaJwB3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fSe0GK7iVRR/03nn9viI5ABnnvq1orx7vG4JJ8zOzw2RG8Xx5yqZLv3Zbnm5LSLYr
         LBkw7A8qP4yl8dDZsWv0kjoa2y1A5/p1zA77jysdhah8Lqyoe6zDzhgzpm8gEg4HgE
         JYsIE14A3jyyB0XlG3BHUdGZhhNfzqshCbIpixwQ=
Date:   Fri, 18 Feb 2022 10:23:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     gnault@redhat.com, kuba@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] xfrm: Don't accidentally set RTO_ONLINK
 in decode_session4()" failed to apply to 4.19-stable tree
Message-ID: <Yg9loe0InHHnTPQT@kroah.com>
References: <16430300795760@kroah.com>
 <Yg6nc3i9iRjyoPvF@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg6nc3i9iRjyoPvF@debian>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 07:52:19PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jan 24, 2022 at 02:14:39PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport. Will also apply to 4.14-stable.

All now queued up, thanks!

greg k-h
