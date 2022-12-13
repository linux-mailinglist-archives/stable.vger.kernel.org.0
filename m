Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838C364AC6A
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 01:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbiLMA0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 19:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbiLMAYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 19:24:53 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098D7BF8;
        Mon, 12 Dec 2022 16:24:50 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-12c8312131fso10612280fac.4;
        Mon, 12 Dec 2022 16:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h6jeDh34poGguUHZh/fzBbzNtT0IrkZs6ORknKFm/Hc=;
        b=KiP46e83vN9EBSAM5G+UikHEvsSSZgWLhTztZCIrIqzoSpowuhv//TzQK1kWjmRPsC
         tQjmSuMN0RIBQQ2fhLEHQmK1m2YtDcWUQksETOHoWIhzXc1m5dCs1xcOcvdmnQeejHrt
         pE2ENpsm6A+kGaZu4VxMJhkuzw1Wef2c7E6WXRgIaLPUDT1xxNso/uX7/kwBFcK56UwG
         BD6I1HAWovHIVEG4tBjYwe0Jj3vP1/vOtUPzG6h9hg4DNZ9iPKH3tVRQyfq6s1DE/yQh
         Jq/EpOwpvOEMi6JzScIT3W8eipXKOM2v6L6UXQx3/vC58Nv8gZC2XcSJ+2SeoFCjiu96
         3Clg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h6jeDh34poGguUHZh/fzBbzNtT0IrkZs6ORknKFm/Hc=;
        b=v+hb+p78oB4AOIR34jNhFrVATILoIkcnjKVNypV5zIPvPTT/O5NHofn8Z9wcpXoqO4
         xJsEQ96xr77xPQXKYn8mIVQETwRfy70EiZgQLyG+7PWSgwq2+4nXpzqrhI1exe9llYbf
         DAxyQMRrKYXghJoNF1/QorhHgNQ39rmRMgWkueFYA4e3+jefJlA2faWjVPIh3W2cse+4
         0ZQRb9fuHPU2aFrJ0ObIQpgZYKv58xvk305cq9OqQjjMhzOE9/J23sq+krzhXH2I+NTC
         Uuf0fjqSZvQDuKbglIguZ1cZFldTCfLn0CMfzvQbdS9rsydE5pKqclrrn6dviJK/Xo+h
         ZIyg==
X-Gm-Message-State: ANoB5pnW+b53l4adugq7xB0wRSvrVjnuxnNPedVYXRCzWlG07YT5yjW2
        0gArMFA6DdLJyjWyrRiuVhU=
X-Google-Smtp-Source: AA0mqf6yrW4+fhDTK0TH/ksTAbF/lffIgOQeU0L44nis5a6wLk8Jjz0FlR9rtwhx5G2tBIqeTtq9KQ==
X-Received: by 2002:a05:6871:60c:b0:148:592f:83e0 with SMTP id w12-20020a056871060c00b00148592f83e0mr2452184oan.3.1670891089821;
        Mon, 12 Dec 2022 16:24:49 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s21-20020a4ac815000000b004a0aac2d28fsm537225ooq.35.2022.12.12.16.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:24:49 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 12 Dec 2022 16:24:48 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Message-ID: <20221213002448.GE2375064@roeck-us.net>
References: <20221212130924.863767275@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
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

On Mon, Dec 12, 2022 at 02:09:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.159 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
