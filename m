Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D322019B787
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 23:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732527AbgDAVZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 17:25:57 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37197 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732357AbgDAVZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 17:25:57 -0400
Received: by mail-ot1-f65.google.com with SMTP id g23so1208183otq.4;
        Wed, 01 Apr 2020 14:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CxmQrvAa8GNHsreDb0m3HDvj3HWhFUiqQ7e9QqtLS8s=;
        b=vEziVXU+PhPWjGxw/xC7aLHAsGZIYKa2oODtmbkDYY7TjvkqHfsyLFqqjkTbm1bh7a
         GwIWWfviMwy7KYSNSVmERjfgkfn33VkZu/5gbCl7vj141PeSd8OaL/MhqS2iJ8QHzis3
         9Jv/7hnzNa1LSMfSIXHDSKB1AlJ7YRthLzf8aDbhYXbHs5e6CgG86Mqm7YyOcwDoQ5ss
         341M4XgoYS/QTAGPpzsXc0vnHnHx4CkgD9OTCfUiFslaSeNLW1EnMiOZVQ8SO8r5saoP
         amlmzBtoA4Pm7Cfx0A58OKzucr5E/LKJfRTwf77Q2zsLsCoxY8KxEsSGVIn0BUsMIdLo
         aDJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CxmQrvAa8GNHsreDb0m3HDvj3HWhFUiqQ7e9QqtLS8s=;
        b=Pxm2smp+4lQzqJ+6zhqPnSDpiW2V1AzNJVTZzufnwTcUsqj1FhxEBzwkUYIOkDh4QR
         aCFt7sevIh5XPVa9KM1yFA3y9IFjcxZzyiubcgt0hOcJ4HDajovVMCM19iQLrC3Me5Ja
         W017RTB79aixqA/87bkXsHIKD0uVS+DYOCW0MHenFMjZKwt2rHJeEa+kwqL1FjNGy7a3
         uLYVswZuPilRuOBEJBObMvgXtwHQLB7s1umZXEpziXlGJifCO3SJuad6/82KjZBWces5
         1K5vthwLHxml+Of0TQqss8RKky/zYrRTbrbSnW1euEKZqT7Uj+VCJfY8jwKwZSiMSaUN
         ZIjA==
X-Gm-Message-State: ANhLgQ2ew5FHJkBmJsnxNpjKNbRUVz/5SxgLWan5HclY9vs4xYGa3r0k
        Q9HtGNGDEpE7XelpXL1GjYb1Darg
X-Google-Smtp-Source: ADFU+vuL72kTYj3uqbOO7/4sMcpiAe9kQNEEsm+0iR0dEGuzJSt4814GqQbDb6W2N/zzsxd0qTA2pw==
X-Received: by 2002:a05:6830:1413:: with SMTP id v19mr17448119otp.41.1585776355915;
        Wed, 01 Apr 2020 14:25:55 -0700 (PDT)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id j90sm774717otc.21.2020.04.01.14.25.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Apr 2020 14:25:55 -0700 (PDT)
Date:   Wed, 1 Apr 2020 14:25:53 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dirk Mueller <dmueller@suse.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 4.9 061/102] scripts/dtc: Remove redundant YYLOC global
 declaration
Message-ID: <20200401212553.GA43588@ubuntu-m2-xlarge-x86>
References: <20200401161530.451355388@linuxfoundation.org>
 <20200401161543.380204082@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401161543.380204082@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 06:18:04PM +0200, Greg Kroah-Hartman wrote:
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
> @@ -38,7 +38,6 @@ LINECOMMENT	"//".*\n
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

Please see my email on the 5.5 version of this patch:

https://lore.kernel.org/stable/20200331192515.GA39354@ubuntu-m2-xlarge-x86/

As it stands how, this version of the patch does nothing.

Cheers,
Nathan
