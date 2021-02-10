Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839FB316ECF
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 19:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbhBJSfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 13:35:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234384AbhBJSdU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 13:33:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E401464E79;
        Wed, 10 Feb 2021 18:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612981834;
        bh=GhlWvnECgJllfLtO8xUeOGZbtcYjbZu0AtA83aQ0XQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U+pNdBwkeQwxRW6z9EwaaF7HHJhp481ny4Cn5dTs3C/uhMYgWobmcKjHgO6K8mc2I
         fB32I8hy9qHMy+L8fFAT1aRLnxaC88Vv5sH25WvWkOEihlciSvQX/HAiAr22ECmuIj
         QIOC9NkooRs0HkyOUNzgnJSvAxDcNUxtLowMCzbr8vB17faIGZUrektwvmTp6dDO0x
         oV1tKi2GCdTO2PD49BCzX06yf3Yu7SLdMBJeDmQp01xEfRlvcXF2sjcz7If0nsAvTk
         n/kr24H0CzOu9grx3elxL88UgdDhXPwh6Wls/M8TtCnbQuqkS9yyHObZhQd3F+ST5h
         AlkstqAtBqpWA==
Date:   Wed, 10 Feb 2021 13:30:33 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rostedt <rostedt@goodmis.org>,
        Michael Jeanson <mjeanson@efficios.com>
Subject: Re: [stable 4.4, 4.9, 4.14, 4.19 LTS] Missing fix "memcg: fix a
 crash in wb_workfn when a device disappears"
Message-ID: <20210210183033.GF4035784@sasha-vm>
References: <537870616.15400.1612973059419.JavaMail.zimbra@efficios.com>
 <YCQTQyRlCsJHXzIQ@kroah.com>
 <2071967108.15704.1612977931149.JavaMail.zimbra@efficios.com>
 <20210210180025.GE4035784@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210210180025.GE4035784@sasha-vm>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 10, 2021 at 01:00:25PM -0500, Sasha Levin wrote:
>Looks like it doesn't apply due to churn with tracepoints, I think it's
>fixable. Let me try and get something for <=4.19.

I've queued a backport of that patch (via two prereq patches), thanks!

-- 
Thanks,
Sasha
