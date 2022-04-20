Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436515084BB
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 11:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377149AbiDTJVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 05:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377146AbiDTJVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 05:21:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961693D49A
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 02:18:21 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23K8woK3005514;
        Wed, 20 Apr 2022 09:18:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=9Cw92uIvZU8lmojJufRgLk3DwrcHxhmRJObqdCI/umM=;
 b=B+cgsYMz2udYDG67djD6hgquq+KUBsFNExg8aeqrTMRJGjSKym+tTHRtcWf7G8/aJoyo
 thtp86Ayd/dTCjexYMkRDEa/5+mGoywuAFDwuINBDM1a60OKukLuarA3vyFiMYqGt6Nq
 9WwVgGwc2Q0Clv5jMiN3FXZDqPmwuEG/QbKFMESo+t1Pa620/b9fmWtOBL7/raO57DV3
 HeceZzJqANb5Ve92cnNAmIdQ/PD5oAww7ZpBVzN0ErSf6I2sxko2m02U4qLQdExLhTZu
 gUMCPBnmKI23z9KrxgtxZbjUhDKFlwz3BDDPe9ZmxTlfBX1e5A8/MW+Pr8CQFXKzKnNu BQ== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjf51rbqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 09:18:11 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23K97Jsg026472;
        Wed, 20 Apr 2022 09:18:09 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3fgu6u36fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 09:18:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23K9I6qr38469964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 09:18:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0AFC4C040;
        Wed, 20 Apr 2022 09:18:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 168E24C044;
        Wed, 20 Apr 2022 09:18:06 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.160.176])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 20 Apr 2022 09:18:05 +0000 (GMT)
Date:   Wed, 20 Apr 2022 12:18:04 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Tony Lindgren <tony@atomide.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernelci-results@groups.io, bot@kernelci.org,
        gtucker@collabora.com, stable@vger.kernel.org
Subject: Re: stable-rc/linux-5.4.y bisection: baseline.login on
 qemu_arm-virt-gicv2-uefi
Message-ID: <Yl/PzFKR6U0bH43T@linux.ibm.com>
References: <625c8753.1c69fb81.b232.69bb@mx.google.com>
 <Yl65zxGgFzF1Okac@sirena.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl65zxGgFzF1Okac@sirena.org.uk>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SuATDokkRjbI9QDcPl9XA26TqtUpl3jG
X-Proofpoint-ORIG-GUID: SuATDokkRjbI9QDcPl9XA26TqtUpl3jG
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 phishscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 19, 2022 at 02:31:59PM +0100, Mark Brown wrote:
> On Sun, Apr 17, 2022 at 02:32:03PM -0700, KernelCI bot wrote:
> 
> The KernelCI bisection bot found that commit 6026d4032dbbe3 ("arm:
> extend pfn_valid to take into account freed memory map alignment")
> triggered a regression in v5.4.x on 32 bit ARM with a qemu platform
> booting UEFI firmware.  We try to dereference an invalid pointer parsing
> the DMI tables:
> 
> <1>[    0.084476] 8<--- cut here ---
> <1>[    0.084595] Unable to handle kernel paging request at virtual address dfb76000
> <1>[    0.084938] pgd = (ptrval)
> <1>[    0.085038] [dfb76000] *pgd=5f7fe801, *pte=00000000, *ppte=00000000
> 
> ...
> 
> <4>[    0.093923] [<c0ed6ce8>] (memcpy) from [<c16a06f8>] (dmi_setup+0x60/0x418)
> <4>[    0.094204] [<c16a06f8>] (dmi_setup) from [<c16a38d4>] (arm_dmi_init+0x8/0x10)
> <4>[    0.094408] [<c16a38d4>] (arm_dmi_init) from [<c0302e9c>] (do_one_initcall+0x50/0x228)
> <4>[    0.094619] [<c0302e9c>] (do_one_initcall) from [<c16011e4>] (kernel_init_freeable+0x15c/0x1f8)
> <4>[    0.094841] [<c16011e4>] (kernel_init_freeable) from [<c0f028cc>] (kernel_init+0x8/0x10c)
> <4>[    0.095057] [<c0f028cc>] (kernel_init) from [<c03010e8>] (ret_from_fork+0x14/0x2c)
> 
> This particular bisect is from GICv2 but GICv3 shows the same issue, and
> it persists in the latest stable -rc:
> 
>     https://linux.kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kernel/v5.4.189-64-gab55553793398/plan/baseline/

I don't know how exactly kernel-ci runs qemu with UEFI, I've tried this:

$QEMU -serial stdio -M virt-2.11,gic-version=2 -cpu cortex-a15 -m 1G \
-drive file=$QEMU_EFI,if=pflash,format=raw,unit=0,readonly=on \
-drive file=flash1.img,if=pflash,format=raw,unit=1,readonly=off \
-kernel $kernel \
-append "console=ttyAMA0" 

with stable-rc/linux-5.4.y and I've got as far as to failure to mount
rootfs and the crash in dmu_setup() didn't reproduce for me.

My understanding is that with HEAD pointing to 6026d4032dbbe3 crash happens
because ioremap uses pfn_valid() to check if a PFN is in RAM which is fixed
by c97579584fa8 ("arm: ioremap: don't abuse pfn_valid() to check if pfn is
in RAM") that comes on top of 6026d4032dbbe3.

No clues why ab55553793398 fails, though... 

-- 
Sincerely yours,
Mike.
