Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B31645C87
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 15:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiLGO1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 09:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiLGO11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 09:27:27 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B3A1E3EE;
        Wed,  7 Dec 2022 06:27:12 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-142b72a728fso21450050fac.9;
        Wed, 07 Dec 2022 06:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mZUvC3ScOL0OUnwbj9qYew0Nw7ezfdgDGsce7PsMgHA=;
        b=THD2Uz99gkI/jDvqEjfaGSM0ul2tE6hMqBwHU/J0jhblaL0InK/tsGtjX6wggMTNaC
         0WsXA/S+53nDHQoev2O+sJvHlxP72PQ9lFHbTAXlZqxNmc3JwlSkoCuPpCuTwDb/M/xe
         5dDxx8bhSCNlk6XkQUo+PM/7jKVXRyJZkpB11myVj/1BnmLuGQrS2EIQfgxTSSUx50si
         vuv9OPB8ME9u6OlQ/WgwlZO8Eeg/Qe/YtuMN7lCo0yok+7i93DtTI5+zN18DkWP7IvVA
         SE5k7DEXZlEkim/FTa5FZfOh1YRSjvlvDFHZ24hWmUCjAUapmJbhNADN82FKcImHxW2u
         XP/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mZUvC3ScOL0OUnwbj9qYew0Nw7ezfdgDGsce7PsMgHA=;
        b=yx9QkBn7IPRUDJm4CbtzMsl0iJbxRY6ekovQE5lA//2X53lkCYJV14J02iCLwUxbHi
         TDMzP2Zt9FeX5MGO9aFhfbHwwxl1kAIy+A26sIGLCSaH/GkbzKNaNY/ls20VXTCRrkXT
         ujQbDuWSVu4AtJ2kSPvjygv7wR53EvGDWzDYJp5zzdChP0DtSwDLUzqSXdz2c4Bi32+Y
         kHfduJNDLmou1KSrg0pI4Vmy8KIpmZIZjOsBsRGBvvhb9N3cNLwSQ2jTQJUQ9SqrR1YN
         ImL9uZ5YZMGmziwOdtLUPYmflLdKGfZLJ0Nmj4zp08YgWb5rW2AzW2zVrHAzyan5TIQN
         KQfQ==
X-Gm-Message-State: ANoB5pnQgld7PIUCveHp0hGeiI57WTU7r4EeYJVfVBzBpFVGkt2UuKXv
        1bYWNNB8pCF5dRoTcdSZtsg=
X-Google-Smtp-Source: AA0mqf5LOHYQ4eWxv3N3L69NerT5q4RyrcFMpPjbO1+8Xm6UYJOiYR1VDcZlIE8uZysoRAj4WsvLCg==
X-Received: by 2002:a05:6870:9a8c:b0:144:910f:43ea with SMTP id hp12-20020a0568709a8c00b00144910f43eamr7908586oab.140.1670423232235;
        Wed, 07 Dec 2022 06:27:12 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k203-20020aca3dd4000000b0035763a9a36csm9359849oia.44.2022.12.07.06.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:27:12 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 7 Dec 2022 06:27:11 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/121] 5.15.82-rc3 review
Message-ID: <20221207142711.GF319836@roeck-us.net>
References: <20221206163439.841627689@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206163439.841627689@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 05:39:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 16:34:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
