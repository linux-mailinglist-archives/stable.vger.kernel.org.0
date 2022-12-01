Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1EB463EAFD
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 09:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLAI0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 03:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLAI0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 03:26:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81886034D
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 00:26:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87B11B81E5E
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 08:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27F6C433C1;
        Thu,  1 Dec 2022 08:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669883193;
        bh=m+xBpKCMOKEc9qx0KBpk8BDiMGASH/67XkkPb9hnV9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bVGPu5NcMPitMLV+CN7ZbClV8Vb1OURhVOVZRX9HmCXN/o/d/djAgWB7ZkHxPB/y1
         TSAgMEQFiE1njyALfQnF59QNQe6KGRxzWSal7fMf4ynBknoFL9WAkiGnyNV8Jw6n20
         POhUj8p0njS+YdUH/T8pDhsr8jSlahLOK+pzAMks=
Date:   Thu, 1 Dec 2022 06:57:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Aron <john@aronetics.com>
Cc:     'Mark Salter' <mark.salter@canonical.com>,
        'Mark Lewis' <mark.lewis@canonical.com>,
        regressions@lists.linux.dev, stable@vger.kernel.org,
        kernelnewbies@kernelnewbies.org
Subject: Re: OBJTOOL Build error
Message-ID: <Y4hCVMrg9oZt+YAL@kroah.com>
References: <041601d90035$4f738de0$ee5aa9a0$@aronetics.com>
 <Y3/c73nZVdHCBdZo@kroah.com>
 <0be301d90514$9250bd70$b6f23850$@aronetics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0be301d90514$9250bd70$b6f23850$@aronetics.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Nov 30, 2022 at 06:36:19PM -0500, John Aron wrote:
> One C file and a few header files.

Can you provide a link to them so that we can see what might be the
problem?  Without that, it's impossible to help, sorry.

thanks,

greg k-h
