Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A8E4F627F
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 17:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbiDFPDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 11:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235262AbiDFPCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 11:02:22 -0400
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC774DA296;
        Wed,  6 Apr 2022 05:36:20 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id b24so2409274edu.10;
        Wed, 06 Apr 2022 05:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zoN0C4dCFjchyITLB1tB6zwVEWxxfDvgG1qN8jQPv2I=;
        b=eBR8ZsrKWiHejkZ6qud6doIxyd09MSIW5RfG2+jyj7OQztuTXDLQe+ngmuXIF2YRTZ
         3g2HKwEpZEM1X0+ICBGB+1l8573RZ1AwEAnYCdyaSln9+EhKUtQa5YWbDoSslJZO4OyH
         flkP8AJspoUCPMLGiBkKwVcDEQnlt0SKpaK1UX9AFUMrOpprxU/TrrdJ/U0aY7GdVJjs
         UpYbNXMFpJJLQnKz6ipPqRM+z+1umCFyc33Iv3ZkB2cHSAyuYVNEbP62ECcScDJt0dMM
         5oUjaqU64qr9438zrOgIh6SRJIcfl7r7RXmsF6I4BDcqCSO6GbmNmTRYgMnTufK+1BNG
         ed2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zoN0C4dCFjchyITLB1tB6zwVEWxxfDvgG1qN8jQPv2I=;
        b=f+YxN9zaa/+WNjzUsSvFak8BvNJ2pK/Me1Gnfo18o8nd0dxtvQy64T1oDNjvCOWcGu
         hNqoFCpQeCLWmLDu473hDCdatqyYWgRqfGLD+1GBhJcKUxLS7YMMdzux0P0RzNVLSTc5
         8ZH+cFcAMPsVPr3XRwgRc/VObQcwro9bpiNHcyZ5PCm316xblyzRzoe7ulwKEq5LKvUs
         di+xZDHi+Bu4SunvGYPx4zhDOrYE8u8lTRhPVXNH4lYjhnLmegQk/iPNy5ocipLMAI0L
         wOcEgh2eRUicIZBCxKj+Pa7lGingqkvoMF6Lo7jR1RTi5IJwjs5S+UmYVNbV64XPFV1r
         GMgg==
X-Gm-Message-State: AOAM5309UrTGnEIWhrOa3FcoxIy3Ynf/PQo7JB/hEaDdQ1gC4+GS9jFo
        fdWZcDiRo7jZjrP6Ly3zzQ==
X-Google-Smtp-Source: ABdhPJwNUEZh3XYfKve3Ha4J0OboJ9AEl2Orz3KW5bkdcHRz6931+vhs8I+9B89skl5ZGhs2uQRXyw==
X-Received: by 2002:a05:6402:278d:b0:419:3794:de39 with SMTP id b13-20020a056402278d00b004193794de39mr8480855ede.137.1649248494988;
        Wed, 06 Apr 2022 05:34:54 -0700 (PDT)
Received: from localhost.localdomain ([46.53.248.249])
        by smtp.gmail.com with ESMTPSA id b8-20020a170906728800b006e0351df2dcsm6646164ejl.70.2022.04.06.05.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 05:34:54 -0700 (PDT)
Date:   Wed, 6 Apr 2022 15:34:52 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 327/913] lib: uninline simple_strntoull() as well
Message-ID: <Yk2I7JXzXaXi+6R1@localhost.localdomain>
References: <20220405070339.801210740@linuxfoundation.org>
 <20220405070349.652301661@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220405070349.652301661@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 09:23:09AM +0200, Greg Kroah-Hartman wrote:
> From: Alexey Dobriyan <adobriyan@gmail.com>
> 
> [ Upstream commit 839b395eb9c13ae56ea5fc3ca9802734a72293f0 ]
> 
> Codegen become bloated again after simple_strntoull() introduction
> 
> 	add/remove: 0/0 grow/shrink: 0/4 up/down: 0/-224 (-224)

> -static unsigned long long simple_strntoull(const char *startp, size_t max_chars,
> -					   char **endp, unsigned int base)
> +static noinline unsigned long long simple_strntoull(const char *startp, size_t max_chars, char **endp, unsigned int base)

This patch doesn't fix any bugs, why it is selected?
