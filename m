Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14DC777FC9
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 16:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfG1OMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 10:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfG1OMT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jul 2019 10:12:19 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F204B20693;
        Sun, 28 Jul 2019 14:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564323138;
        bh=rpNWYHg91g/i8jHhEmOU49NVobMvJB2OCILWcNgWeUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D29i49MIDRgM6mf4XwDLvIKUXnemlXKUSNJBCRI6CDx/caDHYq+/Pd5edV6THsabv
         T+awuAu8a7szUUrElxh9sSqe+ZuLycmVjdXn6/I5XNHzyTQcM00mZM1tJBya9pWZXw
         qdnQtTjfTF5jChIF9Y/MT0JQI5VWr5Jrc69M57pY=
Date:   Sun, 28 Jul 2019 10:12:16 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: nosmp build errors in v4.14.y-queue
Message-ID: <20190728141216.GB8637@sasha-vm>
References: <1ab4245e-3174-f081-9dbc-0847723157b9@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1ab4245e-3174-f081-9dbc-0847723157b9@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 27, 2019 at 08:38:00AM -0700, Guenter Roeck wrote:
>Just in case it has't been reported.
>
>x86/x86_64 allnoconfig, tinyconfig:
>
>Error log:
>arch/x86/events/amd/uncore.c: In function 'amd_uncore_event_init':
>events/amd/uncore.c:222:7: error: 'smp_num_siblings' undeclared
>
>"#include <asm/smp.h>" is missing. Added upstream with commit 812af433038f9
>("perf/events/amd/uncore: Fix amd_uncore_llc ID to use pre-defined cpu_llc_id").

I've queued it up, thanks!

--
Thanks,
Sasha
