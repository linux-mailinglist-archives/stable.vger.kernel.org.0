Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D6564AC53
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 01:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbiLMAYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 19:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbiLMAY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 19:24:29 -0500
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3A12195;
        Mon, 12 Dec 2022 16:24:27 -0800 (PST)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1445ca00781so10607771fac.1;
        Mon, 12 Dec 2022 16:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=puW+NA+qcVfbNDwy3Cka1eMBFMm0X68cK1dM0/fozLw=;
        b=Gt7OaSH+GRgqDlxMmqcg+BrgJTkKY2zhgR+fFFSpxbeOVYubEGSgMMK7VZbTDhi5OU
         5eFi9ZJ+BJw9SlQz+ZI5LPFB1/f88G8zT9wFLdT8+mZTWoyYzPwGKgnR3RbGc0TbPbxN
         mYNdrUukBvYLuxqSjaWSCUwm9B9T6XNOAQIrnzMmansPPvL+WhTorjMiwY4MVo5DfZOG
         687+uMkPySjwwfSSWubNmgOH4DtSjUIySm2S1O8jnK9TaCIGhKw7eOV0XMzYeYNa4DR1
         kSLFJ43jPUFELsoBrhHk6AAMv+55oAvtoOhZD7dTHvRpJNzpPrjppUi387Xkr4gJ12wU
         oBSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=puW+NA+qcVfbNDwy3Cka1eMBFMm0X68cK1dM0/fozLw=;
        b=wRrnQudzgAvdiu0+QPa6Jv7mKtCUpkbEVMroK4fq7K3isJKPIYzJCqC8kFyQOG4Bv8
         q8fi/sR3hzypvr4T2/iXF81JkOvyvQTLWlOuzPmdTLrcFjsAgF7dvgZ3ARPDfoNVvnrM
         oa39K3Ky2EAkM73Nn6/k0nYi2j1RNKnsZtl/sojRcaanoC+LFrlkpXhljlLDDkbFo6ti
         vC5CM3H1S1ETexFPLDkL49l9lnvTFTt2gZUtTnWzZ0J+KsXwLM/xDTo2NPwDw//v3Lr1
         b9iQ9P8KnsogdrpeVVKiZxP1mWMR+ZhHfm/6ba+UEMzE72ttvzX9hj0XQG0sEsuRZZII
         JSvg==
X-Gm-Message-State: ANoB5plIGyv3N1l/RWqs8hk5dy5cBLhaxs8WtDdToKFpaNp787XIStqV
        T6pLWSXETWFjo8754PPqsLU=
X-Google-Smtp-Source: AA0mqf440i5VoGkq2sLet0cHK1bXq6hwkYJwe5Dmt9UoKiow17dF+uX43VZ2wMJJnd8N+esnys9KMw==
X-Received: by 2002:a05:6870:b388:b0:13c:14fd:e901 with SMTP id w8-20020a056870b38800b0013c14fde901mr11662446oap.27.1670891067327;
        Mon, 12 Dec 2022 16:24:27 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w6-20020a056871060600b001446480a042sm616253oan.58.2022.12.12.16.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:24:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 12 Dec 2022 16:24:26 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/67] 5.4.227-rc1 review
Message-ID: <20221213002426.GD2375064@roeck-us.net>
References: <20221212130917.599345531@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
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

On Mon, Dec 12, 2022 at 02:16:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.227 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
