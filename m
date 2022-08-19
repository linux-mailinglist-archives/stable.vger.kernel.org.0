Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F06599DAF
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 16:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349038AbiHSOnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 10:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348939AbiHSOni (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 10:43:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0571572683
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 07:43:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93ED06140D
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 14:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795A9C433C1;
        Fri, 19 Aug 2022 14:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660920216;
        bh=DL6W1EfFwIJ1tv9olwB40UVkBE+FWOZkYhRuRcrFsfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u32Vr6HGNyOJzEyq2rjXVbwjTdP/CipOsN7UiFD4VMOUw/8TiTe62A7WQaBHE+p6K
         UFkEJN/sx4/suej8j7DsIpvIKP56CMCHxB9ZC6ILYPKCkfkIiHoleRC03hsr7e118p
         uWOjNthRvAjKYnPu5YURoS1vr7NkLMLA0mFyflSI=
Date:   Fri, 19 Aug 2022 16:43:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Coiby Xu <coxu@redhat.com>
Cc:     bhe@redhat.com, msuchanek@suse.de, will@kernel.org,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.18-stable tree
Message-ID: <Yv+hlUo+42ldU5pD@kroah.com>
References: <16605775842425@kroah.com>
 <20220818041906.dgj4eqrpropved4e@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818041906.dgj4eqrpropved4e@Rk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022 at 12:19:06PM +0800, Coiby Xu wrote:
> Hi Greg,
> 
> This patch depends on three prerequisites but 5.18-stable tree has two
> prerequisites backported. So the full list of commit ids should be
> backported is shown below,
> 1. c903dae8941d ("kexec, KEYS: make the code in bzImage64_verify_sig generic")
> 2. 0d519cadf751 ("arm64: kexec_file: use more system keyrings to verify kernel image signature")
> 
> $ git checkout -b arm_key_5.18.y stable/linux-5.18.y                Updating
> files: 100% (43489/43489), done.
> branch 'arm_key_5.18.y' set up to track 'stable/linux-5.18.y'.
> Switched to a new branch 'arm_key_5.18.y'
> 
> $ git cherry-pick c903dae8941d 0d519cadf751 Auto-merging
> include/linux/kexec.h
> Auto-merging kernel/kexec_file.c
> [arm_key_5.18.y f3c9c5542700] kexec, KEYS: make the code in bzImage64_verify_sig generic
>  Date: Thu Jul 14 21:40:25 2022 +0800
>  3 files changed, 25 insertions(+), 19 deletions(-)
> [arm_key_5.18.y 532854860941] arm64: kexec_file: use more system keyrings to verify kernel image signature
>  Date: Thu Jul 14 21:40:26 2022 +0800
>  1 file changed, 1 insertion(+), 10 deletions(-)

Both now queued up, thanks.

greg k-h
