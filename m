Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22EE456CF46
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 15:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiGJN0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 09:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGJN0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 09:26:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A5BEE2C
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 06:26:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61A2F6121F
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 13:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F085C3411E;
        Sun, 10 Jul 2022 13:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657459607;
        bh=1lwFW9bxhpTR4dah5koUD848PR2BuasJl6f2EikFS/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iKUk3C8SCbvHBDXTeNsgnzrHIWB9rCUqUwLVOPvnwLP3v8oXUCA53qWmqMTQXGNUt
         SFMqfLfj3zAGTLvqCWAuageqf5pNwKSZ3wyUK1agzGqKj7mG26IomRLWivjHpyW6Jo
         sX7uIKBIU/b8rlyz85DIG/LI6LYqCJ+ezG2PU/1I=
Date:   Sun, 10 Jul 2022 15:26:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     theflamefire89@gmail.com
Cc:     stable@vger.kernel.org, James Morris <jmorris@namei.org>
Subject: Re: [PATCH 1/2] security: introduce CONFIG_SECURITY_WRITABLE_HOOKS
Message-ID: <YsrTlX6MHQWazszI@kroah.com>
References: <20220710131055.12934-1-theflamefire89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220710131055.12934-1-theflamefire89@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 10, 2022 at 03:10:54PM +0200, theflamefire89@gmail.com wrote:
> From: James Morris <jmorris@namei.org>
> 
> commit dd0859dccbe291cf8179a96390f5c0e45cb9af1d upstream.
> 
> Subsequent patches will add RO hardening to LSM hooks, however, SELinux
> still needs to be able to perform runtime disablement after init to handle
> architectures where init-time disablement via boot parameters is not feasible.
> 
> Introduce a new kernel configuration parameter CONFIG_SECURITY_WRITABLE_HOOKS,
> and a helper macro __lsm_ro_after_init, to handle this case.
> 
> Signed-off-by: James Morris <james.l.morris@oracle.com>
> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> Acked-by: Casey Schaufler <casey@schaufler-ca.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Alexander Grund <git@grundis.de>
> ---
>  include/linux/lsm_hooks.h | 7 +++++++
>  security/Kconfig          | 5 +++++
>  security/selinux/Kconfig  | 6 ++++++
>  3 files changed, 18 insertions(+)

What kernel version(s) are you wanting this applied to?

And your email send address does not match your signed-off-by
name/address, so for obvious reasons, we can't take this.

thanks,

greg k-h
