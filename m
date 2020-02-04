Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A740151F29
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 18:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgBDRTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 12:19:03 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36970 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgBDRTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 12:19:02 -0500
Received: by mail-pf1-f196.google.com with SMTP id p14so9788160pfn.4;
        Tue, 04 Feb 2020 09:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zoBj57kRLegzfjXTRovLqjvj8GvFZb9E4BHZ0/b5c8U=;
        b=O0nqY3wxxXM8zmwFBj25OrsOeT+qhfqvV2Ky+ysSmr6ryt+SQ8bf8300RpuRemAOoE
         5TWWm6Dq5q3jV+5wkpQQgLTIT8nrx/vZT0pLi/KfD0NcJ0Lj6uti5yLZXkeEPQxCIbyM
         O4+ZQwWmSQiVOCItRG3CEo3NYFpy83bWS2s3ZyEfEbPCF4kH1iZWqI0L1+z5oUjnsG4T
         bCpIU5NIevo7wt6RybuxRBqLcPLYHcFBlUNc57Is3K328eATOwPMSN2FX8YgICYZN6Ix
         Sg/TaM9PAEqUSLvokMBYMRDcn7V1fr3UzbFq32bOSVjOkDjZchEFJ8h9uPX9S7voczhZ
         CvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=zoBj57kRLegzfjXTRovLqjvj8GvFZb9E4BHZ0/b5c8U=;
        b=HsS2AOCz9VWwqnClTeRpu4ez3XMorjWF2hhrAWVO8t6tXPhBvhREzAi0j8GUPsdipv
         1KO27YcDSJa1syskTE8fntV8NdQYaDYwN5WwiCwg/Ja68VRnjeKOf32a4EEn9dylgo5Z
         Im8gp2IADKzfwNF+WxmdeOZEEcN03fhs6g6zoVzMdqNjOpbFLavylJmPx0QLGi9YN+L4
         ob6SFS40Jg8sN4OyMcmqoCAGmWG90bmOj/LJcBWMz1QWHXLOh+8GaXCM0MOKo4xBQvdP
         zyLgQctKKaMD4r2b3kF7h+T2wJXsgoxDzMYIzf9pqQqPR03FVNO0udZzWamVZ0fnysVT
         2AYw==
X-Gm-Message-State: APjAAAWMDPf8H/JAa+EFyRIuAGTfFn0VcsM0wLeRCTfA/YVhFvz/O4F4
        0UiXQwNeXf+LUh+0A8ziRZI=
X-Google-Smtp-Source: APXvYqxk4sP7W9bEFiL24lWRKqtA2u2eDTz2nJ4qHSyjIusPJNqPVsF3p2z45mdvzTQnKpOFIGEnEw==
X-Received: by 2002:a63:5962:: with SMTP id j34mr33369375pgm.421.1580836742315;
        Tue, 04 Feb 2020 09:19:02 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a195sm25112091pfa.120.2020.02.04.09.19.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Feb 2020 09:19:01 -0800 (PST)
Date:   Tue, 4 Feb 2020 09:19:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/89] 4.14.170-stable review
Message-ID: <20200204171901.GC10163@roeck-us.net>
References: <20200203161916.847439465@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 03, 2020 at 04:18:45PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.170 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 376 pass: 376 fail: 0

Guenter
