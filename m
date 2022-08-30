Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBF15A6739
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 17:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiH3PXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 11:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiH3PWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 11:22:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32A2153D12
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 08:22:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C562B615EB
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 15:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E1EC433C1;
        Tue, 30 Aug 2022 15:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661872965;
        bh=z3cAM+rmwVM+4W37cNbQsTTYSjWoOaPmObLdawqerdI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gpxmh1xxII7ZLXn1q7LmTCoZsRhM/Rflg5iEPB+wJkuNzf/G/hTR4U7KXrsQf09Sl
         XzrH+lN2UagVdQ6IUF/8yDHIhbNGICPDmiMP1eWSfi3+Unqq33YPGdnTnLR3SOPrY+
         RFLSwLbc/Zr65s+n5Mpu4NcTZ+DuobjMP1zryLrU=
Date:   Tue, 30 Aug 2022 17:22:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lucas Wei <lucaswei@google.com>
Cc:     stable@vger.kernel.org, Robin Peng <robinpeng@google.com>,
        Will Deacon <willdeacon@google.com>,
        Aaron Ding <aaronding@google.com>,
        Daniel Mentz <danielmentz@google.com>,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH] arm64: errata: Add Cortex-A510 to the repeat tlbi list
Message-ID: <Yw4rQpToPsHdE8fz@kroah.com>
References: <20220830150804.3425929-1-lucaswei@google.com>
 <CAPTxkvS5etzB6jexmjPCsma4W=Lb2qveKher7GmCpgULugtv9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPTxkvS5etzB6jexmjPCsma4W=Lb2qveKher7GmCpgULugtv9Q@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

On Tue, Aug 30, 2022 at 11:13:31PM +0800, Lucas Wei wrote:
> Hi Greg,
> 
> I send this mail through git send-email from kernel
> guide(https://www.kernel.org/doc/html/v4.10/process/email-clients.html).
> Would you help to confirm this could be applied on linux-5.15.y? Great thanks.

See my other response, what git id is this in Linus's tree?

Always give us context on what to do please.

thanks,

greg k-h
