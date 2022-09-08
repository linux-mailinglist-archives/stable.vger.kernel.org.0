Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001495B1BEB
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 13:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiIHLww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 07:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiIHLwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 07:52:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15E8127552
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 04:52:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66EB3B820D3
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 11:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A408C433D6;
        Thu,  8 Sep 2022 11:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662637968;
        bh=x+F0rEo6xO5POmYrW0rKGz2BB067TvOmeZfLDmASst4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dvsPWaCF2tlc9qywa7ykyqMlSUjQf0KAuNG2czpY0Z4H8papfjWoHOLhRjkeVJhh0
         FFOeyU7eS9ix94XQDL+WbgfoH6R7nTGRDCucixUIlW3cbUYMiqBVHzkYxYRqMWd9QQ
         Kn87cpy92u5IG8MTEmE3iiXnn0Wj+9CiNYbuVaAI=
Date:   Thu, 8 Sep 2022 13:53:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org, Jiri Slaby <jirislaby@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH 5.10 0/2] tty: n_gsm: fix lock handling problems in
 gsmld_write()
Message-ID: <YxnXncgEmXtRfevx@kroah.com>
References: <20220906182212.25261-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906182212.25261-1-pchelkin@ispras.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 09:22:10PM +0300, Fedor Pchelkin wrote:
> The lock handling problems in gsmld_write(), reported by Syzkaller, have
> been fixed by the following patches which can be cleanly applied to the
> 5.10 branch.

All now queued up, thanks.

greg k-h
