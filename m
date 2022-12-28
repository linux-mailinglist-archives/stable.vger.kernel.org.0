Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4956F658511
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbiL1RFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235365AbiL1RFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:05:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A052420348
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:59:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 547E5B8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3715C433EF;
        Wed, 28 Dec 2022 16:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246771;
        bh=iEGaSj1v2RYiszKBidfEv59SvXTmvQxtF1f05jWAbSQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=efz6eeg870KLfhUUhWLz1DpNU914zY1zlMic2qantEP39Hv9y9kpHjC2hTHig9v5p
         YiPboekrnrn9d20wZJUVef10fMPIwL9B9VB5Laj0w7+rqFFuPrttNe4VWRmWDFdRZy
         oVHqTUxgICotaJ1hJZQLQj6Y3tlebYROIRtdNQCo=
Date:   Wed, 28 Dec 2022 16:45:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Message-ID: <Y6xkpmqxRQwDyLAb@kroah.com>
References: <20221228144330.180012208@linuxfoundation.org>
 <2bf086f8-aa9d-b576-ba8b-1fcfbc9a4ff1@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2bf086f8-aa9d-b576-ba8b-1fcfbc9a4ff1@applied-asynchrony.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 28, 2022 at 04:02:57PM +0100, Holger Hoffstätte wrote:
> On 2022-12-28 15:25, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.2 release.
> > There are 1146 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> I know this is already a large set of updates, but it would be great if
> commit 6f12be792fde994ed934168f93c2a0d2a0cf0bc5 ("mm, mremap: fix mremap()
> expanding vma with addr inside vma") could be added as well; it applies and
> works fine on top of 6.1.1.
> This fixes quite a few annoying mmap-related out-of-memory failures.

It's set up for future releases.  If this was such a big issue for
6.1-final, why wasn't it sent to Linus before 6.2-rc1?

thanks,

greg k-h
