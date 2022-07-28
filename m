Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD8D584879
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 00:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiG1W66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 18:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiG1W66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 18:58:58 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2905071E;
        Thu, 28 Jul 2022 15:58:57 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id s204so4064003oif.5;
        Thu, 28 Jul 2022 15:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QGR8OswaXrAayR1Mb8hCQjgWTbwmiZMqL6kqBUAiYqY=;
        b=Z1sbVQdxAYj37+zOb0LctsawPW+cbvlRqYY3T5JJQ5FVla7SSmC4vb0ZGTkouuH+h6
         dFY4KZ1CsOG2C3p8v+ZTT5L0d+/3vfeBgZs8xjkId5Z2+Mu4sC9NNeA/O6XfsFoVmGoZ
         xjbkF85jJsUeBuwWSHzINGcpO8KzoYVwO1RG36T+umh1viMyhEa03xrCn+RVbicdfLY7
         gRTVutKh5D9RJx93EPwfxsh4Pl3uTp0vpDAa0QfWyyilTz4YU5EQvZZf+cFoeiXTJ+lo
         PkBvBVWIPElHx/J7pDQFVPU6DG7GqYUS2WZUTgX/LiGsC34/YBFHMhtoRFjZ3zKO+SnX
         sEvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=QGR8OswaXrAayR1Mb8hCQjgWTbwmiZMqL6kqBUAiYqY=;
        b=1X3q9RO+rqrgKQUcoolyJGMQLzB8qnqmO1aOqbXtVgNEXvOI+H9kWVVgSoD+a9qVsU
         0UfSOk/UjfxQprcnNydpu2mTa00/3WfdAMyehTTpW50MtythClioI6K99y53MdWg5y9K
         ef9HjB+fhMtrPqliDQfJuZreMFqp3v0QuTifdxmfUPR0gbYsEeZZqJbZbxIOGK6oS22R
         h+ps0Sjv8j26X9Sk8y6uFhy1mb41zTkBgt4QZ8m+6lYgWX8cQJrcI1JGHO525sTCQgSY
         JiJDOmnVmyapFSXN6kvBCUO52VlaU0tMAVRjgDa8MivdXS7qQFjxZ0qLjhCrHoKYdURb
         ErhA==
X-Gm-Message-State: AJIora8JBUcGa906bTykd8DOIY/1vCcJjuyS002sqBfz+f24kyZe/pyc
        lYJSnKKvSKdoOXE7nwoVBnI=
X-Google-Smtp-Source: AGRyM1vtEVw/hD8YqSs0XJWfuOCy5bf39ggNwKi9XzmrRrchTSr9BXlRwpJ0Po1zucRk0P5OEsGv1g==
X-Received: by 2002:a05:6808:bcb:b0:33a:bf52:721b with SMTP id o11-20020a0568080bcb00b0033abf52721bmr751944oik.113.1659049137020;
        Thu, 28 Jul 2022 15:58:57 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k95-20020a9d19e8000000b0061c9159bb8asm828159otk.61.2022.07.28.15.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:58:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 28 Jul 2022 15:58:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/101] 5.10.134-rc2 review
Message-ID: <20220728225855.GE1979085@roeck-us.net>
References: <20220728150340.045826831@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728150340.045826831@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 28, 2022 at 05:05:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.134 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 30 Jul 2022 15:03:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
