Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7054C10B82
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 18:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfEAQoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 12:44:10 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35128 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfEAQoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 May 2019 12:44:10 -0400
Received: by mail-pl1-f195.google.com with SMTP id w24so8436029plp.2;
        Wed, 01 May 2019 09:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SA9625o8KPfSBbeon3dI2ru7VoPb71SSTR3He3XjO08=;
        b=tb7HSuZhC8Lf7Rx/I0ZlNwoeaIONLeJD0Js37ydR4iv4oO9m+pN3rMzy9hPqjNasuC
         4GzSxQ0O/VnpmmTIpjRJPcjzp7Cq0+NgGkO7fYePtE+14gq/VvMJFSz/ngVH1nYnRlY5
         reRypbQ6JnpR/wMTe+zwcT2fzzaiHbGt75OZllv4q95U+lwb46DNfpgFr5bGVJBdki1v
         X5CNFLUnxoBmpfbqMRPhh617pf/Pab2NqvkfDrzchaI1hVgw/YKz7O0ZD2DkgopA12ap
         DhxRnbyBrxDlm85Y5foFRjpwIoMyy7mrMY2jrZJsaSpYytprYZVKDM0cSFEk8eSCgwwY
         Y6JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=SA9625o8KPfSBbeon3dI2ru7VoPb71SSTR3He3XjO08=;
        b=VgOp5OLjNeFX647hcA+KV+3fEIckYmnom9ArPTLKubBySoH0TNj1n4lLI+oEEJjbC5
         UuF+pNm8b8coWyxzoFgCDDPtAStLM2DVT4uzXeAieUsD9u/NRLCksWlUQNkwVhCQ0+rn
         iic8x+Zt60AabGLaF6NHFyclFhKW1OdOsSrQMMiczjSfA7H0d3WkScu++TLNtymDxBPi
         X7kzz9Yod+KoQq7KVr6Owx1WRijG+Fp7fLgy5owwaVpCwTsRP5YxbfLwDVYYXn+aSSCb
         qU94eE60jJ9EoaMeBou3wwhmn40Ck7n2h3jLpRBXO2r8dKv2XLtSdfG8yBEVBabTX2Yi
         CfMw==
X-Gm-Message-State: APjAAAXgh594CcVaDnUhiCUroB3Ob9jD5aHBtUggwt0qB4z9bf2QsejX
        Mi4NkPVftT6gJ88Eg9b6/7k=
X-Google-Smtp-Source: APXvYqxzXQdmaCU43QIMZAzvv+pfw1ntUZ3xXBZnK0pZH9Gof9KnkCbyUqRBotZDOmjtGoV+ZL0ERw==
X-Received: by 2002:a17:902:ac1:: with SMTP id 59mr78092539plp.294.1556729049789;
        Wed, 01 May 2019 09:44:09 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n67sm8800030pfn.22.2019.05.01.09.44.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 09:44:09 -0700 (PDT)
Date:   Wed, 1 May 2019 09:44:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/53] 4.14.115-stable review
Message-ID: <20190501164408.GB16175@roeck-us.net>
References: <20190430113549.400132183@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 01:38:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.115 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 02 May 2019 11:34:49 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 333 pass: 333 fail: 0

Guenter
