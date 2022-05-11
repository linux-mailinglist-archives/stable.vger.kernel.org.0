Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948E85228B0
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 03:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240130AbiEKBKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 21:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240046AbiEKBK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 21:10:26 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B3221551E;
        Tue, 10 May 2022 18:10:24 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id i66so968117oia.11;
        Tue, 10 May 2022 18:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4RYsvfj51TW59tKHSOkguY2UjpOlT1Q0GK2exBAIZwg=;
        b=DQ9mErP9MqY/nkkEfK17lMLOQoQ4oui6GRauv8Zp7W7TcITibrHNT6sYylFi9k2IEE
         KBqGjij5gxMXAqwgpmm5b3ZGylU5lN2bFPvYFc83jGWansis1NH03opcTWZvqI42he1r
         mB8deyCXVvKr4noXEXibYYqEzlC2G9he7qDE8poaB3fwGGcyiTQSw+EHk8QsJuveXa+Q
         yR62J9VRJVYHYGFLPRGjXpU9Gfo6vK8SC9xlbruDRmGZjJ3KO44lSASTs6KjDz0zwkQ6
         qr6QvXvfO0fjqMu6qFy0xPWPfYj1fmBHwzjGbUl868Eiq/jC4MtJYzKQbp8VZsvIhLzr
         KCzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=4RYsvfj51TW59tKHSOkguY2UjpOlT1Q0GK2exBAIZwg=;
        b=pC8W5o+H+IH1b32vi1Lp7cxFyys2ejFZsStcd2ZatK497aByuCM6nYxewgur87MXxA
         nIjU87nLtsUxTgDKGAIJCqpMGSBn7e4YMcA8Hayw4nVXIEXQ5RFRiLu8Y/ZvLJMWl8PK
         N8GrbpvkNBu7HS2D4U57g6rUkNdNzvMRrC1RsOPWaaxxALUJuzfjCroPD+3pqF62lHGx
         TDxZi8wwa7AndeW1CcBPrG+rUsByND1GgSJMGJJI7Hh49cz/9Lhymlqyj+728ONIBgOq
         qzfs78TRWWoW9uvnjZyEi5hbtuzb5DPlxEmhdtFVj/uPZSCFtbbqyyQq2eAIuz7b1pG1
         b3CQ==
X-Gm-Message-State: AOAM53219KAQznoaelsUnQDWVtR9sCjTOeMolQ0D+Fq4xTEzcZu28Vvc
        JC9bJRVqw8oW27IU6gEe6HKdrbAUG8tz1Q==
X-Google-Smtp-Source: ABdhPJxJvvWEU1bpNQHmhF73V/v80xw/2MlLlWq/x4MXroMUhOaC851Jz6RZHuRZvg0IjVIAOtjbig==
X-Received: by 2002:a05:6808:3010:b0:2f7:3e71:88b2 with SMTP id ay16-20020a056808301000b002f73e7188b2mr1373068oib.102.1652231424190;
        Tue, 10 May 2022 18:10:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h36-20020a4a9427000000b0035eb4e5a6d6sm331726ooi.44.2022.05.10.18.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 18:10:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 10 May 2022 18:10:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/66] 4.9.313-rc1 review
Message-ID: <20220511011022.GA2315160@roeck-us.net>
References: <20220510130729.762341544@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
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

On Tue, May 10, 2022 at 03:06:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.313 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
