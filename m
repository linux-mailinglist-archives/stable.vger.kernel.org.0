Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD91E6671B3
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjALMJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbjALMIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:08:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE7230D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 04:03:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64312B81E32
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 12:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986C1C433D2;
        Thu, 12 Jan 2023 12:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673525004;
        bh=8Bvla2RHsxVnjw8SVYyrPpK9xh9IVLmTqZt3uMysAM4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nOEQuU3iW6PfTC39bnCHseoVFJsBegWJiUh2OXLqOOXUfcyOaeSqUPWnpOQukkG9a
         N26LraRW+eV0pZ3RjF4mVTh8jP922fxid+dH34DtwdfSJbCfCOyLU2SfoQOXs2VdvY
         lkwADs7sdSFZpzSWZpdoWmQ4FcfwsOS5AgZunSfU=
Date:   Thu, 12 Jan 2023 13:03:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Helge Deller <deller@gmx.de>
Cc:     stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>
Subject: Re: [STABLE] [PATCH] parisc: Align parisc MADV_XXX constants with
 all other architectures
Message-ID: <Y7/3BGuydMVoVFSy@kroah.com>
References: <Y73ELN4bGardXInF@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y73ELN4bGardXInF@p100>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 09:01:48PM +0100, Helge Deller wrote:
> Hi Greg,
> can you please consider adding this patch to the 6.0-stable series
> (actually kernels 5.18 up to and including 6.0)?
> It's a backport of upstream commit 71bdea6f798b425bc0003780b13e3fdecb16a010

6.0 is now end-of-life, sorry.  No need to worry about that one anymore!

greg k-h
