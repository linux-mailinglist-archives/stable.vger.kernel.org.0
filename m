Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9EB597E0D
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 07:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243180AbiHRF0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 01:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237986AbiHRF0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 01:26:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0D6ABD7A;
        Wed, 17 Aug 2022 22:26:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F55061620;
        Thu, 18 Aug 2022 05:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B2BC433C1;
        Thu, 18 Aug 2022 05:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660800364;
        bh=Pob14GlFlt3/nMNC2MLFsE/TmmhajH5vCAnT5j7uBn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EF6DLRQ/CTkEzVVe/gDZvHvhRnhKtYdiWCqFBon6195IXe1J2yjfsYNfrOmrhabfk
         DcjiV9iSbYeaxrITJYRxfeTEsM0aMUr0tQIly61Ojwqr/Rr12QcmVkmYPYsLgr2Q7B
         JgRANXbgnbSDQKK6MOsQxKmsO97m7sC7LFjRjejQ=
Date:   Thu, 18 Aug 2022 07:26:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Carlos Llamas <cmllamas@google.com>
Cc:     Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Christian Brauner <brauner@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Suren Baghdasaryan <surenb@google.com>,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] binder: fix UAF of ref->proc caused by race condition
Message-ID: <Yv3NaRWWd9UPWEUq@kroah.com>
References: <20220801182511.3371447-1-cmllamas@google.com>
 <Yul9sEAtM+4aGbEg@google.com>
 <Yuoj1GVrgtflsYYZ@kroah.com>
 <Yv1mAu9Ndk1SoUHr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv1mAu9Ndk1SoUHr@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 10:04:50PM +0000, Carlos Llamas wrote:
> On Wed, Aug 03, 2022 at 09:29:24AM +0200, Greg Kroah-Hartman wrote:
> > 
> > Thanks, I'll add this when I queue it up after 5.20-rc1 is out.
> > 
> > greg k-h
> 
> Hi Greg,
> 
> I think this might have fallen through the cracks, I can't find it in
> char-misc or linux-next trees.

-rc1 only came out a few days ago, and I have a lot to catch up on:
	$ mdfrm -c ~/mail/todo/
	1770 messages in /home/gregkh/mail/todo/

Please give me a chance...

thanks,

greg k-h
