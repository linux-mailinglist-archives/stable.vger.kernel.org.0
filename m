Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89F266470E
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 18:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbjAJRJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 12:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbjAJRJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 12:09:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C5B63E7
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 09:09:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65F66615A2
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 17:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96148C433EF;
        Tue, 10 Jan 2023 17:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673370572;
        bh=zijp5N0/ktFnFgvdWVIb3M90CFKCNN0Ee6lMWDEEl8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c/aNrha1KMq1LNvU4kaObspX+XIe/C+2wQjWxJBNh4Uvs6VKqRWSSRd9AIJmQPBET
         7YKHUF8KB/dnuGYVg/mtkWN84z9FeXP4la2mQ1AaiH3NBof+Em03DnLcKC5MG3CdXG
         MpeuY//zEYU19MNQq5BbGl4cRdp+l/05j+gQQPaE=
Date:   Tue, 10 Jan 2023 18:09:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH stable] efi: random: combine bootloader provided RNG seed
 with RNG protocol output
Message-ID: <Y72bx/IyZ0zl6opA@kroah.com>
References: <20230110160416.2590-1-Jason@zx2c4.com>
 <Y72YyXw5HcsbDac1@kroah.com>
 <CAHmME9r_tDXfnvdPfyQ+m_EB_nyNHs65NMueNHnk2u5Paqt3RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9r_tDXfnvdPfyQ+m_EB_nyNHs65NMueNHnk2u5Paqt3RQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 05:57:21PM +0100, Jason A. Donenfeld wrote:
> Thanks! IIRC, this applies to all current stable kernels (now that
> you've sunsetted 4.9).

It does not apply cleanly to 5.4.y or 4.19.y or 4.14.y so can you
provide working backports for them?

thanks,

greg k-h
