Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4844D25A57C
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 08:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgIBGXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 02:23:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27670 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbgIBGXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 02:23:32 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082621uU021263;
        Wed, 2 Sep 2020 02:23:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=Qoo4IPgfjGzssjVtjDecsDGFzDuZljj645sp3n19IaQ=;
 b=FKLWkUaYmaDDGRCPmW6AiVXlRQwEum0XLB/Qbih2sfc8MsvgT3yFXHrktrnUK8ooiLT5
 q16zgY1PRo69SH8H8dZXSDFM2YsmW6S/3UqnVI+qMShDOYQBtDVtNeI44c/0j3VnW2m4
 qQrBCuBh4wlrQUBJ5ijPEczRoqbAQwGKlIPoxabMmh3TXAh/mFU0HiogTJWW+ihlLvBx
 u2scS7Nn6K2SFJs9SDgVyV4AO3DhUPJqlDDAw+thRBFb/ZL7p5BrtsBpigbXPLuDopI0
 eVQzzcyR0rjEUNL8dWV/csnc6SEbdM778vTDNpR3msaTlpBYdblFj01QsU8U8Va6loUH Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33a4kqa2n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 02:23:22 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08262Fm4021867;
        Wed, 2 Sep 2020 02:23:21 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33a4kqa2mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 02:23:21 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0826J5Gt015660;
        Wed, 2 Sep 2020 06:23:19 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 337en82naq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 06:23:19 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0826Lklu64487890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Sep 2020 06:21:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FE31AE045;
        Wed,  2 Sep 2020 06:23:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21629AE053;
        Wed,  2 Sep 2020 06:23:14 +0000 (GMT)
Received: from in.ibm.com (unknown [9.85.95.25])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  2 Sep 2020 06:23:13 +0000 (GMT)
Date:   Wed, 2 Sep 2020 11:53:11 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Pavel Tatashin <pasha.tatashin@soleen.com>
Cc:     Roman Gushchin <guro@fb.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 00/28] The new cgroup slab memory controller
Message-ID: <20200902062311.GB52094@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <20200127173453.2089565-1-guro@fb.com>
 <20200130020626.GA21973@in.ibm.com>
 <20200130024135.GA14994@xps.DHCP.thefacebook.com>
 <CA+CK2bCQcnTpzq2wGFa3D50PtKwBoWbDBm56S9y8c+j+pD+KSw@mail.gmail.com>
 <20200813000416.GA1592467@carbon.dhcp.thefacebook.com>
 <CA+CK2bDDToW=Q5RgeWkoN3_rUr3pyWGVb9MraTzM+DM3OZ+tdg@mail.gmail.com>
 <CA+CK2bBEHFuLLg79_h6bv4Vey+B0B2YXyBxTBa=Le12OKbNdwA@mail.gmail.com>
 <20200901052819.GA52094@in.ibm.com>
 <CA+CK2bDZW4F-Y7PDiVZ_Jdbw8F5GCa26JRSXyxFbdu-Q6dEpRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bDZW4F-Y7PDiVZ_Jdbw8F5GCa26JRSXyxFbdu-Q6dEpRg@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_03:2020-09-01,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 impostorscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020052
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 08:52:05AM -0400, Pavel Tatashin wrote:
> On Tue, Sep 1, 2020 at 1:28 AM Bharata B Rao <bharata@linux.ibm.com> wrote:
> >
> > On Fri, Aug 28, 2020 at 12:47:03PM -0400, Pavel Tatashin wrote:
> > > There appears to be another problem that is related to the
> > > cgroup_mutex -> mem_hotplug_lock deadlock described above.
> > >
> > > In the original deadlock that I described, the workaround is to
> > > replace crash dump from piping to Linux traditional save to files
> > > method. However, after trying this workaround, I still observed
> > > hardware watchdog resets during machine  shutdown.
> > >
> > > The new problem occurs for the following reason: upon shutdown systemd
> > > calls a service that hot-removes memory, and if hot-removing fails for
> > > some reason systemd kills that service after timeout. However, systemd
> > > is never able to kill the service, and we get hardware reset caused by
> > > watchdog or a hang during shutdown:
> > >
> > > Thread #1: memory hot-remove systemd service
> > > Loops indefinitely, because if there is something still to be migrated
> > > this loop never terminates. However, this loop can be terminated via
> > > signal from systemd after timeout.
> > > __offline_pages()
> > >       do {
> > >           pfn = scan_movable_pages(pfn, end_pfn);
> > >                   # Returns 0, meaning there is nothing available to
> > >                   # migrate, no page is PageLRU(page)
> > >           ...
> > >           ret = walk_system_ram_range(start_pfn, end_pfn - start_pfn,
> > >                                             NULL, check_pages_isolated_cb);
> > >                   # Returns -EBUSY, meaning there is at least one PFN that
> > >                   # still has to be migrated.
> > >       } while (ret);
> > >
> > > Thread #2: ccs killer kthread
> > >    css_killed_work_fn
> > >      cgroup_mutex  <- Grab this Mutex
> > >      mem_cgroup_css_offline
> > >        memcg_offline_kmem.part
> > >           memcg_deactivate_kmem_caches
> > >             get_online_mems
> > >               mem_hotplug_lock <- waits for Thread#1 to get read access
> > >
> > > Thread #3: systemd
> > > ksys_read
> > >  vfs_read
> > >    __vfs_read
> > >      seq_read
> > >        proc_single_show
> > >          proc_cgroup_show
> > >            mutex_lock -> wait for cgroup_mutex that is owned by Thread #2
> > >
> > > Thus, thread #3 systemd stuck, and unable to deliver timeout interrupt
> > > to thread #1.
> > >
> > > The proper fix for both of the problems is to avoid cgroup_mutex ->
> > > mem_hotplug_lock ordering that was recently fixed in the mainline but
> > > still present in all stable branches. Unfortunately, I do not see a
> > > simple fix in how to remove mem_hotplug_lock from
> > > memcg_deactivate_kmem_caches without using Roman's series that is too
> > > big for stable.
> >
> > We too are seeing this on Power systems when stress-testing memory
> > hotplug, but with the following call trace (from hung task timer)
> > instead of Thread #2 above:
> >
> > __switch_to
> > __schedule
> > schedule
> > percpu_rwsem_wait
> > __percpu_down_read
> > get_online_mems
> > memcg_create_kmem_cache
> > memcg_kmem_cache_create_func
> > process_one_work
> > worker_thread
> > kthread
> > ret_from_kernel_thread
> >
> > While I understand that Roman's new slab controller patchset will fix
> > this, I also wonder if infinitely looping in the memory unplug path
> > with mem_hotplug_lock held is the right thing to do? Earlier we had
> > a few other exit possibilities in this path (like max retries etc)
> > but those were removed by commits:
> >
> > 72b39cfc4d75: mm, memory_hotplug: do not fail offlining too early
> > ecde0f3e7f9e: mm, memory_hotplug: remove timeout from __offline_memory
> >
> > Or, is the user-space test is expected to induce a signal back-off when
> > unplug doesn't complete within a reasonable amount of time?
> 
> Hi Bharata,
> 
> Thank you for your input, it looks like you are experiencing the same
> problems that I observed.
> 
> What I found is that the reason why our machines did not complete
> hot-remove within the given time is because of this bug:
> https://lore.kernel.org/linux-mm/20200901124615.137200-1-pasha.tatashin@soleen.com
> 
> Could you please try it and see if that helps for your case?

I am on an old codebase that already has the fix that you are proposing,
so I might be seeing someother issue which I will debug further.

So looks like the loop in __offline_pages() had a call to
drain_all_pages() before it was removed by

c52e75935f8d: mm: remove extra drain pages on pcp list

Regards,
Bharata.
