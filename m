Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9864B51CB8F
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 23:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238900AbiEEVrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 17:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiEEVrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 17:47:20 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D11352E77;
        Thu,  5 May 2022 14:43:38 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-e5e433d66dso5526208fac.5;
        Thu, 05 May 2022 14:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HwVwUxk5H0GtYIO92JdyFcoBHKe3VuV2ZMa5DcmeEHI=;
        b=kGTK3m6KN9Js2LjNbj+P7ZjUmo9wgkKemNu3EKGtiVjTpyzNzvoRZivBzthfxvxm23
         F5Y5+RDOMSMDwC2gWpw7FyCLYxj9at8fVxhsIXx0LEe1Xnc8QknHQgWhgkkOu0HOWsyL
         wA/R8C9RKtig+xMv9UY7KzopFlspn35mc8ZjEGet6Fye2pSTun0Y8dA7GA5tXlEVM+RM
         ZWAKrsIERhYn/zTYaeObou2fXyLQWSpdOdkULf+Ju1hOdJfN8N6Lqt2BruRQLBX7HWrX
         q7HjQK/T0/S2F/n7dCgpv0PtujT86kTA/S/k91VJZLLhYZ36SBdWGsfo3y+tJwjmE2Q+
         ZOZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=HwVwUxk5H0GtYIO92JdyFcoBHKe3VuV2ZMa5DcmeEHI=;
        b=iE0V84216SIIx5HvaipNpIETaS6Tu4cKWvw5gWFbA271EMM7oQoIOmaHO0s2zv6Nfb
         mdGK+22EFtlPa9zH1ETnUXoIezTsI0loKY8nl6C+GMBxv6HyarS+KV8OpSMpY1jlzKdg
         uBd5hHhDmibs/lMgwTlM5Y45R8qbYUFbp/UhAr4Vgkv6O8lawSka83SOK9tm3Ev3gKgj
         /y5zsOln2M9oJPFStnaiYuByNJY4ngu35DMokxYRJeVPQSQuQ9yL6AkeFfVgJG7mRgjB
         oww49o5nf2HrykY+YqJjzK7QSiZtKFnb0tDh3D6JON9FfqAF/9fgmqSZK0d0UTRMNyiq
         8CJg==
X-Gm-Message-State: AOAM5331M8CZTIUeZ5VogUEHvfLOeZ1ik5pue9CcIYwizTwl/eLib5C5
        zd2RHnB3xbuvX+0UEv4vzXc=
X-Google-Smtp-Source: ABdhPJwzoiGQJXFexMygYYgnrH+9SnCHxAzU3LeHp/H3m9EXYk8zhQv75IjaQj2C/Jqh5L6rXPQlTA==
X-Received: by 2002:a05:6870:891f:b0:e1:ec98:3c59 with SMTP id i31-20020a056870891f00b000e1ec983c59mr111734oao.295.1651787017929;
        Thu, 05 May 2022 14:43:37 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a32-20020a9d2623000000b006060322123csm1012879otb.12.2022.05.05.14.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 14:43:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 5 May 2022 14:43:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/225] 5.17.6-rc1 review
Message-ID: <20220505214336.GD1988936@roeck-us.net>
References: <20220504153110.096069935@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 04, 2022 at 06:43:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.6 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
