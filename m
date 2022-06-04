Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3111953D899
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 23:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241758AbiFDVUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 17:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241962AbiFDVT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 17:19:59 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7523D4D61C;
        Sat,  4 Jun 2022 14:19:57 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-e656032735so14843591fac.0;
        Sat, 04 Jun 2022 14:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K2R5nf9O6AXprXYtmFMJmMfna4dlV7oqPr6ZCw0TaSM=;
        b=Mr2vutiv5X3Uqb/yPEUs+327z19fq38IV3IhPA2fuBuPaiQ36mMBs2FQCtbNhRh6Pp
         WLRDwyMxgYWBGf6MLFnhUKPez6h5VAuWU0pz1gEDtpE/1Plad+V+F/T5gpnVBSL9z0DE
         igOBECG1EXpTxN8oDCbVpzr7Rptin9icrl6p7ggrjSrNMsQTEdeunJFauHLoheUHUzhW
         7e0cRtNYFPoCusfynYimsvOP0xbQXeDPxTCaRjYJgEzZR5dijrIlrlk38Z3JdoGxTJ5D
         wYGwiRGE3GXBcu/QQ04nV9zg94UDMx9WU1svOTx+bIUbUrFHGqNCA6C8qyr4mXo/2ok1
         XafQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=K2R5nf9O6AXprXYtmFMJmMfna4dlV7oqPr6ZCw0TaSM=;
        b=tCfCj0Cp4YRbWjDa1cz2n1JwnlGeo0xfE6uKO/BoYt8Jo3L5YjO4smxE/l77STHmFT
         TcyC4M0CZc0/a7Wyfb5cA30A0AtU61WbKb7G06enimwResMJ8kvI2P4YjNdWwS6Ikk2M
         daK6p/HWeLwN/XGENGbrk38Rw3syv80nDoixfRvapzquLiC0S9Ev4eUb8PgfQZEYeiKz
         VF4RJ+wcoYlwdvKnveea9ZYtzgs0s3Z+GcqK//vS5lVyhlXwRRH/xdKlSeSzD6DNQgpc
         fySsaF4/YP1UIhWqlAbkna80FrcphKa2s70rvWCEZGoLKbRHxajeK7cW+ttMjFGwPmH5
         J/3w==
X-Gm-Message-State: AOAM53172nk7nMkmiEmRDqurUkXAz7YqzM7S1w4anVFIYvpHIb6q5R6a
        F4w+Fas+f+3z+QjIARHoV4I=
X-Google-Smtp-Source: ABdhPJwYEaG9q9x4p0Kd0sEYx8WTM1dFHp/XBRnjlJ58/Y4KLNuaufFeXR99f7Co6LhD60kSbPKQTQ==
X-Received: by 2002:a05:6870:b292:b0:f5:da78:c444 with SMTP id c18-20020a056870b29200b000f5da78c444mr13453322oao.214.1654377596779;
        Sat, 04 Jun 2022 14:19:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m11-20020a4aedcb000000b00415a9971cfcsm5731100ooh.38.2022.06.04.14.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 14:19:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 4 Jun 2022 14:19:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/66] 5.15.45-rc1 review
Message-ID: <20220604211954.GA4026952@roeck-us.net>
References: <20220603173820.663747061@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
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

On Fri, Jun 03, 2022 at 07:42:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.45 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
