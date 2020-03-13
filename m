Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFE7184175
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 08:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgCMHW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 03:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgCMHW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Mar 2020 03:22:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67FE5206EB;
        Fri, 13 Mar 2020 07:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584084176;
        bh=s8jXm3HAs5OHg9DFoQrxl6Qi/ieToacj5wAR/8wWSQ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QbnFOcN80B9BZ9kOrjismqZtjIbLGnV3sV7UwlpLImUb7I6xecuK92MrXFrp3esoG
         IIPoEsd5H+lGEMX2M88p+mXl5j1r1M9xxx8NVJ//j0KfK78ANEuv7DDOvRnqh1dHxW
         +RaOCoupFSTr9fyTWcNS9SOdSDSSHrhQEXFGJFwU=
Date:   Fri, 13 Mar 2020 08:22:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bruno Meneguele <bmeneg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        pmladek@suse.com, sergey.senozhatsky@gmail.com, rostedt@goodmis.org
Subject: Re: [PATCH] kernel/printk: add kmsg SEEK_CUR handling
Message-ID: <20200313072254.GA1960396@kroah.com>
References: <20200313003533.2203429-1-bmeneg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313003533.2203429-1-bmeneg@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 12, 2020 at 09:35:33PM -0300, Bruno Meneguele wrote:
> Userspace libraries, e.g. glibc's dprintf(), expect the default return value
> for invalid seek situations: -ESPIPE, but when the IO was over /dev/kmsg the
> current state of kernel code was returning the generic case of an -EINVAL.
> Hence, userspace programs were not behaving as expected or documented.
> 
> With this patch we add SEEK_CUR case returning the expected value and also a
> simple mention of it in kernel's documentation for those relying on that for
> guidance.
> 
> Signed-off-by: Bruno Meneguele <bmeneg@redhat.com>
> ---
>  Documentation/ABI/testing/dev-kmsg | 2 ++
>  kernel/printk/printk.c             | 4 ++++
>  2 files changed, 6 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
