Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CC8654168
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 13:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbiLVM5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 07:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbiLVM5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 07:57:13 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84A5C09;
        Thu, 22 Dec 2022 04:57:12 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id t2so1956812ply.2;
        Thu, 22 Dec 2022 04:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=shgak+5Q2UJGQJ85fQXrp0MEzUzzc2nXkSpaCSHFJYQ=;
        b=FcKTZen7yqObZyLVxp/FvVZ7ea8HzZe2c6uOTBFoi7g3bvvFbNxS69MvDGg046Y6un
         2LeP2xDKu2GfR1YyG/aBRDuXAF0ecWQ8Csl3hbcVWuWf0bY9B0qsqtf++qNrc4XoWglU
         7sq1XNpnuhVkAkm6nmtoBQRGunTiEs0fikUVrcAJYPT4W/S+xMeirwizvmIFvNcG0NKj
         elRI9YWw1QUFmanPdZAO23zBuVVXSkxIZV42evQWC4a0bir2+suL+8q9eHgXsI2kAzHP
         YUI31GiOOBZw7mFH2MbVypk9uQo+Zlsi6nhfVbkhYS21wyAoIIycudtzOE+Pbj/aUQVy
         C4QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=shgak+5Q2UJGQJ85fQXrp0MEzUzzc2nXkSpaCSHFJYQ=;
        b=R1sP2lipLMMXjocjmJnWAD3tKDhaYwrTlRbPCGA1tQXhiaaSAjui2OrN2t9cH3O4eY
         RNUaAzUvCrIj5ft7adKLv6/8O1PSO7VOH9Q5CPOCy1+A2g6uHTtQDbP72qneM90wFpCU
         syc/AqkYlmMuXAY1tX1dpzNNQhGBDuozbsxJ7+wFNDbBPYHKPiprw7bn1DofWtt55pr8
         eWz5ENg11g/GrfO3oo1eJpDc9zUag4N8Y22E28GX3uawgeYqrwVG9LG9DpCeezl8pRL+
         eMxtQdVyEPUW8BbyjzOLb29AnRdzp3miORnyYAAWnCWkcS+CUgP6W4BBUdQirJ1NO3w8
         TxQg==
X-Gm-Message-State: AFqh2krp4jgHWpfVjfHPTDpfWKJbg+W5M5l/sozWCXDqTBpGAlGssKTI
        KBW18RzNPhraLkBQct+aWurTuIRNEbQ=
X-Google-Smtp-Source: AMrXdXsd9OGV3/LNWKzCGh0+pYkG2ET1wu9v2lHLd6/kz1GWmcYM10Z3xGox/MgmSzx2r2SjbHrbvg==
X-Received: by 2002:a17:902:7243:b0:189:30cd:8fa2 with SMTP id c3-20020a170902724300b0018930cd8fa2mr6203652pll.50.1671713832224;
        Thu, 22 Dec 2022 04:57:12 -0800 (PST)
Received: from [192.168.43.80] (subs03-180-214-233-71.three.co.id. [180.214.233.71])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902ea0600b001913c5fc051sm404944plg.274.2022.12.22.04.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 04:57:11 -0800 (PST)
Message-ID: <4fbc9e89-24af-9d59-dab0-73925ac94df1@gmail.com>
Date:   Thu, 22 Dec 2022 19:56:57 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] Documentation: stable: Add rule on what kind of patches
 are accepted
Content-Language: en-US
To:     Tudor Ambarus <tudor.ambarus@linaro.org>,
        gregkh@linuxfoundation.org, sashal@kernel.org, corbet@lwn.net
Cc:     stable@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, joneslee@google.com
References: <20221222091658.1975240-1-tudor.ambarus@linaro.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20221222091658.1975240-1-tudor.ambarus@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/22/22 16:16, Tudor Ambarus wrote:
> The list of rules on what kind of patches are accepted, and which ones
> are not into the “-stable” tree, did not mention anything about new
> features and let the reader use its own judgement. One may be under the
> impression that new features are not accepted at all, but that's not true:
> new features are not accepted unless they fix a reported problem.
> Update documentation with missing rule.
> 

Are there any other examples of problems that can "only" be solved by
introducing new features? Or new huge features that are virtually
harder to backport?

-- 
An old man doll... just what I always wanted! - Clara

