Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7B16A8EBC
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 02:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjCCBaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 20:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjCCBaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 20:30:15 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BADC55529;
        Thu,  2 Mar 2023 17:30:09 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id b5so429579iow.0;
        Thu, 02 Mar 2023 17:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677807008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=owjpyZ4YssNHMo11kjTh9xv1lU6Ssd531IleRLffemk=;
        b=XRR92sY5TwiA1oLizZDrUoFTbDEQLns0/+8JIpPqjy3R0W5mswrcTsVDCkx0/I3jIq
         mhDmpcxq8d8BL+nYCmWf492f1z0QXU5asYiIJvx2ZQoAtoVVifVSCAEyZ1nbXdnd7HdX
         NjYwrzsoxCA2GVhMpmyNFA3QIo/aWmE5jmzoVdA/gEz2y7DSSWiWtDTd8dWhQXGMLzwF
         nNtENT8ycvUdrwyRgHBVt05E5tyGz82ZNTX5Yn1G5KP0eTl8VuAwLv2Vby164wxK5WOl
         +FqHkKDJvl8ffV/1y2/VvavYqXps8dU0p6FnX0xp0Pj9dSyhTJSeUsnudIirZ6jPC05o
         KjMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677807008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=owjpyZ4YssNHMo11kjTh9xv1lU6Ssd531IleRLffemk=;
        b=UfAjWz70ThvklyIANIwnzsMg3EimT3DYMtXxn+Vl0Uqd1UE+yyN6YCCudQGphd0Tq6
         olYH8xRd4jCbqWmh7sUWpaojvGbdK4K8kpq1w4Ik+F+dOokMVslLZ3KgFSqq9d58ueE8
         0CCEHwQkaFNU99BQlIhBNIDXdsQls59Ghqv44ov4wy9XyEG1f/eu7l8KTdRd4A6HXStc
         EQsOELe9q5Aoe5JrxUuNMAjjTvvMgSe12XNJ3tk7lT2wrvuH+khpDAi4/9Uu2zlXXwkK
         BFV7VemlvTFy9o3Rr1I1T6M5nxwNCgINIh618tMvSGulhY7H4v5V2J18MQ1RmNPMdBtP
         Cycw==
X-Gm-Message-State: AO0yUKXQJfFNkHvT3IeGIk2XtRNuiYfDnK2E/w0ug2aPWOIeb3p9rRig
        H7IF0ydpcSS4iMgjGy0hEFM=
X-Google-Smtp-Source: AK7set9fhR4TYUFVbkZkVFd6kHFFDTpiCE6Gi4zYoAjq+2ZGZxe4Ux2rCq5WQdGqOWS+jEK/6k2GpA==
X-Received: by 2002:a05:6602:20c2:b0:74c:b069:f38c with SMTP id 2-20020a05660220c200b0074cb069f38cmr9502ioz.1.1677807008627;
        Thu, 02 Mar 2023 17:30:08 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w25-20020a6b4a19000000b00719987fc43fsm294662iob.24.2023.03.02.17.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 17:30:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 2 Mar 2023 17:30:07 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
Message-ID: <c85f14a1-c73d-44f7-808d-d72484ae680c@roeck-us.net>
References: <20230301180652.316428563@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 07:08:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.171 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 478 pass: 478 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
