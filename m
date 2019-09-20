Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE834B90D3
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 15:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbfITNmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 09:42:19 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37566 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfITNmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 09:42:19 -0400
Received: by mail-pg1-f195.google.com with SMTP id c17so3862524pgg.4;
        Fri, 20 Sep 2019 06:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K1+o2msjS5R2+l8wSLddLpo6dmi3+jzYIL/yCC3kAgQ=;
        b=ZyEzuBNG3OolFTwQf8fvn1I4uYjQKvXlHC9i7pjRcLCNxd1TNL29eoS52P8+D4ho6M
         ypfIRzwupjFq3bEczm8gZOGBO81szrR3LIMPfq3D69/WdA1Bs8tRvfqHfdrW9033YENh
         q+JnYs77AYyfasocTdVNCVyKSPHvNI4Azvtdkc4GlSznM6kNJ285DyzXfYcwsxRXlDLk
         IiO//hCR3HaCtrQtRcYaaRZe7ULFbNsSZTImhAVuT+RR7gjafuMjxGshK2gdWb2QzUnv
         5R7cK7kMARHWAF7MBi6eo5X5rEoasPAcxV6fphK069z6moEmYwJR6C9/f4ezoPRUzf7n
         qG3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=K1+o2msjS5R2+l8wSLddLpo6dmi3+jzYIL/yCC3kAgQ=;
        b=Pngia1v1r88woi+Ktw5xfg8kn2CqMn2JT7jKqIiiJHknc5rRMRPC/4HU+gkOjc3kfz
         OikWeU3x/BvwI4tQhvWJU120yNrDa89joLhjFqQ0oxHNx8XwBNk0k8FvSykMovzGTXoL
         E1JPW5RLRqUnV6HwfB7md67iAUjAaQ/u31B6m6MDgleMR/8vTQxkph11n6bVSuZyT1+D
         +FvhDDLRX5a8vH9z+QfinIO+4prdPKTGN4xgivuyWn9QX1JGv5fchshllcuOuaxY9pl3
         /kELQ+gNEsAUe+PacCpmaktjfPJkdwcyQbGWKxfYMBrDOef9YZxpIgXrusC8pAkimMg3
         kvuw==
X-Gm-Message-State: APjAAAVwFqlec4XnYPMMDdgVlRAluOhO3Q77hKDyXKSo5FpQuLKaf3d+
        V8ddObq+x9aJWLeNRpHnA8g=
X-Google-Smtp-Source: APXvYqyaBBAIbDSCc7/xDdJGnEIp+TNfhvG+/581fMDYbR13FXBZCj0Z7F8cyHXpMpOHMuuGACN6tw==
X-Received: by 2002:a63:2b0c:: with SMTP id r12mr15358918pgr.206.1568986938920;
        Fri, 20 Sep 2019 06:42:18 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a11sm2876559pfo.165.2019.09.20.06.42.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Sep 2019 06:42:18 -0700 (PDT)
Date:   Fri, 20 Sep 2019 06:42:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/74] 4.9.194-stable review
Message-ID: <20190920134217.GB26460@roeck-us.net>
References: <20190919214800.519074117@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 12:03:13AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.194 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 356 pass: 356 fail: 0

Guenter
