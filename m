Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2984935C2B5
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 12:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbhDLJrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:47:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:42236 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238959AbhDLJpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:45:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618220714; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7sa/hj4u/V5reWyozzht2uCFPvZTmFgvs67chooCm9w=;
        b=ixDHpl+WefpBBW97JDvdapFctRI1FCKRJrYUvy1IlcBhan1vbckclU9UegDacILepp31JD
        URzkFzmuboCpDZ3It2nLriqE40EU6BIqU0uHC+c02lzoX55F+B90bxkTbgDfjszX/rQddB
        /FVIo83iBc9agoaAYNadJxshsA5T5Yg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DB96DAF1A;
        Mon, 12 Apr 2021 09:45:13 +0000 (UTC)
Subject: Re: [PATCH] xen/events: fix setting irq affinity
To:     Juergen Gross <jgross@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
References: <20210412062845.13946-1-jgross@suse.com>
 <38b2b47d-a77a-9d02-3034-f1c4d03ffdd5@suse.com>
 <bec9c7a5-5661-73b4-1b0b-137dacba7bbf@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <a5852f35-8828-c6a0-260a-cf095626eb1f@suse.com>
Date:   Mon, 12 Apr 2021 11:45:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <bec9c7a5-5661-73b4-1b0b-137dacba7bbf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.04.2021 11:39, Juergen Gross wrote:
> On 12.04.21 11:32, Jan Beulich wrote:
>> Possibly related, but first of all seeing the redundancy between
>> eoi_pirq() and ack_dynirq(): Wouldn't it make sense to break out the
>> common part into a helper? (Really the former could simply call the
>> latter as it seems.)
> 
> In theory, yes. OTOH this no longer applies to upstream, so i dind't
> bother doing that for stable.

Oh, I guess I should have check the tip of the tree first...

Jan
