Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE4C2E6D26
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 03:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgL2CCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 21:02:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64234 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726014AbgL2CCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 21:02:07 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BT20dt3084874;
        Mon, 28 Dec 2020 21:01:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=zpGZc8IXi4CYn0gMF7b15UVmW0LDja39wbTr+ZLDeHc=;
 b=C9Dj029zjXs6APnNtJlwuJxET53G2T9JpmqSP7F3/yvwB9knFlf4MYoFlFj8DiXLzee8
 NDpZywEJWTY9WzB0zWVmFzGegkH+SoXEEa6bus2pG/jDW0zc+xG9AgpIX4H/HUvaX1NK
 xB469TQcL8uKVakntQx/26tCGMjx2yWq6pc7IDq+iRSE0ZpvewYEMvqepb2Gw7kn67wa
 mXua3IL9SNogx4pKsATy6osUYL3yuZ5WAtPC4DArpSBwKqB0Gj+ho+XbAK6LwJBkkDay
 26EQroStU+FMh61Ha5TAl3rwmox/sOduy1XvUQ6k+wMytprGYePu0VJbQDRuxXQeGP9U Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35qtv4rjp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Dec 2020 21:01:21 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BT21LEG086703;
        Mon, 28 Dec 2020 21:01:21 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35qtv4rjnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Dec 2020 21:01:21 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BT1vU8G018439;
        Tue, 29 Dec 2020 02:01:19 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 35nveh2hev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Dec 2020 02:01:19 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BT21H7h49348898
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Dec 2020 02:01:17 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A7E5A4053;
        Tue, 29 Dec 2020 02:01:17 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD5CAA4055;
        Tue, 29 Dec 2020 02:01:14 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.72.172])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Dec 2020 02:01:14 +0000 (GMT)
Message-ID: <50b9d5059e8e2b86c25770d76432a555fbaf29c0.camel@linux.ibm.com>
Subject: Re: [PATCH AUTOSEL 5.7 03/30] ima: extend boot_aggregate with
 kernel measurements
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Ken Goldman <kgold@linux.ibm.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Maurizio Drocco <maurizio.drocco@ibm.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date:   Mon, 28 Dec 2020 21:01:13 -0500
In-Reply-To: <fccbb614-3a73-651d-b2f4-fb98ff4022f5@linux.ibm.com>
References: <20200708154116.3199728-1-sashal@kernel.org>
         <20200708154116.3199728-3-sashal@kernel.org>
         <1594224793.23056.251.camel@linux.ibm.com>
         <20200709012735.GX2722994@sasha-vm>
         <5b8dcdaf66fbe2a39631833b03772a11613fbbbf.camel@linux.ibm.com>
         <20201211031008.GN489768@sequoia>
         <659c09673affe9637a5d1391c12af3aa710ba78a.camel@linux.ibm.com>
         <76710d8ec58c440ed7a7b446696b8659f694d0db.camel@HansenPartnership.com>
         <05266e520f62276b07e76aab177ea6db47916a7f.camel@linux.ibm.com>
         <fccbb614-3a73-651d-b2f4-fb98ff4022f5@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-28_20:2020-12-28,2020-12-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1031 bulkscore=0 impostorscore=0 mlxscore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012290006
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-12-28 at 14:28 -0500, Ken Goldman wrote:
> On 12/12/2020 9:22 PM, Mimi Zohar wrote:
> > Ok.   Going forward, it sounds like we need to define a new
> > "boot_aggregate" record.  One that contains a version number and PCR
> > mask.
> 
> Just BTW, there is a TCG standard for a TPM 2.0 PCR mask that works
> well.

Sounds good.
> 
> There is also a standard for an event log version number.  It is
> the first event of a TPM 2.0 event log.  It is strange.

Ok
> 
> One useful field, though, is a mapping between the algorithm ID (e.g.,
> sha256 is 0x000b) and the digest size (e.g., 32 bytes).  This permits
> a parser to parse a log even when it encounters an unknown digest
> algorithm.

The template data is prefixed with the template data length.  The
problem is verifying the boot_aggregate, not parsing the log.

thanks,

Mimi

