Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB4E1B4E6D
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 22:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgDVUgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 16:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgDVUgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 16:36:14 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E36C03C1A9;
        Wed, 22 Apr 2020 13:36:14 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r4so1689161pgg.4;
        Wed, 22 Apr 2020 13:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vkT8qxOnWuyioPqENoaMUl3y2aRHXNjjk0feERUfkGc=;
        b=gczPsCtfcsa+czKcD4nlSQUiVU/HMO07z5yY/xBxDBnFNX2Z8f6YVIFfWBHL632lnb
         6XvnAz6vZ1B/xThTWnKNyuMlI8N50Jt42DeWFPF49x5rZhuiFS6m9s6zQBriQT9NCgkf
         hXCEURzPNeI6LEr0F3rzp97CoHgUJaGdxfWxEmuXCgDDQNLbVZV4s6lBf0K+KWOPFwJx
         UteQIUgPqfOTNsaQcB6z1B/zgKkwqzmB0EVfCXtJLFoHXZ+61KDSEF2nCZpuFiA37oXX
         5uD0GZ7OBZ/CKxJq5uyW671+V4OiR7x8CAVD8gTU77EySdwDTq+82+ZtICJFaB+WMQg+
         /ckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=vkT8qxOnWuyioPqENoaMUl3y2aRHXNjjk0feERUfkGc=;
        b=Bx/TCarQ6Hvwm4mDMBpP1BcZYSf+6iD7aI696lK74sxhR7MgPtZa2UpKppLRe6A3Bv
         U9jk6G/NjzF4LiIXTg4ZWsP0jpzXW5X5ouVS+jvjfNAVof2kcSisw7XjFplUDBg3KqMW
         4FuFpDCD/sNni0IJTWAcbiqXYcah8seBNX/kyQZ2W0vKqZvuiNxydG1FpcoQ1ozxPPEv
         M3D96YyW1I6xre5UVLF3TThAbDKZpKbcvQ23XrrPh81Lz/NjGwxOvP6C5ZgDDnw0qNSE
         1My9MSg/pYlmFtOYsNOSTxss7m87YtnUV548umSsxCEcKqh9WvVojGPJVYSQECfbkut2
         JZ6Q==
X-Gm-Message-State: AGi0PuZll3ZS+nc+P+MEDY5waDfgfgrl3m9HYRFxODGgEwOJLRFWVsHP
        oCZpMgSg6aL2LHt3BIFHpr8=
X-Google-Smtp-Source: APiQypKbJBGtsj5by7hmLdo1iY/2lxMrS3gsysisRGNxMxX1krPVtX3v/1V9MZ38T6VYKuEG+jO5OA==
X-Received: by 2002:a62:1452:: with SMTP id 79mr354985pfu.108.1587587774488;
        Wed, 22 Apr 2020 13:36:14 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r26sm392059pfq.75.2020.04.22.13.36.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Apr 2020 13:36:14 -0700 (PDT)
Date:   Wed, 22 Apr 2020 13:36:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/118] 5.4.35-rc1 review
Message-ID: <20200422203613.GC52250@roeck-us.net>
References: <20200422095031.522502705@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 11:56:01AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.35 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Guenter
