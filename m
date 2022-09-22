Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701EA5E68BD
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 18:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiIVQoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 12:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbiIVQoW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 12:44:22 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C38BA99E8;
        Thu, 22 Sep 2022 09:44:21 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id b75so9855893pfb.7;
        Thu, 22 Sep 2022 09:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=bcx+AQmZQA5hSQEFJwbLNrh3coIv8PxTuez3Fat0fgI=;
        b=mEpfbT00WiMkV9CTGVJAJT9CBy1QDBzmQsvAfnk/LAx8CLJCE2nJ2918TqPBM/3gmF
         vlS7KbhTzAbvdD+pfTLrjbOA7Vu6zBRdFSAIk7TBWbthLu/FoTbxbks0/jj01Xbu2/Nv
         HH4k5U2Uw7Ym7dySkfzODPrRqljM8SVfi+xMasFvW3GEWjL72Ap26MbdgbBcBAAGQKjI
         FKzivUaT118F1oZYFYvjRcjNu8gsB0tIjrNflMHWZ8sGxqbtXEdGWC/4havAifrPhAJr
         /NHgcK46A5BYVVa9zuc3l8OKWF9p3nK+Uxlc2O9zbSB0J8s04n5tmEZrRVvvAjuIXyc4
         25vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=bcx+AQmZQA5hSQEFJwbLNrh3coIv8PxTuez3Fat0fgI=;
        b=1CVUqcORNSQDDRIO/KIeAC2nexxDHwDCXUwuwMLBWk6IO9xyywEu/DB9OWwo08XFJm
         6zmDE3S+t6E4xNLJ4XNK8LreDnFZb1dhtJRexrDe4DT2ZONax1+AGBzftpG1nyQDUxAa
         0FCg0s33dsoeF9tLX9wwAjQltPDw5XI9uQDLyG3k/o1XwZwRcrAbEGWTOU5Y5oVB8t2C
         yX98cghRX3quSnaQk1BKKIT/pReJQjyh5JeD8T5OByccaisaR2XmLOaj6V2T/O+rER3u
         EuMyTKGRXWJzs5QTy2RHmW5GfJkhjMD9RwsK4/0acXYI32mJl30GLgdG9WEpy+GXrAL+
         pL1w==
X-Gm-Message-State: ACrzQf1swo73Uc1zZIgmmvcKbc4JMAjsv4sMHXLRcAuJ89nM3NuQ5X+O
        dXc5QfwrIWFZki/snwhWZvw=
X-Google-Smtp-Source: AMsMyM7QiW7UafniOHLsqWxSu3X8BzPGB2AlsbIdq1ZSbWipBD3RX6BOMaDy2K+z3m+mgMKX3xDGuw==
X-Received: by 2002:a63:9042:0:b0:438:8ef2:2476 with SMTP id a63-20020a639042000000b004388ef22476mr3900503pge.55.1663865060701;
        Thu, 22 Sep 2022 09:44:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a205-20020a621ad6000000b0054555418ca4sm4620020pfa.29.2022.09.22.09.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 09:44:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 22 Sep 2022 09:44:19 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/39] 5.10.145-rc1 review
Message-ID: <20220922164419.GC1138811@roeck-us.net>
References: <20220921153645.663680057@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
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

On Wed, Sep 21, 2022 at 05:46:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.145 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
