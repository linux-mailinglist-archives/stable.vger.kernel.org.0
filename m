Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B39248E32
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 20:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgHRSyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 14:54:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11990 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726435AbgHRSyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 14:54:10 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IIX0Td054001;
        Tue, 18 Aug 2020 14:54:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=49QeD8yGPzXltznocAWQRycQ4IpE+YuZU5cSA8vxaj4=;
 b=g1eSUdjuELUx5NDNymQp/VSUJnMITY5YCJQazEY0sJ1DwVnB/najycde2eucPD/CUsBM
 uwZCUY/XyNz9+nzJtKfFFq7cCUZn4q7ooL858fLauXcbN04UFYT5olj69dp9q102gaLw
 e25gP1SK2S9DL9H8nqz1KqW0Lp79/LR06tOHo8VQxwQwJp4C0LvmSQbhlqrahKneKVGo
 z8GD93cgI6gBaTWSm2MhH7RY4bRrh2dAtEuLdpFy6l0LT9mg/1hBGeJMFf3M51nXAWMy
 HMPdthVdfP/YYklySSIr3SStPcVN3L2W3FIQQXlLj/Wgjt3Eyc0pHq123XwwfWCjrQUb cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304swm1xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 14:54:07 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07IIX7qm054499;
        Tue, 18 Aug 2020 14:54:07 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304swm1xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 14:54:07 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07IIoFE9031844;
        Tue, 18 Aug 2020 18:54:06 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 3304scp32n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 18:54:06 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07IIs6aR14156606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 18:54:06 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B2ADAC05F;
        Tue, 18 Aug 2020 18:54:06 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80841AC05B;
        Tue, 18 Aug 2020 18:54:05 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 18 Aug 2020 18:54:05 +0000 (GMT)
Subject: Re: FAILED: patch "[PATCH] tpm: Unify the mismatching TPM space
 buffer sizes" failed to apply to 4.14-stable tree
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        gregkh@linuxfoundation.org
Cc:     jsnitsel@redhat.com, stable@vger.kernel.org
References: <1597659249143217@kroah.com>
 <20200818153602.GA137059@linux.intel.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
Message-ID: <2f57d860-95b8-f4cb-8f3a-2e5078dbc566@linux.ibm.com>
Date:   Tue, 18 Aug 2020 14:54:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200818153602.GA137059@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_12:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 adultscore=0
 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 phishscore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180125
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/18/20 11:36 AM, Jarkko Sakkinen wrote:
> Stefan, are you concerned of not having this in 4.14 and 4.19?

Yes. The problematic scenario is when libtpms  is updated to a version 
(future v0.8.0) that supports 3072 bit RSA keys and software inside a VM 
is using /dev/tpmrm0 and things start failing because of this. My hope 
would be that the distro run inside the VM has a way forward and the 
long term stable kernels seem to help here. Because of this scenario I 
have to delay the release of libtpms v0.8.0 for several months.

    Stefan


