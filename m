Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5798F5228C8
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 03:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiEKBNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 21:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235712AbiEKBNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 21:13:02 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9CE1B33C7;
        Tue, 10 May 2022 18:13:01 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id y27-20020a4a9c1b000000b0032129651bb0so608369ooj.2;
        Tue, 10 May 2022 18:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M1evL4yQaooO0YGgJ8e9rkjmE74mw6fSiieiK/VBCeQ=;
        b=KerUkuwDvwKuKa9mRonT29NSnizZg2Wu6g2dHJrzsFNMQBnDukz0eZ9lF+e4e2p4YH
         3shgh6NwxYqSToWCUw4dsmztNfgQvxgk6Dn2I+MS/FEeemPXkJB8iRZ0JrP7NhBr9blZ
         3wKCy4JQV3eDz3xfeQrddgrim7JZvEiksubjnnvvfVGsiKupmTpfvVOa63E0Drium2yO
         a+SzpJyntGFzfjg2GFBL1M+9lxv2zhl4wdoSoh77ys1MhOTrL2pXYjkAOKMRu0GgZbrF
         VQFOnb29iQzeI0rB+y8FwRDn5hMKlKI4JoVWQ6XHETO+63FMjvz6tw4JptB3K0cvJxk7
         6/hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=M1evL4yQaooO0YGgJ8e9rkjmE74mw6fSiieiK/VBCeQ=;
        b=Ftw7V4t3Ddbu6X7MeONKQcw4WMRHc8ph+UNujSrJyhuh950rNdvx+9Qhq/xv+zIJoz
         YdmYIpICaN0iPQOiTNsVJdBlxoe+N1fyeJlJvqAbT4x4NvQEytZGfeEH709rlWbJdTD6
         OUnUnRR+WZ1uZoDJz1CRg2AXHKWJKXXu0VNttD3pfibE4HIFkmAbQIt0m57NZkgV/pGd
         ehxUuCFnXy40QA0M46gV18EbSr2m3IxJrCFoQE3JwuIGS4i5Nkd0RGHtb3uvKRBs4QtT
         6XAObxDXT7+n2s7EaImryPKMq7+BekFvgGJhZpQd/6NIRwCEPeidxgxB4ghDVFrRE2hc
         hL9g==
X-Gm-Message-State: AOAM530V3ethYGl1HYZvNOl1YBixlbBW34oMgkukE22ZJd/4UqTfF91z
        b78lrXNdcAj995lLeqvAp1y0tgugid5nsA==
X-Google-Smtp-Source: ABdhPJzQW+Wu0i2mcjLTt7sO9YLIqr6GPd2qJxn1/I3voVyDcwpvvPlETYQT0P1xT4rhO2+EQ1s0FQ==
X-Received: by 2002:a9d:620b:0:b0:605:ee19:c4d5 with SMTP id g11-20020a9d620b000000b00605ee19c4d5mr9145038otj.99.1652231581334;
        Tue, 10 May 2022 18:13:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k12-20020a9d4b8c000000b0060603221248sm294126otf.24.2022.05.10.18.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 18:13:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 10 May 2022 18:12:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/140] 5.17.7-rc1 review
Message-ID: <20220511011259.GG2315160@roeck-us.net>
References: <20220510130741.600270947@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
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

On Tue, May 10, 2022 at 03:06:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.7 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
