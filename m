Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74DCF9D263
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 17:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732909AbfHZPNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 11:13:23 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34398 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732872AbfHZPNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 11:13:22 -0400
Received: by mail-pg1-f194.google.com with SMTP id n9so10813691pgc.1
        for <stable@vger.kernel.org>; Mon, 26 Aug 2019 08:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j5KxHjXq4wZrRuSjnTO35VtGsy0U6Zm7/urplqoNwEg=;
        b=LrSYxPcMCE8kKbBcH0Y3Ky8LLQbhHQZMufx9PAeg0KliOgtT46O/2328VxjkC002s0
         fMFUqT3o78VSV7bCvVraoOlBIzM+/qiB5YjjfsWZg/0MDQ9Tukt7OT68Ak+Hc14VlMvF
         4WSz87/WMNlIAu77o+bBIo1Vi/Vgxb1pcjEbFcfy8MGu3LFJRUvTg7GiMMF2p/n5zXmm
         3OVCDL2D5CAWZnrHVicbMxKodku8gEbDG632rr2+ASNo8rlylbBcCHYsOAmF8CmOjLML
         qYi+Nuu1sU4Nybzy33ueiE7/rQK9yoJ6zRD6dYBZazM4SgLXJo9PqUTfJY8OYzOXJQyg
         C+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j5KxHjXq4wZrRuSjnTO35VtGsy0U6Zm7/urplqoNwEg=;
        b=aWi2IuyybshJG8zn0qG5JXLXbNjuZrQfRnN/w7/c+QqssO4aAz8UVSMX41NbyGA9Ie
         N6m73PmmjIaHj6FvQKAsJa/BuSvYf0/ZjCC69SdyZ8Wcf/2n8jxKvhPI2bUbqHENlU2r
         A3imPdeDKL+mCFaAm/XpeAWDJA6r/Dy25dLmLt1nYWPRQwR9pLq3nLdt1VKvRE5TaxuG
         vtGzdsRsk75MXAOq+dQwD0htWRAdCGKeqZahgdz1MQvmAMzZQlcLaBc4fiWGnuw/AdJg
         y8F2LSJbq7EXEqBYtWzv7PATAEeh9nuQBueT0e+Sdtnugp8gq63xlbNmG3Zg6toNtsnL
         LUpA==
X-Gm-Message-State: APjAAAUpV8rdvuObj9NHnT3nn/ZLrwwHPSD8SH4d8+PS/GHXNStiXjvf
        2VrjgnMl1YL31SrF9XIqs+ModQ==
X-Google-Smtp-Source: APXvYqza9qWjK7AbgQw32FUjQQVrD1ZaaAa3XtLTCQmQ29i1QX33eiFCIhXgsXNEeD+tlhOh+piA+Q==
X-Received: by 2002:a63:6c46:: with SMTP id h67mr17290709pgc.248.1566832401867;
        Mon, 26 Aug 2019 08:13:21 -0700 (PDT)
Received: from tuxbook-pro (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id g8sm11351479pgk.1.2019.08.26.08.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 08:13:21 -0700 (PDT)
Date:   Mon, 26 Aug 2019 08:15:12 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vivek Gautam <vivek.gautam@codeaurora.org>,
        Evan Green <evgreen@chromium.org>,
        Niklas Cassel <niklas.cassel@linaro.org>
Subject: Re: [PATCH] phy: qcom-qmp: Correct ready status, again
Message-ID: <20190826151512.GX26807@tuxbook-pro>
References: <20190806004256.20152-1-bjorn.andersson@linaro.org>
 <20190806155040.0B54520C01@mail.kernel.org>
 <57556d09-e2db-dc00-45a9-cbb57da02319@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57556d09-e2db-dc00-45a9-cbb57da02319@ti.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 20 Aug 17:23 PDT 2019, Kishon Vijay Abraham I wrote:

> Hi Sasha,
> 
> On 06/08/19 9:20 PM, Sasha Levin wrote:
> > Hi,
> > 
> > [This is an automated email]
> > 
> > This commit has been processed because it contains a "Fixes:" tag,
> > fixing commit: 885bd765963b phy: qcom-qmp: Correct READY_STATUS poll break condition.
> > 
> > The bot has tested the following trees: v5.2.6.
> > 
> > v5.2.6: Failed to apply! Possible dependencies:
> >     520602640419 ("phy: qcom-qmp: Raise qcom_qmp_phy_enable() polling delay")
> > 
> > 
> > NOTE: The patch will not be queued to stable trees until it is upstream.
> > 
> > How should we proceed with this patch?
> 
> Merging of this patch got delayed. Bjorn, Is it okay if this patch gets merged
> in the next merge window and backported to stable releases then?
> 

That's fine, thanks for picking it up Kishon

Regards,
Bjorn
