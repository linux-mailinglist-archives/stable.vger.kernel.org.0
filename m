Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B83041F900
	for <lists+stable@lfdr.de>; Sat,  2 Oct 2021 03:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhJBBNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 21:13:24 -0400
Received: from mout.gmx.net ([212.227.15.15]:50191 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232212AbhJBBNP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 21:13:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1633137084;
        bh=pbuHOVubPB5LtBHArhqwb6lZtsSVSgz8a6Pv/nZr3Gs=;
        h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
        b=ce9ItxdYn1yJF48y5xBePrsK6LpAP7S8JBI06Bhc86EGoj+ImepizFFSjimtOGn0t
         7iNSHr18WkfMms3zkYxZPQ7dEHO0dTn6EUNvB4jhHJ+BvaBSYb06qSmB3WCbgb16IL
         0MT+H7KFLHGGC6gXo5WaQ81kvcAUwsgHURSjFaa4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MZCb5-1mJ1AI1quP-00V7V4; Sat, 02
 Oct 2021 03:11:24 +0200
Message-ID: <2b50d041-55d7-c3b1-0729-577e0af942dd@gmx.com>
Date:   Sat, 2 Oct 2021 09:11:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Content-Language: en-US
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     stable@vger.kernel.org
References: <3b6169b5a9b7bda03e14bcc7e10f8dcda5e92374.1633111027.git.josef@toxicpanda.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH] btrfs: update refs for any root except tree log roots
In-Reply-To: <3b6169b5a9b7bda03e14bcc7e10f8dcda5e92374.1633111027.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OhlhhgfQ3vE0Dxsda12UW+E/ebnTTx9hF9miaBt899XSfUiRtA/
 vojGeJ/O00TqrvMojcvxzjbc4U1+Xoc5r5jLiIIZl5uqgjDR9okGRBvIDdwByoWffYZF2se
 k0Gu7jYY+f/1dDlygsSH/Eu+eygdWXPmxoQkzN9VK0dQmkQPm924DixurJcfAS/Pk6Zcf+/
 TOdo5I5U9bUIjt7zpkWpg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:DRCqG9Bdq0s=:dvGryETYgmnqzHUXbxWvaO
 aGaBNdyxLs6yb6My02B3OW9oDp5K+BwfSe46wT950/Ala3BJVt4THn1kvTK9lI8BPT3oKNKV6
 GAuOeXTc9VDJQBzlN6r04CFJD7AGzmfHYmw+1bXzh6u2f+eVhdaTCwVIQ1KK6m+Evk/InvoYC
 CBTlsXt60dYw/SnGlef4xOBAgycTJKrctMAgVEflZ77AW6h+UUSDN70iYlep3vi6a0W5XaWqO
 wOKzVW2pNYv1yzXzil0xE7y1M0PWeCpUkv5q0i1lJ4JXv8rL0zuDLGco2Jn2yQHud1kZDytdW
 SknOH11j7GHbjxWptG3aTXh/L3ToHXBXaAgiDtFJO4coBafS1OcRCyb0n/nL3Q+nP0JQSL5VJ
 6dXWF+DvbzQd2yH/dkzF345QIz3xX8Xa5ny9/ML1JwYms2MXF1CGR4PVOpRQbh184cnCkyF4B
 //yEvzOaeg6sTb6Iiw1xk9JNBvBNJlm/XymJkBoAoZirJ1imtxE+LM2H3nukOEzuIrOP0qHXV
 5uxH3864rdBNVzYTdjhZUcY6mIfUyGIoypcC0e0M4b9FRYmmRwU7kCGprnBFNLkiuMxM35IzL
 4kcrx1GROSvKEC2ja7b92Pu1Wv05HVQ4UseCLbePDenC4W9Uk+iTizCmMKe0XohC/qFquHW4e
 mZgUDXA2n7jZtPSTL/Yg4k/+cs/JEgpG8YqhB2lXPrOrpHtPamJb6Gjq0j/UzXWxY9Ay6QHWI
 sJFbjtII8xLJE0tIT+NLnb/EqPZA8JhaXReg1SZh5WyFRTRp8GIjeAfGiFSJY1miKl/LCDVEu
 PRdvKcyNtF3ZH4K++/RKCKbz9FjzUyFbQQo0AtXwd9QtZiXbWG5pax4YCKNe1ICygFg5xgZG+
 QqehcNnrGQYeGqKwyBViqxxCyRVoPn+V+XJSaMTOszXUT9Ms5/E/a2cu+QFXVex2ZUNFMPYEy
 v/u4jA5ybP8k4eXrFBd0v0FWYp/1P0RKtjn1fsTqLSIweEi1jLvuyTBYgxsQgbah1mHfzcWRI
 gWWnUMGxexBzzAClr8BEvpU4PKPfI/fxrFUGo5KbwWFb8xZBCCt5FP1/E9Ov3J4G4X1NOLmU7
 vbL5NfnQ/HDtG0=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/10/2 01:57, Josef Bacik wrote:
> I hit a stuck relocation on btrfs/061 during my overnight testing.  This
> turned out to be because we had left over extent entries in our extent
> root for a data reloc inode that no longer existed.  This happened
> because in btrfs_drop_extents() we only update refs if we have SHAREABLE
> set or we are the tree_root.  This regression was introduced by
> aeb935a45581 ("btrfs: don't set SHAREABLE flag for data reloc tree")
> where we stopped setting SHAREABLE for the data reloc tree.
>
> The problem here is we actually do want to update extent references for
> data extents in the data reloc tree, in fact we only don't want to
> update extent references if the file extents are in the log tree.
> Update this check to only skip updating references in the case of the
> log tree.
>
> This is relatively rare, because you have to be running scrub at the
> same time, which is what btrfs/061 does.  The data reloc inode has its
> extents pre-allcated, and then we copy the extent into the pre-allocated
> chunks.  We theoretically should never be calling btrfs_drop_extents()
> on a data reloc inode.  The exception of course is with scrub, if our
> pre-allocated extent falls inside of the block group we are scrubbing,
> then the block group will be marked read only and we will be forced to
> cow that extent.  This means we will call btrfs_drop_extents() on that
> range when we cow that file extent.

Oh my god, I forgot the corner case here!

>
> This isn't really problematic if we do this, the data reloc inode
> requires that our extent lengths match exactly with the extent we are
> copying, thankfully we validate the extent is correct with
> get_new_location(), so if we happen to cow only part of the extent we
> won't link it in when we do the relocation, so we are safe from any
> other shenanigans that arise because of this interaction with scrub.

But this makes me wonder, can we just leave scrub and balance exclusive?
There are already quite some limitations, like balance and send.

Adding balance and scrub to be exclusive to each other shouldn't cause
too much hassle, and can remove these checks.

>
> cc: stable@vger.kernel.org
> Fixes: aeb935a45581 ("btrfs: don't set SHAREABLE flag for data reloc tre=
e")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks for the cause analyse and fix!
Qu

> ---
>   fs/btrfs/file.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 04e29b40a38e..b7d3559efcf7 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -734,8 +734,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *tr=
ans,
>   	if (args->start >=3D inode->disk_i_size && !args->replace_extent)
>   		modify_tree =3D 0;
>
> -	update_refs =3D (test_bit(BTRFS_ROOT_SHAREABLE, &root->state) ||
> -		       root =3D=3D fs_info->tree_root);
> +	update_refs =3D root->root_key.objectid !=3D BTRFS_TREE_LOG_OBJECTID;
>   	while (1) {
>   		recow =3D 0;
>   		ret =3D btrfs_lookup_file_extent(trans, root, path, ino,
>
