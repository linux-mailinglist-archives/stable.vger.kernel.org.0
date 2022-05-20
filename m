Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C343E52F3A2
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 21:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346410AbiETTFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 15:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238016AbiETTF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 15:05:29 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218BB199484
        for <stable@vger.kernel.org>; Fri, 20 May 2022 12:05:28 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id b81so4536449vkf.1
        for <stable@vger.kernel.org>; Fri, 20 May 2022 12:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=efficientek-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=0ty3iWO/CTr86IPd/0eXR6lki0qwSNT0fd9XDvWt+tk=;
        b=aYkkYon/IuBCQrOFJZ+0d7yF4z48+RjxAVlMTT3OSXkFBQkyj02gbuZvHj8mZbPk+F
         BTybw+RUyG34rnd+yihoTxpWgQwtuSrayzaSLZ33GBzbxj9D2JlFYR2G5yyJOvrxFt4E
         qSZULDxaR8MSLGpCTNS3OKHcVb2ohS9XxmaTvIHl8lrKsNffcQqJb6l1s4BEXn4TIsE1
         kN3uC8oboHQRvA+WWTbf8ua3N0IzK6hN7oVGlkBITVfNFehZnLXIazlcZvV8tw49Prq1
         7806AGiiJ0vB/aRTJybabAki6zE3k9Dxg917wPv0IowTs4Z51WqZCgWP0J+7yKNvzXqH
         MqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=0ty3iWO/CTr86IPd/0eXR6lki0qwSNT0fd9XDvWt+tk=;
        b=EDAHuKTmhta0cAnMyFQ+1jJYWmRvjMlss+XcRF3wKNIMLcDCDmYLrzBVOJUoa8n4B+
         NlGUfm1dwMTXuKtK3wEzzxI1yyr9oAUQC4iK/byJCpE3xLe1kqtpcnO4i7eLUoWcGkmb
         kMrZWzbwsL+c39bc/Vj9lW3llIVf5KS9ybZtB4B5awA5AXtX3eS7udHEgPVedU3DxikW
         Se4aQQ7frNnSjEmzwEh84zv1cPzCG7KaturCuk152rLNzzV2qendG6sPBseEDaeMpnfL
         hETcYM8KJ8nHf70PrlmPqugZbDPjdCF55Nrfp0plQGrcLScw18WMeo4rRbfBv/gO7uVo
         RsGQ==
X-Gm-Message-State: AOAM533sGS+Pu+EyY88h4Uu3rRjUDL5Qmsx4vYV65y679lEayYDV3l/U
        7ADddHoacaUNG2eF6lMqvFt3Uk1H6cjk0g==
X-Google-Smtp-Source: ABdhPJzqkM25vgN/IqFyD5Emo/yvFtcBOFchq8e2Q55GzmG45A7lff9iz+XQQv6jpWFUtLFlCm+edw==
X-Received: by 2002:a05:6122:c8e:b0:34e:948a:fb93 with SMTP id ba14-20020a0561220c8e00b0034e948afb93mr4844641vkb.37.1653073527203;
        Fri, 20 May 2022 12:05:27 -0700 (PDT)
Received: from crass-HP-ZBook-15-G2 ([37.218.244.249])
        by smtp.gmail.com with ESMTPSA id v26-20020ab0201a000000b00364eac116f0sm31355uak.2.2022.05.20.12.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 12:05:26 -0700 (PDT)
Date:   Fri, 20 May 2022 14:05:15 -0500
From:   Glenn Washburn <development@efficientek.com>
To:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     stable-commits@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>
Subject: Re: Patch "um: port_user: Improve error handling when port-helper
 is not found" has been added to the 5.17-stable tree
Message-ID: <20220520140515.35ab0497@crass-HP-ZBook-15-G2>
In-Reply-To: <20220519135207.392505-1-sashal@kernel.org>
References: <20220519135207.392505-1-sashal@kernel.org>
Reply-To: development@efficientek.com
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Resending this because stable@vger.kernel.org using wrong header field.
Apologize for duplicates.

On Thu, 19 May 2022 09:52:07 -0400
Sasha Levin <sashal@kernel.org> wrote:

> This is a note to let you know that I've just added the patch titled
> 
>     um: port_user: Improve error handling when port-helper is not found
> 
> to the 5.17-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      um-port_user-improve-error-handling-when-port-helper.patch
> and it can be found in the queue-5.17 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

First, I should say that I'm not familiar with the process so I'm
likely to be wrong on any number of things. Second I'm the author of
this patch and I would like to see this included in the stable trees.
However, it appears to me that there is a problem in including just this
patch, as it depends on a previous patch which does not appear to be
applied[1].

> commit efc324ad7e7e1c92a8862bd71b2f5f8f15513304
> Author: Glenn Washburn <development@efficientek.com>
> Date:   Thu Mar 3 01:53:32 2022 -0600
> 
>     um: port_user: Improve error handling when port-helper is not found
>     
>     [ Upstream commit 3cb5a7f167c620a8b0e38b0446df2e024d2243dc ]
>     
>     Check if port-helper exists and is executable. If not, write an error
>     message to the kernel log with information to help the user diagnose the
>     issue and exit with an error. If UML_PORT_HELPER was not set, write a
>     message suggesting that the user set it. This makes it easier to understand
>     why telneting to the UML instance is failing and what can be done to fix it.
>     
>     Signed-off-by: Glenn Washburn <development@efficientek.com>
>     Signed-off-by: Richard Weinberger <richard@nod.at>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> diff --git a/arch/um/drivers/port_user.c b/arch/um/drivers/port_user.c
> index 5b5b64cb1071..133ca7bf2d91 100644
> --- a/arch/um/drivers/port_user.c
> +++ b/arch/um/drivers/port_user.c
> @@ -5,6 +5,7 @@
>  
>  #include <stdio.h>
>  #include <stdlib.h>
> +#include <string.h>
>  #include <errno.h>
>  #include <termios.h>
>  #include <unistd.h>
> @@ -175,6 +176,17 @@ int port_connection(int fd, int *socket, int *pid_out)
>  	if (new < 0)
>  		return -errno;
>  
> +	err = os_access(argv[2], X_OK);
> +	if (err < 0) {
> +		printk(UM_KERN_ERR "port_connection : error accessing port-helper "
> +		       "executable at %s: %s\n", argv[2], strerror(-err));
> +		if (env == NULL)

The the afore mentioned patch that this patch depends on "env" is
declared and set. Without it, I'd expect this to fail to compile. As
such, I may be wrong in that the dependent patch was not already
included because I'd expect there to have been a compile test prior to
this patch getting to this phase.

My suspicion is that the stable trees try to not include new
functionality, which the missing patch may have been considered to have
done, and thus was not included. If its deemed undesirable to include
the missing patch, this "if" block can be removed. Although, I think
the missing patch is valuable enough to include.

The above goes for all the stable branches that this patch is set to be
included in.

Glenn

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.18-rc7&id=db8109a8bb4a4b31e7f630d7667749d62ee4a087

> +			printk(UM_KERN_ERR "Set UML_PORT_HELPER environment "
> +				"variable to path to uml-utilities port-helper "
> +				"binary\n");
> +		goto out_close;
> +	}
> +
>  	err = os_pipe(socket, 0, 0);
>  	if (err < 0)
>  		goto out_close;
