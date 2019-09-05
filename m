Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69CE3AA3BC
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 15:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732440AbfIEND0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 09:03:26 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:17700 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726097AbfIEND0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 09:03:26 -0400
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x85D2S1I005776;
        Thu, 5 Sep 2019 13:02:54 GMT
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com [15.241.140.73])
        by mx0a-002e3701.pphosted.com with ESMTP id 2utevt0pkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Sep 2019 13:02:54 +0000
Received: from stormcage.eag.rdlabs.hpecorp.net (unknown [128.162.236.70])
        by g4t3427.houston.hpe.com (Postfix) with ESMTP id 26A796A;
        Thu,  5 Sep 2019 13:02:52 +0000 (UTC)
Received: by stormcage.eag.rdlabs.hpecorp.net (Postfix, from userid 5508)
        id B7067201EA1B7; Thu,  5 Sep 2019 08:02:52 -0500 (CDT)
Message-Id: <20190905130252.590161292@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: quilt/0.46-1
Date:   Thu, 05 Sep 2019 08:02:52 -0500
From:   Mike Travis <mike.travis@hpe.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 0/8] x86/platform/UV: Update UV Hubless System Support
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_04:2019-09-04,2019-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=515 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909050128
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


These patches support upcoming UV systems that do not have a UV HUB.

	* Save OEM_ID from ACPI MADT probe
	* Return UV Hubless System Type
	* Add return code to UV BIOS Init function
	* Setup UV functions for Hubless UV Systems
	* Add UV Hubbed/Hubless Proc FS Files
	* Decode UVsystab Info
	* Account for UV Hubless in is_uvX_hub Ops

-- 
