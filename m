Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630D0557F50
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbiFWQGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbiFWQGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:06:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897604506C
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 09:06:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2055861F0D
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 16:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76CDC3411B;
        Thu, 23 Jun 2022 16:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656000382;
        bh=qXrmtQK16lq4o6WvI2fGq2jKZoUtewVaocP0OG6vq2Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yqHlRPj/ctdp4eggpo0P/b9AIGtQt29N2C8MWLmYFzUawevpirZjskIMjkZDDeiqi
         E006OTazgxYPTOsmrkBwcq2iADv4MYU6DvCDHhsAoBpoC0SfOdpapshORh0tgmEXGV
         EjTSCzeM9R94/SzfHhM+J2G+63zxcBEr5wUkS1xY=
Date:   Thu, 23 Jun 2022 18:05:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [stable] Various security fixes
Message-ID: <YrSPWxFQ0+Wmc7mm@kroah.com>
References: <b5fe519ec956e0771a988c486291b6e8a0fefd17.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5fe519ec956e0771a988c486291b6e8a0fefd17.camel@decadent.org.uk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 22, 2022 at 12:31:13AM +0200, Ben Hutchings wrote:
> I've attached mailboxes with backports to 4.9, 4.14, and 4.19 of fixes
> for:
> 
> - TCP source port randomisation
> - xprtdma header length calculation
> - [4.9 only] swiotlb information leak
> - [4.9 only] FUSE pipe buffer information leak

All now queued up, thanks.

greg k-h
