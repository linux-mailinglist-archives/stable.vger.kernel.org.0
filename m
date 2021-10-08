Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FB6426653
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 11:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhJHJJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 05:09:37 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:45303 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234798AbhJHJJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 05:09:35 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 40E933201C5C;
        Fri,  8 Oct 2021 05:07:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 08 Oct 2021 05:07:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=p
        WOdH8+W/4ATMGKAClyVxwRlDK91C0vl2ZiXv3Q0yAU=; b=i16n60tgUoAXqzopY
        gm1PFWCDDymNlXhHH5bhArTBXeFgpViKih69FtuhJ93N7HlMCjK7ux3PWAa3GdeZ
        u5Qhclot4vmxDekeo5xcQRdxVkKzJBfKs0q2C1jjrbW6VGtlOqsQVBIqCwCSgP7f
        YunDCuFwBMgDu4zSeadY7+Umtrh0iN09iFly1CBuizHTbGy1Wmds7u9yBKMYjjXM
        1vhbn0XnUDO9u+/ESN2syblnabIlbY85dR6/3k83p/1yvZg1GVXo2lXQUfoclSH7
        H1tJq2eSe2ZgK7UF8qr6UWf8KeDyFHDLV2wxq/e3XaQXTrEnNVbZiG3qmR/9Vpcw
        KsQNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=pWOdH8+W/4ATMGKAClyVxwRlDK91C0vl2ZiXv3Q0y
        AU=; b=EjpTG/UPIk44x4VHRXqRrZsqalSrRcV2SS7+cmSPjEoF1UyL1Qu9bzwbW
        Dph0GhTmkZ25vOs2D/rEmzaBLof29Wd7jqTitWdQa251Iq/zTQKJmjbMQx3cbjpj
        ojmV2ofyNOPFRCC4AeKBaWu6Kk/Od6D0GbMQw8zcwJ/ZsIdYgATF6imILGywYX9d
        +W/yNx5MT1o+PsrrNhfzuUao22XlSZTg4YjiCSw/e/qF2dOBpwcEkilTm2Bzu2Xf
        U2eYyfzu5iYFocPDOH+oTYjQhI4jzOxGT/qAnZS4rswvXF0tRtFGe+fGHgp6advU
        cQBEZ3O5Xrpd1sK2WJLjIEBHUg07g==
X-ME-Sender: <xms:WwpgYYIzpcSxvtQihXndauyZaoXPhE0NDzcDc6WOd5vhm8ENU8p2NQ>
    <xme:WwpgYYLWa6bGENf8NCqScz_F0SewAB_Qq4E9erW4gemax4qkgft6CJxOJo7-XBMiG
    z-DPBu51fqTiw>
X-ME-Received: <xmr:WwpgYYt52zErqxUCz-ZIP7C2mcdb08Z8eT9LnNNsFVBnsqfaR9YDGeTqRxrefSkxgIRzdKX0W23ll7MnpA07EnWr1FXQM267>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddttddguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekrodttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepudfgud
    ehheffjeeljedttdfgvdefkeefueetjeehueetleetvdehhfelkeduieeinecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:WwpgYVYOrUTv8IEw4oF3r8ByNmwjYmA6UDEKCzG5ZcrN91iF6IAIlw>
    <xmx:WwpgYfYiHMCXg7WZSbPYd9x30_Yv4gwRhuSpXyv_tqsBTJrXHOCxtg>
    <xmx:WwpgYRCDEiOSDHixCb1QrbXV-YrUD6A9WvRTScLUDkQZIboaPgnv4w>
    <xmx:WwpgYUN9rvqvY73-pMghMFR7jt4YX6AgKPaq5U33l1EUQdDD5pUIEQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Oct 2021 05:07:38 -0400 (EDT)
Date:   Fri, 8 Oct 2021 11:07:37 +0200
From:   Greg KH <greg@kroah.com>
To:     Krzysztof =?utf-8?Q?Ol=C4=99dzki?= <ole@ans.pl>
Cc:     stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: Backporting "silence nfscache allocation warnings with kvzalloc"
 - 8c38b705b4f4ca4e7f9cc116141bc38391917c30 into 5.4-stable and potentially
 older stable kernels?
Message-ID: <YWAKWYrOtwQFjIsY@kroah.com>
References: <c510950d-6755-3c1e-4703-e224abaf3566@ans.pl>
 <2eb2d5f5-c00d-9c24-ce38-20df150f05e3@ans.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2eb2d5f5-c00d-9c24-ce38-20df150f05e3@ans.pl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06, 2021 at 09:20:29AM -0700, Krzysztof Olędzki wrote:
> (re-sent with the proper stable@ address)
> 
> On 2021-06-10 at 16:37, Krzysztof Olędzki wrote:
> > Hi,
> > 
> > I noticed sporadic "page allocation failure" errors in my systems
> > running 5.4-stable kernels, that look like this:
> > 
> > [1530107.418557] emerge: page allocation failure: order:5, mode:0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO), nodemask=(null),cpuset=/,mems_allowed=0
> > [1530107.418575] CPU: 7 PID: 673 Comm: emerge Not tainted 5.4.121-o3 #1
> > [1530107.418576] Hardware name: Dell Inc. PowerEdge T110 II/0PM2CW, BIOS 2.10.0 05/24/2018
> > [1530107.418577] Call Trace:
> > [1530107.418585]  dump_stack+0x50/0x63
> > [1530107.418589]  warn_alloc+0xde/0x15c
> > [1530107.418591]  __alloc_pages_slowpath+0x759/0x786
> > [1530107.418594]  ? kernfs_add_one+0xf6/0x10d
> > [1530107.418597]  ? preempt_latency_start+0x2b/0x3e
> > [1530107.418600]  ? ida_alloc_range+0x2bc/0x378
> > [1530107.418602]  __alloc_pages_nodemask+0x17d/0x243
> > [1530107.418605]  kmalloc_order+0x1b/0x69
> > [1530107.418607]  kmalloc_order_trace+0x18/0xa1
> > [1530107.418609]  nfsd_reply_cache_init+0xae/0x13a
> > [1530107.418612]  nfsd_init_net+0x66/0xfe
> > [1530107.418615]  ops_init+0xa9/0xd5
> > [1530107.418617]  setup_net+0xb3/0x19b
> > [1530107.418619]  copy_net_ns+0xec/0x140
> > [1530107.418621]  create_new_namespaces+0x125/0x19a
> > [1530107.418623]  unshare_nsproxy_namespaces+0x86/0x9c
> > [1530107.418626]  ksys_unshare+0x14b/0x2e3
> > [1530107.418628]  __x64_sys_unshare+0x9/0xc
> > [1530107.418630]  do_syscall_64+0x72/0x7f
> > [1530107.418633]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [1530107.418636] RIP: 0033:0x7f47d7161f97
> > [1530107.418638] Code: 73 01 c3 48 8b 0d d1 fe 0b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a1 fe 0b 00 f7 d8 64 89 01 48
> > [1530107.418639] RSP: 002b:00007ffd9a1f61f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
> > [1530107.418641] RAX: ffffffffffffffda RBX: 00007ffd9a1f6200 RCX: 00007f47d7161f97
> > [1530107.418642] RDX: 0000000000000000 RSI: 00007f47c95d2800 RDI: 000000006c020000
> > [1530107.418643] RBP: 00007ffd9a1f6200 R08: 0000000000000000 R09: 00007ffd9a1f6250
> > [1530107.418643] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd9a1f6348
> > [1530107.418644] R13: 0000000000000000 R14: 00007ffd9a1f62c0 R15: 00007ffd9a1f6328
> > [1530107.418646] Mem-Info:
> > [1530107.418650] active_anon:507099 inactive_anon:153606 isolated_anon:0
> >                    active_file:2413575 inactive_file:4701878 isolated_file:0
> >                    unevictable:2557 dirty:2354 writeback:0 unstable:0
> >                    slab_reclaimable:275977 slab_unreclaimable:23789
> >                    mapped:27516 shmem:12726 pagetables:5087 bounce:0
> >                    free:83786 free_pcp:0 free_cma:0
> > [1530107.418653] Node 0 active_anon:2028396kB inactive_anon:614424kB active_file:9654300kB inactive_file:18807512kB unevictable:10228kB isolated(anon):0kB isolated(file):0kB mapped:110064kB dirty:9416kB writeback:0kB shmem:50904kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
> > [1530107.418656] DMA free:15888kB min:8kB low:20kB high:32kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15988kB managed:15904kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> > [1530107.418657] lowmem_reserve[]: 0 2422 32068 32068
> > [1530107.418661] DMA32 free:248688kB min:1728kB low:4208kB high:6688kB active_anon:94588kB inactive_anon:108056kB active_file:976696kB inactive_file:792500kB unevictable:104kB writepending:2744kB present:2574428kB managed:2549240kB mlocked:104kB kernel_stack:192kB pagetables:968kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> > [1530107.418662] lowmem_reserve[]: 0 0 29645 29645
> > [1530107.418666] Normal free:70568kB min:21180kB low:51536kB high:81892kB active_anon:1934340kB inactive_anon:506132kB active_file:8677844kB inactive_file:18015144kB unevictable:10124kB writepending:6672kB present:30932992kB managed:30357820kB mlocked:10124kB kernel_stack:5732kB pagetables:19380kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> > [1530107.418666] lowmem_reserve[]: 0 0 0 0
> > [1530107.418668] DMA: 0*4kB 0*8kB 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15888kB
> > [1530107.418674] DMA32: 10702*4kB (UME) 3914*8kB (UME) 4900*16kB (UME) 1794*32kB (UME) 623*64kB (UM) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 249800kB
> > [1530107.418680] Normal: 1795*4kB (UMEH) 635*8kB (UMEH) 284*16kB (UMH) 297*32kB (UMEH) 703*64kB (MEH) 3*128kB (H) 0*256kB 1*512kB (H) 0*1024kB 0*2048kB 0*4096kB = 72196kB
> > [1530107.418687] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
> > [1530107.418688] 7129905 total pagecache pages
> > [1530107.418690] 13 pages in swap cache
> > [1530107.418691] Swap cache stats: add 121, delete 108, find 15/20
> > [1530107.418692] Free swap  = 4191732kB
> > [1530107.418692] Total swap = 4193276kB
> > [1530107.418693] 8380852 pages RAM
> > [1530107.418694] 0 pages HighMem/MovableOnly
> > [1530107.418694] 150111 pages reserved
> > 
> > If I'm not mistaken, 5.10 and newer kernels have a fix for this:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8c38b705b4f4ca4e7f9cc116141bc38391917c30
> > 
> > I wonder if it would be possible to include it in 5.4-stable and potentially older stable kernels?

I've applied this to the 5.4.y tree, but it did not apply to older
kernels.  If you want it on them, please provide a working backport.

thanks,

greg k-h
