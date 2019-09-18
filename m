Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64649B6CB1
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 21:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbfIRThK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 15:37:10 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36207 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727588AbfIRThK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 15:37:10 -0400
Received: by mail-pl1-f193.google.com with SMTP id f19so449079plr.3;
        Wed, 18 Sep 2019 12:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HtjQH7P5Wg51kHjhBLZuMipuSIo+nXboHVegkyyMDOg=;
        b=CNB8ys1d7e0ApFxfA7o+tX+Xy8ECCusNwgVGXUkCxnLDXQELIYRBWNJYJejgYoy4L+
         7q9ugHMqL9u9CU8nbGiuAKBkAKaxGsmfqvPvp/3lYNhlZwOFXHPf2HP7gXFKVkoqdpiE
         uZn/6rx1/+sSOInuegGguqdMMn0wqa9j7iA8zclzEeodnu1ZFnxAqEOxZQyNtz7Llzew
         da638ccoATmhOPmqyFt/o5xAsL8qcIysGuLd4/XRez/rpGPpf69d5EbzfLIEQEF6LQKb
         nXNmika11XJoQZFyXmsxdnL/zOZMrL1cYvlHYLqyjBUynAFdFj69yKrTktKxPq4ZedFN
         EKhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=HtjQH7P5Wg51kHjhBLZuMipuSIo+nXboHVegkyyMDOg=;
        b=NKB99I3QotrZYvA0Lf63GB+/kaQinfQ5HqI/gdpFQpl8O9PM4iEcWjiwX9DY4cwSwi
         i0YHV1qgN32GUg52ewU0mhNx7nGIG5lRo8kWSQsLwSEdZOqsAwcqqttnzy5PwNNzsUJ0
         j9DgAye/nDW0brDN8Z9WEYuFHq0FV/ZwdDdTzWzGS8JDxUPQXSP0dUrw2i//J5gZwGEN
         KRWbmnqyA5Qi7XmPS13wsMkl/YRbtYmtIzRd6E/O9TBEKVRgApX7bIf6CiRrsWRTsFiu
         D4t9AgT832x4mUSs0LkhBOVu7YMVMDIHKVuNVGMrbgV6v41+9CyinIBcENe8lPaMcTbI
         OuJw==
X-Gm-Message-State: APjAAAWD9oKcDxsGngDRpnt1hzBCLBnCx2DVQiO6h+cwBatWlsBoHU4d
        IffX/l4FX1aWh9liaUCppWI=
X-Google-Smtp-Source: APXvYqw3qg3Rn0UNkDw399FpTEF9DMWKLeihiUUX/C8eMdxsVGqWJ2y3O2qICU6fWP1s4tPSORo4ng==
X-Received: by 2002:a17:902:7617:: with SMTP id k23mr5725807pll.314.1568835429508;
        Wed, 18 Sep 2019 12:37:09 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c62sm10733577pfa.92.2019.09.18.12.37.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Sep 2019 12:37:08 -0700 (PDT)
Date:   Wed, 18 Sep 2019 12:37:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/45] 4.14.145-stable review
Message-ID: <20190918193707.GA30544@roeck-us.net>
References: <20190918061222.854132812@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918061222.854132812@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 08:18:38AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.145 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

Guenter
