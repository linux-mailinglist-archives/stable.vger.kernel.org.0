Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCB9122BC4
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 13:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfLQMhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 07:37:41 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37506 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLQMhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 07:37:41 -0500
Received: by mail-pl1-f193.google.com with SMTP id c23so6061184plz.4
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 04:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MRudvmKhJDWYtzneDuCIws5zDLnO7yoUHBs3dAUugWc=;
        b=jF/qD4BknEFRCtTNqmrtKXztOwg8qDq5/1np9XgRXSq/6WBXUR3hZLMz5Ag/uGmzxv
         baxZHfit28ov6PRGnkNNgThDdFE7MHeypi7bLi4FNYh2CYlU83KVj3RGN/HCGwzm3noc
         /7SEarI0b9E7r5BoWrXihFoBkSGYFmQzrltwz0Gx3BA7NdXIs5Kzn5JtR+sWbBTf75EL
         LRRm2fB7wWk7qRVGPjPQ6HXPo39rH8fpaDC2jhhozINJnqT//0qpKgntXM+zZSPP/WT/
         g/+2XLHmvhe+u7VVsy52blYmo2B/Nqfz5Rd+wmFkoo132R0ZU1wPzaKn/qPj7k/MJpBJ
         z4kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MRudvmKhJDWYtzneDuCIws5zDLnO7yoUHBs3dAUugWc=;
        b=I5ru8XQkSlwWBLNqHpN2jawQn2Viz0m1e1SZwEgvxS2BqaUiagtXJn0qnZS56X61XQ
         CCSqH2GIIV3c1pA1E/20rDg2BvS5cwvwF7msRAZQHmmkRaNPGJEZ3I2eLJbmwvPizPlP
         hP6w6SQCIoNob7LqfmTt/Jhfy8Y+mMIoMXQ96QJYBiVhonJlaeE4d9IpGdeSvYn+VWMD
         ouYzq9LcABCgvYlPDaJYtNqKhM76ck5JtYxAClyKsSnFWetuSsODdOM8OcNN0F5EFiww
         9RMTF3Jq/6IK/eRFYID37wlCzMw3v0JS7WuWMl6dn6rJ9h2ghL46pZeixfcRWqgDNAM6
         O3nQ==
X-Gm-Message-State: APjAAAWaHgV/b41yofCOYEouxDiP9zPc6XEcGNdW8rhgmcR4X26+owXC
        K/U0o7f2FrbIqDVX2lyib9dQAw==
X-Google-Smtp-Source: APXvYqwhUF3RlGnGikHc4pNISjJk5YxydwinKeNP1wBXzeE9lF9vDsz5YnzP44Qkb9ZLo7Y+iTOjwA==
X-Received: by 2002:a17:90a:17e3:: with SMTP id q90mr5601351pja.139.1576586260124;
        Tue, 17 Dec 2019 04:37:40 -0800 (PST)
Received: from debian ([122.174.84.27])
        by smtp.gmail.com with ESMTPSA id k5sm3258658pju.5.2019.12.17.04.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 04:37:39 -0800 (PST)
Date:   Tue, 17 Dec 2019 18:07:32 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.4 000/177] 5.4.4-stable review
Message-ID: <20191217123732.GA3492@debian>
References: <20191216174811.158424118@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 06:47:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.4 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Dec 2019 17:41:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,

No new errors from "dmesg -l err" on a typical kernel configuration on my laptop.

--
software engineer
rajagiri school of engineering and technology
