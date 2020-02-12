Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4080A15A1F5
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 08:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgBLH1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 02:27:37 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37349 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728342AbgBLH1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 02:27:37 -0500
Received: by mail-pf1-f193.google.com with SMTP id p14so796986pfn.4
        for <stable@vger.kernel.org>; Tue, 11 Feb 2020 23:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8ibAYzH7JwVChn/H9xG7OZ9qhyi4dW0rrjKwNb5KAWM=;
        b=GQn85WKXRnkAY5iH0k9SE+x/iSThmMmKghqDjUFg2sHbDyFtvdqI7TM4RiX0EEwmLe
         h8u2IonB0PxHjglmyiEljJSChjO3yQaFpkKcnxPszQPElPJPu22iukCoWSV8Wj3L65uc
         ZnWtY4izdXQj881iVbMNCkRu4Q3dWL52WAgDjIB6lbE6qGQAV95RmpfY6giTClUumhz7
         jK8UkZ6Q3m5gpzW1JYBVxBGJilyHnqkPfasDpSU62lG7p9WFXOY+zHrhsPnDunSFwIQF
         hXy7J/9QM2WJdw4A4s86oS5VqVeqp8MML4qvl7tZ9T23zzImJ/1tjdELNWk8/AcReZ3n
         D1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8ibAYzH7JwVChn/H9xG7OZ9qhyi4dW0rrjKwNb5KAWM=;
        b=GGo2KygXKdLaAKUDbRDvzdTGJMA+T+eaieNOLfUjQNcMf3PQqJdddHN5aTlCyxDZ4K
         T1Qh58NZ1kEpsDLJDGkTYnDTKgXm0OcL8vj+HDhQ+qiBighzoCEqORvbGk6+9wU4Sazs
         OybMoR3R1bls3coC33lVU/jMRpzdCGnLYUIfQXmr4bQveMIj5XT0l9xYjSuwqlVbzUW+
         bG14FyQ16vMMSzfxH9juZLtPVIQUYZ0i1ukm93BMAh5D6wU150/n1cFI52zIKmNmf9ee
         oVJrNznI/2DNQSf9X/MDtnsul/M5gDbMYi/m2lXi509LVp1L9L454CG2edi9UgnMP1Mf
         FN1g==
X-Gm-Message-State: APjAAAVOCeBJPkVyJmWWVa5mD/vwT6eVblzYcedAzeFCrlXKwW3/TLs6
        0W45D0a2aMIWWsxyCECGmYu5YA==
X-Google-Smtp-Source: APXvYqzb1q6Be3UwEdG2DOk2jCioBvFQ1A3EV8QQ+Cxg85nPVGVMz8mF0U3jqDZ6cDb4AbclPMYhCA==
X-Received: by 2002:a63:9dcd:: with SMTP id i196mr10811370pgd.93.1581492456207;
        Tue, 11 Feb 2020 23:27:36 -0800 (PST)
Received: from debian ([122.183.169.124])
        by smtp.gmail.com with ESMTPSA id 23sm6843069pfh.28.2020.02.11.23.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 23:27:35 -0800 (PST)
Date:   Wed, 12 Feb 2020 12:57:28 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.5 000/367] 5.5.3-stable review
Message-ID: <20200212072728.GA4944@debian>
References: <20200210122423.695146547@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 04:28:33AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.3 release.
> There are 367 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Feb 2020 12:18:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.

hello,

compiled and booted 5.5.3-rc2+ . No new error according to "sudo dmesg -l err"
