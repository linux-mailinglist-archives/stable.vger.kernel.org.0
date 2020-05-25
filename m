Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EC41E10B1
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 16:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390960AbgEYOjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 10:39:43 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:52413 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390944AbgEYOjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 10:39:43 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 19B961942B88;
        Mon, 25 May 2020 10:39:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 25 May 2020 10:39:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MV2RBC
        HiGs4cWy6bO2ArWxzc0RxpHLw2mZ+zz2GzqQI=; b=iKYLCQuDF6oPygOpwPhTjM
        +Bbh3JwlJq8ZzkZDeiJXTSF0wEAlkWiSuua+s558eE9CQ5jBZl4azGWTD3viReYJ
        3RMG2/H3fcGhL4jsfpxJ/c1x+pVa1h1lkZnczR0hdDq4FH2cDq4zh41HkIiSk6Fo
        JGitLCkCW2m4pOxdM1qv+YBnU8Mdf06/ZiRmYov/BFQKS5iV61IbPqlbBgONAYqo
        2H/lvaScyrK4Gm/UPfOVNViZ91xCuDvE2RF/vPuyvMwJOZ5Mnc6BUHBligG6BJI1
        poQeGFNREtgDmdGml3XaMAGYIrv/sCH+5vz/kDT8sZmVxXmkSX6RXu4VO0W4E6Bg
        ==
X-ME-Sender: <xms:rdjLXpp5xklhi9R4OBF0jUUn787dx6a4_LRBbvbS_ak4BerLVAhjtg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:rdjLXro-sKi1-FApuChK0VZ4dMZTFyxD7FmAZ7zTySwW3Sr5c8KYUg>
    <xmx:rdjLXmMpPkK5x6kORU0R49gNL61VDf5pZI7lx5mvZBRR_SZErjvy8w>
    <xmx:rdjLXk79zVNydFEwi6EU9cKFD-uD4TX6XKDub1lzZparN-h3-oh4tg>
    <xmx:rtjLXtjvU8ZMdQ9FqDlugFQpkTrD4Xx44c9TGnQPR6xfvxkseouM3Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A6DE7306656D;
        Mon, 25 May 2020 10:39:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bpf: Prevent mmap()'ing read-only maps as writable" failed to apply to 5.6-stable tree
To:     andriin@fb.com, ast@kernel.org, jannh@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 May 2020 16:39:40 +0200
Message-ID: <15904175802874@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dfeb376dd4cb2c5004aeb625e2475f58a5ff2ea7 Mon Sep 17 00:00:00 2001
From: Andrii Nakryiko <andriin@fb.com>
Date: Mon, 18 May 2020 22:38:24 -0700
Subject: [PATCH] bpf: Prevent mmap()'ing read-only maps as writable

As discussed in [0], it's dangerous to allow mapping BPF map, that's meant to
be frozen and is read-only on BPF program side, because that allows user-space
to actually store a writable view to the page even after it is frozen. This is
exacerbated by BPF verifier making a strong assumption that contents of such
frozen map will remain unchanged. To prevent this, disallow mapping
BPF_F_RDONLY_PROG mmap()'able BPF maps as writable, ever.

  [0] https://lore.kernel.org/bpf/CAEf4BzYGWYhXdp6BJ7_=9OQPJxQpgug080MMjdSB72i9R+5c6g@mail.gmail.com/

Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/bpf/20200519053824.1089415-1-andriin@fb.com

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2843bbba9ca1..4e6dee19a668 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -623,9 +623,20 @@ static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	mutex_lock(&map->freeze_mutex);
 
-	if ((vma->vm_flags & VM_WRITE) && map->frozen) {
-		err = -EPERM;
-		goto out;
+	if (vma->vm_flags & VM_WRITE) {
+		if (map->frozen) {
+			err = -EPERM;
+			goto out;
+		}
+		/* map is meant to be read-only, so do not allow mapping as
+		 * writable, because it's possible to leak a writable page
+		 * reference and allows user-space to still modify it after
+		 * freezing, while verifier will assume contents do not change
+		 */
+		if (map->map_flags & BPF_F_RDONLY_PROG) {
+			err = -EACCES;
+			goto out;
+		}
 	}
 
 	/* set default open/close callbacks */
diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testing/selftests/bpf/prog_tests/mmap.c
index 6b9dce431d41..43d0b5578f46 100644
--- a/tools/testing/selftests/bpf/prog_tests/mmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/mmap.c
@@ -19,7 +19,7 @@ void test_mmap(void)
 	const size_t map_sz = roundup_page(sizeof(struct map_data));
 	const int zero = 0, one = 1, two = 2, far = 1500;
 	const long page_size = sysconf(_SC_PAGE_SIZE);
-	int err, duration = 0, i, data_map_fd, data_map_id, tmp_fd;
+	int err, duration = 0, i, data_map_fd, data_map_id, tmp_fd, rdmap_fd;
 	struct bpf_map *data_map, *bss_map;
 	void *bss_mmaped = NULL, *map_mmaped = NULL, *tmp1, *tmp2;
 	struct test_mmap__bss *bss_data;
@@ -37,6 +37,17 @@ void test_mmap(void)
 	data_map = skel->maps.data_map;
 	data_map_fd = bpf_map__fd(data_map);
 
+	rdmap_fd = bpf_map__fd(skel->maps.rdonly_map);
+	tmp1 = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, rdmap_fd, 0);
+	if (CHECK(tmp1 != MAP_FAILED, "rdonly_write_mmap", "unexpected success\n")) {
+		munmap(tmp1, 4096);
+		goto cleanup;
+	}
+	/* now double-check if it's mmap()'able at all */
+	tmp1 = mmap(NULL, 4096, PROT_READ, MAP_SHARED, rdmap_fd, 0);
+	if (CHECK(tmp1 == MAP_FAILED, "rdonly_read_mmap", "failed: %d\n", errno))
+		goto cleanup;
+
 	/* get map's ID */
 	memset(&map_info, 0, map_info_sz);
 	err = bpf_obj_get_info_by_fd(data_map_fd, &map_info, &map_info_sz);
diff --git a/tools/testing/selftests/bpf/progs/test_mmap.c b/tools/testing/selftests/bpf/progs/test_mmap.c
index 6239596cd14e..4eb42cff5fe9 100644
--- a/tools/testing/selftests/bpf/progs/test_mmap.c
+++ b/tools/testing/selftests/bpf/progs/test_mmap.c
@@ -7,6 +7,14 @@
 
 char _license[] SEC("license") = "GPL";
 
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 4096);
+	__uint(map_flags, BPF_F_MMAPABLE | BPF_F_RDONLY_PROG);
+	__type(key, __u32);
+	__type(value, char);
+} rdonly_map SEC(".maps");
+
 struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
 	__uint(max_entries, 512 * 4); /* at least 4 pages of data */

