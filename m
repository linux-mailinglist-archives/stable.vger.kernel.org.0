Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92FF687E22
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 17:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436665AbfHIPgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 11:36:47 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46357 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436647AbfHIPgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Aug 2019 11:36:47 -0400
Received: by mail-pl1-f196.google.com with SMTP id c2so45090918plz.13;
        Fri, 09 Aug 2019 08:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kIsfn1cHexosA2amwU2vZ25ZZTkSoeu7iIbObHsLJWE=;
        b=EVE36FFxpkAzEZS576eT+dO7wNy60OgrMowGbTBV7R7lncd/9Akw5AyvzRV0OQuCLM
         69OCjU3cwKvUwPvXt1ygsT60oijQVcl7pdN2z/8H+VPnbn3Oc3Zeped4Tem/QweuUTZO
         gxUQULGI9CO3VpZ+hfk3Y8qKMgzzaO78zJhjVIbClPgLI6urt/By3nLcA+yPjE1S6rxd
         yvzzBUgnvhjh1WoD9GBGp13A4q93ZwFWyC9RfIK9Hz3m+7fGOnltOoYSfeOUMNvSYXkj
         7kA40G7ZCm4u85yEysarIP4W2KosPdZsarPFCAXAH7B3mPlFYgBQImJHQbqjsV3oTk9/
         1vig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=kIsfn1cHexosA2amwU2vZ25ZZTkSoeu7iIbObHsLJWE=;
        b=P+y0pehzskR6StUABHQAUhj/OloUYC1nBppgoUJsuENV6gHA6hSCX1heyPzOexVjNM
         7fu31fOIBvaBJ2wd6w21CROlStPPefTCvZn1aCKKKLM5rnHvl7+3oHLCJ41BKnTXqv9/
         I/oASB7hDWVaJaJ3fcDEROSegvKfZgeUlzD4+e+lQyZFfV/G9R3ty6AvyWkmV1CPZEc7
         V2GjCTmCvAM7M5sFLJJocQWLz5m/d+QiOwKOzq1EzfRPuzgBgXYe3ip4az8NX2VdWkbd
         +pIiBwl/O8cKmvl0nlvGNVqFx5Rc0RziqusRRoAmkQydVWqjlJLMfrv8sd6lfTc3AApE
         T7xQ==
X-Gm-Message-State: APjAAAUO5aeqFH3vo86gsQnVh5n/iESadCxxyApYTp3VNqjHlXlGPys3
        pP8deSPaH5V4niScqv+wDfs=
X-Google-Smtp-Source: APXvYqwLX4VJ2RWwcO7y/Vrcun6CgzaD4sBSHZhvtjTkV1LkwAau2StXD3gaHXnQAEcx3KF54VgWbA==
X-Received: by 2002:a17:902:5c3:: with SMTP id f61mr18193958plf.98.1565365006788;
        Fri, 09 Aug 2019 08:36:46 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r13sm167351403pfr.25.2019.08.09.08.36.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 08:36:45 -0700 (PDT)
Date:   Fri, 9 Aug 2019 08:36:44 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/33] 4.14.138-stable review
Message-ID: <20190809153644.GA3823@roeck-us.net>
References: <20190808190453.582417307@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 08, 2019 at 09:05:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.138 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 10 Aug 2019 07:03:19 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

Guenter
