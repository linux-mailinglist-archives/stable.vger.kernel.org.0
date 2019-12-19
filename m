Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECE6D126E19
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfLSTkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:40:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727166AbfLSTkO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 14:40:14 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8061D227BF;
        Thu, 19 Dec 2019 19:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576784413;
        bh=YfgZO6eidbqDyPe42IvVwzOvGm/EGUOZsF5VaxUSOyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UQ3LDi+fKTZGtY23KHibvP8PseLqwKWMYZGqMQp+WFEW2CLHI1razQknfeRBmRkib
         ZwI/35Uss1DB+jIJKTP+I39D3+UlaO6LFIGB+SBrwQd+KawK9psAKTJkJGQPFe0MJq
         VlpaYzet0oBfOS7pJg3zlJ8gZfYrum3ZNBASBOuo=
Date:   Thu, 19 Dec 2019 14:40:12 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH AUTOSEL 5.4 177/350] regulator: fixed: add off-on-delay
Message-ID: <20191219194012.GP17708@sasha-vm>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-138-sashal@kernel.org>
 <20191211105934.GB3870@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191211105934.GB3870@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 10:59:34AM +0000, Mark Brown wrote:
>On Tue, Dec 10, 2019 at 04:04:42PM -0500, Sasha Levin wrote:
>> From: Peng Fan <peng.fan@nxp.com>
>>
>> [ Upstream commit f7907e57aea2adcd0b57ebcca410e125412ab680 ]
>>
>> Depends on board design, the gpio controlling regulator may
>> connects with a big capacitance. When need off, it takes some time
>> to let the regulator to be truly off. If not add enough delay, the
>> regulator might have always been on, so introduce off-on-delay to
>> handle such case.
>
>This is clearly adding a new feature and doesn't include the matching DT
>binding addition for that new feature.

This new "feature" fixes a bug, no? Should we take the DT bindings as
well?

-- 
Thanks,
Sasha
