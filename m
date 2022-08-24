Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0101059FFE8
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 18:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237182AbiHXQ5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 12:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239116AbiHXQ52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 12:57:28 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE2061B38;
        Wed, 24 Aug 2022 09:57:20 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id g129so13732091pfb.8;
        Wed, 24 Aug 2022 09:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=WlBFpbh7KWfEFNvYIikN489GwThR/eMBnv8ESdNVuEM=;
        b=Ldzd9sClgABEARYAN6az+dIYnYws7tiLSY5/eRJokR/zip+e6UtqjVHfpAX38lsTt9
         h2yQGdL0cK7vAEM0up5ldooInJzW0HgPcIJaZODrZwIJVVObDxvFvUIhno2euUj+MDnN
         pP9Z8hrI1+uCcPqcOsJ0429vdn9djFVgCd4nh26Nk1qXBbvojGT5b9YnQA0qXunhLH+g
         GPvQmVRs36NwWnvEsMp7eQFrg60hJp2NDnGDfskjGdctWzIoIvn+los8hRiK+WCCSC78
         FYfuEBfFKmxElVcnuYDxe+nQ+04VvpmfYfsMNLJLlGTGGgWFreR+sU18hVVAqduG2fTK
         q6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=WlBFpbh7KWfEFNvYIikN489GwThR/eMBnv8ESdNVuEM=;
        b=eFWP/I6OUhYdbmPCjhx/VxqAH+F18jriXOOvWkqAsebZTo7wK/2bEtwTfTpt2XUwuF
         cqOkCE+DMQNJpQFmvGmo4BG/yy/wUxNzsKL4V31f8rFjG5ftT5QNv96YiLvOwlFzCntM
         I+PYiDjMzFf3nPNQLaQ15Oy5HHBLwYC/X8kBb2s+93gM7DeCJsVQ3ZCoupsrm+HEvur8
         o+QwhoxEF3eN+A7e+5S+oBDWIU4YbSBt2ZqsunuqtEEJPOFnw8o8FzaSGjacdq66TYaC
         qPP5A7AtYqJCWSXgbwwVa+w+Qc5AvesMdPPJ8EPaWR5lvWFWa3ODKNp4CSrrXjiOC9pJ
         xbYA==
X-Gm-Message-State: ACgBeo2eOj2TOQ+JYnf5ndHB2AnbeuNU5L2GuaFp92hALmEvNNYFL/cO
        e02CSnQRrrb2+x+ibsJDxxU=
X-Google-Smtp-Source: AA6agR6j4Kola2diRL96iTw8k6jWExLtWRQxi8x4UdMU4hZ+91t12LD1vgumqFSYUutMQRL7u6cArA==
X-Received: by 2002:a63:eb54:0:b0:42a:20f7:7d9f with SMTP id b20-20020a63eb54000000b0042a20f77d9fmr23153247pgk.444.1661360240337;
        Wed, 24 Aug 2022 09:57:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e13-20020a056a0000cd00b00535faa9d6f2sm11764051pfj.53.2022.08.24.09.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 09:57:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Aug 2022 09:57:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/98] 4.9.326-rc2 review
Message-ID: <20220824165718.GD708846@roeck-us.net>
References: <20220824072526.750357674@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824072526.750357674@linuxfoundation.org>
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

On Wed, Aug 24, 2022 at 09:27:12AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.326 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Aug 2022 07:24:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
