Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA1C6B2DFD
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 20:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjCITyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 14:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjCITyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 14:54:53 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD23F92CF;
        Thu,  9 Mar 2023 11:54:52 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id o4-20020a9d6d04000000b00694127788f4so1709484otp.6;
        Thu, 09 Mar 2023 11:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678391692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ASgJv906a4xM4w/D+4cFq+nUZbWdbHdbitAAILrPk60=;
        b=A582MTBPzBZrN6YXxVJws8af8uFG6KfDWQe4z3yUwfqHC9z7G98kDa3J3WJH1/Hi4+
         i+eHf98YKGTVXLfs2cnZgNgstN8cl3RWUmnMNtYOtemghO2BGcl5p/2Do3ADaacUBazb
         gZIrvZYbFFuR1SjQqpTvUqbrKEB4PbhEiVMEFOxBCtN2uzBEzW3ZoN8kG2mAi7bZ7NXo
         91f4JOTpF/UoPMOfKqXn5J51+F25LGvendZbFWC4jBzH2ynbMTv7rT2rxRfu9P3ul9lM
         m5dCaUF7s7wN6U/8A+ZPujoAWMW6m5KhCpkpr49e3A+ZDdK3hY9Bkx0aEMpzw0BDoaNs
         iBCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678391692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ASgJv906a4xM4w/D+4cFq+nUZbWdbHdbitAAILrPk60=;
        b=fMx4MQXCtsOYVHK5w2qPGtmVy2kUhjfOnba+LG1/tKUkC+SdPoMX9gxxGBQG5UmvMG
         fTYVNIfMBp+K7qPyzUBRAXMZSNHll69syUtNm9/78RafT8iwG0pXo7LjDTwkj+s2oMjH
         NjkUoEQ+TNEmjMdfflYTgh2s8sNPZZ3H4B5ZfrGjDmpwfznrUV8hK1qcTr3pSoVDgl7b
         cEPyjepSG2OYsk7W1rGtw0vst1bnoN5Mx7GB+BmA2VXbxdT9cjuxaFq4YPmaEyBFQXwD
         +HPTZUMh0ivwWH87ksezr+KD7V6WibbIewZlfS3dPNm/rSMW9B/u56vpSXzZFsp0srEo
         gQRQ==
X-Gm-Message-State: AO0yUKXwKWaFHH1s37XeEq/rweoNdZKai7PImst3LcqAvPwk0CFn8r0/
        /ie2XO+JytR3sNY0iuxZfQw=
X-Google-Smtp-Source: AK7set/mqhc4GJcNt7FnGyLSJWXMy2xPhK/T/4COFxVYMFvDW2nLkEdCurSm6VDNQ+iASkvnxWxhkw==
X-Received: by 2002:a05:6830:24b6:b0:68b:dcbe:d0af with SMTP id v22-20020a05683024b600b0068bdcbed0afmr11232483ots.2.1678391692021;
        Thu, 09 Mar 2023 11:54:52 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l91-20020a9d1b64000000b0069452b2aa2dsm121087otl.50.2023.03.09.11.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:54:51 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 9 Mar 2023 11:54:50 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
Message-ID: <a92d14f9-108c-499e-a699-cccd41dd08f3@roeck-us.net>
References: <20230308091912.362228731@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308091912.362228731@linuxfoundation.org>
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

On Wed, Mar 08, 2023 at 10:29:21AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1000 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 517 pass: 517 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
