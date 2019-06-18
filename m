Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7AF49884
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 07:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbfFRFAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 01:00:15 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41363 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfFRFAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 01:00:15 -0400
Received: by mail-pf1-f195.google.com with SMTP id m30so6903399pff.8
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 22:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5eCFriLQWvF8FYEcvkBi/ZRaZyQ349tVPS3X6QmmHHY=;
        b=rklaTf761xf9MlDfHeHI9rXXxEKi/Yf3nBgqqf89Mb1zKGOaHXXjqat94kI2Zpds+y
         1EzLL6YU+rfMQApjIYKpKJpBCvKYPWoO0LqOVgEn0fxc1rcRoEiNl4b1va+TD4RGMUTX
         X7G4cNF2Nn+1Nl2/c6oS6btS5Mh76y7dDogfgA+14HGimDrCpANLmzzFom30AWPNTzpX
         eHY3+V5sJdHYI5G4WGKfnLQfwLgZdXU/VdgCOY9k4s4GznlwgH67hs71v0aB11O1krl4
         jVp0JRKVstpFbfGwPMNeQxzGKbsQeVeTWUFEZzVp/D/wMq4jH82oxqj1fIpW+lurauoQ
         +EWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5eCFriLQWvF8FYEcvkBi/ZRaZyQ349tVPS3X6QmmHHY=;
        b=R+e/DoUi45JMBitNKEfAujHQgWg/suMrOXTP0aBohqyQtb5sZCRxu/pl0WYKT0MKz+
         TumfdP+WtqqQYHV2F+tleHAhnturybbbKUAE2wvBZxFDrcNck5foi6LWHHy+tjYcyjhd
         66NH9I+cjB2dPfDX/yjxUR/iIexqrQkwwsvErCIDuXDPtWX0os/e36ijN7b7Krh6OGi2
         9uDhqi9zREouAvxTKkgdRN64Yy/XG3wev6V40f4qzsf4MrgvXXCNBa9XUQExD1lQq+M3
         l75LdkoC98AnwRhr0NDoJQgRbQzcO5lX4ZDK1Ys8ukrqINBEstHsW0zJBdvXoIxULamI
         ONWQ==
X-Gm-Message-State: APjAAAXmi3rxNCoXpGEnILmzm7yk3+riwWthNukiRm3ZYB0L0QKp4OEv
        qAsmvsWLcwBDHZwDoQpxBN0FSQ==
X-Google-Smtp-Source: APXvYqzcyaURim/qBrCjV64dB97VjsfXq2VZ/NdHcE7NDZTgG122hxMj1P2s7XZ2CLozqAmziS6xKg==
X-Received: by 2002:a63:5d54:: with SMTP id o20mr825397pgm.97.1560834014099;
        Mon, 17 Jun 2019 22:00:14 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id 85sm14627694pgb.52.2019.06.17.22.00.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 22:00:12 -0700 (PDT)
Date:   Tue, 18 Jun 2019 10:30:10 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Julien Thierry <julien.thierry@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH v4.4 20/45] mm: Introduce lm_alias
Message-ID: <20190618050010.5bp3jfowrzz25w6y@vireshk-i7>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
 <8500aeb27596eef7bd952f988c8db0a4b2f655c6.1560480942.git.viresh.kumar@linaro.org>
 <7b682848-d47d-94cc-6eae-7e97a0ca821a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b682848-d47d-94cc-6eae-7e97a0ca821a@arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17-06-19, 13:33, Julien Thierry wrote:
> I think this commit was backported in 4.9 because one of the commits you
> dropped (6840bdd73d07 arm64: KVM: Use per-CPU vector when BP hardening
> is enabled) depended on it.

Looks like that. I dropped 6840bdd73d07 patch at a later point of time when the
conflicts couldn't get resolved properly any further. I should have dropped
$subject one as well :(

> I have yet to check whether that other
> commit can be just dropped, however on your branch 4.4 branch, lm_alias
> isn't used anywhere, so we probably don't want to backport this
> particular patch (unless we need to actually backport the other patch in
> some way).

Right, dropping this doesn't generate any compilation warnings so we should be
good without it.

-- 
viresh
