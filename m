Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE16A4F1912
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 18:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242759AbiDDQCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 12:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239218AbiDDQCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 12:02:25 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9A624F04
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 09:00:28 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:57496)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nbP7z-00A6kI-IN; Mon, 04 Apr 2022 10:00:27 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:42098 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nbP7x-003Uid-NA; Mon, 04 Apr 2022 10:00:26 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     <gregkh@linuxfoundation.org>
Cc:     keescook@chromium.org, willy@infradead.org,
        <stable@vger.kernel.org>
References: <164889939941112@kroah.com>
Date:   Mon, 04 Apr 2022 11:00:19 -0500
In-Reply-To: <164889939941112@kroah.com> (gregkh@linuxfoundation.org's message
        of "Sat, 02 Apr 2022 13:36:39 +0200")
Message-ID: <87mth0kfe4.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nbP7x-003Uid-NA;;;mid=<87mth0kfe4.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/DpXz8Ln5aU+Fb7s3wJ5UWlxu9zE9cqgQ=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 753 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 12 (1.6%), b_tie_ro: 10 (1.3%), parse: 1.37
        (0.2%), extract_message_metadata: 28 (3.7%), get_uri_detail_list: 4.5
        (0.6%), tests_pri_-1000: 50 (6.7%), tests_pri_-950: 1.75 (0.2%),
        tests_pri_-900: 1.61 (0.2%), tests_pri_-90: 121 (16.1%), check_bayes:
        118 (15.6%), b_tokenize: 14 (1.9%), b_tok_get_all: 13 (1.7%),
        b_comp_prob: 4.1 (0.5%), b_tok_touch_all: 82 (10.9%), b_finish: 1.03
        (0.1%), tests_pri_0: 518 (68.8%), check_dkim_signature: 1.20 (0.2%),
        check_dkim_adsp: 4.4 (0.6%), poll_dns_idle: 0.46 (0.1%), tests_pri_10:
        2.2 (0.3%), tests_pri_500: 13 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: FAILED: patch "[PATCH] coredump: Use the vma snapshot in
 fill_files_note" failed to apply to 5.17-stable tree
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

<gregkh@linuxfoundation.org> writes:

> The patch below does not apply to the 5.17-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I believe it requires backporting these first.

commit 84158b7f6a06 ("coredump: Also dump first pages of non-executable ELF libraries")
commit 95c5436a4883 ("coredump: Snapshot the vmas in do_coredump")
commit 49c1866348f3 ("coredump: Remove the WARN_ON in dump_vma_snapshot")

The first is a more interesting bug fix from Jann Horn.
The other two are prerequisite cleanup-patches.

I will let other folks judge how concerned they are about missing
locking that was detected by code review.


Eric


> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From 390031c942116d4733310f0684beb8db19885fe6 Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Tue, 8 Mar 2022 13:04:19 -0600
> Subject: [PATCH] coredump: Use the vma snapshot in fill_files_note
>
> Matthew Wilcox reported that there is a missing mmap_lock in
> file_files_note that could possibly lead to a user after free.
>
> Solve this by using the existing vma snapshot for consistency
> and to avoid the need to take the mmap_lock anywhere in the
> coredump code except for dump_vma_snapshot.
>
> Update the dump_vma_snapshot to capture vm_pgoff and vm_file
> that are neeeded by fill_files_note.
>
> Add free_vma_snapshot to free the captured values of vm_file.
>
> Reported-by: Matthew Wilcox <willy@infradead.org>
> Link: https://lkml.kernel.org/r/20220131153740.2396974-1-willy@infradead.org
> Cc: stable@vger.kernel.org
> Fixes: a07279c9a8cd ("binfmt_elf, binfmt_elf_fdpic: use a VMA list snapshot")
> Fixes: 2aa362c49c31 ("coredump: extend core dump note section to contain file names of mapped files")
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 7f0c391832cf..ca5296cae979 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1641,17 +1641,16 @@ static void fill_siginfo_note(struct memelfnote *note, user_siginfo_t *csigdata,
>   *   long file_ofs
>   * followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...
>   */
> -static int fill_files_note(struct memelfnote *note)
> +static int fill_files_note(struct memelfnote *note, struct coredump_params *cprm)
>  {
> -	struct mm_struct *mm = current->mm;
> -	struct vm_area_struct *vma;
>  	unsigned count, size, names_ofs, remaining, n;
>  	user_long_t *data;
>  	user_long_t *start_end_ofs;
>  	char *name_base, *name_curpos;
> +	int i;
>  
>  	/* *Estimated* file count and total data size needed */
> -	count = mm->map_count;
> +	count = cprm->vma_count;
>  	if (count > UINT_MAX / 64)
>  		return -EINVAL;
>  	size = count * 64;
> @@ -1673,11 +1672,12 @@ static int fill_files_note(struct memelfnote *note)
>  	name_base = name_curpos = ((char *)data) + names_ofs;
>  	remaining = size - names_ofs;
>  	count = 0;
> -	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
> +	for (i = 0; i < cprm->vma_count; i++) {
> +		struct core_vma_metadata *m = &cprm->vma_meta[i];
>  		struct file *file;
>  		const char *filename;
>  
> -		file = vma->vm_file;
> +		file = m->file;
>  		if (!file)
>  			continue;
>  		filename = file_path(file, name_curpos, remaining);
> @@ -1697,9 +1697,9 @@ static int fill_files_note(struct memelfnote *note)
>  		memmove(name_curpos, filename, n);
>  		name_curpos += n;
>  
> -		*start_end_ofs++ = vma->vm_start;
> -		*start_end_ofs++ = vma->vm_end;
> -		*start_end_ofs++ = vma->vm_pgoff;
> +		*start_end_ofs++ = m->start;
> +		*start_end_ofs++ = m->end;
> +		*start_end_ofs++ = m->pgoff;
>  		count++;
>  	}
>  
> @@ -1710,7 +1710,7 @@ static int fill_files_note(struct memelfnote *note)
>  	 * Count usually is less than mm->map_count,
>  	 * we need to move filenames down.
>  	 */
> -	n = mm->map_count - count;
> +	n = cprm->vma_count - count;
>  	if (n != 0) {
>  		unsigned shift_bytes = n * 3 * sizeof(data[0]);
>  		memmove(name_base - shift_bytes, name_base,
> @@ -1909,7 +1909,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
>  	fill_auxv_note(&info->auxv, current->mm);
>  	info->size += notesize(&info->auxv);
>  
> -	if (fill_files_note(&info->files) == 0)
> +	if (fill_files_note(&info->files, cprm) == 0)
>  		info->size += notesize(&info->files);
>  
>  	return 1;
> @@ -2098,7 +2098,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
>  	fill_auxv_note(info->notes + 3, current->mm);
>  	info->numnote = 4;
>  
> -	if (fill_files_note(info->notes + info->numnote) == 0) {
> +	if (fill_files_note(info->notes + info->numnote, cprm) == 0) {
>  		info->notes_files = info->notes + info->numnote;
>  		info->numnote++;
>  	}
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 7f100a637264..7ed7d601e5e0 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -55,6 +55,7 @@
>  #include <trace/events/sched.h>
>  
>  static bool dump_vma_snapshot(struct coredump_params *cprm);
> +static void free_vma_snapshot(struct coredump_params *cprm);
>  
>  static int core_uses_pid;
>  static unsigned int core_pipe_limit;
> @@ -765,7 +766,7 @@ void do_coredump(const kernel_siginfo_t *siginfo)
>  			dump_emit(&cprm, "", 1);
>  		}
>  		file_end_write(cprm.file);
> -		kvfree(cprm.vma_meta);
> +		free_vma_snapshot(&cprm);
>  	}
>  	if (ispipe && core_pipe_limit)
>  		wait_for_dump_helpers(cprm.file);
> @@ -1099,6 +1100,20 @@ static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
>  	return gate_vma;
>  }
>  
> +static void free_vma_snapshot(struct coredump_params *cprm)
> +{
> +	if (cprm->vma_meta) {
> +		int i;
> +		for (i = 0; i < cprm->vma_count; i++) {
> +			struct file *file = cprm->vma_meta[i].file;
> +			if (file)
> +				fput(file);
> +		}
> +		kvfree(cprm->vma_meta);
> +		cprm->vma_meta = NULL;
> +	}
> +}
> +
>  /*
>   * Under the mmap_lock, take a snapshot of relevant information about the task's
>   * VMAs.
> @@ -1135,6 +1150,11 @@ static bool dump_vma_snapshot(struct coredump_params *cprm)
>  		m->end = vma->vm_end;
>  		m->flags = vma->vm_flags;
>  		m->dump_size = vma_dump_size(vma, cprm->mm_flags);
> +		m->pgoff = vma->vm_pgoff;
> +
> +		m->file = vma->vm_file;
> +		if (m->file)
> +			get_file(m->file);
>  	}
>  
>  	mmap_write_unlock(mm);
> diff --git a/include/linux/coredump.h b/include/linux/coredump.h
> index 7d05370e555e..08a1d3e7e46d 100644
> --- a/include/linux/coredump.h
> +++ b/include/linux/coredump.h
> @@ -12,6 +12,8 @@ struct core_vma_metadata {
>  	unsigned long start, end;
>  	unsigned long flags;
>  	unsigned long dump_size;
> +	unsigned long pgoff;
> +	struct file   *file;
>  };
>  
>  struct coredump_params {
