Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAA34E3ED9
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 13:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbiCVM4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 08:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbiCVM4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 08:56:00 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22353632D;
        Tue, 22 Mar 2022 05:54:32 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id k124-20020a1ca182000000b0038c9cf6e2a6so1623577wme.0;
        Tue, 22 Mar 2022 05:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+2UTXJuqiFDZ39HnP9HDQjye7jwZjpbaDsJ7VLr5nOk=;
        b=aNzYzCJ4PLf+yohKKkdE92T0ZYdYjXmjrzBSEHVk6TsCrGb28L+qb/v7Y4pn53+7f1
         jcPaO3UenBthWJHkJtq859rVaAv26K8QoyfyUiBVJQUxzO+q2rHgv0renoCF3FTPFyo2
         gZlrTL5zPbdc+pDR/3hvfNLHkU6FNn/CvAyj39uWs4cWWnYzhb6Rtk1FTOw7R9Ar68vZ
         LcYtF4FOKjMyj1bJabVRG83ebm/YPhN3MhzWmTZb74M80o5taCxmHtAQHXAuJ4m9I72r
         a+padPJz7aGJxqerRB0YZ2G0wwKzMibHJaWJr9Ab8F6ym4yg3ls2Q3oVTWeagSvkYKHH
         d5JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+2UTXJuqiFDZ39HnP9HDQjye7jwZjpbaDsJ7VLr5nOk=;
        b=enWknHCDCaqwVmpyW8v975ViC7PNo6KpJhDze1IT8EjeaOMem1fkPZ0MhnINfgxydI
         Lm2JiSltarRsq/kat6nUp7/qUww13ZIxLgWwKAs2nQBPNGiVmtv3y+jHH/anqaigIP1V
         hpCSSAXcOoKEGXXDtRzr67CtJ6jojVZWbDMj9ObDNQ+HnlbDASAwfAWG28Akai/3ufu+
         FkQ8x49ykisMnQU9LIMyb8qGhRY3aGUpqwdxWNoXANFWcUacAlXrkDavZWRYTUzIeWMX
         IQ+uLa9q0VaiKgImW6f583upQGPmhEdIDmHjWGj5xGnbWi4KbjHWdvTIRQgk4uziuLk7
         rnDA==
X-Gm-Message-State: AOAM531ws6oQj2jmY02VpV22b2gWT1UPkkcSIhmx+hc3c+jjWQ6SEfIl
        K7JREq9FCyYLC018BeaZ9S/c88kTCOc=
X-Google-Smtp-Source: ABdhPJxnEIVJK7cCdaSegfjFgN2T7n1+pfdwJvVfaEcaYIwtwU775R97d7Ss0Q4lJHkBFudpUbY6gA==
X-Received: by 2002:a7b:c20b:0:b0:38c:6ed9:f4f with SMTP id x11-20020a7bc20b000000b0038c6ed90f4fmr3793856wmi.131.1647953671229;
        Tue, 22 Mar 2022 05:54:31 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id w5-20020a5d5445000000b00203f8c96bcesm10066560wrv.49.2022.03.22.05.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 05:54:30 -0700 (PDT)
Date:   Tue, 22 Mar 2022 12:54:29 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/57] 4.19.236-rc1 review
Message-ID: <YjnHBVv3z6UXc/+X@debian>
References: <20220321133221.984120927@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Mar 21, 2022 at 02:51:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.236 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220314): 63 configs -> no new failure
arm (gcc version 11.2.1 20220314): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220314): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220314): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/926


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

