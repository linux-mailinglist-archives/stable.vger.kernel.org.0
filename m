Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4940322DF62
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 14:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgGZM6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 08:58:10 -0400
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:37815 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726668AbgGZM6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jul 2020 08:58:09 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jul 2020 08:58:07 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1595768286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=xZto1JqnMeR/Mm/WwJHjAf/7al7ioKJ23iXTcsEhPFQ=;
        b=kw/Vh6yESiyIGXZcVrWU/9zXquFtnjZoIm23fOmy4aU8R4bDPbAc25puRmAav+Ap1J9Wz2
        h2h7NSKwBR7EutiuqzssNyMXlVmRHET+Sn2hCos4KhYpdfiyqT3vi2VI27tTIepnWc/6XS
        0FGj8M3IaVJYMc8C5TBtH6AokMtRMec=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2051.outbound.protection.outlook.com [104.47.2.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-5-mqiWmf34NEONzu41VRDHag-1;
 Sun, 26 Jul 2020 14:51:58 +0200
X-MC-Unique: mqiWmf34NEONzu41VRDHag-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3wgakcTxzg9l88rfDVo9oK8zCvsDLDM4I0s8/4ZArJ3ALyt3dT5+zJgw8aZR+iFHfCqEf02HoP23cJ/nfqh4092sRNi0B4qa/25KDutvk0BSBKhWtF+vBg1/GVRHv1nBUk27q7749HQeEGlq+B2XAPuoO1Nm5VIA8zuiGp4mnb42aWOPNh3dwjljk40kmiSC/uY/WDhQtVlGOcmKB8YHEk9G4ACy14sa4624tnyKBIBt7kf4U6d9M/djxABQ5q7IWf6M25+kDFEC8P9iWzKnNbwweRvusOd6KtlthUSk7MU+w6zE9pFmW2WB3yh9nA1K8RQAd03HPrUtjO6FrVnBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6uZ1/WXSIb7mgieLBKuUvxloBW5JLWbEm5kFYOWwdRc=;
 b=EDAGCMcvrggfVvuyzfw7tvITaF06ceuYC5T4JUAPgujsTVWeoVtMIcFKp1y6MvodywW0HCRjKfPkLIPXZQE5U2+iGgwUBcT+axNKhXbDYFvVEeGx06X3nbkJ+Awo9sF6o0bqcSNO3FJ/U6OCKgWAabD4g11Z0w1p1lFQUfdxuUxJTGGFf+WSTKDJ0BOng2x/5uxih1qa3T9n3gC3Lq97ue9XBgYq4pR8FsnXULooMUQWqXzNz09JWqC0FGrnkz4jQKFg1srfiqiT9CfyxismuDITxazZbBcsXseuB/U7UknFVTueAFcEmqslxrIBn9Zi5ybkf5tIUPvCfSs0lU04uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB6195.eurprd04.prod.outlook.com (2603:10a6:208:13c::13)
 by AM0PR04MB4162.eurprd04.prod.outlook.com (2603:10a6:208:60::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Sun, 26 Jul
 2020 12:51:57 +0000
Received: from AM0PR04MB6195.eurprd04.prod.outlook.com
 ([fe80::688e:afdb:90d9:bdef]) by AM0PR04MB6195.eurprd04.prod.outlook.com
 ([fe80::688e:afdb:90d9:bdef%3]) with mapi id 15.20.3216.030; Sun, 26 Jul 2020
 12:51:56 +0000
Subject: Re: Patch "btrfs: qgroup: fix data leak caused by race between
 writeback and truncate" has been added to the 4.14-stable tree
To:     gregkh@linuxfoundation.org
CC:     stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>
References: <15957672628285@kroah.com>
From:   Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0GFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPokBTQQTAQgAOAIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJdnDWhAAoJEMI9kfOhJf6oZgoH
 90uqoGyUh5UWtiT9zjUcvlMTCpd/QSgwagDuY+tEdVPaKlcnTNAvZKWSit8VuocjrOFbTLwb
 vZ43n5f/l/1QtwMgQei/RMY2XhW+totimzlHVuxVaIDwkF+zc+pUI6lDPnULZHS3mWhbVr9N
 vZAAYVV7GesyyFpZiNm7GLvLmtEdYbc9OnIAOZb3eKfY3mWEs0eU0MxikcZSOYy3EWY3JES7
 J9pFgBrCn4hF83tPH2sphh1GUFii+AUGBMY/dC6VgMKbCugg+u/dTZEcBXxD17m+UcbucB/k
 F2oxqZBEQrb5SogdIq7Y9dZdlf1m3GRRJTX7eWefZw10HhFhs1mwx7kBDQRZ1YGvAQgAqlPr
 YeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4KXk/kHw5h
 ieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T7RZwB69u
 VSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9fNN8e9c0
 MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD/dt76Kp/
 o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgBCAAmAhsM
 FiEELd9y5aWlW6idqkLhwj2R86El/qgFAl2cNa4FCQlqTn8ACgkQwj2R86El/qhXBAf/eXLP
 HDNTkHRPxoDnwhscIHJDHlsszke25AFltJQ1adoaYCbsQVv4Mn5rQZ1Gon54IMdxBN3r/B08
 rGVPatIfkycMCShr+rFHPKnExhQ7Wr555fq+sQ1GOwOhr1xLEqAhBMp28u9m8hnkqL36v+AF
 hjTwRtS+tRMZfoG6n72xAj984l56G9NPfs/SOKl6HR0mCDXwJGZAOdtyRmqddi53SXi5N4H1
 jWX1xFshp7nIkRm6hEpISEWr/KKLbAiKKbP0ql5tP5PinJeIBlDv4g/0+aGoGg4dELTnfEVk
 jMC8cJ/LiIaR/OEOF9S2nSeTQoBmusTz+aqkbogvvYGam6uDYw==
Message-ID: <3b1eaf71-0b54-ae4d-0fd5-26103ee8ff3d@suse.com>
Date:   Sun, 26 Jul 2020 20:51:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <15957672628285@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To AM0PR04MB6195.eurprd04.prod.outlook.com
 (2603:10a6:208:13c::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [0.0.0.0] (149.28.201.231) by BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Sun, 26 Jul 2020 12:51:54 +0000
X-Originating-IP: [149.28.201.231]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f15e843-02f3-417f-36e0-08d83162adc7
X-MS-TrafficTypeDiagnostic: AM0PR04MB4162:
X-Microsoft-Antispam-PRVS: <AM0PR04MB4162C5862485211502DC8889D6750@AM0PR04MB4162.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c9fSNQKnHl2Pz5+dxXqM9tDkMShWTXOweJym5wrjnRLcDuWvuenzy6FXN10z+kRYFhcIAToEPo+YnjAi6FpY4P9wekMTAe5MJKdQ+zqKKSb7ayFSigbqFBVeLTgswFm1VP7R0VP27F6l+oCzzd0ElvOmGNB1C7dUszxScsu8A2Un/OtGBcS/d9I9EMS5Hvu2dxLaXCeTwrhB/UA++x2SR/MKeBh3yJc0Y5tfhONrrkAiccDu2pz3rbGvRElQyg/ZnDRlXMVFi1m84P6FKf3TIkBeVoDSQTdhJypL+BabBQ7FNE7EE2pGt4+8eZU5cSFsBHCI8aSJ3vPMrDXfJrymlc/+z8jQJxpOE7Wq9jm9+jJq37XyQUbJNjuz4egvIes0imo8EIQCJzjo73uf9Dz36Lfm91BrnymjtxcLIU+5ilQ2MpnqX3oBQ7Ev+qSjaywCKfYozGk5FcNaDBc5U7sGO7pzbkjcMlewmmigETMQvuw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6195.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(136003)(366004)(39860400002)(376002)(6916009)(31686004)(8676002)(53546011)(6706004)(83380400001)(16576012)(316002)(2906002)(186003)(16526019)(4326008)(26005)(966005)(52116002)(36756003)(66556008)(2616005)(956004)(66476007)(86362001)(31696002)(6486002)(5660300002)(8936002)(66946007)(478600001)(6666004)(78286006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7edjpgLb41BQ71wUP8Z4BIlbdNowYGe0B+zXwhptjVq7riJveFbrQJOV/cNEU4oU9jJyz9iuISt2TCqRoJCYDVZC/gqVbux+zzExiCZBX4JnYqW9cHVFipqN9hNb6eXpsGi23AzETM2Ntam/jnC/F5HEymdFk6GSTd5N9WFRj4y9H+Cp6cnlcLVlFsPsC3ubdXCm77Z18VGHN3ijyNRrm1bRhxFe0XSxSI78SP7r5yog6hSVPGV3OxuK/HDsaxcaG8VC3yf/913sRB9QJT8gN59u7+xigCtwk7SdMjkW1K/KrkEauYtitS/DffdQvfJ0WOq8wYyJ+yY5kEX2IirC9/Kq4DaLSwmxeh4Nz2PePDFVb/pQoQE3xUbtkKbTE/FZExqyYcc7zwRBFj7Y2EO5TRm1pTWRZOZAJVY4fGmXwG/edvjc9thethNOPvMha2AvqIrj+SlyfAVhM80jSWX046UQa5S99/iqLqiGVMBd9j8=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f15e843-02f3-417f-36e0-08d83162adc7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6195.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2020 12:51:56.6774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AEze+cks7Y9ZePZDz5BsR6w4YmYI6d7TAFvvDM1sWnBQxEvCNN21w8/skoAhbXNd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4162
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/7/26 =E4=B8=8B=E5=8D=888:41, gregkh@linuxfoundation.org wrote:
>=20
> This is a note to let you know that I've just added the patch titled
>=20
>     btrfs: qgroup: fix data leak caused by race between writeback and tru=
ncate
>=20
> to the 4.14-stable tree which can be found at:
>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.g=
it;a=3Dsummary
>=20
> The filename of the patch is:
>      btrfs-qgroup-fix-data-leak-caused-by-race-between-writeback-and-trun=
cate.patch
> and it can be found in the queue-4.14 subdirectory.
>=20
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Please don't merge this patch for any of the stable branches.

This patch needs one unmerged patch ("btrfs: change timing for qgroup
reserved space for ordered extents to fix reserved space leak", already
in maintainer's tree) as prerequisite.

The behavior without that patch could be problematic.

I should have noticed this earlier.

Thanks,
Qu

>=20
>=20
> From fa91e4aa1716004ea8096d5185ec0451e206aea0 Mon Sep 17 00:00:00 2001
> From: Qu Wenruo <wqu@suse.com>
> Date: Fri, 17 Jul 2020 15:12:05 +0800
> Subject: btrfs: qgroup: fix data leak caused by race between writeback an=
d truncate
>=20
> From: Qu Wenruo <wqu@suse.com>
>=20
> commit fa91e4aa1716004ea8096d5185ec0451e206aea0 upstream.
>=20
> [BUG]
> When running tests like generic/013 on test device with btrfs quota
> enabled, it can normally lead to data leak, detected at unmount time:
>=20
>   BTRFS warning (device dm-3): qgroup 0/5 has unreleased space, type 0 rs=
v 4096
>   ------------[ cut here ]------------
>   WARNING: CPU: 11 PID: 16386 at fs/btrfs/disk-io.c:4142 close_ctree+0x1d=
c/0x323 [btrfs]
>   RIP: 0010:close_ctree+0x1dc/0x323 [btrfs]
>   Call Trace:
>    btrfs_put_super+0x15/0x17 [btrfs]
>    generic_shutdown_super+0x72/0x110
>    kill_anon_super+0x18/0x30
>    btrfs_kill_super+0x17/0x30 [btrfs]
>    deactivate_locked_super+0x3b/0xa0
>    deactivate_super+0x40/0x50
>    cleanup_mnt+0x135/0x190
>    __cleanup_mnt+0x12/0x20
>    task_work_run+0x64/0xb0
>    __prepare_exit_to_usermode+0x1bc/0x1c0
>    __syscall_return_slowpath+0x47/0x230
>    do_syscall_64+0x64/0xb0
>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>   ---[ end trace caf08beafeca2392 ]---
>   BTRFS error (device dm-3): qgroup reserved space leaked
>=20
> [CAUSE]
> In the offending case, the offending operations are:
> 2/6: writev f2X[269 1 0 0 0 0] [1006997,67,288] 0
> 2/7: truncate f2X[269 1 0 0 48 1026293] 18388 0
>=20
> The following sequence of events could happen after the writev():
> 	CPU1 (writeback)		|		CPU2 (truncate)
> -----------------------------------------------------------------
> btrfs_writepages()			|
> |- extent_write_cache_pages()		|
>    |- Got page for 1003520		|
>    |  1003520 is Dirty, no writeback	|
>    |  So (!clear_page_dirty_for_io())   |
>    |  gets called for it		|
>    |- Now page 1003520 is Clean.	|
>    |					| btrfs_setattr()
>    |					| |- btrfs_setsize()
>    |					|    |- truncate_setsize()
>    |					|       New i_size is 18388
>    |- __extent_writepage()		|
>    |  |- page_offset() > i_size		|
>       |- btrfs_invalidatepage()		|
> 	 |- Page is clean, so no qgroup |
> 	    callback executed
>=20
> This means, the qgroup reserved data space is not properly released in
> btrfs_invalidatepage() as the page is Clean.
>=20
> [FIX]
> Instead of checking the dirty bit of a page, call
> btrfs_qgroup_free_data() unconditionally in btrfs_invalidatepage().
>=20
> As qgroup rsv are completely bound to the QGROUP_RESERVED bit of
> io_tree, not bound to page status, thus we won't cause double freeing
> anyway.
>=20
> Fixes: 0b34c261e235 ("btrfs: qgroup: Prevent qgroup->reserved from going =
subzero")
> CC: stable@vger.kernel.org # 4.14+
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  fs/btrfs/inode.c |   23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
>=20
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9197,20 +9197,17 @@ again:
>  	/*
>  	 * Qgroup reserved space handler
>  	 * Page here will be either
> -	 * 1) Already written to disk
> -	 *    In this case, its reserved space is released from data rsv map
> -	 *    and will be freed by delayed_ref handler finally.
> -	 *    So even we call qgroup_free_data(), it won't decrease reserved
> -	 *    space.
> -	 * 2) Not written to disk
> -	 *    This means the reserved space should be freed here. However,
> -	 *    if a truncate invalidates the page (by clearing PageDirty)
> -	 *    and the page is accounted for while allocating extent
> -	 *    in btrfs_check_data_free_space() we let delayed_ref to
> -	 *    free the entire extent.
> +	 * 1) Already written to disk or ordered extent already submitted
> +	 *    Then its QGROUP_RESERVED bit in io_tree is already cleaned.
> +	 *    Qgroup will be handled by its qgroup_record then.
> +	 *    btrfs_qgroup_free_data() call will do nothing here.
> +	 *
> +	 * 2) Not written to disk yet
> +	 *    Then btrfs_qgroup_free_data() call will clear the QGROUP_RESERVED
> +	 *    bit of its io_tree, and free the qgroup reserved data space.
> +	 *    Since the IO will never happen for this page.
>  	 */
> -	if (PageDirty(page))
> -		btrfs_qgroup_free_data(inode, NULL, page_start, PAGE_SIZE);
> +	btrfs_qgroup_free_data(inode, NULL, page_start, PAGE_SIZE);
>  	if (!inode_evicting) {
>  		clear_extent_bit(tree, page_start, page_end,
>  				 EXTENT_LOCKED | EXTENT_DIRTY |
>=20
>=20
> Patches currently in stable-queue which might be from wqu@suse.com are
>=20
> queue-4.14/btrfs-qgroup-fix-data-leak-caused-by-race-between-writeback-an=
d-truncate.patch
>=20

