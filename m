Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA41507E4
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbfFXKLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728719AbfFXKLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:11:31 -0400
Received: from localhost (unknown [63.142.50.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5B4D205C9;
        Mon, 24 Jun 2019 10:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371091;
        bh=tNGpJNCQVdMt+gzJS6v3e5EAr4c/mmQ2G7RcUbPB5k4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vXJ5gIh5+aS7p8kRjlZBmUDhEVktIPEOeu4OwvrLg46VjDuKbwTHx3Dikgllsqcas
         rcgqbR8KYX8W2u9nFDJUNRBviSb6U4gcOPB20u+gS25RFzek7mXC/8+TiO1UIJZUWB
         D//IORLHTIVPFTmNqis2CyHspJIlLBfQxkMQ11dk=
Date:   Mon, 24 Jun 2019 06:11:29 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Sangbeom Kim <sbkim73@samsung.com>,
        Georg Waibel <georg.waibel@sensor-technik.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] regulator: s2mps11: Fix ERR_PTR dereference on GPIO
 lookup failure
Message-ID: <20190624101129.GQ2226@sasha-vm>
References: <1560948159-21926-1-git-send-email-krzk@kernel.org>
 <20190622181347.3BFC52070B@mail.kernel.org>
 <CAJKOXPeZH+jiXxsm_cpWsfuju=vhAd2GDoj_aH811pv17C6YOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJKOXPeZH+jiXxsm_cpWsfuju=vhAd2GDoj_aH811pv17C6YOQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 24, 2019 at 09:01:27AM +0200, Krzysztof Kozlowski wrote:
>On Sat, 22 Jun 2019 at 20:13, Sasha Levin <sashal@kernel.org> wrote:
>>
>> Hi,
>>
>> [This is an automated email]
>>
>> This commit has been processed because it contains a "Fixes:" tag,
>> fixing commit: 1c984942f0a4 regulator: s2mps11: Pass descriptor instead of GPIO number.
>>
>> The bot has tested the following trees: v5.1.12, v4.19.53.
>>
>> v5.1.12: Build OK!
>> v4.19.53: Failed to apply! Possible dependencies:
>>     Unable to calculate
>>
>>
>> How should we proceed with this patch?
>
>The commit mentioned in fixes tag (1c984942f0a4) came in
>v5.0-rc1/v5.0. Why do you try to port it to v4.19?

This is an interesting one! Usually when something like this happens, it
means that the "fixed" commit was backported to stable, but as you
pointed out, it was not.

My scripts have logic to try and detect these backports, and it appears
that there's a commit with an identical subject line in the 4.19 tree,
so at this point there are two commits with identical subject lines in
Linus's tree:

1c984942f0a4 regulator: s2mps11: Pass descriptor instead of GPIO number
0369e02b75e6 regulator: s2mps11: Pass descriptor instead of GPIO number

Which can be confusing for humans too :)

--
Thanks,
Sasha
