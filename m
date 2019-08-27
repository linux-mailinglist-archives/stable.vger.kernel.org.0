Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F369F245
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 20:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfH0SZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 14:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbfH0SZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 14:25:38 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3AE2217F5;
        Tue, 27 Aug 2019 18:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566930338;
        bh=5YuhsMUYWhySLtlIz2oPLVg9P5dV8mJMaEBHe3mss04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BuuKMT4xoImODw3U2iUm6Gwszvq+Ugxa0FcOJm8qJEkIUkk2z6rbS7s1k8Sc3j8v2
         jr+l+2iSHKzF2ahKrf8cGEtC9GRsxQQwmvFa0mTJ8yGbOm8hZAMHFoGBC1FFHtJzEO
         tFnepD/Ghvm1tmOaEhmFcn+rSrPtKY8pT6G2hRBs=
Date:   Tue, 27 Aug 2019 14:25:36 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Major Hayden <major@mhtx.net>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Yi Zhang <yi.zhang@redhat.com>, Xiumei Mu <xmu@redhat.com>,
        Hangbin Liu <haliu@redhat.com>, Ying Xu <yinxu@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.2.11-rc1-9f63171.cki (stable)
Message-ID: <20190827182536.GS5281@sasha-vm>
References: <cki.98AD376375.DJWRK5AJEY@redhat.com>
 <291770ce-273a-68aa-a4a2-7655cbea2bcc@mhtx.net>
 <20190827170518.GB21369@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190827170518.GB21369@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 07:05:18PM +0200, Greg KH wrote:
>On Tue, Aug 27, 2019 at 09:35:30AM -0500, Major Hayden wrote:
>> On 8/27/19 7:31 AM, CKI Project wrote:
>> >   x86_64:
>> >       Host 2:
>> >          ❌ Networking socket: fuzz [9]
>> >          ❌ Networking sctp-auth: sockopts test [10]
>>
>> It looks like there was an oops when these tests ran on 5.2.11-rc1 and the last set of patches in stable-queue:
>
>Can you bisect?

I think I've fixed it, let's see what happens next run.

--
Thanks,
Sasha
