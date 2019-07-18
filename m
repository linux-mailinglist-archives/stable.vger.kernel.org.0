Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5139D6D562
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 21:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391800AbfGRTsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 15:48:04 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38432 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391701AbfGRTsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 15:48:04 -0400
Received: by mail-pf1-f195.google.com with SMTP id y15so13091771pfn.5;
        Thu, 18 Jul 2019 12:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nM4dWrkb1ajSHYtU8J2KR6ns8hioPS5hXMwlSkpfMZ0=;
        b=D1OPiZeDWLY7htvCnolckTnWMSuJkTVDzs4qDllJ4a7Nqmr0bacYi5Utf+JQ6iGl6T
         ZEfs/4JNJFXH41RNpBCLdPbcR2UOYmxHK9Ba83W38HYSmV0XAkPuO8KZ1b6Vwfb0d4TE
         RDhROZIBrjUqyPDLAA7WnTVi3aqx0kbzifRHxXxvp3wZSXq15zNLaw4/mHwzZXqNMzdT
         2rnyLdPvodhZyu5UHUwJM8aa++rEhnljpsTsLw7SF9+/fbiP6g/unolMS3VvBbvLN5AP
         iTk7jLFE0qvIau1eZXWAKBAuoHZz+joEDeP2HEm6iPiu2Kf/sznE4S2YJdTakA5719/C
         a5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=nM4dWrkb1ajSHYtU8J2KR6ns8hioPS5hXMwlSkpfMZ0=;
        b=IBNe8JaxmNVepAx/hn3Xp4EA9nHt7il/4G/NsFqkcqXEBQIsKrbCuu0GhP2rmMsDzw
         +kQwbSnQGAAZExkGw2kUAklUqkGNg1/kOmJU7F+USYBAFVUN5CfRWPSIokgCH7g11TJI
         3GSZ8RsjsG764ehYLNSYm+hIAeEreShBKJZxsLlSEjk5yb8kQqnNHHHr/+PrWCBkgCsc
         dM+aKkmQFLJXzbtPUezL4EyaE+kdEDdU3fLnd9uuF98z28n6ANcMGYqPU9Uno699bMlq
         Cl9yBi6e7d0PkG6tRrVARq+KpLtDtl9l3iDODcdlewd7J0jJRuSV+UhtknbIMveIt9g9
         vFKg==
X-Gm-Message-State: APjAAAXTbxsFuJTpZojCUPmLp/j2ZWHmNQi3HuEQhCarauXJyKT/xx1U
        Be+OrHMYM8ly4sznfwNqgkdTBAQl
X-Google-Smtp-Source: APXvYqzYtq/R0BI3KODsT7gz4E6YK0lE3CQsRCv/iI3/gnNS5jMMyt/FdIaJzSnSpQfy6/mjoTzZ/Q==
X-Received: by 2002:a63:c84d:: with SMTP id l13mr44460395pgi.154.1563479283737;
        Thu, 18 Jul 2019 12:48:03 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i124sm53445360pfe.61.2019.07.18.12.48.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 12:48:03 -0700 (PDT)
Date:   Thu, 18 Jul 2019 12:48:02 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/80] 4.14.134-stable review
Message-ID: <20190718194802.GC24320@roeck-us.net>
References: <20190718030058.615992480@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 12:00:51PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.134 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 346 pass: 346 fail: 0

Guenter
