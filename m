Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96CE6CAED8
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 21:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbfJCTIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 15:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729702AbfJCTIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 15:08:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D40A20873;
        Thu,  3 Oct 2019 19:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570129689;
        bh=5rCxKyu3RiZEwRfpsf3N4QH4gAu/zVk4UGOmUo+YyYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NHJKVcjsBPYrplAkRtd42nfCvc0yON94Seu1MxmsvRB3hKgJ4UuSScE8aw1rYq8oJ
         5+zvoW2mE5EzPPWtqzTcQBF6KmMaJqoVuQzuRK2TpC6kk8UdnC21X1rdVjpDr2+nSu
         IZMF+5crJBJyy4qy4YxBJ++XsoDWjtuHFxMBsAyg=
Date:   Thu, 3 Oct 2019 21:08:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Fran=E7ois?= Valenduc <francoisvalenduc@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/211] 4.19.77-stable review
Message-ID: <20191003190807.GA3585751@kroah.com>
References: <20191003154447.010950442@linuxfoundation.org>
 <ea824819-1047-e74b-2e71-814c3c2756e9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea824819-1047-e74b-2e71-814c3c2756e9@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 09:02:23PM +0200, François Valenduc wrote:
> This does not compile. I get this error:
> 
>   CC      drivers/ras/debugfs.o
> drivers/ras/debugfs.c:9:5: error: redefinition of 'ras_userspace_consumers'
>  int ras_userspace_consumers(void)
>      ^~~~~~~~~~~~~~~~~~~~~~~
> In file included from drivers/ras/debugfs.c:2:
> ./include/linux/ras.h:14:19: note: previous definition of
> 'ras_userspace_consumers' was here
>  static inline int ras_userspace_consumers(void) { return 0; }
>                    ^~~~~~~~~~~~~~~~~~~~~~~
> drivers/ras/debugfs.c:39:12: error: redefinition of 'ras_add_daemon_trace'
>  int __init ras_add_daemon_trace(void)
>             ^~~~~~~~~~~~~~~~~~~~
> In file included from drivers/ras/debugfs.c:2:
> ./include/linux/ras.h:16:19: note: previous definition of
> 'ras_add_daemon_trace' was here
>  static inline int ras_add_daemon_trace(void) { return 0; }
>                    ^~~~~~~~~~~~~~~~~~~~
> drivers/ras/debugfs.c:55:13: error: redefinition of 'ras_debugfs_init'
>  void __init ras_debugfs_init(void)
>              ^~~~~~~~~~~~~~~~
> In file included from drivers/ras/debugfs.c:2:
> ./include/linux/ras.h:15:20: note: previous definition of
> 'ras_debugfs_init' was here
>  static inline void ras_debugfs_init(void) { }
>                     ^~~~~~~~~~~~~~~~
> make[2]: *** [scripts/Makefile.build:304: drivers/ras/debugfs.o] Error 1
> make[1]: *** [scripts/Makefile.build:544: drivers/ras] Error 2
> make: *** [Makefile:1046: drivers] Error 2
> zsh: exit 2     LANG="C" make
> 
> 
> Does somebody have an idea about this ?

Do you have a .config that causes this?

thanks,

greg k-h
