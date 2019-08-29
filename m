Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78867A190D
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfH2LkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:40:10 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38701 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfH2LkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:40:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id o70so1876987pfg.5
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NYPdFLxnP2SpVPuKchfoNl7WNRTdf28Sddkoq+zSktk=;
        b=Ip9Rj1WgWixO0eEXukO7vDK+ZT/ww9GvUEQkD4LC64n0/0Qc8GDEpoiJuF0HhCPuHv
         8k4jneSJtvEEBym3sMHR53AkA3eg71HYWuNxXW1CcXtubN79R/IgzxxMfWiolR6p76mJ
         RjT3LqZ8+4eLAnLRK0mUAkZvRBlAjc5cHW/67Mk1xB4JqrGKuXSDRUSAqoGeI+vFf12T
         KA592ORTLduKPak+3fJDP31m5Q3P9d2+SPjjxhWGqlOA6xMEpymJ+Y1tqS7eJD8fFxp3
         3grDR3y9gQgOb/Z2rRaY8jXXMc0dRwtsv0403OLzRGTji/E1Fsrui/kqBTZ5Z56MRqN4
         oE5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NYPdFLxnP2SpVPuKchfoNl7WNRTdf28Sddkoq+zSktk=;
        b=rZH3D7CQZJ6Insfv8ZGB70ins3TAfwpWet5ab4WFMiDpCGQw8sN4VsqSFIBmh7VSm0
         iAuTBvOsPqRW9JwxN27WNbFod6OsLxpirTJPrEVVHgiKJYpFfsruUX9QA9p767F3LIFu
         noRCaLpaY7TrV9Jyl5cbb/6Q60e8Y1mxByGAqmU7vcKoyoj5a2ylDf/5oUwfhm7yZ0LD
         +fLPmS/XLm7LLjIQT3oilDwQQLRjEh4QYBQjAgQ7H3uJ2S07Eze2hCQwq2QTLgDx5Bxa
         +guBDXKAHtBz7o/z9HmcjeQVU2vhIH7Xj75ou5LWTC3LGeyCAHWvlzjo3xu83VK6nZ99
         fOwQ==
X-Gm-Message-State: APjAAAV3TgKS7zr0kDPvvnWLkymu96DxB09PbD+baa+4JL5ho7wNA5yn
        wAhAIcog0EHxJl3ZTpihlDKR0qoXP0k=
X-Google-Smtp-Source: APXvYqzEAzoTB6eQRNtv7b/1zJHW4m8QqYQpqNOMdCVDQ9YzPCbag3DRbr3h+bUoBTWPo4qrzC12pA==
X-Received: by 2002:a65:50c5:: with SMTP id s5mr7913573pgp.368.1567078809383;
        Thu, 29 Aug 2019 04:40:09 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id a18sm3924333pfn.156.2019.08.29.04.40.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:40:08 -0700 (PDT)
Date:   Thu, 29 Aug 2019 17:10:06 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: Re: [PATCH ARM32 v4.4 V2 00/47] V4.4 backport of arm32 Spectre
 patches
Message-ID: <20190829114006.ptxnynqcetqbprbm@vireshk-i7>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01-08-19, 13:45, Viresh Kumar wrote:
> Hello,
> 
> Here is an attempt to backport arm32 spectre patches to v4.4 stable
> tree. This was last tried around an year back by David Long [1]. He was
> backporting only a subset (18) of patches and this series include a lot
> of other patches present in Russell's spectre branch.

It's been almost 4 weeks since the first post on this. Can someone
please help with reviews ?

thanks.

-- 
viresh
