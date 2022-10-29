Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EBD61226F
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 13:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJ2Ldy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 07:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJ2Ldx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 07:33:53 -0400
Received: from domac.alu.hr (domac.alu.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FE76AE91;
        Sat, 29 Oct 2022 04:33:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 0DC82604F0;
        Sat, 29 Oct 2022 13:33:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1667043229; bh=5b8ZceQye+XJZlRK33PMTcEM2oXhPTuSpv6wrVcuSWM=;
        h=Date:From:Subject:To:References:In-Reply-To:From;
        b=2KCHx/CHGn5WHyTme2T7LYkhGPDj2Buiymd5yATPYxRhKjeYELmKeuOdCfaHTC+Rm
         QL4FL9aGZBttjIXVVKQmTHtUCspzfu0icsHPw+37NNWP/6ggMNnC57dyxQgysix4pr
         kMyyaC4EM4wAClOVkQ4Ld0e8WB6+scZOAyyQt0Dx3mix8u2DauskkIdVhjJCCx+ypH
         YjZkC/hEo9WsfnCLrQYoQXlvThyQSTO5Ic1a9BPfyKQCSJ4bjnVhbKNS8fPBb97F7s
         0mno6WMvBtxw2SEVe3J9jdXPX2QyBoR06JsjSDtTP+zt+bPSckCw51jeTasIdb7hku
         X4QEgCb71OQKg==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PRELwbB7cwwK; Sat, 29 Oct 2022 13:33:46 +0200 (CEST)
Received: from [192.168.0.12] (unknown [188.252.198.201])
        by domac.alu.hr (Postfix) with ESMTPSA id 2BBEF604EC;
        Sat, 29 Oct 2022 13:33:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1667043226; bh=5b8ZceQye+XJZlRK33PMTcEM2oXhPTuSpv6wrVcuSWM=;
        h=Date:From:Subject:To:References:In-Reply-To:From;
        b=W3sw+0p6L4w2Y6ZdjXBTf4+qbl/zPu91Rh8P4OBgOC86JJwJ1UppkCHh1kRNYL0rd
         5AB8mrTLzRhuRDyh43boJ9EQfnSfjKFalosC5WHMhgKoXvNip8A42PeyvPsKFwmqTI
         OzGj/ZgGc4Hywqb1pGDu7xGH3la9kkgjzZkc2RKWvGkQSpsT9nw2uGGrUCHouvCSPj
         4fYxR+IZ1ibmqqYpvbgkY4oI9+rUbP3KVj6OnYw1agBRltBhmlZgt6KgUrvgZcLHfF
         bfaV0OtycKQoCtzY1U1BJBZ0GvCBHMSi60ABucCp9Dze0lzmkoeRCpnelCI8g2PbfK
         T5vYYJL0Gu1dg==
Message-ID: <5422d190-db17-b6ea-ec13-ed157861c939@alu.unizg.hr>
Date:   Sat, 29 Oct 2022 13:33:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: Re: [merged mm-hotfixes-stable]
 squashfs-fix-buffer-release-race-condition-in-readahead-code.patch removed
 from -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        srw@sladewatkins.net, regressions@leemhuis.info,
        marcmiltenberger@gmail.com, hsinyi@chromium.org,
        dimitri.ledkov@canonical.com, bagasdotme@gmail.com,
        phillip@squashfs.org.uk
References: <20221028210704.43CFAC433C1@smtp.kernel.org>
Content-Language: en-US
In-Reply-To: <20221028210704.43CFAC433C1@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28. 10. 2022. 23:07, Andrew Morton wrote:
> The quilt patch titled
>       Subject: squashfs: fix buffer release race condition in readahead code
> has been removed from the -mm tree.  Its filename was
>       squashfs-fix-buffer-release-race-condition-in-readahead-code.patch
>
> This patch was dropped because it was merged into the mm-hotfixes-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> ------------------------------------------------------
> From: Phillip Lougher <phillip@squashfs.org.uk>
> Subject: squashfs: fix buffer release race condition in readahead code
> Date: Thu, 20 Oct 2022 23:36:16 +0100
>
> Fix a buffer release race condition, where the error value was used after
> release.
>
> Link: https://lkml.kernel.org/r/20221020223616.7571-4-phillip@squashfs.org.uk
> Fixes: b09a7a036d20 ("squashfs: support reading fragments in readahead call")
> Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
> Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Reported-by: Marc Miltenberger <marcmiltenberger@gmail.com>
> Cc: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> Cc: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> Cc: Slade Watkins <srw@sladewatkins.net>
> Cc: Thorsten Leemhuis <regressions@leemhuis.info>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Dear Mr. Andrew Morton,

For correctness sake, as you can witness yourself from the archive, it 
is Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>, who was the 
initial reporter of the bug.

Reference: 
https://lore.kernel.org/all/2f0ddb46-d197-558d-4be7-d40506e0a64f@alu.unizg.hr/

Mr. Miltenberger's credit is also important, for he was the first person 
to reproduce the bug.

Actually, the LKML archives already represent the correct state, however 
someone might want to reproduce additional hypothetical errors in this 
segment of code, and probably correct the person(s) who helped bisect
the bug.

I am looking forward to your reply.

The first patch in the series has correct references:

From: Phillip Lougher<phillip@squashfs.org.uk>
Subject: squashfs: fix read regression introduced in readahead code
Date: Thu, 20 Oct 2022 23:36:14 +0100

[...]

Link:https://lkml.kernel.org/r/20221020223616.7571-1-phillip@squashfs.org.uk
Link:https://lkml.kernel.org/r/20221020223616.7571-2-phillip@squashfs.org.uk
Fixes: 8fc78b6fe24c ("squashfs: implement readahead")
Link:https://lore.kernel.org/lkml/b0c258c3-6dcf-aade-efc4-d62a8b3a1ce2@alu.unizg.hr/
Signed-off-by: Phillip Lougher<phillip@squashfs.org.uk>
Reported-by: Mirsad Goran Todorovac<mirsad.todorovac@alu.unizg.hr>
Tested-by: Mirsad Goran Todorovac<mirsad.todorovac@alu.unizg.hr>
Tested-by: Slade Watkins<srw@sladewatkins.net>
Tested-by: Bagas Sanjaya<bagasdotme@gmail.com>
Reported-by: Marc Miltenberger<marcmiltenberger@gmail.com>
Cc: Dimitri John Ledkov<dimitri.ledkov@canonical.com>
Cc: Hsin-Yi Wang<hsinyi@chromium.org>
Cc: Thorsten Leemhuis<regressions@leemhuis.info>
Cc:<stable@vger.kernel.org>
Signed-off-by: Andrew Morton<akpm@linux-foundation.org>

Thank you very much.
Mirsad

> --- a/fs/squashfs/file.c~squashfs-fix-buffer-release-race-condition-in-readahead-code
> +++ a/fs/squashfs/file.c
> @@ -506,8 +506,9 @@ static int squashfs_readahead_fragment(s
>   		squashfs_i(inode)->fragment_size);
>   	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
>   	unsigned int n, mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
> +	int error = buffer->error;
>   
> -	if (buffer->error)
> +	if (error)
>   		goto out;
>   
>   	expected += squashfs_i(inode)->fragment_offset;
> @@ -529,7 +530,7 @@ static int squashfs_readahead_fragment(s
>   
>   out:
>   	squashfs_cache_put(buffer);
> -	return buffer->error;
> +	return error;
>   }
>   
>   static void squashfs_readahead(struct readahead_control *ractl)
> _
>
> Patches currently in -mm which might be from phillip@squashfs.org.uk are
>
--
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
-- 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

