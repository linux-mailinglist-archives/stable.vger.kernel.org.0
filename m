Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3AF64A71F
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 18:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbfFRQh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 12:37:58 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43227 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729349AbfFRQh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 12:37:57 -0400
Received: by mail-pl1-f194.google.com with SMTP id cl9so5929804plb.10;
        Tue, 18 Jun 2019 09:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9S1tG0HhIH97LRIta5mSzXislzsfvJdu1l2txZ11Jjw=;
        b=gRfo0su4BF73/wbSbNlitsopte46aUzLz5uMK2NxAfA0fmSMOAOEIfmHA8em66+C7q
         Xwafe3qvgiezON18CMsa8Hh5vYQIx1sNhHZl27bDGFst2UxDaclfNwx5VUrgAa1hEF/y
         qg5mPpjS/wUzKlfE94V8E/p4sJobhyD3WGs1hvsf2uWDB6IU9vSQ0mazhH0ZFADZsHpI
         18dnYVboTvu/24NeaUdEQuZEwjjyf70jRZExdHSblJZwdRrUzzd4N73Y6joOMhDC1VjI
         HbO3lzvKoPY7pF9NMZvYjq+1upAXhhwROykO8ozC7619BDt0Ur1jMnXrh3uGvLS3ntAH
         6vIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=9S1tG0HhIH97LRIta5mSzXislzsfvJdu1l2txZ11Jjw=;
        b=EWqQGsvbL2cNp2Ef6NaH37hPL0fLHVthITZJIbea8bcHOa2E89/g8LOPB2ZS+SMw+S
         5reYgSfeedjiW6/fq7coasLJiAtR2ggAGgRiph4Bi+MxjPckNt1eWslPQ667kBN5Erq0
         vw/HEtxuwb6FurXQYE9btVwzXa7n/SEO3yoIeJqXYoYv5OZ8/c6smosKnW8RE+Ufrr9v
         2r3EAuqTv6LI1XwwtKmfD4ucJokLUASICUIk+dcH/aLftroj5kSC04rdTEbr1jPuUiiD
         E3+MooMED1UWiF98oBnuWhlhDiJyGYkMhmV5FWxHQeObJhoCSQJMf4DjfZeBjRrM8Aj5
         R3Wg==
X-Gm-Message-State: APjAAAXGdaYnlATzGb8sF/xssBFTDnqDjPsSxfRW3h0ZCJ67BZEiPA9N
        +Gx+n2zRfeXVqnxIMqQU/2g=
X-Google-Smtp-Source: APXvYqz9GLahVk5B7R8NS7m9UYkDMb/KD8eDSB4DZU0CLzKxvg/aeLoQFSYakgG704yT5gF0JjucKA==
X-Received: by 2002:a17:902:1003:: with SMTP id b3mr116215415pla.172.1560875877307;
        Tue, 18 Jun 2019 09:37:57 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e127sm16450716pfe.98.2019.06.18.09.37.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 09:37:56 -0700 (PDT)
Date:   Tue, 18 Jun 2019 09:37:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/75] 4.19.53-stable review
Message-ID: <20190618163755.GB1718@roeck-us.net>
References: <20190617210752.799453599@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 11:09:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.53 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 19 Jun 2019 09:06:21 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 366 pass: 366 fail: 0

Guenter
