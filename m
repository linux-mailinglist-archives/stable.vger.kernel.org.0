Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DF453FA6C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbiFGJz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240371AbiFGJy4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:54:56 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915F9D2444;
        Tue,  7 Jun 2022 02:54:53 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 29B4632009B2;
        Tue,  7 Jun 2022 05:54:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 07 Jun 2022 05:54:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1654595689; x=1654682089; bh=Hpeb2D3TKQ
        4H2hp9llZjHy9pjNtHqPGHYAg6yQDNXIM=; b=QgVq+0Cts//N9rzEk3Gar9CVtB
        Yu4kH/02B1QZNThE6M/E6U/ZI+kearWw63G8XfbiZwn2LxOiCmEJkh4FYZrOm0gN
        mcl4qAAm3c4ceVrN4Mqs97tbpyo2I2toh15olHfdZWcHsdB+DpnQIGqvftnaxHCg
        qrmBzHJ6jPHRcZ6nmz1oC72Tx1Zlcc2LqsHUUjwpiDR3h3EewyNC5R6G63OTfFTS
        iJUc7ERBZDf2JNcXtCfdCH1pwAKRLC2eTXHiol3Crcag4d8GMn4VqJM6ajkMshUR
        HcaEz1IVsWjyqmjMp/t6kEY3CLzZiX14MV9fubWvGPZHorwzvOPHj3CmqvoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1654595689; x=1654682089; bh=Hpeb2D3TKQ4H2hp9llZjHy9pjNtH
        qPGHYAg6yQDNXIM=; b=brhkbWnJQ3j0sGy328RgcklyTrNtBW22+700mu6rspgF
        bBnLCgicsvVC51aOPX95zUsGsSAFUuROE5dfk4Tt3Pu99UVVV7WsD3XZcPhuMxGs
        ntXVzpNafOtHHd1TmI3/qa9pEJdocCj87HDu6FSOnX1H4cdqTSGXU+Tdfd159+iG
        DI0rDe2qYyQWP4sIG4D7OZukGRI1juzngL7lU3tAeWEPpIrosDB2KzfsfBl+zYZ1
        G4MDuQWFfh+5+2hfS2vsn07NA8jJLtkmESf9PtlCfHMR4vgTU5BvXuJ2eLZsBTLe
        tXrcD/5qxZfEU5bmMY9fTpD6Zos/M6qNKN5Yut8NYA==
X-ME-Sender: <xms:aSCfYmQ1Tojaru80ntpwzXkeQBsruepS8u9pmiajNcNUSMbnn4cnEA>
    <xme:aSCfYryvaoX8vAPJ7M-de9VUxFouc7FDClEtgC4AhGY0KOGHH0I05DAN3E7xuxtW0
    JBhmL8SxpHjlQ>
X-ME-Received: <xmr:aSCfYj0TAKmHtru_apxnwAzf7LXeFQPtZrreQ1_6gwO5UeMBgTA-fyilOinK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedruddthedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:aSCfYiBrcO2sav_m2mSMHK2uhspP32DxZLWInanrhrO8Lk9hJCkC7w>
    <xmx:aSCfYvgg4NYfmkSSlxfQcUswwpYPjhLjnFr24I3uF3UNuxKwx7LpTw>
    <xmx:aSCfYup1k9DfVw5V84bV_EMIXGkh_rt9PPgwqPeztZD7YeHBuAkXwA>
    <xmx:aSCfYkbh8M9J5ZZtiAJK1_q8OMu5q-FvTahOn_5KI8IPRhLPYA3kXg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Jun 2022 05:54:48 -0400 (EDT)
Date:   Tue, 7 Jun 2022 11:54:46 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fscrypt@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5.10] ext4: only allow test_dummy_encryption when
 supported
Message-ID: <Yp8gZlE6oEhXIRzD@kroah.com>
References: <20220606231233.165860-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606231233.165860-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 04:12:33PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit 5f41fdaea63ddf96d921ab36b2af4a90ccdb5744 upstream.
> 
> Make the test_dummy_encryption mount option require that the encrypt
> feature flag be already enabled on the filesystem, rather than
> automatically enabling it.  Practically, this means that "-O encrypt"
> will need to be included in MKFS_OPTIONS when running xfstests with the
> test_dummy_encryption mount option.  (ext4/053 also needs an update.)
> 
> Moreover, as long as the preconditions for test_dummy_encryption are
> being tightened anyway, take the opportunity to start rejecting it when
> !CONFIG_FS_ENCRYPTION rather than ignoring it.
> 
> The motivation for requiring the encrypt feature flag is that:
> 
> - Having the filesystem auto-enable feature flags is problematic, as it
>   bypasses the usual sanity checks.  The specific issue which came up
>   recently is that in kernel versions where ext4 supports casefold but
>   not encrypt+casefold (v5.1 through v5.10), the kernel will happily add
>   the encrypt flag to a filesystem that has the casefold flag, making it
>   unmountable -- but only for subsequent mounts, not the initial one.
>   This confused the casefold support detection in xfstests, causing
>   generic/556 to fail rather than be skipped.
> 
> - The xfstests-bld test runners (kvm-xfstests et al.) already use the
>   required mkfs flag, so they will not be affected by this change.  Only
>   users of test_dummy_encryption alone will be affected.  But, this
>   option has always been for testing only, so it should be fine to
>   require that the few users of this option update their test scripts.
> 
> - f2fs already requires it (for its equivalent feature flag).
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> Link: https://lore.kernel.org/r/20220519204437.61645-1-ebiggers@kernel.org
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Both now queued up, thanks.

greg k-h
