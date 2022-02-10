Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2798B4B175A
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 22:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344465AbiBJVAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 16:00:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344475AbiBJVAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 16:00:42 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBB610DE;
        Thu, 10 Feb 2022 13:00:43 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id v17-20020a4ac911000000b002eac41bb3f4so7869730ooq.10;
        Thu, 10 Feb 2022 13:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xCUSvUDhegb+MwjyyYwbJOCuBUgfoSg8Wm2gd4n0yVU=;
        b=bOrnIfvXGBskhmn/i/PGPgZNR087lfr/dskAySqUCXYZ9LsVau36e9XCBjyKAwivO7
         XelzgLBaQKshOah0yfFlaXrDjgyaBr4CP28pakwcb1Rvo2trzwbJ3J+bENzo7/k/t8E7
         HhpMjR65ni468B5qdxdTJluZ2LaSz9VRqSO3jZl0rV6c8VijvK1p2yd/6noDugKSWSUq
         I5ojLB5Pve1xetD7GbLRATPxhXCms72d7rvszhPg0yOcbqWZ8cM2cFkJSlonqeZUvmAI
         8sd2t9arHRRj/JQfiH9EmIzTBualJKR7jwpIOcXdKJf0D/oWPmPicxunSPxicY09I/Ew
         EfsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xCUSvUDhegb+MwjyyYwbJOCuBUgfoSg8Wm2gd4n0yVU=;
        b=WfHCS/RoTeY581p3sS19WcgxTtZW1HXft/p31a2D2OhRx8KRLfFagw9TN28zmrv8eU
         P2JoQ1h/X/WymZcZJ/5GZFPaEoVSufjIAi4ygh2+tc3OscMGscfoeQPq3tXRed4skOuC
         Zg7yutsp2ijv/3HVgZAh5B1nrid2nU0U7sN5IAUHwyCXhvUoxLUY9KdYwp2xMFVv/a5u
         xaYmLUpb7aSQASh+ckO4bMyaGP8OoQMs6P9f7ikE+yxFzA0fHtJ3trq/dZeX6fbIWFEa
         4xBCiZaIwo4YG8iZFCK3Mq0lWU1mPnlgbOpIK3VASTmkY8KxQt/U5oaMfu+rUsnwNYZC
         bxmA==
X-Gm-Message-State: AOAM531F4tHm0Tg1S8/m361PLq8A1zJu/OWVDGiHmjEBSxKvYLUP1dHV
        nySDmWhBkw8Q/3R+QYvknvc=
X-Google-Smtp-Source: ABdhPJwZom/ETNU9HG42vzfM7Wvc/ZgKn+r78lJRODwr/OE73DgSmkfzBxPP7vqurVmjJquT/Vk0Sw==
X-Received: by 2002:a05:6870:3501:: with SMTP id k1mr1357708oah.47.1644526842656;
        Thu, 10 Feb 2022 13:00:42 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f8sm501049oou.19.2022.02.10.13.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 13:00:42 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 10 Feb 2022 13:00:40 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 0/2] 4.19.229-rc1 review
Message-ID: <20220210210040.GB2963498@roeck-us.net>
References: <20220209191248.596319706@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209191248.596319706@linuxfoundation.org>
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

On Wed, Feb 09, 2022 at 08:14:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.229 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
