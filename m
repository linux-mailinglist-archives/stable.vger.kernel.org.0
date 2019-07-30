Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB377B234
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 20:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbfG3Smr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 14:42:47 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38921 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfG3Smq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 14:42:46 -0400
Received: by mail-pl1-f193.google.com with SMTP id b7so29282035pls.6;
        Tue, 30 Jul 2019 11:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z8mvbPQ0gJJm02R53S5piSlJ+PP4rINSfRQKtE076Lo=;
        b=c/KTscEBi7xKomx+47xC61dmg11ku2TAgLmc0sJLcpRED4VH8aeVP+2HFFXvwrsjzG
         CJpVZ40+8UWYe0NAtjKkEHtFLSi60OmoVvO29YRmXu/5gqofi5QiBYvJZVm1GufYjGSQ
         ZDRQ8pR5l+dxd3CETqH/F85t3wHWQ5dRASwnErZ+TwU7OWIDchIdfBc8dIhH4jbGmGbQ
         CwXER8qJ2aF3/1JW3HA6NWSWYE+fbnQtrRRGRKb4pUAQCSbXQ7t2sm4MkjmS+Cib0oMb
         UKdZqiVW8b22NCM95Sh9GstJdd7g79j++5K66sjCGdANYEBqk/cj3+RsNx+ybOosFsfQ
         M2WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=z8mvbPQ0gJJm02R53S5piSlJ+PP4rINSfRQKtE076Lo=;
        b=S1GupP7YIkQBTHzrpfCuyhEZ91uEU7jXQ0OkbEVQvycsKySPYB7NHA1wM3QiijiObj
         hiDfVP3F3a90L7yawP8K30gM8h4uBT0rQft3n5HojECZT9bXa15jEQm8q1ozH6pKPKlm
         QxbnKCPS3EimBgTdWMaMtOqEpL8+qjYrIJV3epcfiGqDsKu4KiY0n7x4uSOcWw1NeTbD
         PrLaaNTP9VpeNA143NgSgzGlCsOCupCWW7OeW06uCJnkGyixoBCeZIsWh0nfwYu2+L9G
         WjNs/xzaG2M8YhJ7ZyGtp0MeqlrqlzzRLC7mQuoQR2defHrIGueEEb+MDF7q38eW40HZ
         3Dqg==
X-Gm-Message-State: APjAAAV+mgVgtWV5oukHU8bYm4Zj3kNpU9lqqbUHIskn86h86kasl27S
        tb+F2F7SJhsuN9EhK26HRinGWXs8
X-Google-Smtp-Source: APXvYqxC9dRGcyfhyQQzRB9FSA4+PhSR42IIMVH2H64yTq6g693UuuMzPzJUXQccVrxf/JWl/c+BAw==
X-Received: by 2002:a17:902:a413:: with SMTP id p19mr117396869plq.134.1564512166162;
        Tue, 30 Jul 2019 11:42:46 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h14sm83345092pfq.22.2019.07.30.11.42.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 11:42:45 -0700 (PDT)
Date:   Tue, 30 Jul 2019 11:42:44 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/113] 4.19.63-stable review
Message-ID: <20190730184244.GC32293@roeck-us.net>
References: <20190729190655.455345569@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 09:21:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.63 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 31 Jul 2019 07:05:01 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
