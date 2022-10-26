Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4933A60DF0E
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 12:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiJZKww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 06:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiJZKwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 06:52:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC564314F;
        Wed, 26 Oct 2022 03:52:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 958E2B8217E;
        Wed, 26 Oct 2022 10:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C59C433C1;
        Wed, 26 Oct 2022 10:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666781568;
        bh=28oHDtf+Z19XMH+PJ+wwerIKNvblRcRilxvuwsC4Uxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cfRuDzdtdS9M/1hFePPjyIErNzNbMX2fmdHSwFvYCGZRDEgR5MuXxsS/cDnOtpQWQ
         7KfiKC0dR8EA1BJrSTpW4MEPq1/UmXk6mZ8Cfki8CwGBJnpt2mKoCOI0cnC0vTyOEQ
         8lRiDinDzZhbfLnuva1qTdAw3lr9xGqFUEVry2Zc=
Date:   Wed, 26 Oct 2022 12:52:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Evgenii Stepanov <eugenis@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64/mm: Consolidate TCR_EL1 fields
Message-ID: <Y1kRftSZdtbgMvYr@kroah.com>
References: <20221021222811.2366215-1-eugenis@google.com>
 <Y1OdfXuLmp/gr1Z4@kroah.com>
 <CAFKCwrg4=MdqNVcma-OnbmDDZXtporAr0x=uBn3rCO7dbC4hFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFKCwrg4=MdqNVcma-OnbmDDZXtporAr0x=uBn3rCO7dbC4hFQ@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 10:56:57AM -0700, Evgenii Stepanov wrote:
> On Sat, Oct 22, 2022 at 1:15 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > What stable kernel branch(es) do you want this applied to?
> 
> 5.15, sorry I forgot to mention that. Thank you!

Now queued up.

Note, you passed on a patch yet you did not sign-off on it.  Please fix
that up the next time you send patches in.

thanks,

greg k-h
