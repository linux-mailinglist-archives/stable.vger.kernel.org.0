Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB8B63F57D
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 17:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbiLAQke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 11:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbiLAQkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 11:40:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C67798395
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 08:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDC8662060
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 16:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6947C433D6;
        Thu,  1 Dec 2022 16:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669912809;
        bh=//pZ1rFIz1l6lbDUMqQrq8hDK5d1VqwBP7IMrfJ7J7U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bFboS8CWbCGqrLDvKfVm05bNSW3wHY04wDbSc2kgVdpQlqMk5k2XGXZQ2w22LbU6U
         W3BO8S/x9Cef6W7NwFWntZweoOUmDW/9XJrYJjG8ZJOf6TVP5ikBYHBLG+Fn7obzF9
         L0ifRjfLdjVbWjy+5XC1BEvX95dTTqSK+5DfGjrs=
Date:   Thu, 1 Dec 2022 17:40:05 +0100
From:   'Greg KH' <gregkh@linuxfoundation.org>
To:     John Aron <john@aronetics.com>
Cc:     'Mark Salter' <mark.salter@canonical.com>,
        'Mark Lewis' <mark.lewis@canonical.com>,
        regressions@lists.linux.dev, stable@vger.kernel.org,
        kernelnewbies@kernelnewbies.org
Subject: Re: OBJTOOL Build error
Message-ID: <Y4jY5TTLkfoSb0CJ@kroah.com>
References: <041601d90035$4f738de0$ee5aa9a0$@aronetics.com>
 <Y3/c73nZVdHCBdZo@kroah.com>
 <0be301d90514$9250bd70$b6f23850$@aronetics.com>
 <Y4hCVMrg9oZt+YAL@kroah.com>
 <002e01d9059c$eb052400$c10f6c00$@aronetics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002e01d9059c$eb052400$c10f6c00$@aronetics.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 01, 2022 at 10:52:16AM -0500, John Aron wrote:
> On Wed, Nov 30, 2022 at 06:36:19PM -0500, John Aron wrote:
> > One C file and a few header files.
> 
> Can you provide a link to them so that we can see what might be the problem?
> Without that, it's impossible to help, sorry.
> --
> The repo is in a private repo online, the entry is:
> static int __init kernel_module_start(void)

<snip>

Without the full source, it's pretty impossible to help, sorry.

thanks,

greg k-h
