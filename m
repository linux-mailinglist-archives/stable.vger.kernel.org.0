Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34CDF3B7A3
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389392AbfFJOnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:43:15 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38075 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389317AbfFJOnP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 10:43:15 -0400
Received: by mail-pg1-f194.google.com with SMTP id v11so5159136pgl.5;
        Mon, 10 Jun 2019 07:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0jZ5l4R0gOuzDEE92f4hnQ6KUg3Ndgb03svKQhwL6tI=;
        b=csR8vQek0KDNcCVN+FFM51FUFiHIadSzyyr1k91KQt+E1zLclXY7xF0xuMU5rOQMju
         zWtMvDhQ8GCbThKxTioPeaLvELI6ASYeLJjGAHDRoRTWIjMdHpuBSoUezpjarRqLiDTN
         yjBFvCWCnwlSZ6GImJbAXks2z5UwZ9CnZ0kuYQgrXfr2MHQfTNV81blu+tD5PJKQZH9h
         3yinxo8C2kMrbLFdMabbLhwJ3vtNRS8S3V6ZfEYff5qxooBnDBdTrl3OONoHTPATogKn
         jroLs9J1JrzSAys+t/2LEEPFVPdKv8jbVgAnWKmXEuO+83JHO+yvRiBpcbN/4gR4X8Mn
         ZEMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=0jZ5l4R0gOuzDEE92f4hnQ6KUg3Ndgb03svKQhwL6tI=;
        b=cF7tVgk7fMwd4JZGUbsw1h1AHkEBk7+iiHJw9cmRIBa1qF/Dz57kQJhZ6t/G3pKk2l
         csXPnFzCOe9KALA4CDuNyiyo/IkmMtQSdgSeBsZKk0ZmDdWHuPu114ckVOoB+kepzGiK
         rTdJEyYr6k/UOs/JqXn2184AvBdF7QXUW4zqJcKCVPraFoWmq4/X847zc+IfxWO96fd2
         MfKlB92vBF1jk0hMY450Cfhp7tj8vlKXo4Ivervu1m+TWrDxg5ZtX5NpxQ38DKRRSm2y
         3VhNOMDm7k5BdYIG08FUo12gBvEN6h8WwKCaU23fztroGoZBPObx9VHdUGBiEzWSz0Jv
         CCgw==
X-Gm-Message-State: APjAAAX5pCwqGn6xpZyBQJUn5ipjOZn+Co6rIsWGS2JlEU93KRjyTrIv
        xhyRMgupS6tr7uH1+LT8KTY=
X-Google-Smtp-Source: APXvYqz9TyCmfSnsl09pBj2+kp4Xw1uh3XHfcv++Y9uuJLI8pbEwkKnk4xOokxgJislQfompIQmffw==
X-Received: by 2002:a17:90a:2228:: with SMTP id c37mr21961431pje.9.1560177794573;
        Mon, 10 Jun 2019 07:43:14 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p15sm12184509pgj.61.2019.06.10.07.43.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 07:43:14 -0700 (PDT)
Date:   Mon, 10 Jun 2019 07:43:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/35] 4.14.125-stable review
Message-ID: <20190610144313.GC7705@roeck-us.net>
References: <20190609164125.377368385@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609164125.377368385@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 06:42:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.125 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 11 Jun 2019 04:40:01 PM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 335 pass: 335 fail: 0

Guenter
