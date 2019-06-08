Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 197CD39B7C
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 09:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfFHHNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 03:13:44 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38709 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbfFHHNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jun 2019 03:13:44 -0400
Received: by mail-lj1-f195.google.com with SMTP id o13so3607444lji.5
        for <stable@vger.kernel.org>; Sat, 08 Jun 2019 00:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DegCVmGIdd0bLWL8bA/nsvYbcUC9KgI6I8cADXdqPho=;
        b=Wsud5zYlPvfWDBl2yhnNC7ok6cBEDBcBXxxLGFBcGkEFEBv/7kPpcCPNBJt/GDoz2t
         YTCmuFmNoj3oT9tjVAb4LnIOAkJAiDVjrO3WaUa5dGXRfl8Af/ljGlRHqAN4z6qWHF23
         1LdDpK4ClPi9GaNDGXumiwke6q+5i0eAcDpOOZX6bDCdnKSfmavGTayjR6dV2Vxwd+M7
         AGzL0SHaU9/s7uVirttj27vdXUIOxxmTlUHNYBxH9dotNILbM8DBUIzIXOE4l7T8T3hO
         GBnFDynfhXR8CM4sjJN6QjRpE1U87h36uKQKsmdevfFtPwM+ZfKWHrc8cFjoJlRXvdZH
         jX/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DegCVmGIdd0bLWL8bA/nsvYbcUC9KgI6I8cADXdqPho=;
        b=DD3HQV2AB7V2C9YTVbaOitupEvSCGmf9LTL4JEM+he7tTv+cT/MknL86TTlNBfIdPH
         XviiR1MaIgI/J8RyPmuen5XtqEUJoAvduo7ywFuYX/7nzo2IXp5f0+XcC9ivfZzb4Dd8
         BOEhGeOVu413pvCZiiossGJMpS6dWql3IMa2yurfUxnkJ5u7+74i08a42FzlQExgKMU8
         qbFAOtkrm1YpipKOgtmbABmaIDJI7P2W4lyv01j+fvAu0iUYZpkBu27DUgTrpBFz5Mor
         H/QNy4geA0uxnQscrR01bVlIs1N/gB4gze1TK2wjYqtM+ujQCMOm3d4UNSTbuMt+UFvY
         KJfw==
X-Gm-Message-State: APjAAAWffecch0iztn0SjH4An1bUbNUvFYsfR4RoTcQtA2n5CgmGMakC
        4WyA+4pGGIeLluLNHIyjc6Qj6Xa3WFWY1L+LbTP1SA==
X-Google-Smtp-Source: APXvYqyKv5fkqvShFOYSR0yEMa8+LXGoV/8oU6hLRVakSWiNWIqbdBNLWpLiaEG/rKoIbph8ziLNaH657x76oNKFsHk=
X-Received: by 2002:a2e:81c4:: with SMTP id s4mr18170669ljg.182.1559978022100;
 Sat, 08 Jun 2019 00:13:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190607153848.271562617@linuxfoundation.org>
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 8 Jun 2019 12:43:31 +0530
Message-ID: <CA+G9fYtmR8mtSzxLzKjCuKaWzd=zzyFKnUG0pG69+EkEpRQA0A@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/69] 4.14.124-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, fdmanana@suse.com
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 7 Jun 2019 at 21:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.124 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 09 Jun 2019 03:37:08 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.124-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

compile kernel module failed for arm and i386.

> Filipe Manana <fdmanana@suse.com>
>     Btrfs: incremental send, fix file corruption when no-holes feature is enabled
>
> Filipe Manana <fdmanana@suse.com>
>     Btrfs: fix fsync not persisting changed attributes of a directory
>
> Filipe Manana <fdmanana@suse.com>
>     Btrfs: fix race updating log root item during fsync
>
> Filipe Manana <fdmanana@suse.com>
>     Btrfs: fix wrong ctime and mtime of a directory after log replay

fs/btrfs/inode.c: In function 'btrfs_add_link':
fs/btrfs/inode.c:6590:27: error: invalid initializer
  struct timespec64 now = current_time(&parent_inode->vfs_inode);
                          ^~~~~~~~~~~~
fs/btrfs/inode.c:6592:35: error: incompatible types when assigning to
type 'struct timespec' from type 'struct timespec64'
  parent_inode->vfs_inode.i_mtime = now;
                                  ^
fs/btrfs/inode.c:6593:35: error: incompatible types when assigning to
type 'struct timespec' from type 'struct timespec64'
  parent_inode->vfs_inode.i_ctime = now;
                                  ^

Full build log link,
https://ci.linaro.org/job/openembedded-lkft-linux-stable-rc-4.14/487/DISTRO=lkft,MACHINE=intel-core2-32,label=docker-lkft/consoleText

-- 
Linaro LKFT
https://lkft.linaro.org
