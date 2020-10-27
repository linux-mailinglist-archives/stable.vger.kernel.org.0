Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E5F29A601
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 09:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508585AbgJ0H74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 03:59:56 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35051 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2508581AbgJ0H7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 03:59:55 -0400
Received: by mail-lf1-f66.google.com with SMTP id f9so292994lfq.2;
        Tue, 27 Oct 2020 00:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GyCZOL7vC1Nhz7WTiuAb24B1ml36O2cs7jkzOpAKESY=;
        b=Q64EH0QSRH8h3FgbrpHDOmPEi6yJiU3jZbL/K+a3SqEqJYl/Lraj4Mn2JQWJRTKSm5
         7fblJQWyl5wQRZZSxZWPs3/G4cU6ffuFGzZ/CL3sq9IWdQsO5zG4mU++q0grHog0Ifj+
         W5bOttOkT888Nza7jNunw8fyzoU9Kw1E/N/W7I/cMtwGJWvxNKvDeRgu+XpIacxdmSOn
         XEUVUreCWlRaB8qNj6WkP+asGjOG2CxnwuKCasvstopuVt20pE5WnBRCMAzJw8x3HCDc
         rYz9Co2pr8ptmgXroprRQh6YCR/7eGlu67C3EU0q1ZPuSVxW84ErCrB/UF1z2fOvnnAs
         5BAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GyCZOL7vC1Nhz7WTiuAb24B1ml36O2cs7jkzOpAKESY=;
        b=bfPJk7rpfZbZ3uPyjaqLATRFq+y2KgggCWxv1DJDEghAuCAnXAfy+mFRI5KxHEl57f
         qOsK8+SR51tDwSvWOL9WZeAP8WBo28l+k2yhF4WbF6JKu6oNYx/OeP+mj9/1SvqMCK9w
         Sk4RGYSgo+R2buYmL51bmfUrSX/GkjFylyDjvbAuid8dJdU0hH9ywvVqTCO7MI3MToOp
         oPtpb2jDULUyHRvxetRt7PF/63/M8FIjOaoCyqZCWYgl9cxRSAjRWO4lBK0waojfvyGW
         zhjXsoquJHm87g0IF2jH9SWs8hBkUbzS8vzZ9vdQF8jq58HileAeg88W3Yf3Ooxnf90e
         ck9w==
X-Gm-Message-State: AOAM530DwW8oBfKmngLQCjLm6ktIBz85+tKqiN1+9iddnof8tVcZmoih
        IKndEevDem4YRLySWb1VzdSKiSVFjrc=
X-Google-Smtp-Source: ABdhPJxPO//vXt7YXKWsmJkbaxahsE2Re3dR5YqgcLasdFy5J+rtvtB4pU9D+RBNjczFxi07Ak2xfQ==
X-Received: by 2002:a05:6512:3388:: with SMTP id h8mr442415lfg.318.1603785591080;
        Tue, 27 Oct 2020 00:59:51 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:664:39b9:40da:9eb9:498f:e092? ([2a00:1fa0:664:39b9:40da:9eb9:498f:e092])
        by smtp.gmail.com with ESMTPSA id g14sm82180ljn.67.2020.10.27.00.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 00:59:50 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 4.19 08/60] MIPS: ftrace: Remove redundant #ifdef
 CONFIG_DYNAMIC_FTRACE
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Zejiang Tang <tangzejiang@loongson.cn>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org
References: <20201027000415.1026364-1-sashal@kernel.org>
 <20201027000415.1026364-8-sashal@kernel.org>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <ac792f50-7bb9-1234-c38a-1d2e32aaf56c@gmail.com>
Date:   Tue, 27 Oct 2020 10:59:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201027000415.1026364-8-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 27.10.2020 3:03, Sasha Levin wrote:

> From: Zejiang Tang <tangzejiang@loongson.cn>
> 
> [ Upstream commit 39116103a7345927fa99644d08bc0cc9d45fea6f ]
> 
> There exists redundant #ifdef CONFIG_DYNAMIC_FTRACE in ftrace.c, remove it.
> 
> Signed-off-by: Zejiang Tang <tangzejiang@loongson.cn>
> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/mips/kernel/ftrace.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
> index b122cbb4aad18..7dd52da55907f 100644
> --- a/arch/mips/kernel/ftrace.c
> +++ b/arch/mips/kernel/ftrace.c
> @@ -37,10 +37,6 @@ void arch_ftrace_update_code(int command)
>   	ftrace_modify_all_code(command);
>   }
>   
> -#endif
> -
> -#ifdef CONFIG_DYNAMIC_FTRACE
> -
>   #define JAL 0x0c000000		/* jump & link: ip --> ra, jump to target */
>   #define ADDR_MASK 0x03ffffff	/*  op_code|addr : 31...26|25 ....0 */
>   #define JUMP_RANGE_MASK ((1UL << 28) - 1)

    Are you sure this is neccessary in -stable? What bug does it fix?

MBR, Sergei
