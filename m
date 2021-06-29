Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CD03B7AC1
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 01:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbhF2XqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 19:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235295AbhF2XqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 19:46:11 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3ADC061760;
        Tue, 29 Jun 2021 16:43:43 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 59-20020a9d0ac10000b0290462f0ab0800so644671otq.11;
        Tue, 29 Jun 2021 16:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EwO3ppmJv4/g6TaSH0GAtYwMN1IRLmJS32aKKx7ZD3w=;
        b=EdM1+Yw2tY8WnefmCfURI7wvqWvi4syQhG12O+5p0MGbD/AE8ioDCiu3/Gb02ETCx9
         DPVJYq5NpC9JOaq1Kks5MWXgIMSaP+uatJdIGJoTlG7G40kiHTa8i+vhP8eew99vRYwb
         /qIgcmkCw3f0r0DqXePrb5+GtLTASiXxPxA6BQlZGXeSwpoRPap5nYKD7YmarljJD4JL
         omDmzmmdBdmtrQc8KLd67+SNqzG9C94I3aqvvBAUJ0GlqGx/EJcBVWJ48gAIWdKmpUUQ
         zNDm5jExnq7ggjxKJGpR/E3Ls0VVpDtLu9oAQla9AQQI45KR16hwxQAB/3x4TEgEz552
         Tguw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EwO3ppmJv4/g6TaSH0GAtYwMN1IRLmJS32aKKx7ZD3w=;
        b=f7FxtP8DDkB49YVQJLD3TvKi3CFmP17maEJWWBpRobKvQN+onNj5TTsq5keSwlYsHo
         MLythinwdClOHC3xjRlOq0U2B58Z2ETLVsoZ4GPLICwpYrgw4wBOT0kya9wzVqvwUTg5
         Pnt8SM9s+x2hgcevrbZxiRP+C3aJHMNJS4Mbvh2Bz7c75g0nevPnrRc1lkMfpTKY7zp7
         HxZp5sv1YKBkxFP//aAmgrtT+VY1f5ww2l4RlKoxEeXf+BlfwlC0PoKmvsejGPG7TQWd
         aHizG05sb1miaOG5E3/iaT6xiZr81LlW+Y7XvX3izafbLR2yhp4PIpyeW52g9stbM5Xn
         0YPQ==
X-Gm-Message-State: AOAM533tBc4DbENEFQBbtKGNkbiVjyHvokmLsekZZeF/BbvzTvGQvuCI
        ma3HV0DrOxGz1SqElceouT0=
X-Google-Smtp-Source: ABdhPJwLr7feKuqRjeBK1XNb4MRL3pJTcDlj+e9m+8jD0ldT6+k0PWu2AMBWeviMe10Iid62fdFdjw==
X-Received: by 2002:a9d:2621:: with SMTP id a30mr6546961otb.221.1625010222683;
        Tue, 29 Jun 2021 16:43:42 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y20sm2734895ots.23.2021.06.29.16.43.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 16:43:42 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 4.9 00/71] 4.9.274-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
References: <20210628144003.34260-1-sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <39c818b1-c748-0abc-f96e-246a2eb9bba5@roeck-us.net>
Date:   Tue, 29 Jun 2021 16:43:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/28/21 7:38 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.9.274 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:39:51 PM UTC.
> Anything received after that time might be too late.
> 

For v4.9.273-70-ga70498c:

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
