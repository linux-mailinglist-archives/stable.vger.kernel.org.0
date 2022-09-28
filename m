Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FF65ED29C
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 03:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbiI1BVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 21:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiI1BVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 21:21:46 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F542E9F5;
        Tue, 27 Sep 2022 18:21:44 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d11so10547525pll.8;
        Tue, 27 Sep 2022 18:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=aRsadRg9iYOCCwFVp9ayiiO/T39gVQdCVLuY+hGQPnk=;
        b=kQJ9DbUb4H5e9mLr17rIW/fgeSbGkp9+hNmmVQQuq7tXBGmGO7x3I+fFQf2c5lZl92
         yKJaBiiOrU4n4//H3SpZhoWJ4fJeuEq4io9KFI8+cXgJNxVGkobFXYNMBtLt6mJl4MgH
         tEwkm5ygrSc/HWDLb9Hmcman3BetKFyEr9lN9egV28I3H+BUXxH24EYzjCAqOX2sSzI7
         JxUa18YGAoS7aWtZmkF9B7n21N3Y+CvHe1xw0kVZmwv8YoMWou7XL3cvQmg5C7Q/g+Y2
         Q10TGOu1VZ/l0WwD/jXW0UqZEN6XvXYZdsFVtn4ST9i6YRiJBHZfzziOZDOUrRNXZhXB
         DYYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=aRsadRg9iYOCCwFVp9ayiiO/T39gVQdCVLuY+hGQPnk=;
        b=YdOzMdvrI/UAT07TyeLFKN0oAFUjmRY262jV70Ge+LJV4JTLBXtSmLOkVJZxh/FXJ5
         KKvfEmvMwSPk9VLnChcGUpNS4c0UYjRVPaPYG+VFBxSyevByeYqe2Bbwswzqql6qDtIO
         CB264IynUc8g1JHXIkWsLWQFA6qHVfTiV4FM88W/SR5LUAShK30MmVZH3ZijHXp/J6uN
         Lfe5ns/eNFioXIb/B/tFuFhkL1SXKdrdHi9MVxFwWJAD7iG69+bTAKnpYiG2Yxp2ZNRs
         FIU8JVGNaDn5MqytDezn8eOQnAjJ7wTaGRcaFiC9EvMFZtWRXFWbxDYsA4DgBp/y7k0Y
         ciSg==
X-Gm-Message-State: ACrzQf3Kooplnyw6eVfNhEdwCSVh7XlPfAYJCRuk/Po9Q+4OA7kjA47h
        KgD4766+W+pFvkLyWkRx0YM=
X-Google-Smtp-Source: AMsMyM4wnzfvi/AYLGsokzVqWai+0CXrXVnkWft5C7fKWM9GYyE/bxEzzfQakZ6LFD+YSsZp12SQvg==
X-Received: by 2002:a17:903:2601:b0:178:a68:82ee with SMTP id jd1-20020a170903260100b001780a6882eemr29642620plb.163.1664328104350;
        Tue, 27 Sep 2022 18:21:44 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z3-20020aa79903000000b0053bf1f90188sm2524502pff.176.2022.09.27.18.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 18:21:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 27 Sep 2022 18:21:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/207] 5.19.12-rc1 review
Message-ID: <20220928012142.GG1700196@roeck-us.net>
References: <20220926100806.522017616@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 12:09:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.12 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 150 pass: 150 fail: 0
Qemu test results:
	total: 490 pass: 490 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
