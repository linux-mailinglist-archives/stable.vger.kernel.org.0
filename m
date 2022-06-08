Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76F0543FD3
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 01:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiFHXXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 19:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiFHXXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 19:23:12 -0400
Received: from outbound-ss-820.bluehost.com (outbound-ss-820.bluehost.com [69.89.24.241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5152CB4DF
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 16:23:08 -0700 (PDT)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
        by progateway2.mail.pro1.eigbox.com (Postfix) with ESMTP id 518E1100483EB
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 23:23:08 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id z511nGh2zvL44z512nXO87; Wed, 08 Jun 2022 23:23:08 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=ZebYiuZA c=1 sm=1 tr=0 ts=62a12f5c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=JPEYwPQDsx4A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=AkPWfByBYZ7bnkEz5_cA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:In-Reply-To:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=i00GwMOJb/UE630gGGgOwFnwi32p8v4PrZiencxXVb0=; b=kVV3Zc5wFfvshWkqNJycPdabl+
        MtBAmh3+6/wg2r/4hf7ZGAuXPn/rxGnLRmosENknh6bZdY8WYMnX67afXwwXl4xCSxd41uQtyRsZn
        u+utUxERfCpvZfyutfU0l785SONU2CxWQdCUguJwfzokZo4ZLVilbCFLNMNfSGKUs0+C+03euYXtu
        o8FAu8cgyNNChriNzSdA7uhH6NUQS/k3aRWW1VpbN9IGmDl5fUzH9cva9OtFZAUikWTNsms60lVo8
        gS5yzx0x0E/V5zs+TOkQNDmUdxu2uauif0F6Ys2L4FB2WpoVJm1Rbbd38lRNselq1yrCqkxty34qX
        xBmsC3QQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:54530 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1nz510-001r1Z-PB;
        Wed, 08 Jun 2022 17:23:06 -0600
Subject: Re: [PATCH 5.17 000/772] 5.17.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220607164948.980838585@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
Message-ID: <0a063e00-360e-7b63-988c-e6c028063cf9@w6rz.net>
Date:   Wed, 8 Jun 2022 16:23:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.232.9
X-Source-L: No
X-Exim-ID: 1nz510-001r1Z-PB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:54530
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/7/22 9:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.14 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
Regression on RISC-V RV64 (HiFive Unmatched).

An Oops occurs when an NFS file system is mounted.

[   98.244615] FS-Cache: Loaded
[   99.311566] NFS: Registering the id_resolver key type
[   99.311621] Key type id_resolver registered
[   99.311626] Key type id_legacy registered
[   99.469053] Unable to handle kernel access to user memory without 
uaccess routines at virtual address 0000000000000000
[   99.479039] Oops [#1]
[   99.481246] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs 
lockd grace fscache netfs nvme_fabrics sunrpc binfmt_misc nls_iso8859_1 
da9063_onkey lm90 at24 uio_pdrv_genirq uio sch_fq_codel dm_multipath 
scsi_dh_rdac scsi_dh_emc scsi_dh_alua ipmi_devintf ipmi_msghandler drm 
backlight ip_tables x_tables autofs4 btrfs blake2b_generic zstd_compress 
raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor 
async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear rtc_da9063 
da9063_regulator mscc macsec nvme macb xhci_pci nvme_core 
xhci_pci_renesas i2c_ocores phylink
[   99.532427] CPU: 2 PID: 889 Comm: mount.nfs Not tainted 5.17.13 #1
[   99.538572] Hardware name: SiFive HiFive Unmatched A00 (DT)
[   99.544133] epc : nfs_fattr_init+0x1e/0x48 [nfs]
[   99.549059]  ra : _nfs41_proc_get_locations+0xb4/0x128 [nfsv4]
[   99.555877] epc : ffffffff02332e76 ra : ffffffff023c076c sp : 
ffffffc894793960
[   99.563084]  gp : ffffffff81a2ed00 tp : ffffffd896180000 t0 : 
ffffffd887720000
[   99.570294]  t1 : ffffffff81a9c110 t2 : ffffffff81003c04 s0 : 
ffffffc894793970
[   99.577503]  s1 : ffffffd887700000 a0 : 0000000000000000 a1 : 
ffffffd883de3d80
[   99.584721]  a2 : ffffffd887700000 a3 : ffffffc704608a00 a4 : 
ffffffff0236aa28
[   99.591924]  a5 : ffffffff02410cf8 a6 : ffffffff0240fc00 a7 : 
0000000000000006
[   99.599134]  s2 : ffffffd885df6000 s3 : ffffffc8947939c8 s4 : 
ffffffc894793998
[   99.606343]  s5 : ffffffd881a9f000 s6 : ffffffc704608a00 s7 : 
ffffffff021c7db8
[   99.613552]  s8 : ffffffff0240fd50 s9 : 0000000000000cc0 s10: 
0000003fd7d2e260
[   99.620762]  s11: 0000000000016700 t3 : 0000000000000020 t4 : 
0000000000000001
[   99.627971]  t5 : ffffffdbffdde088 t6 : ffffffdbffdde0a8
[   99.633266] status: 0000000200000120 badaddr: 0000000000000000 cause: 
000000000000000f
[   99.641236] ---[ end trace 0000000000000000 ]---

Manually bisected to this commit:

NFSv4: Fix free of uninitialized nfs4_label on referral lookup.

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.17.y&id=9a4a2efee41c4aca43988c43e16d44656f3c2132

