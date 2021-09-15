Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED78740C568
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 14:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbhIOMlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 08:41:03 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:35611 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234331AbhIOMlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 08:41:03 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 55CF932009C4;
        Wed, 15 Sep 2021 08:39:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 15 Sep 2021 08:39:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=anq4my38VxpmhyCZ2E2/QGU2BQg
        88QWfeXmMzvtQi0w=; b=lrOVr4VyUjl2hLICKAt8tfrN7QMcMRJyy+VK3390gFl
        7TqHP2M0MRliQJSlQm+37JBN7SbB3nq/JLX1M5B1MLQloh6m+TeBrg3j0Kpghqvl
        M5O+ybLbCmJK5Bu6bDJfCQ1BWuoVYfmpgimQoV9unS03N4sMnV/qdcKEEUb6mMx6
        aE9Nakn+ea3psvOnOfyTUwO2x8yHEZpJY+33w4Qd28wVCOuWZ376LP1hHg3vpHpx
        Hd5zCKfXoeMNxFMM0veSlJOiv2wvPIgbH1Xqxvb6JxiUqfWtRD7CkgFmG0hEYBcI
        B122QHqK6ydUAVlMWukAIRxotwV7sW3cSSazl4bwHRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=anq4my
        38VxpmhyCZ2E2/QGU2BQg88QWfeXmMzvtQi0w=; b=tooSXNCS134k861NLa+b2y
        A904iUWGOrHkd3VM9a/mszoR71VYSMWJCpVHXl9/krqc1p4zYQGZKrDZVBfrR7ml
        8Yl/BwgfTr9Qk1frWvU9LBAnZOc7I2+ssp3gDKqax+jTKhY3gvvNfrxOfHaEh3IY
        NXZI67j32pOwXHlnhUyji+2oJwq+8X/877pIBiEemuNAqXU9JcmxpsCulkk1QCm6
        5nxtQT/RqP8se0svaq4y5/kDSAqJkyTIERnrpv9iQX0a4XLcf4ca8QZovui5UA8d
        vCGy3CQZ0GwdC/+ryeDlp7tn1igvmkzVLGR9MaiG1LmBXW9Hs3t+fG7gHdiyL1Vg
        ==
X-ME-Sender: <xms:julBYcbxZJG_9qnxBIygLn_XJ6T-ipIaNmuVFdaoqcOTCg9vnGXy4w>
    <xme:julBYXbxsHfe-dxoB7BkVjc82fpbdWrl0j9C_eFc3_qgB40MrmfA3-Oe8yp385oRY
    UnXigRDU6ZW6Q>
X-ME-Received: <xmr:julBYW8rb9M7jVcZoLe3qhUClZSjlJRPE5BbS8cRclwCSy-JkgbogyAysdRT85k1Qrm4lKh68WUTBoAveXWsvb3NkSGC8gGv>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehuddgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:julBYWqkknjA1N2kokRYVPObO_MJSpizbiWTc7T3VLzjVYYc2GSHvA>
    <xmx:julBYXoBI9CoY1vSwH3MvQUyMgRza_kG4PPlBbjNGQwpphBdJMbWZw>
    <xmx:julBYUTZmbs3oNtkNVmbl3rDYj2B8Q20KLgcf9WakyZcecRhvnLK_w>
    <xmx:julBYYdUqi1Wm1EGTfIbVcbbNxoJp8wNvR650Pjn6GRkb48o2IT-xA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Sep 2021 08:39:42 -0400 (EDT)
Date:   Wed, 15 Sep 2021 14:39:39 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH 4.19 00/13] bpf: backport fixes for
 CVE-2021-34556/CVE-2021-35477
Message-ID: <YUHpi57yv6DX/AtN@kroah.com>
References: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 06:35:24PM +0300, Ovidiu Panait wrote:
> Backport summary
> ----------------
> 679c782de14b ("bpf/verifier: per-register parent pointers")
> 	* Context patch for 2039f26f3aca5 ("bpf: Fix leakage due to
> 	  insufficient speculative store bypass mitigation").
> 	* Context adjustments because of the code added by post-4.19 commit:
> 	  f92a819b4cbef ("bpf: prevent out of bounds speculation on pointer
> 	  arithmetic").
> 
> 0bae2d4d62d5 ("bpf: correct slot_type marking logic to allow more stack slot sharing")
> 	* Context patch for 2039f26f3aca5 ("bpf: Fix leakage due to
> 	  insufficient speculative store bypass mitigation").
> 	* Minor context adjustement in selftest.
> 
> 2011fccfb61b ("bpf: Support variable offset stack access from helpers")
> 	* Context patch for 2039f26f3aca5 ("bpf: Fix leakage due to
> 	  insufficient speculative store bypass mitigation").
> 	* 4.19 does not have the reg_state(env, regno) helper defined, so
> 	  replace the call with "cur_regs(env) + regno".
> 
> f2bcd05ec7b8 ("bpf: Reject indirect var_off stack access in raw mode")
> 	* Follow-up fix for 2011fccfb61bb ("bpf: Support variable offset stack
> 	  access from helpers").
> 	* Clean cherry-pick.
> 
> 088ec26d9c2d ("bpf: Reject indirect var_off stack access in unpriv")
> 	* Follow-up fix for 2011fccfb61bb ("bpf: Support variable offset stack
> 	  access from helpers").
> 	* Drop comment in retrieve_ptr_limit(), as it was made obsolete by
> 	  post-4.19 commit 45bfdd767e235 ("bpf: Tighten speculative pointer
> 	  arithmetic mask").
> 
> 107c26a70ca8 ("bpf: Sanity check max value for var_off stack access")
> 	* Follow-up fix for 2011fccfb61bb ("bpf: Support variable offset stack
> 	  access from helpers").
> 	* Clean cherry-pick.
> 
> 8ff80e96e3cc ("selftests/bpf: Test variable offset stack access")
> 	* Selftest follow-up for 2011fccfb61bb ("bpf: Support variable offset
> 	  stack access from helpers").
> 	* Post-4.19, the verifier tests were split into different
> 	  files, in 4.19 they are still all in test_verifier.c, so apply the
> 	  changes manually.
> 
> f7cf25b2026d ("bpf: track spill/fill of constants")
> 	* Context patch for 2039f26f3aca5 ("bpf: Fix leakage due to
> 	  insufficient speculative store bypass mitigation").
> 	* Drop verbose_linfo() calls, as the function is not implemented in 4.19.
> 	* Adjust mark_reg_read() calls to match the prototype in 4.19.
> 	  (mark_reg_read() was changed to take 4 parameters in post-4.19 commit
> 	  5327ed3d44b75("bpf: verifier: mark verified-insn with sub-register
> 	  zext flag"), but backporting it is out of scope for this patchseries).
> 
> fc559a70d57c ("selftests/bpf: fix tests due to const spill/fill")
> 	* Selftest follow-up for f7cf25b2026d ("bpf: track spill/fill of constants").
> 	* Post-4.19, the verifier tests were split into different
> 	  files, in 4.19 they are still all in test_verifier.c, so apply the
> 	  changes manually.
> 
> f5e81d111750 ("bpf: Introduce BPF nospec instruction for mitigating Spectre v4")
> 	* Contextual adjustments.
> 	* Drop arch/powerpc/net/bpf_jit_comp32.c changes, as the file is not
> 	  present in 4.19
> 	* Drop riscv changes, as arch/riscv/net/bpf_jit_comp.c file is not
> 	  present in 4.19
> 
> 2039f26f3aca ("bpf: Fix leakage due to insufficient speculative store bypass mitigation")
> 	* Contextual adjustments.
> 	* Apply check_stack_write_fixed_off() changes in check_stack_write().
> 	* Replace env->bypass_spec_v4 -> env->allow_ptr_leaks.
> 
> c9e73e3d2b1e ("bpf: verifier: Allocate idmap scratch in verifier env")
> e042aa532c84 ("bpf: Fix pointer arithmetic mask tightening under state")
> 	* Contextual adjustments.
> 
> With this patchseries all bpf verifier selftests pass (tested in qemu for x86_64):
> root@intel-x86-64:~# ./test_verifier
> ...
> #663/p pass modified ctx pointer to helper, 3 OK
> #664/p mov64 src == dst OK
> #665/p mov64 src != dst OK
> #666/u calls: ctx read at start of subprog OK
> #666/p calls: ctx read at start of subprog OK
> Summary: 932 PASSED, 0 SKIPPED, 0 FAILED
> 

All now queued up, thanks for the backports!

greg k-h
