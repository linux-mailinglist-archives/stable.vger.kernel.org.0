Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15F263DE99
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiK3Siw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiK3Sir (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:38:47 -0500
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD2D9702B
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:38:44 -0800 (PST)
Received: from in02.mta.xmission.com ([166.70.13.52]:55652)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <dominic@xmission.com>)
        id 1p0Ryl-002tgK-QV; Wed, 30 Nov 2022 11:38:43 -0700
Received: from 75-169-132-183.slkc.qwest.net ([75.169.132.183]:58736 helo=mail.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <dominic@xmission.com>)
        id 1p0Ryk-00BPYx-DH; Wed, 30 Nov 2022 11:38:43 -0700
Date:   Wed, 30 Nov 2022 18:38:18 +0000
Message-ID: <4e195b030b250e2e338bee0bb1873e38.dominic@xmission.com>
From:   Dominic Jones <jonesd@xmission.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain
X-XM-SPF: eid=1p0Ryk-00BPYx-DH;;;mid=<4e195b030b250e2e338bee0bb1873e38.dominic@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=75.169.132.183;;;frm=dominic@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX1953+92SV+K8Rk+AOT3unu/
X-SA-Exim-Connect-IP: 75.169.132.183
X-SA-Exim-Mail-From: dominic@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Greg KH <gregkh@linuxfoundation.org>, Thorsten Leemhuis
        <regressions@leemhuis.info>
X-Spam-Relay-Country: 
X-Spam-Timing: total 876 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 12 (1.4%), b_tie_ro: 10 (1.2%), parse: 0.89
        (0.1%), extract_message_metadata: 38 (4.3%), get_uri_detail_list: 4.1
        (0.5%), tests_pri_-1000: 66 (7.6%), tests_pri_-950: 1.32 (0.2%),
        tests_pri_-900: 0.97 (0.1%), tests_pri_-200: 0.80 (0.1%),
        tests_pri_-100: 14 (1.7%), tests_pri_-90: 150 (17.1%), check_bayes:
        122 (13.9%), b_tokenize: 10 (1.2%), b_tok_get_all: 12 (1.4%),
        b_comp_prob: 3.9 (0.4%), b_tok_touch_all: 91 (10.4%), b_finish: 1.19
        (0.1%), tests_pri_0: 364 (41.5%), check_dkim_signature: 0.63 (0.1%),
        check_dkim_adsp: 6 (0.6%), poll_dns_idle: 197 (22.5%), tests_pri_10:
        4.3 (0.5%), tests_pri_500: 221 (25.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [REGRESSION] v6.0.x fails to boot after updating from v5.19.x
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> 
> On Thu, Nov 24, 2022 at 01:08:57AM +0000, Dominic Jones wrote:
> > > On Fri, Oct 28, 2022 at 02:51:43PM +0000, Dominic Jones wrote:
> > > > Updating the machine's kernel from v5.19.x to v6.0.x causes the machine to not
> > > > successfully boot. The machine boots successfully (and exhibits stable operation)
> > > > with version v5.19.17 and multiple earlier releases in the 5.19 line. Multiple releases
> > > > from the 6.0 line (including 6.0.0, 6.0.3, and 6.0.5), with no other changes to the
> > > > software environment, do not boot. Instead, the machine hangs after loading services
> > > > but before presenting a display manager; the machine instead shows repetitive hard
> > > > drive activity at this point and then no apparent activity.
> > > > 
> > > > ''uname'' output for the machine successfully running v5.19.17 is:
> > > > 
> > > >     Linux [MACHINE_NAME] 5.19.17 #1 SMP PREEMPT_DYNAMIC Mon Oct 24 13:32:29 2022 i686 Intel(R) Atom(TM) CPU N270 @ 1.60GHz GenuineIntel GNU/Linux
> > > > 
> > > > The machine is an OCZ Neutrino netbook, running a custom OS build largely similar to
> > > > LFS development. The kernel update uses ''make olddefconfig''.
> > > 
> > > Can you use 'git bisect' to find the offending change that causes this
> > > to happen?
> > 
> > Bisection is complete. Here's what it returned.
> > 
> > ---
> > 
> > 3a194f3f8ad01bce00bd7174aaba1563bcc827eb is the first bad commit
> > commit 3a194f3f8ad01bce00bd7174aaba1563bcc827eb
> > Author: Naoya Horiguchi <naoya.horiguchi@nec.com>
> > Date:   Thu Jul 14 13:24:14 2022 +0900
> > 
> >     mm/hugetlb: make pud_huge() and follow_huge_pud() aware of non-present pud entry
> >     
> >     follow_pud_mask() does not support non-present pud entry now.  As long as
> >     I tested on x86_64 server, follow_pud_mask() still simply returns
> >     no_page_table() for non-present_pud_entry() due to pud_bad(), so no severe
> >     user-visible effect should happen.  But generally we should call
> >     follow_huge_pud() for non-present pud entry for 1GB hugetlb page.
> >     
> >     Update pud_huge() and follow_huge_pud() to handle non-present pud entries.
> >     The changes are similar to previous works for pud entries commit
> >     e66f17ff7177 ("mm/hugetlb: take page table lock in follow_huge_pmd()") and
> >     commit cbef8478bee5 ("mm/hugetlb: pmd_huge() returns true for non-present
> >     hugepage").
> >     
> >     Link: https://lkml.kernel.org/r/20220714042420.1847125-3-naoya.horiguchi@linux.dev
> >     Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> >     Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
> >     Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> >     Cc: David Hildenbrand <david@redhat.com>
> >     Cc: kernel test robot <lkp@intel.com>
> >     Cc: Liu Shixin <liushixin2@huawei.com>
> >     Cc: Muchun Song <songmuchun@bytedance.com>
> >     Cc: Oscar Salvador <osalvador@suse.de>
> >     Cc: Yang Shi <shy828301@gmail.com>
> >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > 
> >  arch/x86/mm/hugetlbpage.c |  8 +++++++-
> >  mm/hugetlb.c              | 32 ++++++++++++++++++++++++++++++--
> >  2 files changed, 37 insertions(+), 3 deletions(-)
> > 

I got two replies here, so I'm responding to both for visibility.

From Greg K H:
> Great!  Please work with those developers to figure out why this is
> causing a problem for your system.

From Thorsten L:
> Many thx for this. A fix for that particular commit for recently
> committed to 6.0.y:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.0.y&id=bccc10be65e365ba8a3215cb702e6f57177eea07
> 
> That thus bears the question: does your problem still happen with the
> latest 6.0.y version?

Version 6.0.9 appears to fix the issue, with no regression as of 6.0.10.
(The issue appeared in 6.0.7. I didn't test 6.0.8 since 6.0.9 had already
appeared by the time bisection was complete.)


Thanks!

Dominic Jones
jonesd@xmission.com
