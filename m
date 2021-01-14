Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37B42F5ABD
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 07:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbhANGay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 01:30:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:49786 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbhANGax (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 01:30:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 861DDAB92;
        Thu, 14 Jan 2021 06:30:12 +0000 (UTC)
MIME-Version: 1.0
Date:   Thu, 14 Jan 2021 07:30:11 +0100
From:   Oscar Salvador <osalvador@suse.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     =?UTF-8?Q?HORIGUCHI_NAOYA=28=E5=A0=80=E5=8F=A3_=E7=9B=B4=E4=B9=9F=29?= 
        <naoya.horiguchi@nec.com>, akpm@linux-foundation.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        David Hildenbrand <david@redhat.com>, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/5] mm: Fix page reference leak in soft_offline_page()
In-Reply-To: <CAPcyv4gVPMUD7P0KwAY9xk3xBkodPExeJVG6i9=9FGexbJZpBw@mail.gmail.com>
References: <161058499000.1840162.702316708443239771.stgit@dwillia2-desk3.amr.corp.intel.com>
 <161058501210.1840162.8108917599181157327.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210114014944.GA16873@hori.linux.bs1.fc.nec.co.jp>
 <CAPcyv4gVPMUD7P0KwAY9xk3xBkodPExeJVG6i9=9FGexbJZpBw@mail.gmail.com>
User-Agent: Roundcube Webmail
Message-ID: <c470b3d344e560e5c1c7b57f9bf83a37@suse.de>
X-Sender: osalvador@suse.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-01-14 07:18, Dan Williams wrote:
> To be honest I dislike the entire flags based scheme for communicating
> the fact that page reference obtained by madvise needs to be dropped
> later. I'd rather pass a non-NULL 'struct page *' than redo
> pfn_to_page() conversions in the leaf functions, but that's a much
> larger change.

We tried to remove that flag in the past but for different reasons.
I will have another look to see what can be done.

Thanks

-- 
Oscar Salvador
SUSE L3
