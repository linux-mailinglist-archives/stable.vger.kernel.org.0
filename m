Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E8F533217
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 22:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbiEXUCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 16:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241512AbiEXUBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 16:01:38 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CA52A709;
        Tue, 24 May 2022 13:01:36 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-f2a4c51c45so2566084fac.9;
        Tue, 24 May 2022 13:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cOR7DaeFEGNH+t5NasKTrM6gqL4Lc3YLoxuqld1dLT8=;
        b=mz015q+CJs0wWhv3RKJDhOGvL+gtqDNd7CmGcByJrCK2w7jTpLa7xI1jDXuC6Xetpc
         94uLMr/YT0TH5Gul5WdoGpyHzGcwKG4adftIW9b3FdYMvXPMsBdFzjK8FI24CTJBOuix
         hQtZZurE6Jhu9LeFOXCnu17HWCtcwd3YnZ+PjfmWv0RilzTNAhyhteCwz97qrT0LaeM9
         iSi1trACxBFuFCroEzKcPp8qq+Ng2YnhkFLj4glhrkKCoFM0qhjAbvZzg1WjUdWbRhcd
         hdCwF+U2DV+iPoRFWg3P6JRW+Qlryu3ArvOMf1CyRWNDOSQqsO7yvkpxJWCv8XzlbT7o
         IWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=cOR7DaeFEGNH+t5NasKTrM6gqL4Lc3YLoxuqld1dLT8=;
        b=csIkr28ZkSBDXaSOSdp2Nqgs81YmJWrwbHOnSC8qguHzxKY+zX31pW5MSsqzd3q1hW
         nDM5peb8R6/mtZ+WT8yZKBHA/+U/gMFSixEFWSTiQ9If/RilFko4B8DrPLxiDdnomhlC
         Dqw9nzTMnRFUhMLcxMDuWQQ27MdSD+hIPgJKUjhonvTPjVaSyEx7OYq9khXpI5ynZkZB
         xNLS4g+Bp8UVd46s4sTAJWkVJwYMDAG69rdprgLM2gJ4z45S800g/Gs3+EbxKSau+ikZ
         TSqnMnSCh9gJruHQiLA3heeAzLFoDS6TFyfe7w3u2283Bo1zkc7XmOG2rxS7vjF6Fbbz
         KqVg==
X-Gm-Message-State: AOAM532upfG+dpmEJWM3VjRHST3wfY8qp6dzpHJnQ+otSfFih1HNKqTV
        TEd+q30uHfe/MKsUtgW8yaa9wvYkvFjgDw==
X-Google-Smtp-Source: ABdhPJzRwqioKaOKAmzt6NHIGGesBp3xpuXJFOzsWA2XDqr5M+0ttE37cdjS2Q9Q/h5bkfBdS0gl4w==
X-Received: by 2002:a05:6870:c0c6:b0:f2:25c6:ba69 with SMTP id e6-20020a056870c0c600b000f225c6ba69mr3439987oad.26.1653422496058;
        Tue, 24 May 2022 13:01:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 8-20020a9d0688000000b0060ae5f10973sm5363228otx.15.2022.05.24.13.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 13:01:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 24 May 2022 13:01:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/33] 4.14.281-rc1 review
Message-ID: <20220524200134.GB3987156@roeck-us.net>
References: <20220523165746.957506211@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523165746.957506211@linuxfoundation.org>
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

On Mon, May 23, 2022 at 07:04:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.281 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
