Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F2F616F0C
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 21:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbiKBUqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 16:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbiKBUqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 16:46:05 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C900895BC;
        Wed,  2 Nov 2022 13:46:03 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 16-20020a9d0490000000b0066938311495so10945924otm.4;
        Wed, 02 Nov 2022 13:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4aG3HGUNyt0DwZjjpAuTJy3w3YBkMNz9bVnWWoE5yxo=;
        b=mfGOuVFr9mYTrrD4fJ6eUxcXNsu/7ZbadNCdYERyIVRHIbU9VX6YiOjiBixVFxgoFd
         Uuig9VXG1k0xYSoCEDqjY8L/DrvyK5xt3GIEpyh6Xjr58WpH+wuwMfce3O3p1TlND7rJ
         4sDfYt4ug35saReS2gSuDXjaAvvwarpHeOCej8QWULwBX9sJl/Joz3utLkdDkuFF8snq
         gjd0Yg2f3c9WLPmeeuM708ziCL97lDMwdOicl6bL91C9brf61oSAv97Ezv4AAaO1Z3nR
         RnJG/hE6D3vdRVa+VbL0KDH2qcNgiKg1/FFe82brEJHYn3/UFfXiIdXpCgZCcu4cC3Ub
         wWEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4aG3HGUNyt0DwZjjpAuTJy3w3YBkMNz9bVnWWoE5yxo=;
        b=uTo4Z9XnkF9eMJsVeVgRe+WpMNtdJ0fTCKUS6tpdZHKd2gohgcWYXVj+tFgVMfkCYk
         La/PH2tApcUo1EKfCxesTG6Nf6C4rZ3zUhwh767CWD++RUYH8zDKcx00chl45vi9s+Hg
         QYR3fABl6DG8PbMWh4MFR6FXpI3tElOHyLjF0M+/zWeN8x/YHh+Unxz6Yu6RDNMqvcq4
         RBFw9HCh1OEgTkr5P6t0iX2DSlhgDqZF/+muoMztDsffxW2ewrMXtIeh6JjlVYV8N63U
         AwYkurrWsBkOyfM9c/9D6ARuhzA8WRYc6UAMheR8BtxyopDJOXomuIXQhcanQcR7nMO9
         QCJw==
X-Gm-Message-State: ACrzQf1a8j5mvwibqe/HMCBRNkefkVh+k88b7v11JWCgn3uFoEEvwt+S
        j3o99xQ0MkZhRmEIq2LEiCQ=
X-Google-Smtp-Source: AMsMyM7DFmD1zxRjWQ8b6Se5pEik4ZuRNeplTN9G/2+VqDX+VDDjf4dczm+fSbKd/dTF0QdkuXU/Ng==
X-Received: by 2002:a05:6830:6019:b0:66a:f955:4548 with SMTP id bx25-20020a056830601900b0066af9554548mr13508765otb.176.1667421963185;
        Wed, 02 Nov 2022 13:46:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y37-20020a9d22a8000000b0065c2c46077dsm5328617ota.67.2022.11.02.13.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:46:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 2 Nov 2022 13:46:01 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 4.19 00/78] 4.19.264-rc1 review
Message-ID: <20221102204601.GD2089083@roeck-us.net>
References: <20221102022052.895556444@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
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

On Wed, Nov 02, 2022 at 03:33:45AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.264 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
