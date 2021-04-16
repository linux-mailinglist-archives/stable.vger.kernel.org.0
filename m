Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6884B3629E5
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 23:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238522AbhDPVEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 17:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235986AbhDPVEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 17:04:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53A88613C3;
        Fri, 16 Apr 2021 21:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618607045;
        bh=rd4spGJKEsyu0I0obvw/p7gJ8uSJIZ5iLddjVLOzHPU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ia0oTfaltA7xcAs926O5/e/Dx+SxfpvXrchU05H+9jmLpSDzQ5MWzfvjoHUs0HOWD
         XYI5PniGM1s6D/w2WIrVAQrrIr7H2H5Jv2RJwKSmbttSaBY+CamkvVyBhC+KIOhRTt
         4xEUD09XhDO1gyEYrntAvNkUFoeyenkse5H/soYMZTbbWslOb/rz6DMZuANv0CHeKP
         J8m49v8hUyox+i0gncul/xjR3/7c/1DwrnrbT63r9qmd4JQHmy+BWZ+9EK0WYNUEh3
         U1EqDN2DwVRKvpGdWbME9eWs0EOlNub0WkzoMWU/RI8LuL01tqmmf1LQr2GJ+x5I12
         IV2Sybmk2qqLA==
Date:   Fri, 16 Apr 2021 17:04:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Steve Beattie <steve.beattie@canonical.com>
Subject: Re: Please apply commit 7c03e2cda4a5 ("vfs: move cap_convert_nscap()
 call into vfs_setxattr()") to stable series from 5.10.y back to 4.19.y
Message-ID: <YHn7xAHwhcKDHdie@sashalap>
References: <YHnr2D9UO+pQO6uq@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YHnr2D9UO+pQO6uq@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 16, 2021 at 09:56:08PM +0200, Salvatore Bonaccorso wrote:
>Hi Greg, hi Sasha
>
>Please consider to apply commit 7c03e2cda4a5 ("vfs: move
>cap_convert_nscap() call into vfs_setxattr()") to stable series at
>least back to 4.19.y. It applies to there (but have not tested older
>series) and could test a build on top of 5.10.y with the commit.
>
>The commit was applied in 5.11-rc1 and from the commit message:
>
>    vfs: move cap_convert_nscap() call into vfs_setxattr()
>
>    cap_convert_nscap() does permission checking as well as conversion of the
>    xattr value conditionally based on fs's user-ns.
>
>    This is needed by overlayfs and probably other layered fs (ecryptfs) and is
>    what vfs_foo() is supposed to do anyway.
>
>Additionally, in fact additionally for distribtuions kernels which do
>allow unprivileged overlayfs mounts this as as well broader
>consequences, as explained in
>https://www.openwall.com/lists/oss-security/2021/04/16/1 .

Is it needed without the rest of the patches in the series it was sent
in
(https://lore.kernel.org/linux-fsdevel/20201207163255.564116-1-mszeredi@redhat.com/)?

-- 
Thanks,
Sasha
