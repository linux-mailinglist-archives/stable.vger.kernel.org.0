Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87D759300B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 15:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbiHONgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 09:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbiHONgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 09:36:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4326013E16;
        Mon, 15 Aug 2022 06:36:01 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27FDIcOu032536;
        Mon, 15 Aug 2022 13:35:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=eaRViY6pucTtow3bgZIPD2Vkh83IVZr4lnZB/1dV7zs=;
 b=AVhYp0YlYP85MwZ2J9bSZT/ru6Q5BDOe8dLNGrNf2zMar9UMvHBPJmP0xHTKgiEa19HW
 iAg5M3QlKG48q61FCbGo/BqfoougQYbCwLM1M0mgYI/kV9xR3L81TGdpYc427zhiMP/M
 ZiqES4DRbxYoTxtt7LknqsoFcuuvuTay7R7LyrGLoR+sf5ZoKxxnwPSbfWCRfWEZfY61
 6/h85R72ka6iHpmyBIa4EUHJTnnWlFUtIj0S8sIZM8u7Gb8dGr7LtoCuEETIjW7/Gjtq
 FWc4wZCeV1PVww/LpmUu484y9kU3m9GOBHobvfu2hy7IxuZx9Tij9UEiQfAt+J7DPJE6 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hypwtrbyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Aug 2022 13:35:57 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27FDIs9s000774;
        Mon, 15 Aug 2022 13:35:56 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hypwtrbxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Aug 2022 13:35:56 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27FDKxIv030037;
        Mon, 15 Aug 2022 13:35:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3hx3k9a1x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Aug 2022 13:35:53 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27FDZpnw31588852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Aug 2022 13:35:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F33811C052;
        Mon, 15 Aug 2022 13:35:51 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45B6511C04C;
        Mon, 15 Aug 2022 13:35:51 +0000 (GMT)
Received: from thinkpad (unknown [9.171.38.199])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 15 Aug 2022 13:35:51 +0000 (GMT)
Date:   Mon, 15 Aug 2022 15:35:49 +0200
From:   Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/hugetlb: support write-faults in shared
 mappings
Message-ID: <20220815153549.0288a9c6@thinkpad>
In-Reply-To: <YvVRfSYsPOraTo6o@monkey>
References: <20220811103435.188481-1-david@redhat.com>
        <20220811103435.188481-3-david@redhat.com>
        <YvVRfSYsPOraTo6o@monkey>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MJ3X9Xzr4PUIE9CAayI4halGlGSPtmrU
X-Proofpoint-ORIG-GUID: 4HAYzzsF6Hbu_TodGuw7lQnxBf51R8Hp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1011
 priorityscore=1501 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208150053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 11 Aug 2022 11:59:09 -0700
Mike Kravetz <mike.kravetz@oracle.com> wrote:

> On 08/11/22 12:34, David Hildenbrand wrote:
> > If we ever get a write-fault on a write-protected page in a shared mapping,
> > we'd be in trouble (again). Instead, we can simply map the page writable.
> > 
> <snip>
> > 
> > Reason is that uffd-wp doesn't clear the uffd-wp PTE bit when
> > unregistering and consequently keeps the PTE writeprotected. Reason for
> > this is to avoid the additional overhead when unregistering. Note
> > that this is the case also for !hugetlb and that we will end up with
> > writable PTEs that still have the uffd-wp PTE bit set once we return
> > from hugetlb_wp(). I'm not touching the uffd-wp PTE bit for now, because it
> > seems to be a generic thing -- wp_page_reuse() also doesn't clear it.
> > 
> > VM_MAYSHARE handling in hugetlb_fault() for FAULT_FLAG_WRITE
> > indicates that MAP_SHARED handling was at least envisioned, but could never
> > have worked as expected.
> > 
> > While at it, make sure that we never end up in hugetlb_wp() on write
> > faults without VM_WRITE, because we don't support maybe_mkwrite()
> > semantics as commonly used in the !hugetlb case -- for example, in
> > wp_page_reuse().
> 
> Nit,
> to me 'make sure that we never end up in hugetlb_wp()' implies that
> we would check for condition in callers as opposed to first thing in
> hugetlb_wp().  However, I am OK with description as it.

Is that new WARN_ON_ONCE() in hugetlb_wp() meant to indicate a real bug?
It is triggered by libhugetlbfs testcase "HUGETLB_ELFMAP=R linkhuge_rw"
(at least on s390), and crashes our CI, because it runs with panic_on_warn
enabled.

Not sure if this means that we have bug elsewhere, allowing us to
get to the WARN in hugetlb_wp().
