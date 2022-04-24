Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C60F50D029
	for <lists+stable@lfdr.de>; Sun, 24 Apr 2022 09:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbiDXHLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Apr 2022 03:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbiDXHLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Apr 2022 03:11:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E912917ABA;
        Sun, 24 Apr 2022 00:08:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF70D612D6;
        Sun, 24 Apr 2022 07:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09D9C385A7;
        Sun, 24 Apr 2022 07:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650784116;
        bh=rhnPDv3m0PNekYvfKwNPrTY0HxMA1SMyxqQWbEaoOYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UiTHE7IpGZhJ6tSXNNPyh3ytNCEnPa7I6oE602K5jKTsqz6UstCQfxjg2yKScR/vl
         KdXskO62ktmvkErW0ZXFDsBFwSk0g9VhiMt/hlDi3ogza2DqpYDD+eiHQGmDB0xqbR
         hE0vVA5ssjRblKkqXg5zITILFm7xNvdoU12WLr+M=
Date:   Sun, 24 Apr 2022 09:08:33 +0200
From:   gregkh <gregkh@linuxfoundation.org>
To:     =?utf-8?B?5byg5bm/6L6J?= <zhang.guanghui@cestc.cn>
Cc:     roid <roid@nvidia.com>, saeedm <saeedm@nvidia.com>,
        parav <parav@nvidia.com>, jgg <jgg@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: Fix a devlink AB-BA deadlock on net namespace deletion
Message-ID: <YmT3cSkfIhLx0CVj@kroah.com>
References: <342746123.81421.1650369512240.JavaMail.xmail@ma-wm-1-new>
 <2141729194.2508.1650780142235.JavaMail.xmail@wm-2-new>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2141729194.2508.1650780142235.JavaMail.xmail@wm-2-new>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 24, 2022 at 02:02:22PM +0800, 张广辉 wrote:
> 
> Hi  all
> 

<snip>


Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch is malformed (tabs converted to spaces, linewrapped, etc.)
  and can not be applied.  Please read the file,
  Documentation/email-clients.txt in order to fix this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot

