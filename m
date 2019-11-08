Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E77A0F3C83
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 01:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbfKHAFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 19:05:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfKHAFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 19:05:04 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D53E3214DB;
        Fri,  8 Nov 2019 00:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573171504;
        bh=x5Lzm8SbrwzjU2HtokmyRRzdfHGual2SPlOH0CtUT2Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ER2euYGvf7UHpsPTycvQhLJJUJYjESz2sDKupSsTaJbuh4fKfl0CWAi7WSOuuqU2H
         2+wVHA9mEPnlDYgpsyDcr6Qbop+BjsnUMSDw4esiD26Z1Gk83RcYvoOFhqYAHJ8Km2
         bwzO2zk7fMEU7CdLJwFMFebJgGZqcU2uILbHlD9I=
Date:   Thu, 7 Nov 2019 19:05:02 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Brian Norris <briannorris@google.com>
Cc:     stable <stable@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: Re: [FOR STABLE] wireless: Skip directory when generating
 certificates
Message-ID: <20191108000502.GL4787@sasha-vm>
References: <CA+ASDXM=wh7TqO55BSV-Z12iJz08uVonJScCUDCRA+_h8JGe0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+ASDXM=wh7TqO55BSV-Z12iJz08uVonJScCUDCRA+_h8JGe0Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 07, 2019 at 10:45:22AM -0800, Brian Norris wrote:
>Hello stable!
>
>I'd like to see the following commit included in -stable trees:
>
>commit 32b5a2c9950b9284000059d752f7afa164deb15e
>Author: Maxim Mikityanskiy <maxtram95@gmail.com>
>Date:   Tue May 7 20:28:15 2019 +0300
>
>    wireless: Skip directory when generating certificates
>
>As it is, CONFIG_CFG80211_EXTRA_REGDB_KEYDIR is broken between v4.15 and v5.2.

Queued up for 4.19, thank you.

-- 
Thanks,
Sasha
