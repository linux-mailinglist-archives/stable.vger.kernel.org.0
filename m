Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271115876A5
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 07:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235582AbiHBF2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 01:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235604AbiHBF23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 01:28:29 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABE93C8DF;
        Mon,  1 Aug 2022 22:28:29 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id v16-20020a17090abb9000b001f25244c65dso17395219pjr.2;
        Mon, 01 Aug 2022 22:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=zbG2Q0AepNQMEB3r/toDmOHW/Si8fawHY5Q0m6x+7Tk=;
        b=PkjiQpgOW6MdjyD5HkiLtnwR5borO+uEewidnksA7zu7mrZe2kBJWsYHEvWuSsjDNk
         L4FaaIF/+3CeNLaJLVEyaC6uJJTGVu60gjUBIvZg71yzzvuaSPs/kkk8Ai4CSchzbIID
         mvCPlmfry7nRk+X3Qw3hzhPco0cB3vqYA3frSJXq5iTdA4Nqp763FxSrHbjG7fWl43fV
         jmu9DSXYtsnaYwXLm2XEH+qhgJ2bBzlBvBYLnhJNnrBjUZaODFKp0UjzXVumhutq16FY
         O6uDsNxV/mzwJOWbYKTci8uzvRMGqEFjDdHKrhcNUyL5BPpPe0IMr+l5eIxIVG32Wdj0
         swFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=zbG2Q0AepNQMEB3r/toDmOHW/Si8fawHY5Q0m6x+7Tk=;
        b=2W8Fd5CWH3HSS6gXuXgZJ/39DGlxI4eBXnlBWGCB2hiqEfbX4X0wX1P3tFeHU+NCCS
         F/2xvHvZE+yO34RPyC12g3UFWUnahMoOUxrUFtXiJMAjhktCNwQ99mLo9CVEioA5OXO7
         mSETwNwTsGFju/ohFdB8O7Gol2suRydnR1uNDf7SYsBjW5gh5RuTXvc1BqZgw3Y+SZ+d
         kHXUr2TaA0J3pImzNLMG6pR5kLSox1td8SwhNDwMHMcHrRDmTVK+z4FGvVFUcnRuXHio
         6uyruVx9gu1T5MxFguB85WdV4h1OXuFd23mkRVzx9DR24LKv4rEPO/ZxUDUqCUXMsYoZ
         igjQ==
X-Gm-Message-State: ACgBeo0+8DeAC9+dUyyfQ4nV6UKC7VaXOauUmZ0qaW07V3Rd8N+Wl8lQ
        OGNj0RIeLEdfVHcfSC6YMPI=
X-Google-Smtp-Source: AA6agR4cmdk9PBpVxNnl+dfoveEv99YZnZzx3d3Mv4gX7+PpBL3RWBplBeojPTu5GPxtIMetGWmuPQ==
X-Received: by 2002:a17:902:d651:b0:16b:f55e:c626 with SMTP id y17-20020a170902d65100b0016bf55ec626mr20149747plh.78.1659418108659;
        Mon, 01 Aug 2022 22:28:28 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f1-20020a170902ce8100b0016191b843e2sm10674076plg.235.2022.08.01.22.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 22:28:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 1 Aug 2022 22:28:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/65] 5.10.135-rc1 review
Message-ID: <20220802052826.GB572977@roeck-us.net>
References: <20220801114133.641770326@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 01:46:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.135 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
