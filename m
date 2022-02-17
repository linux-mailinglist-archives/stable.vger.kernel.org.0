Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D224BA936
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 20:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244974AbiBQTGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 14:06:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244971AbiBQTGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 14:06:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D51C811A0
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 11:05:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2972561C9C
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 19:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26F8C340E8;
        Thu, 17 Feb 2022 19:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645124750;
        bh=Twy6KJtSmEo8G8OKKxFGM0v7fzSP0d/z48TzmHmksoU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C7hxNYM/I/Fc23dyrbPhITOALAqgJGQKQO5E7j1n7Qi4ynCzC2LGJmPyyZ1IU2+vk
         p5TNtkYCGNZFDPsm+lFYdz/mubeGWry3cNBNzzLH9Vbi9sseyUL10J/sEUNG5t52E8
         kS8NXjpzZEFkpSYRCS2qXuJjioQM1Hry1OkqqGJ4=
Date:   Thu, 17 Feb 2022 20:05:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hao Luo <haoluo@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, laura@labbott.name,
        stable@vger.kernel.org
Subject: Re: [PATCH stable linux-5.16.y 0/9] Fix bpf mem read/write
 vulnerability.
Message-ID: <Yg6cixLJFoxDmp+I@kroah.com>
References: <20220216225209.2196865-1-haoluo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216225209.2196865-1-haoluo@google.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 02:52:00PM -0800, Hao Luo wrote:
> Hi Greg,
> 
> Please consider cherry-pick this patch series into 5.16.x stable. It
> includes a fix to a bug in 5.16 stable which allows a user with cap_bpf
> privileges to get root privileges. The patch that fixes the bug is
> 
>  patch 7/9: bpf: Make per_cpu_ptr return rdonly
> 
> The rest are the depedences required by the fix patch. This patchset has
> been merged in mainline v5.17. The patches were not planned to backport
> because of its complex dependences.

How about 5.10 or 5.15?  Any chance to backport them there too?

thanks,

greg k-h
