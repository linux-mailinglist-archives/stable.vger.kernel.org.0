Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765F8248E4D
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 20:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgHRS4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 14:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgHRS4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 14:56:38 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C602C061389;
        Tue, 18 Aug 2020 11:56:38 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d22so10417318pfn.5;
        Tue, 18 Aug 2020 11:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=h1Npy9lfI4/JBxbU7+Sh0rToSsovercBDFWIbJBFebE=;
        b=EZuMUn/pn56XcIr+CA7pCkm804c+SZUQT/fSTLD8ncwKQXfxoZmWeg5OaELcsW66/n
         WzGLdUH6xGgg1y6c17ZaLuF4SHLeJqVTEXhydij9Pol3JSG2tDEKdh5gy7LKssH6ZtXM
         EuIQfo1wODDXVYEB/4B3VwI9L2/e2AF1HrFV05zIbkt0TvMTBYs/ut+zwnU7yJ8G1HuB
         3L0niE39VIlsz9WiIC+ttgbpLKSm7C3B3z3MSxe2DDMEXUfIOcPIfsZVZy1ArkDns5ZV
         2pYi9hSbuwrsqworCDT/gxSCJPe5YBhAgWg5T81AK6JWfRDaAIESwSeLRWdcvRf4++QC
         Yshw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=h1Npy9lfI4/JBxbU7+Sh0rToSsovercBDFWIbJBFebE=;
        b=N7hn/+WJRFyl/jGLxIPRYnyTWWGnt81sOo5armPyePzlL1BsThUjO01lZ3K45Rzbgq
         rIVTxH20f2DkyALBuJa0uSwO6uUnuqmd/JsmojsLaY3HLwLIYIy9bT6YFFxqMSEqjFcP
         SxQ6fXcECunQ6t/pXU1NVIRTHBlXOCgPDE0pm/g97vuohIwUXKE0+Z4fGnP3gddmuyZM
         x2vq65l5zflUYbz4EqBGK+iRc/m/t/KrHfYPlJbWye0NDCG3PeiDfGgfuRz4vpEJvCcx
         2A+u8w6ca08CfBwCApgcgFfNW7MRRNk42Di7csCBnyh8dErZZLmqmUWb0xjF3c5ItolU
         seAg==
X-Gm-Message-State: AOAM532EgNCj/ZpywaF1GYuHNfsVh9BMKTl0DbDapuqLBXx8LvF8L+7+
        iYgZkHZ1H5jC0R20ggzxOeI=
X-Google-Smtp-Source: ABdhPJzOjILTwrVr021GUqcpseRIbho03toh6P066cByz8UimyTorcFKkdPCZKOzZOGdYqEWDdDfrQ==
X-Received: by 2002:a62:90:: with SMTP id 138mr16435308pfa.0.1597776997789;
        Tue, 18 Aug 2020 11:56:37 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k42sm590771pjb.52.2020.08.18.11.56.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Aug 2020 11:56:37 -0700 (PDT)
Date:   Tue, 18 Aug 2020 11:56:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/168] 4.19.140-rc1 review
Message-ID: <20200818185635.GA235171@roeck-us.net>
References: <20200817143733.692105228@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 05:15:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.140 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 420 pass: 420 fail: 0

Guenter
