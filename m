Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187E356CF48
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 15:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiGJN2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 09:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGJN2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 09:28:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6980EE2C
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 06:27:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80FD66121A
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 13:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830DCC3411E;
        Sun, 10 Jul 2022 13:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657459678;
        bh=GJb9XTTk4yoLIcTLiIRnhkmeqZK5I8UxbFjN1dFTexA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h7o02mY/MH8UapGvicLlKmq2PCVXdMrJUx05KXglSmfUi1ss4pv9wqcRuPNFs/67q
         HmRVcECLthkWjtVTVqgENoGm11KEuylC0SzltgjwWmJY7J5oXVSbWTr9RbtA3muef0
         oY6Sakq/tKt8SMK0oessNDcUtI2l9PeWN5NowZAE=
Date:   Sun, 10 Jul 2022 15:27:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     theflamefire89@gmail.com
Cc:     stable@vger.kernel.org, James Morris <jmorris@namei.org>
Subject: Re: [PATCH 1/2] security: introduce CONFIG_SECURITY_WRITABLE_HOOKS
Message-ID: <YsrT3AjiVaK4oCi/@kroah.com>
References: <20220710131055.12934-1-theflamefire89@gmail.com>
 <YsrTlX6MHQWazszI@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsrTlX6MHQWazszI@kroah.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 10, 2022 at 03:26:45PM +0200, Greg KH wrote:
> On Sun, Jul 10, 2022 at 03:10:54PM +0200, theflamefire89@gmail.com wrote:
> > From: James Morris <jmorris@namei.org>
> > 
> > commit dd0859dccbe291cf8179a96390f5c0e45cb9af1d upstream.
> > 
> > Subsequent patches will add RO hardening to LSM hooks, however, SELinux
> > still needs to be able to perform runtime disablement after init to handle
> > architectures where init-time disablement via boot parameters is not feasible.
> > 
> > Introduce a new kernel configuration parameter CONFIG_SECURITY_WRITABLE_HOOKS,
> > and a helper macro __lsm_ro_after_init, to handle this case.
> > 
> > Signed-off-by: James Morris <james.l.morris@oracle.com>
> > Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> > Acked-by: Casey Schaufler <casey@schaufler-ca.com>
> > Acked-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Alexander Grund <git@grundis.de>
> > ---
> >  include/linux/lsm_hooks.h | 7 +++++++
> >  security/Kconfig          | 5 +++++
> >  security/selinux/Kconfig  | 6 ++++++
> >  3 files changed, 18 insertions(+)
> 
> What kernel version(s) are you wanting this applied to?
> 
> And your email send address does not match your signed-off-by
> name/address, so for obvious reasons, we can't take this.

And of course, why is this needed in any stable kernel tree?  It isn't
fixing a bug, it's adding a new feature.  Patch 2/2 also doesn't fix
anything, so we need some explaination here.  Perhaps do that in your
0/X email that I can't seem to find here?

thanks,

greg k-h
