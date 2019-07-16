Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 796216A0ED
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 05:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbfGPDom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 23:44:42 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33566 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730311AbfGPDom (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 23:44:42 -0400
Received: by mail-pf1-f194.google.com with SMTP id g2so8413189pfq.0
        for <stable@vger.kernel.org>; Mon, 15 Jul 2019 20:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HAbLIcu7Y20FNSdYESSfYWN0X3RSwMnzsh7JLim98Ng=;
        b=yKegYub9QM21pRBwJqRi8F7TMNXEId9/ySwc7QINpN5uD4U+n1p44JjV3eA/OqTnvV
         Fj5JMWC1s6/aaaAIgNxP6aXrqZM2z28G/TuoS/cKOI5fImpiNmGIAABDDxRTi/x8zgSs
         qDhUk4CmUXpAlWbWemWBVPqNwL8dvuZc0kzNpTWfUOChO/yGROao6ZRDEWTZWQbDe5A1
         qby6s15XKz0DYAIEiwMs356UINM7Zqw2pGSHUudVEKGRA2YlB6EEzyxObeyRN49XMeiQ
         72LyTwIb8qPvXQogyOtk4zMLcTn2DJPhSaEfl9WwB6R0YHCHfEzy4ozhvn5eHa0kip7m
         996w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HAbLIcu7Y20FNSdYESSfYWN0X3RSwMnzsh7JLim98Ng=;
        b=hu70ci7VnjXeDZw20cXX/aJfIQvLsWFj5sTQnme6dJTE9JDUqx2wteMFd5uEg3nnvY
         JPvhnCuBA+LkYbsaMnh3Log5TrkbX70VZ/s0Ji+JsFpfT1o4Y9f9GVPxlMY5HWDNrgfq
         g9RCQ0WrbZK4NMDFNn3ohs0j4OpVJlmUHv/rRKjNbFunjfpxc4v1ABrPxatkrludqp3m
         7GiKP3T4vZpUow8ss+Opu+o1kVluX8RIJLPCGrJn8OLG63rB7TmjNogSPbZGL0FWtPm7
         YEEqZ9Ld65VCCc376kLTrplIAW6/hKA4R00H91DaLvP69StOwKJq4vfIPIqL70GJ1Q79
         of6g==
X-Gm-Message-State: APjAAAV9P0bVFbVBJe50dk77VShoPgz51FQqaw3DHpZtwzAaFBBnBVUw
        RPWoJackTbY5/TKYOTzrcxfBoQ==
X-Google-Smtp-Source: APXvYqyh2bo4bQr+Uxcy92vuimvnkN7dPco681H2kbg5jPAu33xrMkg0wuu6HD4e5qQkyrKUiJau7A==
X-Received: by 2002:a17:90a:fa12:: with SMTP id cm18mr33204852pjb.137.1563248680896;
        Mon, 15 Jul 2019 20:44:40 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id u16sm19716809pjb.2.2019.07.15.20.44.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 20:44:39 -0700 (PDT)
Date:   Tue, 16 Jul 2019 09:14:37 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH v4.4 V2 00/43] V4.4 backport of arm64 Spectre patches
Message-ID: <20190716034437.gq4q4bsftfzqd2ll@vireshk-i7>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <20190715130936.GH56232@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715130936.GH56232@lakrids.cambridge.arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15-07-19, 14:09, Mark Rutland wrote:
> It looks like I messed up spectacularly when backporting that commit;
> those files should not have been added. I must have had those lying
> around from a rebase or similar.

That's what I thought :)

> I'll spin a patch for v4.9.y to drop the bits I added erroneously.
> 
> It is somewhat concerning that no-one spotted that (myself included)
> when the v4.9.y backport was originally made. :/

Looks like no one reviewed the patches seriously as they came from you
and people thought they should be okay. We know Mark :)

-- 
viresh
