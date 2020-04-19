Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAE31AFC07
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgDSQc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 12:32:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55250 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726643AbgDSQc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Apr 2020 12:32:28 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03JG3Cl9088946
        for <stable@vger.kernel.org>; Sun, 19 Apr 2020 12:32:28 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ggxn1967-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Sun, 19 Apr 2020 12:32:27 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <ajd@linux.ibm.com>;
        Sun, 19 Apr 2020 17:32:20 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 19 Apr 2020 17:32:18 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03JGWMmI65208530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Apr 2020 16:32:22 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CE2F4C04A;
        Sun, 19 Apr 2020 16:32:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 396554C040;
        Sun, 19 Apr 2020 16:32:22 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 19 Apr 2020 16:32:22 +0000 (GMT)
Received: from [9.206.160.27] (unknown [9.206.160.27])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 4F428A01A8;
        Mon, 20 Apr 2020 02:32:16 +1000 (AEST)
Subject: Re: [PATCH AUTOSEL 5.5 73/75] ocxl: Add PCI hotplug dependency to
 Kconfig
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Frederic Barrat <fbarrat@linux.ibm.com>,
        "Alastair D'Silva" <alastair@d-silva.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
References: <20200418140910.8280-1-sashal@kernel.org>
 <20200418140910.8280-73-sashal@kernel.org>
From:   Andrew Donnellan <ajd@linux.ibm.com>
Date:   Mon, 20 Apr 2020 02:32:19 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200418140910.8280-73-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20041916-0028-0000-0000-000003FB1EEC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041916-0029-0000-0000-000024C0DC41
Message-Id: <c2bceeb6-07bb-1cc4-0d67-48b9fe0f6ba9@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-19_04:2020-04-17,2020-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1031 impostorscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=947 bulkscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004190143
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/4/20 12:09 am, Sasha Levin wrote:
> From: Frederic Barrat <fbarrat@linux.ibm.com>
> 
> [ Upstream commit 49ce94b8677c7d7a15c4d7cbbb9ff1cd8387827b ]
> 
> The PCI hotplug framework is used to update the devices when a new
> image is written to the FPGA.
> 
> Reviewed-by: Alastair D'Silva <alastair@d-silva.org>
> Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
> Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20191121134918.7155-12-fbarrat@linux.ibm.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This shouldn't be backported to any of the stable trees.

-- 
Andrew Donnellan              OzLabs, ADL Canberra
ajd@linux.ibm.com             IBM Australia Limited

