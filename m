Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBDDAA96B
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732722AbfIEQzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:55:23 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38757 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728254AbfIEQzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:55:23 -0400
Received: by mail-pg1-f194.google.com with SMTP id d10so1735192pgo.5;
        Thu, 05 Sep 2019 09:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9Iu+90P+XBQtWwq8jZrry/xtl3By2pETxjT+u3DO+OM=;
        b=SHPCVEE3HhBl4aZFgkPKS0dEoNKnwdTf4VtsatZeohq+Oj6Ty3/BdN60MRB0QsJN+e
         ztX+6xbslxdVrY26pRaDHU0fnx6PKyioDbN3zKuKnUDpR23xZjtWdKvJjnz8vUCecEFx
         0Y1O80CefzCEF7phLhM0YYBkCZDR9mHexTMFE/03/6PX38cZWe5alHowmPGOm1/QCjOw
         gfYM7nmMzGtw7/MlvF93TXeed3oq/DbSavTx9gpIJatTEudrNVKpYxS3jgBNdkJGqRsK
         7nK4wcl4SFYFdFKzArUrC1IlrjVIEQ+W5L3eta/YSZ1m+sXyJodkDacri13PRMgpo70T
         EeGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=9Iu+90P+XBQtWwq8jZrry/xtl3By2pETxjT+u3DO+OM=;
        b=bKDYlrAuOf8KuFqdfMSxGexjT4Xo2n8rdn3R/FvUmyKECUN3vFRRBiTWJJDpspAjMO
         eOl3edPqWlVj6Mk692vwn1kfXHid5/Tm1pEHZf0N09Lla7DJDl3pvDWb98XZq9gm0ERZ
         K51D1X1hYTtJtPO1nJ0VfVuE1MJRCpTRo+jrLBiHNgbuzy99Vg/q2lFLyIaaAkK425xZ
         zw2uyvHtZ9ShuljG1bN/E6jHNvcO38/1JzTsSiDQJBl+SZrIlNJJbihLJ1cr/LNAnQ1i
         4BIhPGQMuVR+UXK7LnOFYak9Hhq+Rph5ZAC0obnMEN+HPGt8ck+7vkzGZPheJ7lJ9XWz
         kw3g==
X-Gm-Message-State: APjAAAXnN/uVni5z6v/nTCTDX41pjiKRI/RxgXuBzg6qgNxdPywqSqxw
        XFqacPGPtkIgjIahpI4LDtA=
X-Google-Smtp-Source: APXvYqz3ind6qTZjey5AjK8BfOtQdVhkUj0hVs04MKmXrAC9RghtNsK78KldAAIi6OpNeI7u8j5sgQ==
X-Received: by 2002:a17:90a:c386:: with SMTP id h6mr4904376pjt.122.1567702523027;
        Thu, 05 Sep 2019 09:55:23 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e6sm6478518pfl.146.2019.09.05.09.55.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 09:55:22 -0700 (PDT)
Date:   Thu, 5 Sep 2019 09:55:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/83] 4.9.191-stable review
Message-ID: <20190905165521.GC23158@roeck-us.net>
References: <20190904175303.488266791@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 07:52:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.191 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 356 pass: 356 fail: 0

Guenter
