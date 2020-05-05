Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27191C627F
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 22:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgEEU6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 16:58:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:44922 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgEEU6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 16:58:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 067EAACB8;
        Tue,  5 May 2020 20:58:03 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 05 May 2020 22:58:01 +0200
From:   Roman Penyaev <rpenyaev@suse.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Jason Baron <jbaron@akamai.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] epoll: call final ep_events_available() check under
 the lock
In-Reply-To: <20200505130357.04566dee5501c3787105376f@linux-foundation.org>
References: <20200505084049.1779243-1-rpenyaev@suse.de>
 <a9898eaefa85fa9c85e179ff162d5e8d@suse.de>
 <20200505130357.04566dee5501c3787105376f@linux-foundation.org>
Message-ID: <35b7d79b5cc7ee5befb1e632043701a7@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-05-05 22:03, Andrew Morton wrote:
> On Tue, 05 May 2020 10:42:05 +0200 Roman Penyaev <rpenyaev@suse.de> 
> wrote:
> 
>> May I ask you to remove "epoll: ensure ep_poll() doesn't miss wakeup
>> events" from your -mm queue? Jason lately found out that the patch
>> does not fully solve the problem and this one patch is a second
>> attempt to do things correctly in a different way (namely to do
>> the final check under the lock). Previous changes are not needed.
> 
> Where do we stand with Khazhismel's "eventpoll: fix missing wakeup for
> ovflist in ep_poll_callback"?
> 
> http://lkml.kernel.org/r/20200424190039.192373-1-khazhy@google.com

This one from Khazhismel is needed. Others are complementary to the
Khazhismel's, except the "epoll: ensure ep_poll() doesn't miss
wakeup events", which you've already removed.

Thanks.

--
Roman

