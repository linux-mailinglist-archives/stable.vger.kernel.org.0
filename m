Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1639830201
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 20:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfE3Sff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 14:35:35 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43451 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Sfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 14:35:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id f25so2491855pgv.10;
        Thu, 30 May 2019 11:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=licCAydm1QVEpJVhJzEJwjT/r85K3Q12XSdqcbWYB5k=;
        b=EFw7h+fzhet39kCb2E4/Mf4HpZnaz03H11koUHgLYSzOrgw8JIVk6UZMlT1mZLwXY4
         BmLDyrOqmxXPpuk6MptoZ3hZKzsVzJChD4qD0gIiUSjcXi30aHafHvlRCdugrfAiksMe
         N9gYXWPc+tyX3ZBuB+0uKY7g1eqZmaBGZkc+hvka891pTUCd9jFX58XfIxmGLHHlkURO
         VbZMZfh3rL6r52Dh2wjH8GLLPuSKYwxHxb0MAENPHMYUNzc/dJw4z2eOE58oW18EgHlw
         2R6O+z3B4YnH66aCUipUN5pddnH+LN3RAnvvA+ojZaoB/xvoOg/jWDZPnRD4p1mKdHTY
         V6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=licCAydm1QVEpJVhJzEJwjT/r85K3Q12XSdqcbWYB5k=;
        b=Nv39hT2k9m2Q9o9zq6AQXNUhppdign4VwSrwAyf3ld9G0qz85FoBIzXtCR4UDSuFKS
         0VSvtFLFtlBIAZi+86kMVz6934+WDVe4UidfAjUXzVO5/1Jg9/RImVfeJK4/JtQOAbXF
         sG7RxCwqVTbnYSPK/ofla14TLkCmiqOWVoU58rwE7bLpxDGxmYub8jf++m3x70DMCisZ
         gOg8Hk+i7knnkERF72xQPiGQxCchhswzgW9XQt/6sZlmBhsGxFq4oMSMLslRMxKIvtHt
         KL7B9sj+Twz03QshnZJ9PaTCdYxdtIdnWnyY1pGYx4XfTEdHaiJ9Fe3kAFrBOqmXfJcT
         795g==
X-Gm-Message-State: APjAAAVmuP53lD1EsepljMN2Ybc23xWx2RKO8A3OJGcZf9MCF6vvDn2l
        DRz9nflnWS1MZ+W3EvwEhKI=
X-Google-Smtp-Source: APXvYqzFSsPVliFpTYamS1r47yn4gjVUBDD19XYJTa4zJKh9g9/e+qpgtKn6Z3GybtmAbrqzOm7qPg==
X-Received: by 2002:a63:5c45:: with SMTP id n5mr4871702pgm.172.1559241334360;
        Thu, 30 May 2019 11:35:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a26sm6135683pfl.177.2019.05.30.11.35.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 11:35:33 -0700 (PDT)
Date:   Thu, 30 May 2019 11:35:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.0 000/346] 5.0.20-stable review
Message-ID: <20190530183533.GA9720@roeck-us.net>
References: <20190530030540.363386121@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 08:01:13PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.20 release.
> There are 346 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 01 Jun 2019 03:02:10 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
