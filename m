Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E985FA17B
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 17:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiJJP6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 11:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJJP6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 11:58:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D6E726A1;
        Mon, 10 Oct 2022 08:58:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A618260F83;
        Mon, 10 Oct 2022 15:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE16C433C1;
        Mon, 10 Oct 2022 15:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665417482;
        bh=4X8G6+O+QPksuawyg4i/Nna0sKN6RLkcN88gN30z0WQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=or5Xo6bByP/+sU2YzNNgerI3psEg5NS8d6+pB4H4McSxdVROTy4ecdDYLLzj1EdQS
         s1qOZ29tUdTt7BnP4Q8tF+qlG7NwCnF/4uPSvWD/KElohBWibmREfwob1qG14Z2NNB
         F6QqsCqZnFrmxqYuZF2S1NVcAby0aWBqDf8ZiSH4=
Date:   Mon, 10 Oct 2022 17:58:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yong w <yongw.pur@gmail.com>
Cc:     jaewon31.kim@samsung.com, linux-kernel@vger.kernel.org,
        mhocko@kernel.org, stable@vger.kernel.org, wang.yong12@zte.com.cn
Subject: Re: [PATCH v2 stable-4.19 0/3] page_alloc: consider highatomic
 reserve in watermark fast backports to 4.19
Message-ID: <Y0RBNTQnYpoF1r7w@kroah.com>
References: <Yyn7MoSmV43Gxog4@kroah.com>
 <20220925103529.13716-1-yongw.pur@gmail.com>
 <YzmwKxYVDSWsaPCU@kroah.com>
 <CAOH5QeB2EqpqQd6fw-P199w8K8-3QNv_t-u_Wn1BLnfaSscmCg@mail.gmail.com>
 <Y0BWuJHsK6XDk2nx@kroah.com>
 <CAOH5QeAX0NzO2mXqBbMRYGMzNMTAq4H1r9r_AFWC2Fj=MNWwiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOH5QeAX0NzO2mXqBbMRYGMzNMTAq4H1r9r_AFWC2Fj=MNWwiw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 10, 2022 at 11:47:30PM +0800, yong w wrote:
> Greg KH <gregkh@linuxfoundation.org> 于2022年10月8日周六 00:40写道：
> >
> > A: http://en.wikipedia.org/wiki/Top_post
> > Q: Were do I find info about this thing called top-posting?
> > A: Because it messes up the order in which people normally read text.
> > Q: Why is top-posting such a bad thing?
> > A: Top-posting.
> > Q: What is the most annoying thing in e-mail?
> >
> > A: No.
> > Q: Should I include quotations after my reply?
> >
> > http://daringfireball.net/2007/07/on_top
> >
> >
> > On Fri, Oct 07, 2022 at 04:53:50PM +0800, yong w wrote:
> > > Is it ok to add my signed-off-by? my signed-off-by is as follows:
> > >
> > >   Signed-off-by: wangyong <wang.yong12@zte.com.cn>
> >
> > For obvious reasons, I can not take that from a random gmail account
> > (nor should ZTE want me to do that.)
> >
> > Please fix up your email systems and do this properly and send the
> > series again.
> >
> > thanks,
> >
> > greg k-h
> 
> Sorry, our mail system cannot send external mail for some reason.

Sorry, then I can not attribute anything to your company.  It has
already been warned that it can not continue to contribute to the Linux
kernel and some of your gmail "aliases" have been banned from the
mailing lists.

Please fix your email system so that you can properly contribute to
Linux.

> And this is my email, I can receive an email and reply to it.

Yes, but I have no proof that your ZTE email is correct, only that this
is a random gmail.com address :(

What would you do if you were in my situation?

Please work with your IT group to fix their email systems.

good luck,

greg k-h
