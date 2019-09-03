Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52FD5A5E67
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 02:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfICASf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 20:18:35 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:6424 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727868AbfICASe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 20:18:34 -0400
Received: from pps.filterd (m0148663.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8307BKl007200;
        Tue, 3 Sep 2019 00:18:17 GMT
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com [15.241.140.78])
        by mx0a-002e3701.pphosted.com with ESMTP id 2ur2gebynq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 00:18:17 +0000
Received: from stormcage.eag.rdlabs.hpecorp.net (unknown [128.162.236.70])
        by g4t3425.houston.hpe.com (Postfix) with ESMTP id 312178D;
        Tue,  3 Sep 2019 00:18:16 +0000 (UTC)
Received: by stormcage.eag.rdlabs.hpecorp.net (Postfix, from userid 5508)
        id BA2B5201E92B3; Mon,  2 Sep 2019 19:18:15 -0500 (CDT)
Message-Id: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: quilt/0.46-1
Date:   Mon, 02 Sep 2019 19:18:15 -0500
From:   Mike Travis <mike.travis@hpe.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
Cc:     Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 0/8] x86/platform/UV: Update UV Hubless System Support
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-02_10:2019-08-29,2019-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 mlxlogscore=519 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909030000
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
