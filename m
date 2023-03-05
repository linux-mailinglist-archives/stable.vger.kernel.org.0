Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264306AADF4
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 04:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjCEDGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 22:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCEDGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 22:06:17 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22294DBCA;
        Sat,  4 Mar 2023 19:06:16 -0800 (PST)
Date:   Sun, 5 Mar 2023 03:06:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
        s=mail; t=1677985574;
        bh=4iNvUXg+xGchA+t/SiNGqzsm5uYMI8vRwYpFFjAOz8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D4pnv6oxT6uZh/m3UvkWVLywxHJTe9Kijm7HskEPVlYtJcVmssbNbP6WkmAM7coyZ
         /cav1pksEdJh+qEHhhETjEePR48hoJslO5bxFZHmCkUoHmnubEGSQP3mHK42b9Qaa6
         nd8yUB/gZCR2drBraqhISJdA3ksfTdR9S06itasQ=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To:     Storm Dragon <stormdragon2976@gmail.com>
Cc:     stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Iurii Zaikin <yzaikin@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Request to backport "sysctl: fix proc_dobool() usability" to
 stable kernels
Message-ID: <09ee7747-3038-4d6c-b063-f0349fa52b6e@t-8ch.de>
References: <20230210145823.756906-1-omosnace@redhat.com>
 <9563010d-a5cf-49e2-8c51-f2e66f064997@t-8ch.de>
 <ZAQDxbTlaIoKb9yB@mjollnir>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZAQDxbTlaIoKb9yB@mjollnir>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 04, 2023 at 09:51:49PM -0500, Storm Dragon wrote:
> On Sun, Mar 05, 2023 at 02:18:11AM +0000, Thomas Weißschuh wrote:
> > This ioctl is used for the copy-and-paste functionality of the
> > screenreader "fenrir".
> > ( https://github.com/chrys87/fenrir )
> > 
> > Reported-by: Storm Dragon <stormdragon2976@gmail.com>
> > Link: https://lore.kernel.org/lkml/ZAOi9hDBTYqoAZuI@hotmail.com/
> 
> I believe this will also cause some loss of functionality in brltty as
> well:
> 
> https://brltty.app

The documentation of brltty indicates that they only use TIOCSTI as
fallback. By default a virtual keyboard device is used to simulate
typing.


Maybe it would also make sense to open a ticket to ArchLinux to enable
CONFIG_LEGACY_TIOCSTI again, as per the kernel default.

In accordance with the options help text:

"Say 'Y here only if you have confirmed that yout system's userspace
depends on this functionality to continue operating normally"

Could you create such a ticket if think it's necessary?
