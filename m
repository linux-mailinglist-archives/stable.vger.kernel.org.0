Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0364D9B37
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 13:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241833AbiCOMa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 08:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237425AbiCOMa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 08:30:27 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51326522CF;
        Tue, 15 Mar 2022 05:29:15 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j26so28755181wrb.1;
        Tue, 15 Mar 2022 05:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Qt8Zi6N5CRpqtRb8Q70WvpWjF1xQqsL2VLBHLQjfewk=;
        b=Gzn0UDPLSgpftfbkJ7185XS8OEWz57i05Ai2HcNoDo9fR5YowSwMWtRZaO4DFzuRg3
         IcmNYcKW8lcRrsY2dTW5/Yfv+KYLRYbmkfk/8CksYwGDCSwxbBIdeWw2EKT7aZwmCDcg
         VCef7+Bo0/Lv+H1mt9uYnILTswRbi+KmVXFEn8cWU0D9h3B2EEfQ8H/JTFrglkDkKNtr
         qAbY6xa2IfgXdMeM7t5KuXHd5szn0JRscW8TYxJtdi+BUPAdxWI56ipVROOSuvq2Vlmk
         cahxLCmVsj0RcASgm3ig+Pc8g1wlNt+cszq5sTT+DtPH+U0hsVsoqleqNaZ1HItbRJ5l
         nZ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Qt8Zi6N5CRpqtRb8Q70WvpWjF1xQqsL2VLBHLQjfewk=;
        b=wWnez7xlkzPb1T90an0KOMTqbjiJp/jEgrQurLXIuIXNAT8wQ+bufTYNYGdaWevftq
         YYckO1kjGtxGsD9xOsysUCrH1X4TGVYepffAVyWF6PBiyUVbCDSxbCm+n3/ynGCHW4AX
         Ah1cKBfDlfyjPtTmL6Mr/IOZAInMjwl3a+QRPW9OtxyzTbb2SJDETLvxY9dEfCnq8Io9
         0vmkd8l/bdOxpNvuf7OUtCOp2qG4DCIEAgpgUEPhp9MxwFmzduKHnNnNFGMhCkuQeHKN
         HdyyAf2/1fKPrw6hQjHW+gK85eHxUFethYwavE7s8pzMaq1IvE6wl6S7G15GTVOHlFuC
         yZKQ==
X-Gm-Message-State: AOAM531diuhynjblEkouMgYwaRE+yygkzKrOR1hYHwhYa50BihkBogUs
        iFvq8440QIpWfh6cpxCbkcY=
X-Google-Smtp-Source: ABdhPJwDkIOy1jz9GLuhiJaqEfKeEbM4arr8+YvQ86nf//j4wIRRuoduy9FNIQYyG5Vq/R554BMcwg==
X-Received: by 2002:a05:6000:2c1:b0:203:7395:8668 with SMTP id o1-20020a05600002c100b0020373958668mr20399671wry.409.1647347353810;
        Tue, 15 Mar 2022 05:29:13 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id k13-20020a7bc40d000000b00381890032dfsm2154788wmi.1.2022.03.15.05.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 05:29:13 -0700 (PDT)
Date:   Tue, 15 Mar 2022 12:29:11 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/43] 5.4.185-rc1 review
Message-ID: <YjCGl7OYvBLkXH24@debian>
References: <20220314112734.415677317@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
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

On Mon, Mar 14, 2022 at 12:53:11PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.185 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220301): 65 configs -> no new failure
arm (gcc version 11.2.1 20220301): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220301): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220301): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/881


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

