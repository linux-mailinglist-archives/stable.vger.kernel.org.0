Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D848B192D29
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 16:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbgCYPpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 11:45:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727386AbgCYPpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 11:45:23 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PFXJtj056759;
        Wed, 25 Mar 2020 11:45:21 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywejxr2q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 11:45:19 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02PFavTl026619;
        Wed, 25 Mar 2020 15:45:16 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 2ywaw2axyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 15:45:16 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02PFjDuG38404424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 15:45:13 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AFE178066;
        Wed, 25 Mar 2020 15:45:13 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7DBF78064;
        Wed, 25 Mar 2020 15:45:12 +0000 (GMT)
Received: from t440p.yottatech.com (unknown [9.80.224.172])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Wed, 25 Mar 2020 15:45:12 +0000 (GMT)
Received: (from gcwilson@localhost)
        by t440p.yottatech.com (8.15.2/8.15.2/Submit) id 02PFj7fs016534;
        Wed, 25 Mar 2020 10:45:07 -0500
X-Authentication-Warning: t440p.yottatech.com: gcwilson set sender to gcwilson@linux.ibm.com using -f
Date:   Wed, 25 Mar 2020 10:45:07 -0500
From:   George Wilson <gcwilson@linux.ibm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>, stable@vger.kernel.org
Subject: Re: [PATCH v4] tpm: ibmvtpm: retry on H_CLOSED in tpm_ibmvtpm_send()
Message-ID: <20200325154506.GA16060@us.ibm.com>
References: <20200320032758.228088-1-gcwilson@linux.ibm.com>
 <20200320175945.6B8F920663@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320175945.6B8F920663@mail.kernel.org>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_08:2020-03-24,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 suspectscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250124
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 20, 2020 at 05:59:44PM +0000, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: 132f76294744 ("drivers/char/tpm: Add new device driver to support IBM vTPM").
> 
> The bot has tested the following trees: v5.5.10, v5.4.26, v4.19.111, v4.14.173, v4.9.216, v4.4.216.
> 
> v5.5.10: Build OK!
> v5.4.26: Build OK!
> v4.19.111: Build OK!
> v4.14.173: Build OK!
> v4.9.216: Failed to apply! Possible dependencies:
>     02ae1382882f ("tpm: redefine read_log() to handle ACPI/OF at runtime")
>     2528a64664f8 ("tpm: define a generic open() method for ascii & bios measurements")
>     402149c6470d ("tpm: vtpm_proxy: Suppress error logging when in closed state")
>     4d23cc323cdb ("tpm: add securityfs support for TPM 2.0 firmware event log")
>     745b361e989a ("tpm: infrastructure for TPM spaces")
>     748935eeb72c ("tpm: have event log use the tpm_chip")
>     7518a21a9da3 ("tpm: drop tpm1_chip_register(/unregister)")
>     b1a9b7b602c5 ("tpm: replace symbolic permission with octal for securityfs files")
>     cd9b7631a888 ("tpm: replace dynamically allocated bios_dir with a static array")
>     f5595f5baa30 ("tpm: Unify the send callback behaviour")
> 
> v4.4.216: Failed to apply! Possible dependencies:
>     02ae1382882f ("tpm: redefine read_log() to handle ACPI/OF at runtime")
>     036bb38ffb3e ("tpm_tis: Ensure interrupts are disabled when the driver starts")
>     23d06ff700f5 ("tpm: drop tpm_atmel specific fields from tpm_vendor_specific")
>     25112048cd59 ("tpm: rework tpm_get_timeouts()")
>     402149c6470d ("tpm: vtpm_proxy: Suppress error logging when in closed state")
>     41a5e1cf1fe1 ("tpm/tpm_tis: Split tpm_tis driver into a core and TCG TIS compliant phy")
>     4d627e672bd0 ("tpm_tis: Do not fall back to a hardcoded address for TPM2")
>     4eea703caaac ("tpm: drop 'iobase' from struct tpm_vendor_specific")
>     51dd43dff74b ("tpm_tis: Use devm_ioremap_resource")
>     55a889c2cb13 ("tpm_crb: Use the common ACPI definition of struct acpi_tpm2")
>     56671c893e0e ("tpm: drop 'locality' from struct tpm_vendor_specific")
>     570a36097f30 ("tpm: drop 'irq' from struct tpm_vendor_specific")
>     57dacc2b4ce5 ("tpm: tpm_tis: Share common data between phys")
>     745b361e989a ("tpm: infrastructure for TPM spaces")
>     7ab4032fa579 ("tpm_tis: Get rid of the duplicate IRQ probing code")
>     d30b8e4f68ef ("tpm: cleanup tpm_tis_remove()")
>     d4956524f1b0 ("tpm: drop manufacturer_id from struct tpm_vendor_specific")
>     e3837e74a06d ("tpm_tis: Refactor the interrupt setup")
>     ee1779840d09 ("tpm: drop 'base' from struct tpm_vendor_specific")
>     ef7b81dc7864 ("tpm_tis: Disable interrupt auto probing on a per-device basis")
>     f5595f5baa30 ("tpm: Unify the send callback behaviour")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Hi Sasha,

I've backported the patch to both 4.9.y and 4.4.y.

> 
> -- 
> Thanks
> Sasha

-- 
George Wilson
IBM Linux Technology Center
Security Development
