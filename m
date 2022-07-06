Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E445689CD
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 15:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiGFNmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 09:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbiGFNmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 09:42:00 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A08725583;
        Wed,  6 Jul 2022 06:42:00 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c13so9934247pla.6;
        Wed, 06 Jul 2022 06:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JOC/YszHZ8c0f0EkqP+91wooVvbUgqmmFpJRMtswPC4=;
        b=qZeevQqSaI8AhBWKgXQFF75GcrrylTOusXc2jPCEu7Wi8K4NWHdERRM/93lVB0+p5w
         uzDcS9jTHD/CVHVfVWfgnNSLFftUR2vv5qwSn3EUl6UFMQ9M+lbj7O6FAoin8w4LQxjR
         4FW923rH6AjhFE8nc44ZIE2n6nr7Uhkdrw3HybG0uH8oicc48SPTl+FdI0uO4uFwKS2N
         5PtjSMsmRW+Q14LxKnTrG2UWDs2yRwzX9WAEL5AXbe7UgvxrGepKNMP6iwHN4930T1Tj
         u34eMLlWEsBi0QOR8h+M2xlcapFfpJe/ahBQ8T+ty2j5XEXMY5hFacsQLzgiYKjwtkPZ
         HnGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=JOC/YszHZ8c0f0EkqP+91wooVvbUgqmmFpJRMtswPC4=;
        b=Xwgud+HSA4pBmml/Hq7ljdGUnXHw5cFGHYpAFZHCZJ+gVfLkahGBsp7KpOi+C1ssFu
         kuErnVM2y57P32PkeWrP8EtShePpNv9E47iCwhQnABvBjH7q+ahq//2SK7DLmePnWJSN
         DIRL0YX21T9P8HPcsQkP11c2PaCP3wot64fIK7+Rejbng5jhuxrwrGuPSKi0uN7M0ZIj
         mRFSq/8VU8k5dehxlNdlOSv9WxSfhvwt9cmwdEpgrUfJe0dfgGIBAsQhoHX8LWOAOMFd
         ZFhVuPpzA5Z4q0iSt03C80ahmw/5aaH4OLOiTaFWltY6+GCNykRTuO/AYt9jW+ZAK7Tq
         u8ug==
X-Gm-Message-State: AJIora/2QYtqqEy9Gjj7WyQo/5kGVVDAt86K8H/tphD1uO58p0axQ+ZS
        RqdQGHB7j9ETMjryt0oNPts=
X-Google-Smtp-Source: AGRyM1ve1vQdQAB5MEXns9/EDw/X7iQKfMsrn+5a7cEGbm7uGA/n7JQq91nuU28A4DZX0eauxSpdmg==
X-Received: by 2002:a17:902:f707:b0:16b:8399:9aec with SMTP id h7-20020a170902f70700b0016b83999aecmr49082597plo.102.1657114919646;
        Wed, 06 Jul 2022 06:41:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t20-20020a17090b019400b001ef9c00e39csm3992213pjs.18.2022.07.06.06.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 06:41:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 6 Jul 2022 06:41:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/29] 4.9.322-rc1 review
Message-ID: <20220706134158.GA769692@roeck-us.net>
References: <20220705115605.742248854@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705115605.742248854@linuxfoundation.org>
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

On Tue, Jul 05, 2022 at 01:57:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.322 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
