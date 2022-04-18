Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F29504E6E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 11:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbiDRJmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 05:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiDRJmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 05:42:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8A513D77
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:39:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59B5E61199
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 09:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18750C385A7;
        Mon, 18 Apr 2022 09:39:56 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PcBPjRul"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1650274794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8hxf/hVwPJN9Lvh0H+W0/RkxKKOel3OeT9I/MIIn0Fk=;
        b=PcBPjRulBVoPO8OrY9x05umOG7zCul41wgksRPurF4T7ENfErY7X1cO+HlxCYemf8F/QZf
        pQOmhSZgs3Pq09BaxAnA40T4S3W1aB/vSaDyQgb6k3edkL2FFTUeZjhSOB+AjIHDxWOPod
        6R1BAq+EMHw3h4/h0JyBc2qBLK5jeWU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c45ee964 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 18 Apr 2022 09:39:54 +0000 (UTC)
Date:   Mon, 18 Apr 2022 11:39:52 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     keescook@chromium.org, pageexec@freemail.hu, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gcc-plugins: latent_entropy: use
 /dev/urandom" failed to apply to 4.9-stable tree
Message-ID: <Yl0x6HEAlUdeu/Mi@zx2c4.com>
References: <16502694453885@kroah.com>
 <Yl0rFqfaETxNfTgh@zx2c4.com>
 <Yl0vnls++OCbpGzX@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yl0vnls++OCbpGzX@kroah.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Apr 18, 2022 at 11:30:06AM +0200, Greg KH wrote:
> On Mon, Apr 18, 2022 at 11:12:11AM +0200, Jason A. Donenfeld wrote:
> > Hi Greg,
> > 
> > On Mon, Apr 18, 2022 at 10:10:45AM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 4.9-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > ------------------ original commit in Linus's tree ------------------
> > > 
> > > From c40160f2998c897231f8454bf797558d30a20375 Mon Sep 17 00:00:00 2001
> > 
> > Apparently on 4.9.y, applying this commit cleanly also requires
> > 5a45a4c5c3f5e36a03770deb102ca6ba256ff3d7 to be cherry picked first.
> 
> That worked, thanks!

Hold up a second; that won't actually compile. Sorry about that, I'm
doing this all on my phone and a bit slow.

I'll do a standalone backport of c40160f without 5a45a4, and will mail
it out shortly.

Jason
