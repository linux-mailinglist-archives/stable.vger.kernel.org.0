Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923D96D615
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 22:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfGRU4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 16:56:17 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38884 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbfGRU4R (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 16:56:17 -0400
Received: by mail-io1-f66.google.com with SMTP id j6so21589261ioa.5;
        Thu, 18 Jul 2019 13:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z3Kb4Nlh28dzyx7WMvMRAp91R/BX5xGt7n3BmbiajKA=;
        b=kSRPEmme686WO0r3pReY+hoHXX7ANZ97LtjusVUaRewJwiurLf1vdQSZzy/N9heT92
         YiWXwvjmtXRGxiQbvGElyHN50iwPgwS2yXj3lhm6VHlGyo/x8QZQ/2TAyuuHT9+HNp7m
         S2Pf/C1lBNXJBvTUwpVkwqf5OPXgeRORP8dzSCn2Cg86FIYDzENMlme8tVAGlScxwBB8
         XYdLbnt9nC3JoDX9lTmfsesffaGvtAnyNiQD8UipveJzecPxFJJZzScmbTdKEaFZ6V/F
         1QFl/4ARSu7loAxVKJJOUVpGcWKXI1niP/mgd20N/A4gD3sPtllfni6jCKoLeYa87k2t
         bplQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z3Kb4Nlh28dzyx7WMvMRAp91R/BX5xGt7n3BmbiajKA=;
        b=tYVaC67p0WsviiIDfeCeLFoO9RzQ7kMtiwznysBiNZGiUcFVpPC720iW4wdCmjiLlE
         2ECjxTdGBafrthLeyrPnIryAYdnBBs/kf6qs3/xCTtmathQou6HF4hDU2/5nXY4sGYhy
         PwAQOV9qwDYIIMYoUDwEl6OHk/Skpa3W4sFrRkZ9JmylHkXyi6vFE2LrQAaDmLtiOTE1
         R+IQhtTO4+C+y9AoqE+/R6vNrc0nyUBFZ/qHkycaD5wuljYsRtbJP7GpN8q+umE3ISiU
         6gN8UjaQ24ttuAe6eBTgC4UquErVXGjkCO3FEuSkizcP5OW/QuurhCzE60ja5HGa12M/
         4jWA==
X-Gm-Message-State: APjAAAVc4EPKTFDqTH+gnMRnKOWETTwaSKqS956DUP23dKngPc6r5g6F
        Ado6cAEVeaeiUq8Ail9Azps=
X-Google-Smtp-Source: APXvYqym0OMsCTmhoU3GNiLoYT23BHmmpqaZ3x0tI15uIs38R13brL9lFlVqyltox2o5wVH++UkgIw==
X-Received: by 2002:a02:cc8e:: with SMTP id s14mr23372671jap.142.1563483376666;
        Thu, 18 Jul 2019 13:56:16 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id k2sm22457619iom.50.2019.07.18.13.56.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 13:56:16 -0700 (PDT)
Date:   Thu, 18 Jul 2019 14:56:14 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/54] 4.9.186-stable review
Message-ID: <20190718205614.GB6020@JATN>
References: <20190718030048.392549994@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718030048.392549994@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 12:01:30PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.186 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.186-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted with no regressions on my system.

-Kelsey
 
