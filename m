Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D594B62561C
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 10:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbiKKJDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 04:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbiKKJDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 04:03:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E1E83BAE;
        Fri, 11 Nov 2022 01:00:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 323F661EE7;
        Fri, 11 Nov 2022 09:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39589C433D6;
        Fri, 11 Nov 2022 09:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668157226;
        bh=DTTrKeOwLWDRFEP/rn+vcIu9TaQT1N03nqooF8hGYF0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WO0gZo3Ew9nKXZc1VbfYk9jtB2siiHNgG8GMZkGkm+NtPZeR+4uT+ooToSKiZO+f/
         OyJ+pP/3OmAgqK+jThriwJQ+BOtka1JOROozTotL4qwUMf60/EHqiV3fosBMBN5s7r
         OXRa1TtGHyabr/aRfpTL+veRiXWJuyCSD0OUPLaQ=
Date:   Fri, 11 Nov 2022 10:00:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Akira Kawata <akirakawata1@gmail.com>,
        linux-hardening@vger.kernel.org
Subject: Re: v5.10.y (was Re: [linux-stable-rc:linux-5.10.y 4906/9423])
 arch/mips/kernel/../../../fs/binfmt_elf.c:823:16: warning: variable
 'load_addr' set but not used)
Message-ID: <Y24PJ6+tQ+nLb0lX@kroah.com>
References: <202211100224.TrhZPz0k-lkp@intel.com>
 <202211091218.79009F93@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202211091218.79009F93@keescook>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 09, 2022 at 12:26:57PM -0800, Kees Cook wrote:
> Hi stable maintainers,
> 
> Can you please backport commit
> 
>   2b4bfbe09676 ("fs/binfmt_elf: Refactor load_elf_binary function")
> 
> to v5.10.y and v5.15.y?
> 
> It seems that commit
> 
>   0da1d5002745 ("fs/binfmt_elf: Fix AT_PHDR for unusual ELF files")
> 
> was backported into v5.10.110 and v5.15.33, but needs the additional
> patch for a clean build.

I would love to, but it does not apply cleanly.  Can you provide a
working backport?

thanks,

greg k-h
