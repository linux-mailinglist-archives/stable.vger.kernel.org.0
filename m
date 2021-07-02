Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A87E3BA045
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 14:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhGBMYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 08:24:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:2691 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232173AbhGBMYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Jul 2021 08:24:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="230395973"
X-IronPort-AV: E=Sophos;i="5.83,317,1616482800"; 
   d="gz'50?scan'50,208,50";a="230395973"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 05:21:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,317,1616482800"; 
   d="gz'50?scan'50,208,50";a="409285142"
Received: from lkp-server01.sh.intel.com (HELO 4aae0cb4f5b5) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 02 Jul 2021 05:21:41 -0700
Received: from kbuild by 4aae0cb4f5b5 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lzIAu-000B4T-JI; Fri, 02 Jul 2021 12:21:40 +0000
Date:   Fri, 2 Jul 2021 20:21:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Mathias Nyman <mathias.nyman@intel.com>
Cc:     clang-built-linux@googlegroups.com, kbuild-all@lists.01.org,
        linux-usb@vger.kernel.org,
        Jonathan Bell <jonathan@raspberrypi.org>,
        stable@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH] xhci: add quirk for host controllers that don't update
 endpoint DCS
Message-ID: <202107022017.5cCgTiis-lkp@intel.com>
References: <20210702071338.42777-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210702071338.42777-1-bjorn@mork.no>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi "Bjørn,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on usb/usb-testing]
[also build test ERROR on v5.13 next-20210701]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Bj-rn-Mork/xhci-add-quirk-for-host-controllers-that-don-t-update-endpoint-DCS/20210702-151445
base:   https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
config: powerpc64-randconfig-r013-20210630 (attached as .config)
compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 9eb613b2de3163686b1a4bd1160f15ac56a4b083)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install powerpc64 cross compiling tool for clang build
        # apt-get install binutils-powerpc64-linux-gnu
        # https://github.com/0day-ci/linux/commit/61088f366a5c42caf8ce20c87355b61efc1b175d
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Bj-rn-Mork/xhci-add-quirk-for-host-controllers-that-don-t-update-endpoint-DCS/20210702-151445
        git checkout 61088f366a5c42caf8ce20c87355b61efc1b175d
        # save the attached .config to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross O=build_dir ARCH=powerpc SHELL=/bin/bash drivers/usb/host/ fs/kernfs/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from drivers/usb/host/xhci-ring.c:55:
   In file included from include/linux/scatterlist.h:7:
   In file included from include/linux/bug.h:5:
   In file included from arch/powerpc/include/asm/bug.h:109:
   In file included from include/asm-generic/bug.h:20:
   In file included from include/linux/kernel.h:12:
   In file included from include/linux/bitops.h:32:
   In file included from arch/powerpc/include/asm/bitops.h:62:
   arch/powerpc/include/asm/barrier.h:49:9: warning: '__lwsync' macro redefined [-Wmacro-redefined]
   #define __lwsync()      __asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
           ^
   <built-in>:308:9: note: previous definition is here
   #define __lwsync __builtin_ppc_lwsync
           ^
>> drivers/usb/host/xhci-ring.c:613:32: error: use of undeclared identifier 'cur_td'
                   halted_seg = trb_in_td(xhci, cur_td->start_seg,
                                                ^
   drivers/usb/host/xhci-ring.c:614:12: error: use of undeclared identifier 'cur_td'
                                          cur_td->first_trb, cur_td->last_trb,
                                          ^
   drivers/usb/host/xhci-ring.c:614:31: error: use of undeclared identifier 'cur_td'
                                          cur_td->first_trb, cur_td->last_trb,
                                                             ^
>> drivers/usb/host/xhci-ring.c:620:3: error: use of undeclared identifier 'state'
                   state->new_cycle_state = halted_trb->generic.field[3] & 0x1;
                   ^
   drivers/usb/host/xhci-ring.c:623:5: error: use of undeclared identifier 'state'
                            state->new_cycle_state);
                            ^
   drivers/usb/host/xhci-ring.c:625:3: error: use of undeclared identifier 'state'
                   state->new_cycle_state = hw_dequeue & 0x1;
                   ^
   drivers/usb/host/xhci-ring.c:627:2: error: use of undeclared identifier 'state'
           state->stream_id = stream_id;
           ^
   1 warning and 7 errors generated.


vim +/cur_td +613 drivers/usb/host/xhci-ring.c

   552	
   553	static int xhci_move_dequeue_past_td(struct xhci_hcd *xhci,
   554					unsigned int slot_id, unsigned int ep_index,
   555					unsigned int stream_id, struct xhci_td *td)
   556	{
   557		struct xhci_virt_device *dev = xhci->devs[slot_id];
   558		struct xhci_virt_ep *ep = &dev->eps[ep_index];
   559		struct xhci_ring *ep_ring;
   560		struct xhci_command *cmd;
   561		struct xhci_segment *new_seg;
   562		struct xhci_segment *halted_seg = NULL;
   563		union xhci_trb *new_deq;
   564		int new_cycle;
   565		union xhci_trb *halted_trb;
   566		int index = 0;
   567		dma_addr_t addr;
   568		u64 hw_dequeue;
   569		bool cycle_found = false;
   570		bool td_last_trb_found = false;
   571		u32 trb_sct = 0;
   572		int ret;
   573	
   574		ep_ring = xhci_triad_to_transfer_ring(xhci, slot_id,
   575				ep_index, stream_id);
   576		if (!ep_ring) {
   577			xhci_warn(xhci, "WARN can't find new dequeue, invalid stream ID %u\n",
   578				  stream_id);
   579			return -ENODEV;
   580		}
   581		/*
   582		 * A cancelled TD can complete with a stall if HW cached the trb.
   583		 * In this case driver can't find td, but if the ring is empty we
   584		 * can move the dequeue pointer to the current enqueue position.
   585		 * We shouldn't hit this anymore as cached cancelled TRBs are given back
   586		 * after clearing the cache, but be on the safe side and keep it anyway
   587		 */
   588		if (!td) {
   589			if (list_empty(&ep_ring->td_list)) {
   590				new_seg = ep_ring->enq_seg;
   591				new_deq = ep_ring->enqueue;
   592				new_cycle = ep_ring->cycle_state;
   593				xhci_dbg(xhci, "ep ring empty, Set new dequeue = enqueue");
   594				goto deq_found;
   595			} else {
   596				xhci_warn(xhci, "Can't find new dequeue state, missing td\n");
   597				return -EINVAL;
   598			}
   599		}
   600	
   601		hw_dequeue = xhci_get_hw_deq(xhci, dev, ep_index, stream_id);
   602		new_seg = ep_ring->deq_seg;
   603		new_deq = ep_ring->dequeue;
   604		new_cycle = hw_dequeue & 0x1;
   605	
   606		/*
   607		 * Quirk: xHC write-back of the DCS field in the hardware dequeue
   608		 * pointer is wrong - use the cycle state of the TRB pointed to by
   609		 * the dequeue pointer.
   610		 */
   611		if (xhci->quirks & XHCI_EP_CTX_BROKEN_DCS &&
   612		    !(ep->ep_state & EP_HAS_STREAMS))
 > 613			halted_seg = trb_in_td(xhci, cur_td->start_seg,
   614					       cur_td->first_trb, cur_td->last_trb,
   615					       hw_dequeue & ~0xf, false);
   616		if (halted_seg) {
   617			index = ((dma_addr_t)(hw_dequeue & ~0xf) - halted_seg->dma) /
   618				 sizeof(*halted_trb);
   619			halted_trb = &halted_seg->trbs[index];
 > 620			state->new_cycle_state = halted_trb->generic.field[3] & 0x1;
   621			xhci_dbg(xhci, "Endpoint DCS = %d TRB index = %d cycle = %d\n",
   622				 (u8)(hw_dequeue & 0x1), index,
   623				 state->new_cycle_state);
   624		} else {
   625			state->new_cycle_state = hw_dequeue & 0x1;
   626		}
   627		state->stream_id = stream_id;
   628	
   629		/*
   630		 * We want to find the pointer, segment and cycle state of the new trb
   631		 * (the one after current TD's last_trb). We know the cycle state at
   632		 * hw_dequeue, so walk the ring until both hw_dequeue and last_trb are
   633		 * found.
   634		 */
   635		do {
   636			if (!cycle_found && xhci_trb_virt_to_dma(new_seg, new_deq)
   637			    == (dma_addr_t)(hw_dequeue & ~0xf)) {
   638				cycle_found = true;
   639				if (td_last_trb_found)
   640					break;
   641			}
   642			if (new_deq == td->last_trb)
   643				td_last_trb_found = true;
   644	
   645			if (cycle_found && trb_is_link(new_deq) &&
   646			    link_trb_toggles_cycle(new_deq))
   647				new_cycle ^= 0x1;
   648	
   649			next_trb(xhci, ep_ring, &new_seg, &new_deq);
   650	
   651			/* Search wrapped around, bail out */
   652			if (new_deq == ep->ring->dequeue) {
   653				xhci_err(xhci, "Error: Failed finding new dequeue state\n");
   654				return -EINVAL;
   655			}
   656	
   657		} while (!cycle_found || !td_last_trb_found);
   658	
   659	deq_found:
   660	
   661		/* Don't update the ring cycle state for the producer (us). */
   662		addr = xhci_trb_virt_to_dma(new_seg, new_deq);
   663		if (addr == 0) {
   664			xhci_warn(xhci, "Can't find dma of new dequeue ptr\n");
   665			xhci_warn(xhci, "deq seg = %p, deq ptr = %p\n", new_seg, new_deq);
   666			return -EINVAL;
   667		}
   668	
   669		if ((ep->ep_state & SET_DEQ_PENDING)) {
   670			xhci_warn(xhci, "Set TR Deq already pending, don't submit for 0x%pad\n",
   671				  &addr);
   672			return -EBUSY;
   673		}
   674	
   675		/* This function gets called from contexts where it cannot sleep */
   676		cmd = xhci_alloc_command(xhci, false, GFP_ATOMIC);
   677		if (!cmd) {
   678			xhci_warn(xhci, "Can't alloc Set TR Deq cmd 0x%pad\n", &addr);
   679			return -ENOMEM;
   680		}
   681	
   682		if (stream_id)
   683			trb_sct = SCT_FOR_TRB(SCT_PRI_TR);
   684		ret = queue_command(xhci, cmd,
   685			lower_32_bits(addr) | trb_sct | new_cycle,
   686			upper_32_bits(addr),
   687			STREAM_ID_FOR_TRB(stream_id), SLOT_ID_FOR_TRB(slot_id) |
   688			EP_ID_FOR_TRB(ep_index) | TRB_TYPE(TRB_SET_DEQ), false);
   689		if (ret < 0) {
   690			xhci_free_command(xhci, cmd);
   691			return ret;
   692		}
   693		ep->queued_deq_seg = new_seg;
   694		ep->queued_deq_ptr = new_deq;
   695	
   696		xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
   697			       "Set TR Deq ptr 0x%llx, cycle %u\n", addr, new_cycle);
   698	
   699		/* Stop the TD queueing code from ringing the doorbell until
   700		 * this command completes.  The HC won't set the dequeue pointer
   701		 * if the ring is running, and ringing the doorbell starts the
   702		 * ring running.
   703		 */
   704		ep->ep_state |= SET_DEQ_PENDING;
   705		xhci_ring_cmd_db(xhci);
   706		return 0;
   707	}
   708	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--J/dobhs11T7y2rNN
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--J/dobhs11T7y2rNN--
