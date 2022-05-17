Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406A352ABFC
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 21:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352727AbiEQTbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 15:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344679AbiEQTbq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 15:31:46 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371D81A076;
        Tue, 17 May 2022 12:31:46 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-edf3b6b0f2so25449888fac.9;
        Tue, 17 May 2022 12:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JOD1jL8NXltXyWYnVTWVOcJCh8rBpERbE9/YPLi+pYw=;
        b=CSkvq5O+htBaFLfOJx7mdt9pLTInl2sxASdCExBjQCwQTOZAXCe0vOu0VD26OEYoIf
         sjJbhca3wQu8W+sL3sEKD8hawf0qL+9+83UresJFVzNl8uZhKr5zuVdMQEXL/0v5ijSm
         T9ZMDeL5X3/rSlbUIYx/jby1xH3Jrw70yTNwUeD5/+mbYfNJNhAjyzaz3mjadprKfc8Z
         bpIrCDMwbDODlP/F1PMCQmj8FFB2pOOSSU1aQcjpL4YnEuEfrmU+jvsYX800GkesRb+g
         2jwVVm2zmOw2jtOaM20WsBwWOCLUrbKAvNLMPclIppo5Y9HYzVNnicABps2wH4fV9q+B
         ch3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=JOD1jL8NXltXyWYnVTWVOcJCh8rBpERbE9/YPLi+pYw=;
        b=DMvyCp7aaSKDYfKVO14w/7WHrrWV2IlbIeuTe704EDXkNBSkXulhaTO46/Sb0In4lg
         q9Ye6VHhI2IH40bCrffBtEhsA1zn7iLgiG96uK5GrefmOr5CluchDuQzZZl87RA9uw69
         sUFQXgqzSRIZZaL+1+fy+ginIx5TQaBGWRCPAoou8LU3Lb6+zfVGlEO5W73SU1GbpbqG
         SJ3Ay19bIsRvu6cQi8/VOIfbXLsvqXp0voUufhRR5jVRc742kKiHI2g+X4UQDwy70YZx
         60IqTKGBQX/bsIaBeA6ZvEdlKPHiguBMKxY+0RDiVcqmYK3sKZ5JhARWSLCK7irA4tjN
         YZEg==
X-Gm-Message-State: AOAM5309TXTDofzCu6kgL0tYFYOsI1b1QvpUtcS32ap5xbYzd82EWDQj
        HAgdRrCIctQEZ7E9vMii9Jc=
X-Google-Smtp-Source: ABdhPJxml77qht5cf3i/NEhn8RtOzRa2I0ibVbymHVJeu4M2PuKKEEyMwkgJhoX31+ZGu/PIJSA1oQ==
X-Received: by 2002:a05:6870:b00a:b0:f1:7f07:8c36 with SMTP id y10-20020a056870b00a00b000f17f078c36mr9549264oae.278.1652815905557;
        Tue, 17 May 2022 12:31:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l84-20020aca3e57000000b00328e70cae5csm61339oia.43.2022.05.17.12.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 12:31:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 May 2022 12:31:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/102] 5.15.41-rc1 review
Message-ID: <20220517193143.GF1013289@roeck-us.net>
References: <20220516193623.989270214@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
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

On Mon, May 16, 2022 at 09:35:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.41 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
