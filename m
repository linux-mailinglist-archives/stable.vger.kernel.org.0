Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744D0638EE8
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 18:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiKYRSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 12:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiKYRSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 12:18:42 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FE450D52;
        Fri, 25 Nov 2022 09:18:37 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-14279410bf4so5833094fac.8;
        Fri, 25 Nov 2022 09:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l7x5BBj5fBLX/5/DEcV6SvhEuCMk9BiFNrwgWVnByZg=;
        b=aeQEdLl6pBOWT8hSwQ8jK8lMK4i9lzz3gaGUob6rWROi/4evSRD3g4xv9zBe9gIpih
         ETNw6gyJaZ/On0dQsv4l9AlsnlsS9HrF1bELcGvj5m2nxIgo1ldMaeXDImbeEmLMmqav
         bEe7nv2t1ZQO4Jy6MyZ4WLMkmFy9iz9K3BLRuxhLe/ZsnFovSjyG6HcMtji76BrG2cDZ
         r2ATnjFS0TCJzfdBHUQu/GT51jHk80EPro5uV8/YvmwhUJF/3tyfJ2wvLGsKPvsP1lT/
         15b2NXbDJ3Ax33Pqnm/4tTWTg0BHD+xArvLaG0obj3dRIru8x4bp0RycYTG9p+vgEF6h
         7ZIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l7x5BBj5fBLX/5/DEcV6SvhEuCMk9BiFNrwgWVnByZg=;
        b=KwKEExAoubCPPo9BUD9ZGc7dyzowvbdIgtjB40mtqvbURlHiC+bnRcsB9GlsuXM75r
         OL2QFDF/IB5hLXn8W8OizXQTGBjVELhnMKgUrbu38/1gDNMo9KKrJcs24bEL7btJoLKZ
         fbcr2tk3OtYtDRQcHZ+Dm1/9M6eG4LbA0X7vZt3fTnNce7TzPRMkqsxQiMocVhfKp05C
         Or+zE9DAqy4iWqbyEinOEixBzhfrPZ5Qijz4+4Qaa+53ejNsbp/cHfGT2YkuYfyOI3ri
         q3/TZ6ru/V03h7wckDJFqAPQdzkAa0DKHon0Nr5iDidw45/aoSHGEYlTRpiry9G95Pd7
         xwmw==
X-Gm-Message-State: ANoB5plmbxH2FKbJcgyP8Lwl2h1uqOIFdUG8Lpu1lpkITCVanNFutK/p
        D+V0v4EX+s9pZkcAgM11FXRIGn4VXRw=
X-Google-Smtp-Source: AA0mqf5HOtSMBhsfSc+27EtISyyy9Jr09IyMh3qKXAM/mvSAyEX0iHF6yEBFNrHylI+9AogHN3BoVA==
X-Received: by 2002:a05:6870:5896:b0:13b:d2ae:ee0e with SMTP id be22-20020a056870589600b0013bd2aeee0emr12431501oab.19.1669396716658;
        Fri, 25 Nov 2022 09:18:36 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n30-20020a0568080a1e00b0035b451d80afsm1687547oij.58.2022.11.25.09.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 09:18:35 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 25 Nov 2022 09:18:34 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/180] 5.15.80-rc2 review
Message-ID: <20221125171834.GA1205540@roeck-us.net>
References: <20221125075750.019489581@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125075750.019489581@linuxfoundation.org>
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

On Fri, Nov 25, 2022 at 08:58:52AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 180 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Nov 2022 07:57:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
