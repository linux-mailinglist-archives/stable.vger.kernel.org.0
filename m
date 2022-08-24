Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CB959FFDD
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 18:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239215AbiHXQzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 12:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239216AbiHXQza (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 12:55:30 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8257679;
        Wed, 24 Aug 2022 09:55:22 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o14-20020a17090a0a0e00b001fabfd3369cso2081717pjo.5;
        Wed, 24 Aug 2022 09:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=nfhKxuSdD9rESx2UwzKNdRt6OgiXjuqyiduyrmCgI28=;
        b=AheTGGDjRYx7TWsxkrfIA0YLnYVBrz4nMkIjuax4wHtwwHS9zxCWpE4N8wV1ev6XQa
         ojtKoztl628vuRInyBXiwHGKuIphnkYYqJ/IF+1f1y9tkqv24uTFfktH3JaTi+ITK8Qm
         we4bN22FTVQUfuX3jbIYPeTnf3nl+v9SHOZT5v4pgwmfl20+GKupRbAjyhh3XwwJVdel
         tqYctbte01YpdzAFhY2UWUO374wD46PzQRxt0AHia0XCZyUF0JjN5/7Q0z8rJzRkbwtR
         IU8P72VZjUKx5kATL3R9oh0IrUyJ8IfKd7qsMpCkpk0JLQQK+l/2xjcuXGNEBYscqINZ
         i6lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=nfhKxuSdD9rESx2UwzKNdRt6OgiXjuqyiduyrmCgI28=;
        b=ohjQD58Hvk+I+HtSkjjk4ClYK1Q96BFnf4U0Oh8WyyGvB8bI56Z4wYyVC3greDncM4
         DG/v36uMqRTOqkIKas4GcKsZuplzcJ4+TPy1OJOxU+KCZy84/Uxc8aD2loWSY5rA6wcX
         a3J9PfQII7bhiNEAfSiYVLTM8UWmIa/HZf9hZGkKqpvZOJwiYMJJGnlCvhn3Cda0qM4F
         qhOwbV9Gz77zhHNgGSfOFKzkWjkE5SEITva/0nflK1Q3n3AEs2srk5gdQaKblZKk/RdP
         yiZEl4sPthi484BgRuRi+gAUMpMVca4YEdvhlH65xnbWnd8ZeZKszN3nPU052L+WhMSX
         HR9g==
X-Gm-Message-State: ACgBeo34hI2lBySoo4QMCexTgd6GQ71awAwTqWBJhM/rRtxwJDccioJX
        NVuaYpt6kOc7QXFMExd9azU=
X-Google-Smtp-Source: AA6agR60linLHqI81a3bVOjcePvwHQgha1SzlWUxoi4kgudZgX7v+gwAe8PFFj3UZj5z8pGJ+K0Dyg==
X-Received: by 2002:a17:90a:c402:b0:1f2:ca71:93a5 with SMTP id i2-20020a17090ac40200b001f2ca7193a5mr91381pjt.34.1661360121728;
        Wed, 24 Aug 2022 09:55:21 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w1-20020aa79541000000b005361c023874sm11165266pfq.179.2022.08.24.09.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 09:55:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Aug 2022 09:55:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/242] 5.15.63-rc2 review
Message-ID: <20220824165520.GB708846@roeck-us.net>
References: <20220824065913.068916566@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824065913.068916566@linuxfoundation.org>
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

On Wed, Aug 24, 2022 at 09:01:03AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.63 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Aug 2022 06:58:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
