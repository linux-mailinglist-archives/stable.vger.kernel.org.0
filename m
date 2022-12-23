Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65089654A8F
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 02:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiLWBzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 20:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLWBzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 20:55:14 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597ED218BD;
        Thu, 22 Dec 2022 17:55:14 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d3so3643237plr.10;
        Thu, 22 Dec 2022 17:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=srfyvT9Du35tqYJ7381ERyAs8xUzuRO4CHRPOvNkoCQ=;
        b=g6jDtfgABgcUkGmH/9Xy+64QNxKFTXo7Fxgc7UF4nHEKi0elkWyNdzUA0Q9NC1n6nt
         6Jye5Fy3ttPq+UPUARhwIItgtNTbRT//XihpFY3Ru/t2FCCtnHrZWymcEWH61L+WQkMP
         xGCVwuzSh+ahlFdmMJOhUYmwgH5/yuJhYdL9GuzQcx+UeWO4fCLYcZHcGiUHaqL/6g5T
         CYM8/Dl9BaDdSuWpPeoFKDOdr3wVanLuJ+jPlBUg8C3QgY5ijWq88Wr/U7aLAuV4UC/S
         eKmQMqs/7FA5VRBgC09k2xJ4m3Ar8meijXDKHnm67OebcITHy415+UlTJg7Bhja5ctvz
         nZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=srfyvT9Du35tqYJ7381ERyAs8xUzuRO4CHRPOvNkoCQ=;
        b=Z4t+K3jkdUPohr3uDOs7q/TLksSfcalqVTZjuKg13wmsLqkbpYYMfqO3Ybj0rlKXHO
         2JPcAiJqKb+3f+i1D8LD0Xz/OXsgrF3C3rOR2pzZcLyPre2LDJ4A6tNMMYfuPfa0X7X6
         vB49Rufz7067bGLbZqaA3dS/2nQ213rP8AD3aSsLt3bunrDM2W418tDKQ5uFrOpGKBgS
         FV6e+ZoDA5/61HtiRT02qG7xU1Ep0b4icDhh7atHrI6BY81oAy8gllF+pfenDRqUyluX
         bPFOpjUUOjW89gpqoj0WjHU9gLNplOlczX507bKTaF7fFOFLR65O9eem8jAeLpWV7Y+J
         DR9w==
X-Gm-Message-State: AFqh2koWdbKgp5Ke1gPWLjoQun6It4V3LwSm847wuaO3e+JdWDt0+ls4
        2ZTx6wHBCBXVTivrcdFu3kfu9NBzqqI=
X-Google-Smtp-Source: AMrXdXubmd0pUwnZdbokkePY9fPYiYY3PSxppIA15h4hNtcYXdvp5EkYv96DvF5REQN+42UW/fa2ZA==
X-Received: by 2002:a17:90a:1701:b0:223:4785:1458 with SMTP id z1-20020a17090a170100b0022347851458mr8568635pjd.45.1671760513826;
        Thu, 22 Dec 2022 17:55:13 -0800 (PST)
Received: from [192.168.43.80] (subs03-180-214-233-82.three.co.id. [180.214.233.82])
        by smtp.gmail.com with ESMTPSA id ne2-20020a17090b374200b001ef8ab65052sm1202532pjb.11.2022.12.22.17.55.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 17:55:13 -0800 (PST)
Message-ID: <65421f5e-6af7-ac1b-d1ec-209c3e45edac@gmail.com>
Date:   Fri, 23 Dec 2022 08:55:08 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] Documentation: stable: Add rule on what kind of patches
 are accepted
To:     Tudor Ambarus <tudor.ambarus@linaro.org>,
        gregkh@linuxfoundation.org, sashal@kernel.org, corbet@lwn.net
Cc:     stable@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, joneslee@google.com
References: <20221222091658.1975240-1-tudor.ambarus@linaro.org>
 <4fbc9e89-24af-9d59-dab0-73925ac94df1@gmail.com>
 <5fe3c17b-44c3-1e1a-9ac5-1db8766120f4@linaro.org>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <5fe3c17b-44c3-1e1a-9ac5-1db8766120f4@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/22/22 20:01, Tudor Ambarus wrote:
>> Are there any other examples of problems that can "only" be solved by
>> introducing new features? Or new huge features that are virtually
>> harder to backport?
>>
> 
> Here's an example:
> https://lore.kernel.org/linux-kernel/20221222083545.1972489-1-tudor.ambarus@linaro.org/

I have seen that, but is there an answer for the latter question that
I have asked before?

-- 
An old man doll... just what I always wanted! - Clara

