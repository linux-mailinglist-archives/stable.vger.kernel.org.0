Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7654A7726
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 18:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbiBBRzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 12:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240652AbiBBRzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 12:55:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80077C061714
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 09:55:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F2A761834
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 17:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3290C340EC;
        Wed,  2 Feb 2022 17:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643824530;
        bh=rpcNtULe9WjPkoAVK0o028dhFh24QfS0Xhd0sGaZ58s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BpIsQ/9/aH4GPFCoqxIKz2YshdB9g+6cxf9vydj6MNMJ6/RAZe6kiH/0RQVgjZ0Ip
         7PGB6Foy/lbGa8l3Fg0gBiYn7Acl73QbM+XEkDaMTNKYf5T46Si7FSZeNFTzFPw1YL
         YcqkhjpumSHB7blrwN0gxU3R5YBld2Qb296Eg0fU=
Date:   Wed, 2 Feb 2022 18:55:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guillaume Bertholon <guillaume.bertholon@ens.fr>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 4.4] KVM: x86: Fix misplaced backport of "work
 around leak of uninitialized stack contents"
Message-ID: <YfrFj5oM/C9b7DvG@kroah.com>
References: <YflzRMVgi+NB4ETP@kroah.com>
 <1643810428-6769-1-git-send-email-guillaume.bertholon@ens.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1643810428-6769-1-git-send-email-guillaume.bertholon@ens.fr>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 02, 2022 at 03:00:28PM +0100, Guillaume Bertholon wrote:
> On Tue, 1 Feb 2022 18:52:04 +0100, Greg KH wrote:
> > Note, 4.4.y is about to go end-of-life now, so I wouldn't spend much
> > more time on it if you do not want to.
> 
> Since I already wrote it, I will send one last patch on the 4.4.y branch,
> and then I will move to 4.9.y.
> 
> If you think it is a waste of your time, feel free to ignore it.

I took it, thanks!

> As a last contribution to 4.4, I can also report that backported
> commit b7cf6750c05a ("drm/amdgpu: when suspending, if uvd/vce was running.
> need to cancel delay work.") applies a fix for `amdgpu_uvd_suspend` in the
> function `amdgpu_uvd_resume`, but I am not sure of where the instruction
> should go, so I could not make a patch for this one.

Ah, odds are no one using that hardware is still using the 4.4 kernel.
It probably should just be reverted, but I'll not worry about it now.

If you want to run your tests/scripts on the 4.9 or other stable kernel
branches, to verify we didn't do much the same type of mistake there,
that would be most appreciated.  This is good stuff, thanks for doing
this.

> Sorry for the bad timing,

Not at all, thank you for the fixes!

greg k-h
