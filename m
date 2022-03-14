Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D234D7DF1
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 09:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbiCNI7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 04:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237728AbiCNI7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 04:59:15 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EEB19C26
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 01:58:03 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 910253201DE2;
        Mon, 14 Mar 2022 04:57:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 14 Mar 2022 04:58:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=SkSeyKPTWI05v6N1wjcspJUWw5vwrJoOrI3Bts
        E89Cw=; b=IJbCJoN7FaftU3vo+8r2vXvDnikuONWU8Xslz0ZtQYtcCg988WimUa
        aN5tM3CKA+9XqhWIoCs/beIicL3fXavvVnBQvJJUfhLqVXVgwU/U30vPMG5DD8fh
        eP+gnslgWJFkVWEsaSyreJSy+x1n8KuSBhTuw0LeY/62kwI9s/V37oQr+R6OoE+y
        oeJCp6VskLXnqIu4/LiJkJuJY9pI9/G5k5k4YrAddlIBRAZfBMONg4mQmasse9bJ
        RRQsVTuFUFY4NVY7HD25VZISz+FHeqmk7goQz8ui4F9oKBvIeyUpn+9Z8Pesj8V/
        DejQZzhqH2LsOsVXU31mgjtSg3rEUT4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SkSeyKPTWI05v6N1w
        jcspJUWw5vwrJoOrI3BtsE89Cw=; b=iczvQOFdimZq9ENNrM5W8crkjKOz6AnTr
        L++0ceEPiKye1UM3xsaduOWksYz+e8L/Zr8P8Z0LXzxkconIlkZjagg+DmDcWjTZ
        FU9ydgrtxRiInPP2tA7m+PQ2nI+7vCQTZ0bmCjNvt+DEs90chM/Q8cWx0INPbqyU
        raIWsr8eWG3449pqIQScitt13jVR89at5MwwIOzmWWXsMkYsth7PdeNEcLXMdcNQ
        rUzg2yAU+14Ss+6MxiFi/rVzC/zJ7mjAMjutKLX/ji4nXaRVTSCur1P07lqRsMcN
        NFzOK44zbIk16VZC5SBUXC9VnDNeMqJpdI1+FLdgFaiTgXPU10rmA==
X-ME-Sender: <xms:lgMvYs1LJZoj-Vd55XGG7esLWSje5QdX1pJZmhsgN_jPsYbTXkvaxA>
    <xme:lgMvYnGQ7RKhsinSu2v_QKy05VdIjcBkfzkQQYd5NO6v6Zdgw17-bDFpvoc4LDQ3v
    ZynrmyC2g4eJg>
X-ME-Received: <xmr:lgMvYk5eeJxgtksEIrqzuNSbqJ2FVjy9ip2hGqkHdLaszC_IOYKdXHPFLNK_l0eyzGR_wWdBpjVkYngqrE-onRAMImMQ9S4G>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddvjedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepfeejvd
    euudejgfdvleelueejgfejgeeiffdufeffvdeufedtjefhtdfghfegkeejnecuffhomhgr
    ihhnpehoshdrohhpvghnpdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:lgMvYl2nxZzkMOvS_VHZqPfQtPdBta2rzUAv4gEqN9W-yXslJ-gDVw>
    <xmx:lgMvYvGUhYDRsvVFesJtopBwivjZnYBzF5TOhMf6J39FE0rOpd7rQw>
    <xmx:lgMvYu-Mw4nl4UtmdDwjqVC8e66Hs4wM0px5_4A4LD1ei4uoHBP-ng>
    <xmx:lwMvYk4-YVJy30W5d5s3Mq2JWYIVlikVeXVJx3v2y_Z5DmedcXP_Dw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Mar 2022 04:57:58 -0400 (EDT)
Date:   Mon, 14 Mar 2022 09:57:55 +0100
From:   Greg KH <greg@kroah.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     stable@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH STABLE 5.10 5.4 4.19 4.14] ext4: add check to prevent
 attempting to resize an fs with sparse_super2
Message-ID: <Yi8Dk80To2px9XVy@kroah.com>
References: <20220313044449.1260655-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220313044449.1260655-1-tytso@mit.edu>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 12, 2022 at 11:44:49PM -0500, Theodore Ts'o wrote:
> From: Josh Triplett <josh@joshtriplett.org>
> 
> commit b1489186cc8391e0c1e342f9fbc3eedf6b944c61 upstream.
> 
> The in-kernel ext4 resize code doesn't support filesystem with the
> sparse_super2 feature. It fails with errors like this and doesn't
> finish the resize:
> 
> EXT4-fs (loop0): resizing filesystem from 16640 to 7864320 blocks
> EXT4-fs warning (device loop0): verify_reserved_gdb:760: reserved GDT 2 missing grp 1 (32770)
> EXT4-fs warning (device loop0): ext4_resize_fs:2111: error (-22) occurred during file system resize
> EXT4-fs (loop0): resized filesystem to 2097152
> 
> To reproduce:
> mkfs.ext4 -b 4096 -I 256 -J size=32 -E resize=$((256*1024*1024)) -O sparse_super2 ext4.img 65M
> truncate -s 30G ext4.img
> mount ext4.img /mnt
> python3 -c 'import fcntl, os, struct ; fd = os.open("/mnt", os.O_RDONLY | os.O_DIRECTORY) ; fcntl.ioctl(fd, 0x40086610, struct.pack("Q", 30 * 1024 * 1024 * 1024 // 4096), False) ; os.close(fd)'
> dmesg | tail
> e2fsck ext4.img
> 
> The userspace resize2fs tool has a check for this case: it checks if
> the filesystem has sparse_super2 set and if the kernel provides
> /sys/fs/ext4/features/sparse_super2. However, the former check
> requires manually reading and parsing the filesystem superblock.
> 
> Detect this case in ext4_resize_begin and error out early with a clear
> error message.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> Link: https://lore.kernel.org/r/74b8ae78405270211943cd7393e65586c5faeed1.1623093259.git.josh@joshtriplett.org
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  fs/ext4/resize.c | 5 +++++
>  1 file changed, 5 insertions(+)

Now queued up, thanks.

greg k-h
