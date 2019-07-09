Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 952C163B5E
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 20:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfGISri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 14:47:38 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43611 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGISri (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jul 2019 14:47:38 -0400
Received: by mail-pg1-f195.google.com with SMTP id f25so9894193pgv.10;
        Tue, 09 Jul 2019 11:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P8UWAmcxhdPpXyx3Jsa3aobBmijvFku89YXIKQmSDK8=;
        b=MwSHIfJ710Cj4zBodNZi0OLmMkFgSFSik5K//5zZNEdJfzMWCUjJMpCF3Dz8b+LLzu
         aOz/5MgFF2MaEaXm0SVlgF5a1syF4tQYioLNnSbl+qkEzxoNy+xaC0gytPKSnZ4cbTGU
         +tb/3CDN9DzFvlsdMAL7CGYU9y2uHG/Mjb0C82xFzK255IEo+YTZkz/WXk92Sb3zUnzh
         QpRqE9E+CLZWb/rhKe9KiZK6hD86NhZgn++7+7kkMz1tx3LUeDx7G8WwqgXMu66QIhq4
         7Qbs7KppV5np6oa8mGjf+IWbTnv6/lSGBm+ODOG2bt54j0V6d63tm4n6UQjlmVYQA9wa
         vOwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=P8UWAmcxhdPpXyx3Jsa3aobBmijvFku89YXIKQmSDK8=;
        b=ok/Y7Dixn8JBheSmjfhiF7tFgPWoI3s/Ifpb1aLajdUXWj5Xn3qcg+WT6NIu2qifwQ
         NDjSvZeIY8x6ibYb1uJiazNEhQzWB8ceVg/8lJG1iGZkLHb/wFMzAcDQo84oPzuQC5yo
         dXQ2jIKfnSGSPL1gIqwtRGR9yJiQUEb7iPAeo18U/sTjyRuVQYgTUrMZAvhnF1PBG2Da
         JyG/AbTApzc5hR/T2XaF+Wdl+M5XLJt4GRSZIe8C1JBNn9Z5vVhzJNPUEhQx7Pq+tQ2k
         G7SygirmyXJCKHMNpeRI4tFqGh+TmKNdZ1Obgx8A5MApcGyTSqwfDY2O8NS46tNNCR6J
         ko/w==
X-Gm-Message-State: APjAAAVmHoY7Q1PRo+p1gnjNEeFDlx7KKen7px/FYgXtiS/bImb3shKW
        JExBFxdFQDsFKRuwpu2aZzS1n+6H
X-Google-Smtp-Source: APXvYqwulUDpt6mh6aUbG2+e+qmpdNGPa70lChbKF+i0J4uhVLkrnql7bJho7+tKR0ydzaxyBDV3zg==
X-Received: by 2002:a17:90a:9604:: with SMTP id v4mr1715823pjo.66.1562698057811;
        Tue, 09 Jul 2019 11:47:37 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h6sm24210586pfb.20.2019.07.09.11.47.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 11:47:37 -0700 (PDT)
Date:   Tue, 9 Jul 2019 11:47:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/102] 4.9.185-stable review
Message-ID: <20190709184736.GA3164@roeck-us.net>
References: <20190708150525.973820964@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 05:11:53PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.185 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 333 pass: 333 fail: 0

Guenter
