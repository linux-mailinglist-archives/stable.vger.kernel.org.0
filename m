Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B245F52AC
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 12:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiJEKfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 06:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiJEKfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 06:35:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A2A1ADB5;
        Wed,  5 Oct 2022 03:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1983861626;
        Wed,  5 Oct 2022 10:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C178C433D6;
        Wed,  5 Oct 2022 10:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664966110;
        bh=2znZxZt3ysEe1mUEXmmm4nj6ittyfZ3jvtOhifSXvJE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dM8qddusatRrT6jIzZTU/k1tXrTNY1hWIg4+Wh5D9SU0eFcDcYw0glkAy44xURpsY
         WjshGQkNTWxx8vhQNpzZmfOJpj+GYI31ndlhRrd2pZ826MAbEwqppcMV9lefVz0YVU
         ZztngHOy/kNi6drN0+VQ5HvPNW28sJVzk5GChdIU=
Date:   Wed, 5 Oct 2022 12:34:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     stable@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        bp@alien8.de, pbonzini@redhat.com, peterz@infradead.org,
        jpoimboe@kernel.org
Subject: Re: [PATCH 5.4 00/37] IBRS support // Retbleed mitigations
Message-ID: <Yz1dnksOuOcXPuk+@kroah.com>
References: <20221003131038.12645-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003131038.12645-1-cascardo@canonical.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 03, 2022 at 10:10:01AM -0300, Thadeu Lima de Souza Cascardo wrote:
> This backport introduces IBRS support to 5.4.y in order to mitigate Retbleed on
> Intel parts. Though some very small pieces for AMD have been picked up as well,
> "UNRET" mitigations are not backported, nor IBPB. It is expected, though, that
> the backport will report AMD systems as vulnerable or not affected, depending
> on the parts and the BTC_NO bit.
> 
> One note here is that the PBRSB mitigation was backported previously to the 5.4
> series, and this would have made things a little bit more complicated. So, I
> reverted it and applied it later on.
> 
> This has been boot-tested and smoke-tested on a bunch of AMD and Intel systems.

Thank you for these, I've queued them up now and will do a -rc release
with them to get some testing.

greg k-h
