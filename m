Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A62584875
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 00:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiG1W6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 18:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiG1W6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 18:58:09 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06BD5071E;
        Thu, 28 Jul 2022 15:58:07 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id n206so4058724oia.6;
        Thu, 28 Jul 2022 15:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2TAi8Coa+C6/B8xZI31cKJDLEkD5bdaIBQLWcJKZ/0Q=;
        b=Jb3cEEVKEIjk04fSt4CRLldMqWPE1rXb8nzfgOldfUUHBzBBl+lKhqTOjVWuxUnzaM
         W7svVfvYNzztn9Dn6+wEagpr3PIrkuBJtTpDDQ35Kl8KyCYU73TexhnR2+wGumznKCEd
         wG8kCY8IwEJSqldB0/69lOsFZs5fl8oxustBdLFgBYSD664EWxnE9hoqYXDjirrRozSo
         8zFUW0KlCDftvJ6ZYC+wfR3ggvRAmmG1TJZ/exoFE2tnCY0zldhT2cGAde13x6tBmXDe
         0ie6Y+5SfTJRA3e2mfzQsQSyrMIhFp/m55ul9HL6E0v8VwIKWDYOtSJhBQ29z3EkzXAo
         dY7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=2TAi8Coa+C6/B8xZI31cKJDLEkD5bdaIBQLWcJKZ/0Q=;
        b=3S9M4RLwZpGj+i+aOaxw5odLgFHBkgjbL8zlLQvIMGCTrpxBkFnml1MmxfnUr9GbCk
         Ui+rjEUqPrv4Ygf3ypmJnZVTwkZMMYO51mdPMyEju+1iX6FzX/q4HknAsRIEc9mw3sjG
         0bvkSwNFWUBoaVwzUA/NlNsLqeT9c0ddNDuTbW1eOSfWUBeQLAkN5WUFGEgzTrEzEwLU
         SMlKolkztupeV2heIj9M0nEvPRX4zza3pS7rOuHomDvHqWR4y081NvCAaYbgmddqtMWm
         ri6u31MzHq/IkkazERZCxKeLreFuL84pn2wdmPdvjsgI8+Qw/FkEfnJNYdtcQfgwgz1d
         Id6Q==
X-Gm-Message-State: AJIora99JhOgdUblw1aJivvxzldXvgGXlgEmIsk59wYMHeT7H67pymOh
        jnMUJWUQihLNLSD4PDdedoA=
X-Google-Smtp-Source: AGRyM1s8GosjAEVG0uziwXJxhELroC4cAXPCxPGnWOXxT890ZEkThH9+MB0NjhmFYx/b6c0Vh81XzA==
X-Received: by 2002:aca:1e09:0:b0:33a:440a:3ea with SMTP id m9-20020aca1e09000000b0033a440a03eamr459795oic.173.1659049087180;
        Thu, 28 Jul 2022 15:58:07 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x11-20020a9d6d8b000000b0061cf19b5717sm816191otp.36.2022.07.28.15.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:58:06 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 28 Jul 2022 15:58:05 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/62] 4.19.254-rc1 review
Message-ID: <20220728225805.GC1979085@roeck-us.net>
References: <20220727161004.175638564@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
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

On Wed, Jul 27, 2022 at 06:10:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.254 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
