Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61FD6168E5
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 19:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfEGRP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 13:15:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43946 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726225AbfEGRP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 13:15:27 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x47HEpDR077296
        for <stable@vger.kernel.org>; Tue, 7 May 2019 13:15:25 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sbb7urymw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 07 May 2019 13:15:18 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <gerald.schaefer@de.ibm.com>;
        Tue, 7 May 2019 18:13:07 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 7 May 2019 18:13:02 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x47HD1lY39846070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 May 2019 17:13:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1037A405B;
        Tue,  7 May 2019 17:13:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28C49A4060;
        Tue,  7 May 2019 17:13:01 +0000 (GMT)
Received: from thinkpad (unknown [9.152.212.151])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 May 2019 17:13:01 +0000 (GMT)
Date:   Tue, 7 May 2019 19:13:00 +0200
From:   Gerald Schaefer <gerald.schaefer@de.ibm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Pasha Tatashin <Pavel.Tatashin@microsoft.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH AUTOSEL 4.14 62/95] mm, memory_hotplug: initialize
 struct pages for the full memory section
In-Reply-To: <20190507170208.GF1747@sasha-vm>
References: <20190507053826.31622-1-sashal@kernel.org>
        <20190507053826.31622-62-sashal@kernel.org>
        <CAKgT0Uc8ywg8zrqyM9G+Ws==+yOfxbk6FOMHstO8qsizt8mqXA@mail.gmail.com>
        <CAHk-=win03Q09XEpYmk51VTdoQJTitrr8ON9vgajrLxV8QHk2A@mail.gmail.com>
        <20190507170208.GF1747@sasha-vm>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050717-0008-0000-0000-000002E43CCF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050717-0009-0000-0000-00002250BAE6
Message-Id: <20190507191300.6e653799@thinkpad>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-07_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1031 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=911 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905070111
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 May 2019 13:02:08 -0400
Sasha Levin <sashal@kernel.org> wrote:

> On Tue, May 07, 2019 at 09:50:50AM -0700, Linus Torvalds wrote:
> >On Tue, May 7, 2019 at 9:31 AM Alexander Duyck
> ><alexander.duyck@gmail.com> wrote:
> >>
> >> Wasn't this patch reverted in Linus's tree for causing a regression on
> >> some platforms? If so I'm not sure we should pull this in as a
> >> candidate for stable should we, or am I missing something?
> >
> >Good catch. It was reverted in commit 4aa9fc2a435a ("Revert "mm,
> >memory_hotplug: initialize struct pages for the full memory
> >section"").
> >
> >We ended up with efad4e475c31 ("mm, memory_hotplug:
> >is_mem_section_removable do not pass the end of a zone") instead (and
> >possibly others - this was just from looking for commit messages that
> >mentioned that reverted commit).
> 
> I got it wrong then. I'll fix it up and get efad4e475c31 in instead.

There were two commits replacing the reverted commit, fixing
is_mem_section_removable() and test_pages_in_a_zone() respectively:

commit 24feb47c5fa5 ("mm, memory_hotplug: test_pages_in_a_zone do not
pass the end of zone")
commit efad4e475c31 ("mm, memory_hotplug: is_mem_section_removable do
not pass the end of a zone")

