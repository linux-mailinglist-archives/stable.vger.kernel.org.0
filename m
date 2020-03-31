Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E721992BA
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbgCaJx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:53:27 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44095 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729425AbgCaJx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 05:53:27 -0400
Received: by mail-oi1-f196.google.com with SMTP id v134so18365663oie.11;
        Tue, 31 Mar 2020 02:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZJf+8fO1Di3E+rPRN5mDE1xuCphkytmjd4M4kAVzgCM=;
        b=XXJ2/Xh5u0ckiJFmd6yNoQkREmmgsJkkg4YsEaOLDUehbmkcJ93XWoKudEuETsfUF7
         oHN3t8JtTKTioLE4665fREueOYo5Mdn8XNXyTn0GsEmnKxtqzByQJkoGHuaoXWa5Ic5N
         eGWz8kBQRJf11yBaEzUQfvbo+rcH8GpW/Ns38MnnKWJs/ZuXxBuIVLSUUcH+RHb5GhrQ
         yz8eNXYNFuOd2IxxB1nLIgkxdJFvKh5KDvssbYn1TTLvrTJREJVNV7wTgFHen+7RI7zn
         22dJuxs/CXSLbW/1IJNua+c1sqBMY4KLWZePXUqhTzgQ71UTm7h1ipNRhGJzO4WBzX34
         w/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZJf+8fO1Di3E+rPRN5mDE1xuCphkytmjd4M4kAVzgCM=;
        b=XzsIaBEPkF1ZWM9bSV8uXfA8Cv9tWhFIfbnvgTxUqa867HRHodEw4Vpfh9PNrBre/b
         fS+jNrSvH8e+iuiodVX2fI4W2emv1E8emGCeZV3HJh5itNeygCJy+47HI2USMmi0wxZq
         bkVO80YeG5ot+Bk1bl1iVfNGoA+gsGr29V5HodpfeSRvz5eYUtTfUKDBqjmV9kCvJwn7
         xac0i/EWT1+/zeGZ31mLdvA5BYUbQMrmeWtgU5NwDAyiZ+BeaK4kM+xXU/YHtSmd0XQr
         kRJ43o2uju6zCPXoUQ8aYTtFs2L8UVvnXUAHO34S/KuRKxdslM0Hzwtd+eKLgWth0G+t
         wHtg==
X-Gm-Message-State: ANhLgQ1D/JFtLr51dL7JGAfXJC+1Zc+0YDt+o5RiInOZUOx9lEiyzTEL
        1Xmu9x58dCwKCbw78JQ9s3E=
X-Google-Smtp-Source: ADFU+vvG0/OMmV3QMr8IkYw11Tdp20RKzY0vxktD6SyERQOVBnrAsYwXlvOx1yYNLDpSlAf/Rcx9ww==
X-Received: by 2002:aca:cf8a:: with SMTP id f132mr1375989oig.151.1585648406904;
        Tue, 31 Mar 2020 02:53:26 -0700 (PDT)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id t4sm4387340otm.45.2020.03.31.02.53.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 31 Mar 2020 02:53:25 -0700 (PDT)
Date:   Tue, 31 Mar 2020 02:53:23 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dirk Mueller <dmueller@suse.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 5.5 102/170] scripts/dtc: Remove redundant YYLOC global
 declaration
Message-ID: <20200331095323.GA32667@ubuntu-m2-xlarge-x86>
References: <20200331085423.990189598@linuxfoundation.org>
 <20200331085435.053942582@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331085435.053942582@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 10:58:36AM +0200, Greg Kroah-Hartman wrote:
> From: Dirk Mueller <dmueller@suse.com>
> 
> commit e33a814e772cdc36436c8c188d8c42d019fda639 upstream.
> 
> gcc 10 will default to -fno-common, which causes this error at link
> time:
> 
>   (.text+0x0): multiple definition of `yylloc'; dtc-lexer.lex.o (symbol from plugin):(.text+0x0): first defined here
> 
> This is because both dtc-lexer as well as dtc-parser define the same
> global symbol yyloc. Before with -fcommon those were merged into one
> defintion. The proper solution would be to to mark this as "extern",
> however that leads to:
> 
>   dtc-lexer.l:26:16: error: redundant redeclaration of 'yylloc' [-Werror=redundant-decls]
>    26 | extern YYLTYPE yylloc;
>       |                ^~~~~~
> In file included from dtc-lexer.l:24:
> dtc-parser.tab.h:127:16: note: previous declaration of 'yylloc' was here
>   127 | extern YYLTYPE yylloc;
>       |                ^~~~~~
> cc1: all warnings being treated as errors
> 
> which means the declaration is completely redundant and can just be
> dropped.
> 
> Signed-off-by: Dirk Mueller <dmueller@suse.com>
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> [robh: cherry-pick from upstream]
> Cc: stable@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  scripts/dtc/dtc-lexer.l |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- a/scripts/dtc/dtc-lexer.l
> +++ b/scripts/dtc/dtc-lexer.l
> @@ -23,7 +23,6 @@ LINECOMMENT	"//".*\n
>  #include "srcpos.h"
>  #include "dtc-parser.tab.h"
>  
> -YYLTYPE yylloc;
>  extern bool treesource_error;
>  
>  /* CAUTION: this will stop working if we ever use yyless() or yyunput() */
> 
> 

Hi Greg,

Replying here simply because I am not subscribed to the stable-commits
mailing list and there does not appear to be an easy way to reply to one
of those emails through the existing archives because they are not as
nice as lore.kernel.org.

This patch is fine for the current releases in review but 4.4, 4.9, and
4.14 need to have the patch applied to scripts/dtc/dtc-lexer.lex.c_shipped
because prior to commit e039139be8c2 ("scripts/dtc: generate lexer and
parser during build instead of shipping"), that was the file that was
being built. Running the command below in the stable-queue repo works
for me and I have tested all of the patches to make sure they still
apply (albeit with some fuzz).

$ sed -i 's;scripts/dtc/dtc-lexer.l;scripts/dtc/dtc-lexer.lex.c_shipped;g' \
queue-{4.4,4.9,4.14}/scripts-dtc-remove-redundant-yyloc-global-declaration.patch

If you would prefer a set of patches, let me know.

Cheers,
Nathan
