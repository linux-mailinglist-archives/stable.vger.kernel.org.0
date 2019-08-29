Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D157A1A22
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 14:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfH2MdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 08:33:02 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36296 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfH2MdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 08:33:02 -0400
Received: by mail-pf1-f196.google.com with SMTP id w2so1964573pfi.3
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 05:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=9ZElwPYDF3hkOnMCGjcM+ceRcwzA1o3dcs++AfpAr2Q=;
        b=lP6LwiRcX+CKxi5zlrF6hLA057Q9b6RXBcsjtZ6JuCvNO1PRIozgrLSburoI81dlVq
         fHlRAYZhCfXk1HMFhCands6o3UPVnfJHNS8mMMb8cC1chwZY40v3AEg2mQrdx7b4mBDz
         gs9VjfEwgMwnifKhXYjm9ZmOHhjb4PDaFq4KDlhv1j6sqHDpqhCMFgJohx4NmSoD9cAy
         XeTx34Sk7PWw2EFMhMlDU+SF9+dOnXfmg6WVhvys914Qp5kolTpfHtM+ngUNyG/YaRiJ
         Ky+OBPf5s0wVSo/s9ilsBRUQCJeYkSpHWXpODxRaZXTgW2XiiqtU4paqf/hRTIhAadK5
         EdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=9ZElwPYDF3hkOnMCGjcM+ceRcwzA1o3dcs++AfpAr2Q=;
        b=tO79h+tw8igYSyjTsneL89Ap+ihg/QZiPqiavyHVpipp7nHc2FelUOPIsqImsWNprO
         mw8RTy5GZxGs2J3twitWkoKh03MtWmhQr1qsIrQckGa9PcMApabigjgiK75qkGiRdieE
         PxIgXf9BVeVSxeLty5D17uyH0IAtEGp0obAUiqzIxjOUD+HzgseRDPSLAeBSAQUPjTVC
         SzKtCA/FeygkuXKnQrGWug4PnhF9MxU4xm+Grl/MK/B1/keJoT5+V3FvqcK7BbxZZYRF
         2otstI4VxvXUfWdRrsZD4uebnxNY8hFvCli+P0Y76Bl9o1cmnnqV4sOYVyi/y5TwMWYa
         s5tg==
X-Gm-Message-State: APjAAAVPSSqvkzJdGF2MHKtVhP6jeb3AZaRuBblx56AmAU93Y9tD6oQB
        da628cgnaqNSKzpnQmGvTi4=
X-Google-Smtp-Source: APXvYqxXWpFDowq+mrgADSaL9kDxl5NO5DmSl2RxCj3g9vs9sSklVTMZHbWEXe5tYJo+UgTxENP2OQ==
X-Received: by 2002:a63:494d:: with SMTP id y13mr8226371pgk.109.1567081981866;
        Thu, 29 Aug 2019 05:33:01 -0700 (PDT)
Received: from localhost ([39.7.51.95])
        by smtp.gmail.com with ESMTPSA id v12sm2126016pgr.86.2019.08.29.05.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 05:33:01 -0700 (PDT)
Date:   Thu, 29 Aug 2019 21:32:57 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Jiri Slaby <jslaby@suse.cz>
Cc:     =?iso-8859-1?Q?Fran=E7ois?= Valenduc <francoisvalenduc@gmail.com>,
        stable@vger.kernel.org, henryburns@google.com,
        sergey.senozhatsky@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Kernel 5.2.11 dpes not compile
Message-ID: <20190829123257.GA8726@jagdpanzerIV>
References: <CACU-xRs6-oog+4gG-zsn-J9MCRS8xF3y-1Aw+yq_iv6PHP7d+A@mail.gmail.com>
 <015acb3e-6722-70c8-b0d5-822f1505fed2@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <015acb3e-6722-70c8-b0d5-822f1505fed2@suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (08/29/19 14:28), Jiri Slaby wrote:
[..]
> as is its definition in the structure (and its other uses).
> 
> > ./include/linux/wait.h:67:26: note: in definition of macro ‘init_waitqueue_head’
> >    __init_waitqueue_head((wq_head), #wq_head, &__key);  \
> >                           ^~~~~~~
> > scripts/Makefile.build:278: recipe for target 'mm/zsmalloc.o' failed
> > make[1]: *** [mm/zsmalloc.o] Error 1
> > Makefile:1073: recipe for target 'mm' failed
> > 
> > You can find my configuration file attached.
> 
> You forgot to attach it, but you have CONFIG_COMPACTION=n, I assume.
> 
> > Does anybody have any idea about this ?
> 
> Sure, this will fix it (or turn on compaction):
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -2413,7 +2413,9 @@ struct zs_pool *zs_create_pool(const char *name)
>         if (!pool->name)
>                 goto err;
> 
> +#ifdef CONFIG_COMPACTION
>         init_waitqueue_head(&pool->migration_wait);
> +#endif

The fix is correct. I believe Andrew already has the same patch
in his tree.

	-ss
