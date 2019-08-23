Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006E69B1EC
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 16:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbfHWO17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 10:27:59 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35569 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbfHWO17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 10:27:59 -0400
Received: by mail-pl1-f196.google.com with SMTP id gn20so5681719plb.2;
        Fri, 23 Aug 2019 07:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kYqot4J9hv4nMkYhpIWP0f5rcI2BLD7md1BdFFFYy2U=;
        b=QX5EAISRAOU3tz71qMZG7IayKaSPjOd1e4ut+3lQxlZ2AYXrPziF/nZBGfzwKnWbz8
         IuyN5YYeuSP76JOnU4JZvAXRdOXo+qP7nRkGHaAwynoNszY9mAKpgfaW/QQ00DjMxclG
         3N8p+/YGTFTCXHTbVHe4hhaFXw8y604znoGGTFi0RRW9F/SnfUE58Q5VaKwD7wW7GMOJ
         dnDq14CS7OAnmwaU1lmzDr7fFyH3fbx3jjMueZxaJdmx8J7W+kpfbwCDt/v8eUyHY063
         TBsMNZx3+deyOhqVsIizRCa+JLhnZ89eZnXwgKPA87OPWe2RFLy+sXBIMXVxYjjrvkyk
         g1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=kYqot4J9hv4nMkYhpIWP0f5rcI2BLD7md1BdFFFYy2U=;
        b=poiticZ1+rCsKmIXykAHYxzMSrJfl1o2gRbp/EaykF/u5WHaZ8Uqu7vEmaWqMVTzD0
         vL/+jFwAz4aAyDjwdZqUDGVSXeWwk1Ausubwr/5nHTSVCWifDARQ6azEdjYuLiW8eVQ4
         CpnEMOE0puRiO3kcbIdveBts74Ng05Rw+yuT8SjDcpZaG95oFuhoyVxnUhDcwF3XFWG9
         oMDojKxdGXjxMuBYQI0US8y7N64GBrwJPyfns6AX+MGkNd/Pdb+TjX6uyao6zdMJkqH0
         yX0bs+13zeeL05aRuxKYyx30zTTprS+l6dYKURhjzypras/pYE5TWbptld33rjQdsc5e
         vHKA==
X-Gm-Message-State: APjAAAWoB6iFNZERXvb11PWPk03Dtk33YLKc2LBnk9z6hLerjefer6Or
        yIMWrqXseydohhwam5F3VY8=
X-Google-Smtp-Source: APXvYqxToXGW7dqVgq79yhxgqLv2D1cS//DWi6rNrWffif/CJfIqh8M+aUZmo7HQ37s6kkGWMM+uPQ==
X-Received: by 2002:a17:902:d207:: with SMTP id t7mr2682057ply.305.1566570478936;
        Fri, 23 Aug 2019 07:27:58 -0700 (PDT)
Received: from localhost (108-223-40-66.lightspeed.sntcca.sbcglobal.net. [108.223.40.66])
        by smtp.gmail.com with ESMTPSA id t6sm3032017pjy.18.2019.08.23.07.27.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 07:27:58 -0700 (PDT)
Date:   Fri, 23 Aug 2019 07:27:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/103] 4.9.190-stable review
Message-ID: <20190823142757.GA18323@roeck-us.net>
References: <20190822171728.445189830@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 22, 2019 at 10:17:48AM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.190 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 24 Aug 2019 05:15:44 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 356 pass: 356 fail: 0

Guenter
