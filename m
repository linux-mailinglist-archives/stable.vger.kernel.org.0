Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A210419760B
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 09:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbgC3H5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 03:57:53 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35641 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729474AbgC3H5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 03:57:53 -0400
Received: by mail-oi1-f194.google.com with SMTP id t25so14928754oij.2;
        Mon, 30 Mar 2020 00:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+ipscCDhCltPMVSXcwaABkat0P1XLNamIU3q22ca/b4=;
        b=eprL7mwrrsjCnp/4zHjc/j1s9AJgIbn7qTQgEjaMpAPLqQSM2S7IFpN7J4j+e9uZz7
         0g2S1iDnBRmuq2ib0noJraYxCDZR98cIBrMdSWT2hEBhgeWxj08mG5X7KZYmyXJPCU0i
         KynIoAHVq9sLwieMz5eFTLTcNKchCG0BcUG9XpBZYKkRcX6mijmWMaE6xWuO/aHaxpGE
         5jgXZh4nIWuYxBob3+SW8ZhCCE/Cy+UvFXkMCNGS/LZBNscbBuiJd6YC9A6xKTjNK3zG
         spPnbJCX3qgRTyZUOc0S5pKc9LTZYqP2N3h9XcBRC/s40pHLopVUYpdRiyZv6XGvTrti
         j3kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+ipscCDhCltPMVSXcwaABkat0P1XLNamIU3q22ca/b4=;
        b=q95jLwB3ywdQbNk6A9RCbbuL0gJYtRSfHIpNg+6PnNejIdNZKSbu41eDoBgD6x6lIn
         4acc/ZXlwLh67diva8D5H7l4FpEv5vtyog2jog8loX7pQZMqnOuxZzHba/PR6Sw7lrzq
         bbDv/I0mZWvhMRBhturwSwXkZD09qgkyUyLBTjD2ODfw/3RkJiOKkPP9Q+YTBV48QbX0
         6Sfa+uQpgQIBO8vViTSUYyLQ4FavJZxRYpxUU9r4Lh8v7eWgWNm1E9VjKe510sElrwAu
         Kn5md6UwM2xaRNju3zp8o0jzK+p4ZtfieRLF5aeVuEB9GtCdwBqexIaKpKImUEz2/W4E
         HELg==
X-Gm-Message-State: ANhLgQ0BuIEdIkckuYC8hzgJS/E7W694xbLCaxH++prEvDlWvdu1G7wH
        QdBOiaQaNz8bDodpLEJRTVg=
X-Google-Smtp-Source: ADFU+vtrqQS7LDW0ZaqXWmRdN1F1p47K+hiXfWjqZgJQouPW+xEwSglG1RNMjCP/sRYf9Vt005/AZg==
X-Received: by 2002:aca:b854:: with SMTP id i81mr6490664oif.22.1585555070879;
        Mon, 30 Mar 2020 00:57:50 -0700 (PDT)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id o1sm4131334otl.49.2020.03.30.00.57.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Mar 2020 00:57:50 -0700 (PDT)
Date:   Mon, 30 Mar 2020 00:57:47 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Clement Courbet <courbet@google.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH v2] powerpc: Make setjmp/longjmp signature standard
Message-ID: <20200330075747.GA19343@ubuntu-m2-xlarge-x86>
References: <20200327100801.161671-1-courbet@google.com>
 <20200330064323.76162-1-courbet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330064323.76162-1-courbet@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 08:43:19AM +0200, Clement Courbet wrote:
> Declaring setjmp()/longjmp() as taking longs makes the signature
> non-standard, and makes clang complain. In the past, this has been
> worked around by adding -ffreestanding to the compile flags.
> 
> The implementation looks like it only ever propagates the value
> (in longjmp) or sets it to 1 (in setjmp), and we only call longjmp
> with integer parameters.
> 
> This allows removing -ffreestanding from the compilation flags.
> 
> Context:
> https://lore.kernel.org/patchwork/patch/1214060
> https://lore.kernel.org/patchwork/patch/1216174
> 
> Signed-off-by: Clement Courbet <courbet@google.com>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> ---
> 
> v2:
> Use and array type as suggested by Segher Boessenkool
> Cc: stable@vger.kernel.org # v4.14+
> Fixes: c9029ef9c957 ("powerpc: Avoid clang warnings around setjmp and longjmp")

Actual diff itself looks good but these two tags need to be above your
signoff to be included in the final changelog. Not sure if Michael will
want a v3 with that or if it can manually be done when applying.

Cheers,
Nathan
