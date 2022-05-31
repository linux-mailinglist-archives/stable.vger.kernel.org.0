Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7BBA5389F4
	for <lists+stable@lfdr.de>; Tue, 31 May 2022 04:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243592AbiEaCiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 22:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbiEaCiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 22:38:12 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F37350052;
        Mon, 30 May 2022 19:38:09 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id bo5so11972196pfb.4;
        Mon, 30 May 2022 19:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5L9D0CPZoOn6iRer1/Iis9Os7Lr0syhKXln0w+FamQg=;
        b=JKLzhF1usQmkIBdH2Vxsk7pDBv1OyOocxBwl+GQaJlEQlp8y2UKmKsfLyJEhM2N/gl
         iBpTqmHvcKayfwyif2yByQnVOdgUmbJMknASvbSKnevTqd+cWvgfp6C8JFvzJqMOC33t
         6d3zn/BOMUCv4CLqOrvzG+XHdi2FkE+Kt+b5geEh67iTW5l+v3dBZcbAlmcZwtnXE49A
         BGLmJvekNBrYyDQdsMrI4ajZKNbTCI+GeoO7dZPXQ/69DR59l+NI/vSXXlfGySI/wQmy
         ssciwG49ZPJBJWcqlayW1szsi/HnLTjWnE7O/zd56W1zaFYDtyzl1+8bZPobCDdswIvC
         ZbPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5L9D0CPZoOn6iRer1/Iis9Os7Lr0syhKXln0w+FamQg=;
        b=HYAZp0lGXeLg8FMuyPclrIN+uYFPHn2OV127p03wbOgBU1LBpVRgkeHj/+GUdJrHYT
         AEHbI5oDaBldA5tqjaBcAaqX8HmBzIGJZzsoDly2PJsesdIoLF/wdw5leVGMb1/iNTix
         Y+9FTSitjeN3CLqLn1fwohHOEtIWctGY6q7c56hZ5Y5LtW697uRTgdciOtgMYf/7S2Qh
         cst0pzANUjqt2g+h+HYuMjGn7TZrQ9kln5M4qEfzU6eDwN8GqeedHc89mEeUqFZ1A8bN
         0IzeNrQd3nNHfBXNn9iyJvnpbLQp47gBWVopX3uQcovujGfmVk6W9or2zvOCUzy9Qq3E
         eOPA==
X-Gm-Message-State: AOAM531hKRVjfRF3hb7reRKIypJSasBrZP7XhqM3DOB88NBYIfklx5Fh
        53Aav2sRzAIVOdhe2o0lXcjYu1GeWDpwWA==
X-Google-Smtp-Source: ABdhPJxO664InV+6aWDDRju8azkE7SdS5F2TwFncm+G+qhlV5ky/ruidv8wc6jADxF5vlYvOx26s1Q==
X-Received: by 2002:a05:6a00:a03:b0:51b:5131:704e with SMTP id p3-20020a056a000a0300b0051b5131704emr7294679pfh.53.1653964688792;
        Mon, 30 May 2022 19:38:08 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-77.three.co.id. [180.214.232.77])
        by smtp.gmail.com with ESMTPSA id y139-20020a626491000000b0051844a64d3dsm9484454pfb.25.2022.05.30.19.38.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 19:38:08 -0700 (PDT)
Message-ID: <1344ac58-f019-03ef-fab8-6e1d910514e2@gmail.com>
Date:   Tue, 31 May 2022 09:38:03 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH AUTOSEL 5.17 128/135] hwmon: Make chip parameter for
 with_info API mandatory
Content-Language: en-US
To:     Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     jdelvare@suse.com, corbet@lwn.net, linux-hwmon@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220530133133.1931716-1-sashal@kernel.org>
 <20220530133133.1931716-128-sashal@kernel.org>
 <dddc2b53-62eb-fda7-4425-afdd179a7037@roeck-us.net>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <dddc2b53-62eb-fda7-4425-afdd179a7037@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/30/22 21:27, Guenter Roeck wrote:
> On 5/30/22 06:31, Sasha Levin wrote:
>> From: Guenter Roeck <linux@roeck-us.net>
>>
>> [ Upstream commit ddaefa209c4ac791c1262e97c9b2d0440c8ef1d5 ]
>>
>> Various attempts were made recently to "convert" the old
>> hwmon_device_register() API to devm_hwmon_device_register_with_info()
>> by just changing the function name without actually converting the
>> driver. Prevent this from happening by making the 'chip' parameter of
>> devm_hwmon_device_register_with_info() mandatory.
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This patch should not be backported. It is only relevant for new
> kernel releases, and may have adverse affect if applied to older
> kernels.

So this patch is meant to be backported to 5.18 only, right?

-- 
An old man doll... just what I always wanted! - Clara
