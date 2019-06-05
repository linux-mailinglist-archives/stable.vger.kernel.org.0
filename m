Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5EB35C4F
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 14:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfFEMIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 08:08:53 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:58082 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFEMIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 08:08:53 -0400
Received: from [167.98.27.226] (helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hYUim-0006zs-UP; Wed, 05 Jun 2019 13:08:49 +0100
Message-ID: <1559736528.24330.87.camel@codethink.co.uk>
Subject: Re: Patch "coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping" has been added to the
 4.4-stable tree
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Michal Hocko <mhocko@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, aarcange@redhat.com,
        akpm@linux-foundation.org, jannh@google.com, jgg@mellanox.com,
        oleg@redhat.com, peterx@redhat.com, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, stable-commits@vger.kernel.org
Date:   Wed, 05 Jun 2019 13:08:48 +0100
In-Reply-To: <20190605065024.GA15685@dhcp22.suse.cz>
References: <155965961313615@kroah.com>
         <20190604145216.GJ4669@dhcp22.suse.cz> <20190604150756.GA24221@kroah.com>
         <1559663498.24330.85.camel@codethink.co.uk>
         <20190605065024.GA15685@dhcp22.suse.cz>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-06-05 at 08:50 +0200, Michal Hocko wrote:
> On Tue 04-06-19 16:51:38, Ben Hutchings wrote:
> [...]
> > - I don't understand why collapse_huge_range() needs to be fixed, but
> > then I really don't understand the khugepaged code at all!  So I would
> > trust Michal on this.
> 
> To be honest, I am not really sure myself here. But we are using a
> remote mm there and I do not see anything that would prevent from racing
> with exit/coredump. Maybe I am wrong. Let's wait for Andrea for his
> review feedback. This patch is quite tricky for the stable backport.

So, Greg, it seems like you should drop this from the current stable
round.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom
