Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8066164AC49
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 01:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbiLMAY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 19:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbiLMAYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 19:24:10 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B68D4D;
        Mon, 12 Dec 2022 16:23:43 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id y194-20020a4a45cb000000b004a08494e4b6so2115943ooa.7;
        Mon, 12 Dec 2022 16:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eKYxCw4845UWrKxWlr/gmTKP2dA8kInVNKwK2c576sU=;
        b=KmbMPr/2L2lmVlM0Fbay2dFxyPaBtGdbatmPpl7GOU0GqJLvxApoSkLWO3usESmZYK
         pQdieVE2dO7B1TBTMAQdf85XIbkqWWDeW/eEnSsk51pbgbu/JiIXAcP4etyXlWnIBJnY
         Cgxf/LTwP83jWcyOAStAf6NAFHnnmmMgrMN9aJ7X2hi/N/PvQPSyBgAfSIbpHpuxURrt
         Pxqu2SzTgsIBvnP+R/jmCizN5AKepF9zJt+N8udPGaLWnR1Cab78P4UJgrm8d85Lfofu
         xooUoAK5W5WOKjYK7S4a6eiykBEPpmC1CNpO7KUvYefofpLDIfli3oV3IfP/8WGD+iqH
         RVrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eKYxCw4845UWrKxWlr/gmTKP2dA8kInVNKwK2c576sU=;
        b=4xxsa/OgwvbiqkNlzcTFMNLcCHdztiSo7imKp5y4tvoqMNFkMnJ/VNqLecttS+/PoD
         TFr1QxuIXYSwGdV/iUd1j4IzKYX8yvYDec9Fh9lG6PGJO2zk/fAP+LK4IZirAFbN2iDl
         a4CWeGBGA/FTNcMbYaRXhWQeA8sgKi0bqBLS67zhRGYTEu6bN8cS906NaU/bo8w6qpeD
         WxdAig+M/uz9YiQwM0IGNzJSjnMPd1UEf96X6MTKcsq91dHgKQjnghkZRmu3n9laGMBv
         EGNelebmRKirDiFFkkfLrpMKl8FqwAiIHR3B+vSALINIOr7eTCjgTwfrMSCXCJHMcUt2
         aDog==
X-Gm-Message-State: ANoB5pkF5fVL1vfIt4xk1w3i5KBmACOVmmYTl6FJDybz3FdxiKWczxhO
        Tn8b+xDlx8GwyNuZkGRjwNk=
X-Google-Smtp-Source: AA0mqf4IctTlXzYNplyKEUYBmYMZIoMCpS3BMHO5P4yu28Wk3E2byaCSM+AiwLHTG/2d4FxC2AtLzA==
X-Received: by 2002:a4a:b445:0:b0:49f:f5f9:ed7f with SMTP id h5-20020a4ab445000000b0049ff5f9ed7fmr7415135ooo.1.1670891022027;
        Mon, 12 Dec 2022 16:23:42 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k15-20020a4ad10f000000b0049bfbf7c5a8sm524757oor.38.2022.12.12.16.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:23:41 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 12 Dec 2022 16:23:40 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/38] 4.14.302-rc1 review
Message-ID: <20221213002340.GB2375064@roeck-us.net>
References: <20221212130912.069170932@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130912.069170932@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 02:19:01PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.302 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
