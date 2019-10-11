Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56AABD3973
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 08:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfJKGf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 02:35:56 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35169 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfJKGf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 02:35:56 -0400
Received: by mail-pl1-f195.google.com with SMTP id c3so4001108plo.2
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 23:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2PKi0gGKFmNsseS6eEp2W7gRX3AXEJ136rqpVgQpudA=;
        b=qNStiJh8USiyUA0LB1YcgQSb04etEkZ//GTZjbSQTL0FseLa/gPSrSO4AZnzDhFfeo
         z9w7tZuRWjm1lwio9JPM+01QLqn0mp4Gu2XQKAgb9apWOX6mRxFiRYoh6Ug99QAWS0PS
         06yB78265v6VWDtQYkI83dMBb8cxazuaaoCr+s31bHeLseS31Tg7QNZCTYue8cJ2HbbZ
         g7xK0cogvKYuZQ6hzouirM1zL+6Mt/V/SUrhUhLsh+pQBmhsCYzbuGbyUmes34DkXxg2
         qaZp/wc6ZVHmXdMOKPMxE/IQX36wVAhb35149kI0dcnJvpfT01Lgdn1zJ/yIzBMOEauO
         xqcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2PKi0gGKFmNsseS6eEp2W7gRX3AXEJ136rqpVgQpudA=;
        b=d3mkulnCdaEqMBzU8Q/8QDGEar/27h5yEHKm7T2sfNegDhH7O1KU1WWVcD06XhNlgD
         /LCwexV+sx9gtFb7zwD79KCdJ4d8YvF+de9qXhParZNNhqx8wuMwSSUsBF2cijHvsuRn
         a7eY1zjk4B1DsKeKdI8qaP5JAm1kLpeqVPM1nY4N5gMPcyVkrNr+4irJAa1uEIr06m1s
         bMEO0bHjhEJaFAUbDTS87fDf4nb3k4ePBwfyW97E2g2meKkJ2CzTIuS8bi25s6EHrgBt
         +uRLt4cx+Sv01mKCBcSDl8jN6ptrFKOz1IdXHfeQlCiCKss3n/C0bY1Q8w7zGdbIXMef
         kA4Q==
X-Gm-Message-State: APjAAAX9DfC3FlmQ0pXRRQnBUaajzRcXdm13Pt28WP3rnbL6oioqFP40
        j8CX5M06mFH8RrzM1plkmPF87AYcp7E=
X-Google-Smtp-Source: APXvYqz4HrIkTF+9y69hw6UyGP8wUvaMTNHDrPrsgDFKM85PJ+Qv5spxv+eUr/l8V6bAyUVHvr3btw==
X-Received: by 2002:a17:902:b08b:: with SMTP id p11mr13304468plr.201.1570775755036;
        Thu, 10 Oct 2019 23:35:55 -0700 (PDT)
Received: from localhost ([122.172.151.112])
        by smtp.gmail.com with ESMTPSA id v8sm21460724pje.6.2019.10.10.23.35.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 23:35:53 -0700 (PDT)
Date:   Fri, 11 Oct 2019 12:05:49 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: Re: [PATCH ARM32 v4.4 V2 00/47] V4.4 backport of arm32 Spectre
 patches
Message-ID: <20191011063549.vfu4fgdmhwrtix3f@vireshk-i7>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
 <20190829114006.ptxnynqcetqbprbm@vireshk-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829114006.ptxnynqcetqbprbm@vireshk-i7>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29-08-19, 17:10, Viresh Kumar wrote:
> On 01-08-19, 13:45, Viresh Kumar wrote:
> > Hello,
> > 
> > Here is an attempt to backport arm32 spectre patches to v4.4 stable
> > tree. This was last tried around an year back by David Long [1]. He was
> > backporting only a subset (18) of patches and this series include a lot
> > of other patches present in Russell's spectre branch.
> 
> It's been almost 4 weeks since the first post on this. Can someone
> please help with reviews ?

Ping..

-- 
viresh
