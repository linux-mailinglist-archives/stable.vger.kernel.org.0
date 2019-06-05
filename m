Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D06C35732
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 08:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfFEGu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 02:50:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:36582 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726341AbfFEGu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jun 2019 02:50:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A99B1AC50;
        Wed,  5 Jun 2019 06:50:25 +0000 (UTC)
Date:   Wed, 5 Jun 2019 08:50:24 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        aarcange@redhat.com, akpm@linux-foundation.org, jannh@google.com,
        jgg@mellanox.com, oleg@redhat.com, peterx@redhat.com,
        rppt@linux.ibm.com, torvalds@linux-foundation.org,
        stable-commits@vger.kernel.org
Subject: Re: Patch "coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping" has been added to the
 4.4-stable tree
Message-ID: <20190605065024.GA15685@dhcp22.suse.cz>
References: <155965961313615@kroah.com>
 <20190604145216.GJ4669@dhcp22.suse.cz>
 <20190604150756.GA24221@kroah.com>
 <1559663498.24330.85.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559663498.24330.85.camel@codethink.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 04-06-19 16:51:38, Ben Hutchings wrote:
[...]
> - I don't understand why collapse_huge_range() needs to be fixed, but
> then I really don't understand the khugepaged code at all!  So I would
> trust Michal on this.

To be honest, I am not really sure myself here. But we are using a
remote mm there and I do not see anything that would prevent from racing
with exit/coredump. Maybe I am wrong. Let's wait for Andrea for his
review feedback. This patch is quite tricky for the stable backport.

Thanks!

-- 
Michal Hocko
SUSE Labs
