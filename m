Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B123A41A6C3
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 06:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhI1Eso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 00:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233039AbhI1Esn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 00:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B7DA61139;
        Tue, 28 Sep 2021 04:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632804424;
        bh=jpZqXI7px7szGzbCLClcib+8fQWcjf2Hode4ZcSW2J0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fEVIkIKL7LZ2UTvf73dt3UIU+g+IGn8mScYHRvBoYjXz/fI94LWVVVGnmddKBUR4Z
         tFBxQJD9ICCTTkckwr+Etg+XLsG6C1I6MDPBhkgGROrltbyAH+/T7caAPqr2zBPWMy
         3937bksLuFCwQ+J3+Kln94tsZLWJJsrc8YePxOFT9WgO+eioOaZtlvYuod/UiuVR28
         oBg0xZ9EWhyzL+Q7MRh2xIliI+a3hV0WNedTUqdJPrz3MxKDIMEqN2y3x/hsFMDuGJ
         EtiRh1B+QMI5XqAYFu637W04JNe2cP4rFc/QQRK+I1mdiGvEOCTRNinpHaV6wrXMFl
         vghhv47WkrNZQ==
Date:   Tue, 28 Sep 2021 00:47:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 5.14 075/162] kselftest/arm64: signal: Add SVE to the set
 of features we can check for
Message-ID: <YVKeSJM8n7RarquM@sashalap>
References: <20210927170233.453060397@linuxfoundation.org>
 <20210927170236.052759270@linuxfoundation.org>
 <20210927171602.GG4199@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210927171602.GG4199@sirena.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 27, 2021 at 06:16:02PM +0100, Mark Brown wrote:
>On Mon, Sep 27, 2021 at 07:02:01PM +0200, Greg Kroah-Hartman wrote:
>> From: Mark Brown <broonie@kernel.org>
>>
>> [ Upstream commit d4e4dc4fab686c5f3f185272a19b83930664bef5 ]
>>
>> Allow testcases for SVE signal handling to flag the dependency and be
>> skipped on systems without SVE support.
>
>Unless you're backporting some test that makes use of this I'm not sure
>why this is stable material?

The patch right after this one wanted it :)

-- 
Thanks,
Sasha
