Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5519C57469F
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 10:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbiGNIUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 04:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbiGNIUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 04:20:34 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9693A4B6;
        Thu, 14 Jul 2022 01:20:29 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id w188so646032vsb.6;
        Thu, 14 Jul 2022 01:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P7yWmbhC5FH2zK57bSWYnmzFw+mWX2gZuUaJyIsrO0E=;
        b=ZknV4n/4slEsbmUHBmPEpE2ZEFcUauYGyxgcil4DuD7ldrUUYqAN1mi9tv9ydnIB81
         w4qzko4Cj3dpMxmyurA/GVGtmx1t+IFBSPKoIXBNadS7DFDd6Z1E5IJbKhJFYAcnYnew
         BKRfUy4qLAdS5R2OJwAr9XK1DrPpUJkGF5uJ/PUaYkYYXZQfkQ5xXNBeQKjIepHfcaMW
         ISFQY57uJ0lRYX97JbOHqx9jQPwnAsz5iA6FrpJp6wxgvyMfHMCMUIjxUMlojXQuSReG
         zezQoPCV0uPSwTpX3mLorwUH+ZMg7Ej5f8tAR7ohrPMQO9jgbK7NTmKYNukr1djedvxj
         VTrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P7yWmbhC5FH2zK57bSWYnmzFw+mWX2gZuUaJyIsrO0E=;
        b=Rdc94h3pcbM4ZRfPwHTPN2Ryu2NjuLz0ORI6gwFXhIJ3ad5uDAUjIxx7XHKjrOWDx9
         mQvtwTZ/nHbhgptwGYzdfRobF2dPqTAWhEUBcYwhnYWPninFPWYmajglOoLkMV4AFYvf
         zQd989RAJ4vOHuY0ZlxpYp9dTDpbbrvrh76Xdu13rdRdyBIyNvt/6RsCuulc+93p6kdi
         mbpCjqhorbdoZRXrCFdjIweU3w7ZPvkz1ZdTDd0UUO0qfRHQnNBT021FOTLLZEmpD0Fg
         52l0WGlNonhInE2jxGd8LRlDTxNk8hOYkR4TH3p0FybGeZ9ez4/TdZptfqAu+C4IrO/4
         LABw==
X-Gm-Message-State: AJIora9E1QxSR4/PgVSoRcyO7rpbaML3VRmTZU40MQSH8sbaOjBT6dGa
        CH/IdPOci5sWp7HpvtgqhTpBHuRb5QW1CCSdNJI=
X-Google-Smtp-Source: AGRyM1spoqLWySpk8MeGgfx7AdmQFCz42DEQ17rAreZ88W27SuQVMPg0OsGZVZdB6EygKlIR4lji3MQFOfbDXwsVEeQ=
X-Received: by 2002:a67:6d86:0:b0:357:3d99:ec77 with SMTP id
 i128-20020a676d86000000b003573d99ec77mr3058519vsc.6.1657786828733; Thu, 14
 Jul 2022 01:20:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220714025649.41871-1-bagasdotme@gmail.com>
In-Reply-To: <20220714025649.41871-1-bagasdotme@gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 14 Jul 2022 10:20:03 +0200
Message-ID: <CAOi1vP__iYzy85CJtxP3qWAKt1OxoLWe3GQPNKwUJ3pmLpRYgg@mail.gmail.com>
Subject: Re: [PATCH next] Documentation: netfs: Use inline code for *foliop pointer
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Linux Documentation List <linux-doc@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 4:56 AM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>
> Sphinx reported inline emphasis warning on netfs:
>
> Documentation/filesystems/netfs_library.rst:384: WARNING: Inline emphasis start-string without end-string.
> Documentation/filesystems/netfs_library.rst:384: WARNING: Inline emphasis start-string without end-string.
> Documentation/filesystems/netfs_library:609: ./fs/netfs/buffered_read.c:318: WARNING: Inline emphasis start-string without end-string.
>
> These warnings above are due to unsecaped *foliop, which confuses Sphinx as
> italics syntax instead.
>
> Use inline code for the pointer.
>
> Link: https://lore.kernel.org/linux-doc/202207140742.GTPk4U8i-lkp@intel.com/
> Fixes: 157be6ddd9e438 ("netfs: do not unlock and put the folio twice")
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Xiubo Li <xiubli@redhat.com>
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Documentation/filesystems/netfs_library.rst | 6 +++---
>  fs/netfs/buffered_read.c                    | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/filesystems/netfs_library.rst b/Documentation/filesystems/netfs_library.rst
> index 8d4cf5d5822de4..73a4176144b3b8 100644
> --- a/Documentation/filesystems/netfs_library.rst
> +++ b/Documentation/filesystems/netfs_library.rst
> @@ -382,9 +382,9 @@ The operations are as follows:
>     conflicting state before allowing it to be modified.
>
>     It may unlock and discard the folio it was given and set the caller's folio
> -   pointer to NULL.  It should return 0 if everything is now fine (*foliop
> -   left set) or the op should be retried (*foliop cleared) and any other error
> -   code to abort the operation.
> +   pointer to NULL.  It should return 0 if everything is now fine (``*foliop``
> +   left set) or the op should be retried (``*foliop`` cleared) and any other
> +   error code to abort the operation.
>
>   * ``done``
>
> diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
> index 8fa0725cd64981..0ce53585215106 100644
> --- a/fs/netfs/buffered_read.c
> +++ b/fs/netfs/buffered_read.c
> @@ -320,8 +320,8 @@ static bool netfs_skip_folio_read(struct folio *folio, loff_t pos, size_t len,
>   * pointer to the fsdata cookie that gets returned to the VM to be passed to
>   * write_end.  It is permitted to sleep.  It should return 0 if the request
>   * should go ahead or it may return an error.  It may also unlock and put the
> - * folio, provided it sets *foliop to NULL, in which case a return of 0 will
> - * cause the folio to be re-got and the process to be retried.
> + * folio, provided it sets ``*foliop`` to NULL, in which case a return of 0
> + * will cause the folio to be re-got and the process to be retried.
>   *
>   * The calling netfs must initialise a netfs context contiguous to the vfs
>   * inode before calling this.
> --
> An old man doll... just what I always wanted! - Clara
>

Hi Bagas,

I folded this fixup into the original patch and added your
Signed-off-by.  I hope you don't mind.

Thanks,

                Ilya
