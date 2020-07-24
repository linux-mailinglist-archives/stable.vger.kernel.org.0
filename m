Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEEA22C5E0
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 15:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgGXNLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 09:11:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:35472 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgGXNLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jul 2020 09:11:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F423FAF24;
        Fri, 24 Jul 2020 13:11:52 +0000 (UTC)
Subject: Re: [PATCH v2 1/4] xen/balloon: fix accounting in
 alloc_xenballooned_pages error path
To:     Roger Pau Monne <roger.pau@citrix.com>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org
References: <20200724124241.48208-1-roger.pau@citrix.com>
 <20200724124241.48208-2-roger.pau@citrix.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <7f18eca6-9785-fbff-7870-83024173cb69@suse.com>
Date:   Fri, 24 Jul 2020 15:11:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200724124241.48208-2-roger.pau@citrix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24.07.20 14:42, Roger Pau Monne wrote:
> target_unpopulated is incremented with nr_pages at the start of the
> function, but the call to free_xenballooned_pages will only subtract
> pgno number of pages, and thus the rest need to be subtracted before
> returning or else accounting will be skewed.
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
