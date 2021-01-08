Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298DB2EF69E
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 18:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbhAHRjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 12:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbhAHRjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 12:39:51 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA966C0612EA;
        Fri,  8 Jan 2021 09:39:10 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id 9so12178539oiq.3;
        Fri, 08 Jan 2021 09:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wU4tN+0lYs4GFBSQpD5eiLVZbqafbNSGHmogDo2Wx/c=;
        b=b9bHksdfG/vC1QVDHMHjhT/EUcwkjYRbTXhvNpsR15vQx9VTzFk0KhVzcJIHDPniMx
         qvV9xIkH5f8OjO3fR3wBv8Gnarpq54fMtJufIkfbt3uyCNPTIbCHKhMPfaDmuHyJIvgE
         1bAsnllIpkZUCENeqF1fKWHQsxErIotvex14FuQCSyPpP/VHfd389QlF72SDfudZWvSQ
         tAYRa6eSL2JfM0QCeXcWK1S7gqijbgNavpvn9boT6R5/obQuLHy+HBKkovFZyxhcgbGL
         72BgXPG9QqMgcKUxCd/KHKVAvfpjj26xkWKMkSXsI4MOYKf+AXn8N2kSuruXt/pPmqlt
         SiUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=wU4tN+0lYs4GFBSQpD5eiLVZbqafbNSGHmogDo2Wx/c=;
        b=XKpeyrv23ox0Prr8TngA3PoLW5uB1VrFxKicc6lDC7ok1bhb+FEn8/PFwehD+c9BlP
         gFot7gVjZY1Rq/tpP+ikz41ZVlO2vxnVgzBGmjY4UgoruuifLzI+IRtPc4ljIJgu8HfB
         CpC2Pi7hLhmBiViFNJ/qDOfhEsQs+jmVBhK4XmB9mu8/+IOlEx4VcP+BJvPY3qTSGXn5
         flrD1jtw7Uw5BCSEdfNS3gAFB2OjhcFtYNBX1WJwLaxloxvJwPhOoJZLlCOJwqHbuEqh
         hlackQ6YxRd8i4KyiLUO841dKDUf3HmFdMh/lLEMUUkdM4DX9Ng74QtJdgZZB4j6vbQS
         S8xg==
X-Gm-Message-State: AOAM5337aTj0GOB14LtAczFGCh1g+aPuXUfUrmuwTlh2uvExdlLt0nqy
        RFGJV0rq+qnIw5dNEHoKH00=
X-Google-Smtp-Source: ABdhPJxyhsAk8bk+nlkPbQNQiW6ZyX1xkQiKh5EH6sAuBjqTDgqDgB7wWZLdZeK3dbqFN/sz55Q46g==
X-Received: by 2002:aca:504e:: with SMTP id e75mr3145171oib.170.1610127550370;
        Fri, 08 Jan 2021 09:39:10 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t24sm1845571oou.4.2021.01.08.09.39.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Jan 2021 09:39:09 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Jan 2021 09:39:08 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/8] 4.19.166-rc1 review
Message-ID: <20210108173908.GD4528@roeck-us.net>
References: <20210107143047.586006010@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107143047.586006010@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 03:32:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.166 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
