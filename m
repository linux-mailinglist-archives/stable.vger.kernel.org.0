Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C85548F4D6
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 05:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbiAOE7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 23:59:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:52808 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230197AbiAOE7n (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jan 2022 23:59:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642222783; x=1673758783;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y7vHzljmhWmZs4NuLlIJ2mDabFIEbEZUNhxDv2TKE+A=;
  b=iDlskJNoSubCGjXuTYxLbYn8utCqiRzbibbQFlNXCnxl9m5G5hOQl8aU
   GDG5eSMEzyQy2PiJENDCKqMHB8pRxPaO60zXw51Fpe1aHQQeAsLyeS8JD
   7Rwd7K/TwmOOiyYoNga0uM3q8YPqlKpWbxKVaID6MN33mmk48OdOe2q+7
   2tuR6kf1hN6Dun3OLypKIJzeQXi9Y+kO8L16UGNLp2IB/GAWF+qVluUe2
   e5WyUA6baNdylnZJkBlHJaWp44b6KSxXPvrcnpKMrCc85OnSI2RdCgQx5
   XCUL4xKgErXYX9GGoTtVh8dslT5tAbLGJ0vsw8WR6yZk0anoQCYQN7Xeo
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10227"; a="244335390"
X-IronPort-AV: E=Sophos;i="5.88,290,1635231600"; 
   d="scan'208";a="244335390"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 20:59:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,290,1635231600"; 
   d="scan'208";a="476013428"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 14 Jan 2022 20:59:40 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n8bAC-0009PD-9n; Sat, 15 Jan 2022 04:59:40 +0000
Date:   Sat, 15 Jan 2022 12:58:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4.y] Revert "ia64: kprobes: Use generic kretprobe
 trampoline handler"
Message-ID: <202201151231.g2sW8oWt-lkp@intel.com>
References: <164215559880.1662358.1475310445318313122.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164215559880.1662358.1475310445318313122.stgit@devnote2>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Masami,

I love your patch! Perhaps something to improve:

[auto build test WARNING on stable/linux-5.4.y]

url:    https://github.com/0day-ci/linux/commits/Masami-Hiramatsu/Revert-ia64-kprobes-Use-generic-kretprobe-trampoline-handler/20220114-182111
base:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
config: ia64-allmodconfig (https://download.01.org/0day-ci/archive/20220115/202201151231.g2sW8oWt-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/514059de80b018e0edcf434519ff6bf41b4a519b
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Masami-Hiramatsu/Revert-ia64-kprobes-Use-generic-kretprobe-trampoline-handler/20220114-182111
        git checkout 514059de80b018e0edcf434519ff6bf41b4a519b
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=ia64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   arch/ia64/kernel/kprobes.c: In function 'get_kprobe_inst':
   arch/ia64/kernel/kprobes.c:325:22: warning: variable 'template' set but not used [-Wunused-but-set-variable]
     325 |         unsigned int template;
         |                      ^~~~~~~~
   arch/ia64/kernel/kprobes.c: At top level:
   arch/ia64/kernel/kprobes.c:407:15: warning: no previous prototype for 'trampoline_probe_handler' [-Wmissing-prototypes]
     407 | int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
         |               ^~~~~~~~~~~~~~~~~~~~~~~~
   arch/ia64/kernel/kprobes.c: In function 'trampoline_probe_handler':
>> arch/ia64/kernel/kprobes.c:414:17: warning: initialization of 'long unsigned int' from 'void *' makes integer from pointer without a cast [-Wint-conversion]
     414 |                 dereference_function_descriptor(kretprobe_trampoline);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for FRAME_POINTER
   Depends on DEBUG_KERNEL && (M68K || UML || SUPERH) || ARCH_WANT_FRAME_POINTERS
   Selected by
   - FAULT_INJECTION_STACKTRACE_FILTER && FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT && !X86_64 && !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM && !ARC && !X86


vim +414 arch/ia64/kernel/kprobes.c

   320	
   321	static void __kprobes get_kprobe_inst(bundle_t *bundle, uint slot,
   322		       	unsigned long *kprobe_inst, uint *major_opcode)
   323	{
   324		unsigned long kprobe_inst_p0, kprobe_inst_p1;
 > 325		unsigned int template;
   326	
   327		template = bundle->quad0.template;
   328	
   329		switch (slot) {
   330		  case 0:
   331			*major_opcode = (bundle->quad0.slot0 >> SLOT0_OPCODE_SHIFT);
   332			*kprobe_inst = bundle->quad0.slot0;
   333			  break;
   334		  case 1:
   335			*major_opcode = (bundle->quad1.slot1_p1 >> SLOT1_p1_OPCODE_SHIFT);
   336			kprobe_inst_p0 = bundle->quad0.slot1_p0;
   337			kprobe_inst_p1 = bundle->quad1.slot1_p1;
   338			*kprobe_inst = kprobe_inst_p0 | (kprobe_inst_p1 << (64-46));
   339			break;
   340		  case 2:
   341			*major_opcode = (bundle->quad1.slot2 >> SLOT2_OPCODE_SHIFT);
   342			*kprobe_inst = bundle->quad1.slot2;
   343			break;
   344		}
   345	}
   346	
   347	/* Returns non-zero if the addr is in the Interrupt Vector Table */
   348	static int __kprobes in_ivt_functions(unsigned long addr)
   349	{
   350		return (addr >= (unsigned long)__start_ivt_text
   351			&& addr < (unsigned long)__end_ivt_text);
   352	}
   353	
   354	static int __kprobes valid_kprobe_addr(int template, int slot,
   355					       unsigned long addr)
   356	{
   357		if ((slot > 2) || ((bundle_encoding[template][1] == L) && slot > 1)) {
   358			printk(KERN_WARNING "Attempting to insert unaligned kprobe "
   359					"at 0x%lx\n", addr);
   360			return -EINVAL;
   361		}
   362	
   363		if (in_ivt_functions(addr)) {
   364			printk(KERN_WARNING "Kprobes can't be inserted inside "
   365					"IVT functions at 0x%lx\n", addr);
   366			return -EINVAL;
   367		}
   368	
   369		return 0;
   370	}
   371	
   372	static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
   373	{
   374		unsigned int i;
   375		i = atomic_add_return(1, &kcb->prev_kprobe_index);
   376		kcb->prev_kprobe[i-1].kp = kprobe_running();
   377		kcb->prev_kprobe[i-1].status = kcb->kprobe_status;
   378	}
   379	
   380	static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
   381	{
   382		unsigned int i;
   383		i = atomic_read(&kcb->prev_kprobe_index);
   384		__this_cpu_write(current_kprobe, kcb->prev_kprobe[i-1].kp);
   385		kcb->kprobe_status = kcb->prev_kprobe[i-1].status;
   386		atomic_sub(1, &kcb->prev_kprobe_index);
   387	}
   388	
   389	static void __kprobes set_current_kprobe(struct kprobe *p,
   390				struct kprobe_ctlblk *kcb)
   391	{
   392		__this_cpu_write(current_kprobe, p);
   393	}
   394	
   395	static void kretprobe_trampoline(void)
   396	{
   397	}
   398	
   399	/*
   400	 * At this point the target function has been tricked into
   401	 * returning into our trampoline.  Lookup the associated instance
   402	 * and then:
   403	 *    - call the handler function
   404	 *    - cleanup by marking the instance as unused
   405	 *    - long jump back to the original return address
   406	 */
   407	int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
   408	{
   409		struct kretprobe_instance *ri = NULL;
   410		struct hlist_head *head, empty_rp;
   411		struct hlist_node *tmp;
   412		unsigned long flags, orig_ret_address = 0;
   413		unsigned long trampoline_address =
 > 414			dereference_function_descriptor(kretprobe_trampoline);
   415	
   416		INIT_HLIST_HEAD(&empty_rp);
   417		kretprobe_hash_lock(current, &head, &flags);
   418	
   419		/*
   420		 * It is possible to have multiple instances associated with a given
   421		 * task either because an multiple functions in the call path
   422		 * have a return probe installed on them, and/or more than one return
   423		 * return probe was registered for a target function.
   424		 *
   425		 * We can handle this because:
   426		 *     - instances are always inserted at the head of the list
   427		 *     - when multiple return probes are registered for the same
   428		 *       function, the first instance's ret_addr will point to the
   429		 *       real return address, and all the rest will point to
   430		 *       kretprobe_trampoline
   431		 */
   432		hlist_for_each_entry_safe(ri, tmp, head, hlist) {
   433			if (ri->task != current)
   434				/* another task is sharing our hash bucket */
   435				continue;
   436	
   437			orig_ret_address = (unsigned long)ri->ret_addr;
   438			if (orig_ret_address != trampoline_address)
   439				/*
   440				 * This is the real return address. Any other
   441				 * instances associated with this task are for
   442				 * other calls deeper on the call stack
   443				 */
   444				break;
   445		}
   446	
   447		regs->cr_iip = orig_ret_address;
   448	
   449		hlist_for_each_entry_safe(ri, tmp, head, hlist) {
   450			if (ri->task != current)
   451				/* another task is sharing our hash bucket */
   452				continue;
   453	
   454			if (ri->rp && ri->rp->handler)
   455				ri->rp->handler(ri, regs);
   456	
   457			orig_ret_address = (unsigned long)ri->ret_addr;
   458			recycle_rp_inst(ri, &empty_rp);
   459	
   460			if (orig_ret_address != trampoline_address)
   461				/*
   462				 * This is the real return address. Any other
   463				 * instances associated with this task are for
   464				 * other calls deeper on the call stack
   465				 */
   466				break;
   467		}
   468		kretprobe_assert(ri, orig_ret_address, trampoline_address);
   469	
   470		kretprobe_hash_unlock(current, &flags);
   471	
   472		hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
   473			hlist_del(&ri->hlist);
   474			kfree(ri);
   475		}
   476		/*
   477		 * By returning a non-zero value, we are telling
   478		 * kprobe_handler() that we don't want the post_handler
   479		 * to run (and have re-enabled preemption)
   480		 */
   481		return 1;
   482	}
   483	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
