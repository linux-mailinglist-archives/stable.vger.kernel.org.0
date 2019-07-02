Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAB65DAD9
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 03:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfGCBab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 21:30:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37370 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbfGCBab (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 21:30:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id 19so346609pfa.4;
        Tue, 02 Jul 2019 18:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=L4pET9YsQCDoE6awsVZbNmmWVq+gXFm7LkEAIu1gcBs=;
        b=EdonMdmdmkotg2/LT1Jpk4FL1maXE5svD0pQof+aR+UNif6NuzSKmQKlhWCSuVFz/o
         YDGpZOnOtRlQs9XuALnqDt66Jo+K2vOLWYvyFO05BJ8qVPWrkx3c1KjAN44shkAmj3ln
         2q5n12oi8oUC25hDtUg4u7QSXtwUaNNg8VkOVnRUb/sem22609SJWE+21KCMO6KFgqhR
         hw1EVRnu+VLCDvrhIGYuY6X+rQyaHWnOW2ctjW2NNYeMw1U4k4z+C8VopwZPdIRYaNZo
         w61Q8YsIr5KPhMJCWd62lMbQPNQotFj3iGFBT7OVhy1E0G5Ff2cSKM5gPfaIzWVzjIIx
         NNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=L4pET9YsQCDoE6awsVZbNmmWVq+gXFm7LkEAIu1gcBs=;
        b=JJrGyiY0e19l3jQp3J4v1zXqCuVndsmMedLgEIH8k6VumF0pH34MOT3SzrFXZvjcBu
         3D1RuJQQTPqvfezOVtaaHXpq+KSgxbz0YCOE7kYYotdMXeepRpdhngulX8LZzD0VKHZ1
         RQvpq5+Fep2xFDN2WPNBvZ5RiWxqC8w4V9uQKfOBg4A9N5i8tyuNqPXOOzjQ+jrL/HgW
         n+/9XnhpUNjkgZRVbjZF1vDOmPtqQFn7UhZWxX0Conk3moGj+cO5v7AwrExk4UqdcELo
         DI20ZAWcytBB2Y065k8wDFgNzyw4yz5pcb7AN0shb/fVeBEdnLLGa70fT3QKil+8XfG5
         pjNg==
X-Gm-Message-State: APjAAAUOpMvQJt2yidpLVJibZJiPmc7VKr8D98EnkGIgJRKBan70tXbN
        v6uTzpGuTyrkVLM4ZepKy0mUa13C
X-Google-Smtp-Source: APXvYqyXvgDCpfZwAW9HAbb/O8p8jWpGBgsXjRUHz3i/iVyqJtvIBTvUS1mUlaDrzx+mSpHGypX75Q==
X-Received: by 2002:a17:90a:a008:: with SMTP id q8mr7786552pjp.114.1562098981736;
        Tue, 02 Jul 2019 13:23:01 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r15sm14610899pfh.121.2019.07.02.13.23.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 13:23:01 -0700 (PDT)
Date:   Tue, 2 Jul 2019 13:23:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/72] 4.19.57-stable review
Message-ID: <20190702202300.GB29128@roeck-us.net>
References: <20190702080124.564652899@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 02, 2019 at 10:01:01AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.57 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 04 Jul 2019 07:59:45 AM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
