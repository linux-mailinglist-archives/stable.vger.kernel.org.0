Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A088AA978
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403774AbfIEQ4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:56:30 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43344 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728254AbfIEQ43 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:56:29 -0400
Received: by mail-pl1-f196.google.com with SMTP id 4so1562512pld.10;
        Thu, 05 Sep 2019 09:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Yau58hoUWJMoTLYD1k0Qt94CoNR7DdlXjaK1w5al7BY=;
        b=kjYWByJJuGWaM+yh7EWk3KZavp0QosrSYhHevoEaS1WcGDkR9LOKWC+5JOqac03ykf
         +Ow0117zZ6Aj0ewPTlB5cYG5HGTP7fA8K+yf3QBVDb0C4UqEZYaxAtnTEbuBaFBmS5kS
         6mrI2PrmL8rN/XWOKeY+0NAa+ivKezGbFqblw13K4a+YidvmfcP6tYCpq0ZK2E/7/m+Q
         8F8YRnDr2Qei1NdBgG0bDRF8b4yMB6ALIjI67JeeUqlkz+2HVfmujCrEBKYrWWFE5p7e
         TJc8O4klT8ycnXiZW+NQNcg7G7xjfUuuVTh2kSkhuyek3cAwFWVoz1+l9hWa37gXShfA
         0gbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Yau58hoUWJMoTLYD1k0Qt94CoNR7DdlXjaK1w5al7BY=;
        b=OjkL6BMml7ZdHKRNIoHQtjW7XCs+4gXc8/5h6YYkqzX/LEWpl1XG/e5dU9bad+lB2p
         Wx0BdJvNY6hWlviDH4ribQF/DfA0YU87IBnCo0UBVu2zAlLmiOQyUATpq1qek34jJMrg
         2fp7sXtF5NcwuppgnXLHvF1lAZHYFqZRa8qk+PpmftycJztx07Su2lrX3O7u4WbWpHRL
         G/+jF6b6WUnxaiLgvJs+vzxbq5yvC0JdSpLrdwV+SuXuY5jMMZRwCWcOxtvc4ovm3MtV
         HZywsmjm5OsYc0WTsYjygom1zPkmE7iSqnK7b59+Savpz70sCY4MpiKl+4IoWPEGc1M7
         sTEQ==
X-Gm-Message-State: APjAAAXY4xFzlA1vYt01Jg6rCD7k/bhOygusViB/lAzXx/BSbzuC1xvN
        QRGpeE9xzJioGJyhhWBZiwY=
X-Google-Smtp-Source: APXvYqy8Erfv75qRQCpBSBieFjH2d3BzB4+vX6hU3s4dDVOgu1K9dvG2xX7aAHFVt4aB7EcZML9FIw==
X-Received: by 2002:a17:902:7791:: with SMTP id o17mr4740150pll.10.1567702589186;
        Thu, 05 Sep 2019 09:56:29 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 185sm3420394pfd.125.2019.09.05.09.56.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 09:56:28 -0700 (PDT)
Date:   Thu, 5 Sep 2019 09:56:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/143] 5.2.12-stable review
Message-ID: <20190905165627.GF23158@roeck-us.net>
References: <20190904175314.206239922@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 07:52:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.12 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
