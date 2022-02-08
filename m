Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A9F4ADC83
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 16:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243746AbiBHPXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 10:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379593AbiBHPXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 10:23:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453AFC061576
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 07:23:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9958615B4
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 15:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833E1C004E1;
        Tue,  8 Feb 2022 15:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644333810;
        bh=LHBps+X64Ov61T9ppg0f3uaNGNzZ413hD29hjbkbFuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M7dxJZWajsH99aL5OQHr5ULP0B/FhfEfCYRWjOd7pES7KdwQ1fuejV0CdIlAruFJc
         ahs1SxdeAsQgHv5Mb1bFAJ7iQuLARWoFjt136zgTEiwbzEsZOvdDWaeExPqmrAil6a
         tZcD7hfSezU0xE2XIuniylDyymn8OenPNXCyjFyw=
Date:   Tue, 8 Feb 2022 16:23:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH for-5.4,5.10] kbuild: simplify access to the kernel's
 version
Message-ID: <YgKK7xskaM6NroIM@kroah.com>
References: <20220207143643.234233-1-jiaxun.yang@flygoat.com>
 <e781d772-71a8-f073-66cf-0b415399413e@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e781d772-71a8-f073-66cf-0b415399413e@flygoat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 08, 2022 at 02:46:36PM +0000, Jiaxun Yang wrote:
> Oh Please ignore this series of backport.

For all branches?

> We find another way to workaround the issue.

What is your solution?  I am sure that others would be interested in it.

thanks,

greg k-h
