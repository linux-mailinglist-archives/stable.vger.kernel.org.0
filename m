Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C351162A2C
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 17:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgBRQO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 11:14:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726411AbgBRQO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 11:14:28 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89BA521D56;
        Tue, 18 Feb 2020 16:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582042467;
        bh=fFn1ZeoNlHUGA1TAePWSyVqbhDwIWxxXNrgF/peZKo0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C1KDVEADesnn6pH/dPy3cs8PRg4kWoAYss2oz4rQ8l1ZgiDifwk9vKA6GOXeVxpie
         7Qk+e6fQsQ9IeYB1E9228sbdbnITW7LpYcWGPNLpg69HAvDPSV2IaH5uR65FmBaBBJ
         Kt7k29hdu50zQ32iIfx9jihZIq5I9OgsiyB/1EeE=
Date:   Tue, 18 Feb 2020 11:14:26 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: 5.4-stable request: 52e29e331070cd ('btrfs: don't set
 path->leave_spinning for truncate')
Message-ID: <20200218161426.GM1734@sasha-vm>
References: <e56ac6c0-2bae-62a1-a22d-d7374a98ab43@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e56ac6c0-2bae-62a1-a22d-d7374a98ab43@applied-asynchrony.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 01:01:40PM +0100, Holger Hoffstätte wrote:
>Hi,
>
>I was just looking throught the current 5.4-stable queue and saw that
>28553fa992cb28 ('Btrfs: fix race between shrinking truncate and fiemap')
>is queued. Upstream has a follow-up fix for this: 52e29e331070cd aka
>'btrfs: don't set path->leave_spinning for truncate'.
>
>Would be nice to get those in together. I only looked at 5.4, don't
>know about other queues.

Since that fix just hit upstream, I'm going to remove 28553fa992cb28
from the queue now and work on getting both patches in the next release.

-- 
Thanks,
Sasha
