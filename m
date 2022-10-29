Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2181611FCD
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 05:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiJ2Dfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 23:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiJ2Dfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 23:35:36 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D007A5B50C;
        Fri, 28 Oct 2022 20:35:34 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id 8so4696158qka.1;
        Fri, 28 Oct 2022 20:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eHuwO5q4rtkcecN30LK1nyJOdXj5b40eoXdabVIwYPA=;
        b=e6AlUrIf+ghzqp0Q905Tjyg04JzD456eKFBvMFc5XEkTKtB8VKjqAsl0NwbxIOUy0K
         Ex10EcJI4HXbmWhfZPawokhT9iTNhtaWNqRAJNXXac25bJPsPJqHBcNwG9uWARR/Vy0S
         ALm0bV+pXLMM/rAG6UxJcjIy0ZsjBEjWO9TW7gbAWV2a7SSl2kZODX2PO0p+LB5sVN6j
         m9OnqR90Hvz0lPxIDLLhjM2J/4lDFXTZwtC6yIuMCqgknTP6bYhwSvvwpzNaz1tC3UxG
         dMhS4CGB3PslyeoXUJtvjwLTjMh/uOqxrl5qYFevzjXNunKLzcdP7L8cuQ1eslAHlaf+
         3E8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eHuwO5q4rtkcecN30LK1nyJOdXj5b40eoXdabVIwYPA=;
        b=Vm4WrEyfZFNEN7p2xgbQyFRkFh8LSz3lCJTUBzOJ8xxmpZj4wFIyH5PyeA7YXp4TMQ
         Yte3t/1iV2Eax6mqm8QwamVDa75viMYTLyDycLzTJN0pE4hDo+Td1PDZaEmXRMhrDOtw
         QhWTe7jUXu4rMc7uQYZXQVAKSz0bfnIISU+9tfjDjNUeRjNxzKPW0qPk9iEH136jbbCJ
         MTnhTs5hOI9TTPvEc+ZrWA01d0+BkMdEOI0nqBcys7h6YE+cb1q9J+9eMLjpHoKe4KuT
         Tgn6WGg3xYTOQpCDsfM9AhuHi5ybWrJ8pJzwNDqQV4lPC+CtvlpY3i/iHKD2aLWYBNOP
         D2Vg==
X-Gm-Message-State: ACrzQf3gBmdnLXjlrLtUKCle7/fNWvaAz/u1L/lY5zrqK3WcgkZFgVha
        GlNMASwPymf9FEdmRUrGUhk=
X-Google-Smtp-Source: AMsMyM5CHoMMGYu+LhlEbUdXT5XDfTuvf+vL2/+0mJlYfzzfMD2zPqXYTz2+o6pV+DF4Y5w4O4uBFw==
X-Received: by 2002:a05:620a:2185:b0:6fa:9b5:7bcd with SMTP id g5-20020a05620a218500b006fa09b57bcdmr1736475qka.689.1667014534017;
        Fri, 28 Oct 2022 20:35:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j6-20020ac874c6000000b0039cbe823f3csm278392qtr.10.2022.10.28.20.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 20:35:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 28 Oct 2022 20:35:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/53] 5.4.221-rc1 review
Message-ID: <20221029033531.GC53002@roeck-us.net>
References: <20221027165049.817124510@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
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

On Thu, Oct 27, 2022 at 06:55:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.221 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
