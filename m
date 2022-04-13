Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5308C4FF8B1
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 16:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiDMONQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 10:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiDMONC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 10:13:02 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F61A5DA61;
        Wed, 13 Apr 2022 07:10:41 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-ddfa38f1c1so2092487fac.11;
        Wed, 13 Apr 2022 07:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CB21EjTwTZX2xIeMuQ+nJ1DY3UPa1qBDqJ2K4iqOEas=;
        b=j2n6xMW3iRyxWZ+enpa0uT72iYc2vbi8Ro5xoYusYFeoGgl2YxM8iRLs4aYMf9bnGO
         6qjjWMd/sPFCXyD63VpVQUWjxO3cpfZmnvO1TUiYNyNUasdxbjgIo7BnOTtXrnytssy+
         O7ikt+dq2WNlsGemzTXk+cX5TDH6DCd/0WAjivn5ouBpO3/K4AtZGFjKwDwkw9Hi/2uW
         PunUhMJ//i8B/RUfXS+6CQXb9SvG6EwiEngxrZAHvKyw+nuS44hcKQdAsxRkbJDyjJk1
         MKudMJtmoJsjhKvVaA1yt1NwGNKyFQr9RGL56BCgVG//fCqyPv0LqV34a2vS9IMKxX3a
         rYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=CB21EjTwTZX2xIeMuQ+nJ1DY3UPa1qBDqJ2K4iqOEas=;
        b=5omKoG1EuIZirWaLVNaJNq7DnaV8nF68UQe5qfuI4Zre8hlraCw5x7C3mu+ChwOmue
         l/CgyxVcsLQgVXodLq47lcOhCLjdSjAvo6WcJJhvVWzkpY4bbqreNza7dzOZ/mprb4Ud
         edr9xj88vijPKMEMERmsDPtgkdJMPL7yxEDf/QppJLCBWsiczVLtvduEoHBhSuchSZWH
         dQ+mJR9Jf5O59/n3dfEeJJqcGKzbRvZEV/D4nAtHwm05p1aaTazeoupcu85X3z/uFIJ1
         BYHD7CojX67Aw25z2DR/VLi9ECQ+4ml7URO95HAqSTnmJ/mMmHUG6zVpmOn8ETpzR7Ek
         f6GQ==
X-Gm-Message-State: AOAM530JFMxbKGFddFGCkggSoj+rhy/G2YnpvtavUMD47jq3okpNkcXK
        IPKRCj1bfx0lLSYAUMTD5L4=
X-Google-Smtp-Source: ABdhPJzdO9MooMAuSEMck+TPSgbY+hgEOwEtJ+siF90uqwOtoM/J8kGPpqEYR6+nWHmurVKlX/8TJw==
X-Received: by 2002:a05:6870:e30e:b0:de:ecf4:df7e with SMTP id z14-20020a056870e30e00b000deecf4df7emr4548389oad.114.1649859040660;
        Wed, 13 Apr 2022 07:10:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o13-20020a4ae58d000000b00324dfcc5bcfsm13987033oov.12.2022.04.13.07.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 07:10:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 13 Apr 2022 07:10:37 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/170] 5.10.111-rc2 review
Message-ID: <20220413141037.GA2398668@roeck-us.net>
References: <20220412173819.234884577@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173819.234884577@linuxfoundation.org>
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

On Tue, Apr 12, 2022 at 07:46:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.111 release.
> There are 170 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 17:37:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
