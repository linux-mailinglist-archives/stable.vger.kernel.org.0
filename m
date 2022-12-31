Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4FBB659F6D
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 01:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235901AbiLaASY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 19:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiLaASX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 19:18:23 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885D31BEA0;
        Fri, 30 Dec 2022 16:18:22 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id p17-20020a9d6951000000b00678306ceb94so13964476oto.5;
        Fri, 30 Dec 2022 16:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aD2pyMO7OOE2EFdyuJsS7VOYOnoYMeTk7hsW83uEvV8=;
        b=gsBeA9puLHv312HXGRargKviqboQP8bDFbKQVh7oLP8HSMGIbMFKW2jkFJluyDd+Ut
         2J82O/Wxazbb4Hhi6kG9AOLCcCF/AEro9GHDhJL6c4+vqhIwO7qiYKscjlmU0m58WeRS
         45gWL+LVa4hvrId0hJR3CtqRGGJHMg1ZLHoRGuym4+6zHHjB4FwF5p3FWMgysRo9ugID
         A7BQcwLyYQ1jaWPqfDoQuPCmTlPrPOXIAid32yMnQuR/0+cCwAsDH6eUfA7JmFHfPWZh
         l1hEFZrJUODk1lHeonJtfxWwNNpGFcNdgecScij3+wGCAwnqlkNVZcQAyCutCdvy5eZ1
         jDsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aD2pyMO7OOE2EFdyuJsS7VOYOnoYMeTk7hsW83uEvV8=;
        b=7jaYl/EQZY8LQk7EgRaE6QEE6NyaWrnHLu+6fS14ZMW6AgF6xCsEiV287yzA/ZkT4n
         zIRK9hEcuPhP2fnpmdLjoSs8mOlr5Gr6ASzhHl7HmhNUsKDdLLlEknVtqTkaIGULrdRS
         c4P/X1IDwMiiRALLHNfWqOg0HDlp3mpJWhz/j4i0NZy70kvZCt1JFtfo1EgniTMNm7xp
         EclqVGaBJz6fXlSovC48sy4Q+J2FPMgTHvEXNUOXrECmPZq1duzv4w1oh/HgEuyMna2G
         brXXl3SCZxJA+KvfhBWHJ01lzPT+svl+z6tsjA71F/aISfNBub8sJBVdL68CuyLtTkAy
         h6Lg==
X-Gm-Message-State: AFqh2krAsQjEJP1lYglcBaVO5fH2rCjdXSv04hc7IDJJiLkF3qsmEZJe
        QIjrhwPhhBiCP6uS9oVdWZg=
X-Google-Smtp-Source: AMrXdXvdz+SsbecyfkE7gIv/54GF5vG6lc9xlPFy7e3LWgWslg7ajzCmV8QAsZb0wnBmQUnbsypmOg==
X-Received: by 2002:a9d:7f12:0:b0:670:9cff:64bf with SMTP id j18-20020a9d7f12000000b006709cff64bfmr16529193otq.21.1672445901893;
        Fri, 30 Dec 2022 16:18:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c1-20020a9d6c81000000b0066c15490a55sm10767405otr.19.2022.12.30.16.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 16:18:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 30 Dec 2022 16:18:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
Message-ID: <20221231001820.GB2916712@roeck-us.net>
References: <20221230094059.698032393@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230094059.698032393@linuxfoundation.org>
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

On Fri, Dec 30, 2022 at 10:49:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1066 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
