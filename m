Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16BF506081
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 02:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiDSAHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238932AbiDSAHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:07:36 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D465A2ED65;
        Mon, 18 Apr 2022 17:04:35 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-e2442907a1so15837463fac.8;
        Mon, 18 Apr 2022 17:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=13pC3MIrNRaRP5xsh5VedJ9t/ELApbJaFWSLBJXvlS8=;
        b=ROhJgwX1X02jWLRNtXQJ1wcsQMXNCiupTEwdtk4sSOUmKuX0sX1M6Vt09MYLU7xJDP
         OmzFqAEUE5oLUr2PnY/g5/PZCSgFbyY4eGuz6fjmbZRPl+3uZfcq1ui1ABRHB7fr/X4w
         b/G/WecR+0P386Zd9rWc74Yiu3I2QG9DPKvNIABemuKmKN8tt5LN1Xn1NnoGUN1cEF4i
         WWENwMgtB6JEbVdQHTXjYqcQwv9n8Pnm5QAVgvqs8qEpPn/mISO+26xvKlKyj2Kw9Ocz
         QL/s5em6SIir3c9/EK5Tec8L9NH3TiiDkWgp9EJ1CLbbLhFiI08tDIL+tUXm7QAd0onq
         /HVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=13pC3MIrNRaRP5xsh5VedJ9t/ELApbJaFWSLBJXvlS8=;
        b=w9ckUoG3ybfVcJZPYu+vvNqryRlrPNxrbhhhVIGsor6M/e4yulPQk1KqC3LhydXKS5
         YDC9Ns9Fj8WmXB5JYrdG7VoFA/B3IrFyWzHBmAVAOe+0GnCmlPXO3Tw5Aog+oI7YqhPJ
         Txw7qSJCOibTqYI61VUyRz1VK/t4iOv+CYvpPwq+AjNrnksHsYJWj/h4jUs1XeVY1zsY
         FQwFru87qRWIrRPhc+d3bEtABlrK3jtp6O/FJN7GakCq4EPPHNGTES1n5s06w5TM0nVy
         te04TEBAEQb0EhYRY2LruAU9pxTPZ7oodf/aIhzErjaZqmXi3HQoN0b5qOpPzjh5pGiE
         f4mg==
X-Gm-Message-State: AOAM532nFZx/gKOzjEwT/m/nwnuk2d2DAPS64+ruO/VI07+db9ImDfum
        rO/1yBidxrY5ucRLtDECRtk=
X-Google-Smtp-Source: ABdhPJzc70PVhaVHUcstBGIvTQpqkeQfkcRJ2paG2F8X4s8LBEC+23+MOXRPLKmoq0cDUtz3Qjdskw==
X-Received: by 2002:a05:6870:631b:b0:e2:7f47:9bf6 with SMTP id s27-20020a056870631b00b000e27f479bf6mr6781402oao.201.1650326675258;
        Mon, 18 Apr 2022 17:04:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j126-20020acab984000000b002da77222b7dsm4598099oif.22.2022.04.18.17.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 17:04:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 18 Apr 2022 17:04:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 000/284] 4.14.276-rc1 review
Message-ID: <20220419000433.GB1369577@roeck-us.net>
References: <20220418121210.689577360@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
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

On Mon, Apr 18, 2022 at 02:09:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.276 release.
> There are 284 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
