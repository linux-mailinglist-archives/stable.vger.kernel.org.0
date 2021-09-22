Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E3F414EF7
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236716AbhIVRYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:24:00 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45041 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236701AbhIVRX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:23:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id F066D5C00FD;
        Wed, 22 Sep 2021 13:22:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 22 Sep 2021 13:22:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=mVswv+rGa7zWOpJ+g7pPSg9baSm
        R1CQiMi0TNDeEMP4=; b=et6eNyazL/j/lAj9iHj0xZCuoYsAOT+itrKtiuJNqvY
        fY8J09mXevrivw9Hc7Dq06ILpG38+fr2yUSF1nhxBTt5buNic1PcAhAS1toNcaQw
        8ny+vX6LuvTHMNgGIqBO5QXM2egLzhTAwHYeK6BiAGQpebAlkfeSgpBNJ18gEuK5
        rqheT8t5tJKs1Ro6ztFuQpStUAM75Y09JuWrqVK/B2XQldJ65/TwkoK5FG9goO+G
        38pLjV5p9iMsDCdRXO30apzcp/FX4oP6+k1uACOboyxfS39wBS6BcTbHq4Ksxdgj
        TIh4gIatlLlYAoV9Qp6EQvMSTtbHEfOO9yk1Fk7HzHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=mVswv+
        rGa7zWOpJ+g7pPSg9baSmR1CQiMi0TNDeEMP4=; b=TG955IHjiTibAQLHT+qB3l
        Ox+LZld0MEUg2ATVTXLmSpP4jncc1VICOCLLELePEak9e3hmxhZ22QfSvm0JsnuI
        ibArvdAu1LoFWBNRWKl/LijLhN+GCmmlTG1CyPClwIX8xVfpxYlPjfxDeRrxvMG6
        DJa3+6JPJmMIsRT4goUJt4BapszeiPKtZ0uuLIYRQd/UTnp1gJW6GFI+gsPHxg5Z
        y2Le+fSLQdKaoFhM7z6p/BMCAWV1lWZp4XTY8Ue6zd7K/DFkWWKjN8be9e9JGbvI
        r7wnxBXortShNWFbT21qRon+uPwthJKvgsBUNDbOhTrdUVEBTsRhcLEkJ4kJeCfg
        ==
X-ME-Sender: <xms:VGZLYXzuzHaWVTxrnkq37q7pqtzNDiXaxN-CNK8vkNHH02jRS-pJ8w>
    <xme:VGZLYfQOy11lCAyXp8SOoU-rv9rLkCQXOJLIcTCCsG0UWLV3wy7Yh3Zpiq-lWtSeU
    3DCPOtoaMHWLIGi7wo>
X-ME-Received: <xmr:VGZLYRXuNLfDZYKwG0gBmkYz_JVEuqOLb6X1FyNq19SW1hJ8kx5RqeRsaho>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeijedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    dtvdfftddvveduieejtedufeeuudefueefhfdujedutdegtddtffffiefgtefgtdenucff
    ohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:VGZLYRipr4VzBQvjpSo0EzJiqyly-d7EikoQyZlE4AUSJj3Difkg4Q>
    <xmx:VGZLYZBTGqzFRxSbmqsWBbDy7OmTXL3iYvHQRWu5tuGiTiZ7OZPXbg>
    <xmx:VGZLYaKQ71dXo1hY_oCrK2x74TFwfASG6NHCsodHz9a8WL5wRerYzQ>
    <xmx:VGZLYcNC5smMjVL9aI209GkyPdo0v9XywYKmT8QexQgbov5vOczHCQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Sep 2021 13:22:28 -0400 (EDT)
Date:   Wed, 22 Sep 2021 10:22:11 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] fs-verity: fix signed integer overflow with i_size near
 S64_MAX
Message-ID: <YUtmQ4m0MPfAjsb9@devbig008.ftw2.facebook.com>
References: <20210916203424.113376-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916203424.113376-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 01:34:24PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> If the file size is almost S64_MAX, the calculated number of Merkle tree
> levels exceeds FS_VERITY_MAX_LEVELS, causing FS_IOC_ENABLE_VERITY to
> fail.  This is unintentional, since as the comment above the definition
> of FS_VERITY_MAX_LEVELS states, it is enough for over U64_MAX bytes of
> data using SHA-256 and 4K blocks.  (Specifically, 4096*128**8 >= 2**64.)
> 
> The bug is actually that when the number of blocks in the first level is
> calculated from i_size, there is a signed integer overflow due to i_size
> being signed.  Fix this by treating i_size is unsigned.
> 
> This was found by the new test "generic: test fs-verity EFBIG scenarios"
> (https://lkml.kernel.org/r/b1d116cd4d0ea74b9cd86f349c672021e005a75c.1631558495.git.boris@bur.io).
> 
> This didn't affect ext4 or f2fs since those have a smaller maximum file
> size, but it did affect btrfs which allows files up to S64_MAX bytes.
> 
> Reported-by: Boris Burkov <boris@bur.io>
> Fixes: 3fda4c617e84 ("fs-verity: implement FS_IOC_ENABLE_VERITY ioctl")
> Fixes: fd2d1acfcadf ("fs-verity: add the hook for file ->open()")
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Ah good catch! I'll update the test to not work around it.

Reviewed-by: Boris Burkov <boris@bur.io>

> ---
>  fs/verity/enable.c | 2 +-
>  fs/verity/open.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/verity/enable.c b/fs/verity/enable.c
> index 77e159a0346b1..60a4372aa4d75 100644
> --- a/fs/verity/enable.c
> +++ b/fs/verity/enable.c
> @@ -177,7 +177,7 @@ static int build_merkle_tree(struct file *filp,
>  	 * (level 0) and ascending to the root node (level 'num_levels - 1').
>  	 * Then at the end (level 'num_levels'), calculate the root hash.
>  	 */
> -	blocks = (inode->i_size + params->block_size - 1) >>
> +	blocks = ((u64)inode->i_size + params->block_size - 1) >>
>  		 params->log_blocksize;
>  	for (level = 0; level <= params->num_levels; level++) {
>  		err = build_merkle_tree_level(filp, level, blocks, params,
> diff --git a/fs/verity/open.c b/fs/verity/open.c
> index 60ff8af7219fe..92df87f5fa388 100644
> --- a/fs/verity/open.c
> +++ b/fs/verity/open.c
> @@ -89,7 +89,7 @@ int fsverity_init_merkle_tree_params(struct merkle_tree_params *params,
>  	 */
>  
>  	/* Compute number of levels and the number of blocks in each level */
> -	blocks = (inode->i_size + params->block_size - 1) >> log_blocksize;
> +	blocks = ((u64)inode->i_size + params->block_size - 1) >> log_blocksize;
>  	pr_debug("Data is %lld bytes (%llu blocks)\n", inode->i_size, blocks);
>  	while (blocks > 1) {
>  		if (params->num_levels >= FS_VERITY_MAX_LEVELS) {
> -- 
> 2.33.0
> 
