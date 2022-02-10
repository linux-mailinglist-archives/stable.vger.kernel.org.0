Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF5E4B124A
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238790AbiBJQD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:03:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238433AbiBJQD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:03:57 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6388B8;
        Thu, 10 Feb 2022 08:03:58 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id d14-20020a05600c34ce00b0037bf4d14dc7so3630759wmq.3;
        Thu, 10 Feb 2022 08:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2xF053KIw30nL+7mS9g3wv9CW2QElTIChX0OJqPTszc=;
        b=FczoO6cObrWTfaY/ikD3OA/l1n4TR5YQ9il61pSRasI3yzxUQsAOOfTx8UebI+WLoN
         qx1SOEjfKQS7t9fX7oEN6YpENTYn4kHJ4SmYT6Puwzx65hCvELHj/caZC72JSYkkuC5j
         EOJUT69X7+3JvPm0d3cU8YygYY49ofe1lZbsHILvh7qj8iJshxw32SSA4E0sKW1SgPFJ
         ab3DVJ4J9b2+h1Yu7hG8C6Ov3VDaG1TcxIdEDeLIdUWvhTfjFYxd3K0hJqlExZJQSV/d
         8y0uMnkcEDXLaifEiYJA1YGZ/Ua4uaIUqgEaLkn3QRf0Ubj+K27C9mnS1ChhAiFB4wIT
         zihQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2xF053KIw30nL+7mS9g3wv9CW2QElTIChX0OJqPTszc=;
        b=43Lwf891u3s1iiWf1NtlUbHVAB0yqpEe8531cFppVhpD3kjdFQO3pqNHF13MfUhD0n
         jWg38Og5ZTAVb22lOzHpcFzSJlAVX9IWv/4UYSGBwyzZSWSgRth57jSouC2inwoXtUvb
         FZ0kXZUFaPAtuYyq3/cn4zQJLs9ZdixRH6OLWjd2/KeNuW+TBUT9At96qpKu7ba6PCyK
         atRVhjmZEDZf0AjDqB3JdhKvh2DiThORV5JT6Tl8ML4vZ6fwW4/G6pz0S/anu0FUgY8E
         5dwnBYUpJEEJ6ZaqPo0jv5epzDEdSnGMvk2iPCeV1v+BLhz51nHcKKl4qTUMGwj31fC0
         +yDA==
X-Gm-Message-State: AOAM530hENel3P3bigHswpq1etBKee62REe18KlMKGXRhWEqPZ+PGxJM
        ogbe2SJjAKnQ8ebd0pzRFIiQYob9ouUZbA==
X-Google-Smtp-Source: ABdhPJzm+pH6rNm+jo0Se4bsZ0PE4OR4R4cOhiR/qyGh8aaq+Rtco/5CuAWhGMCN8QW0QSlAyg1oVw==
X-Received: by 2002:a05:600c:1d92:: with SMTP id p18mr2683856wms.93.1644509037372;
        Thu, 10 Feb 2022 08:03:57 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id r6sm7230394wrn.74.2022.02.10.08.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 08:03:57 -0800 (PST)
Date:   Thu, 10 Feb 2022 16:03:55 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 0/1] 5.4.179-rc1 review
Message-ID: <YgU3a/A00ZerWhtD@debian>
References: <20220209191248.688351316@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209191248.688351316@linuxfoundation.org>
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

On Wed, Feb 09, 2022 at 08:14:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.179 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 65 configs -> no new failure
arm (gcc version 11.2.1 20220121): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/733


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

