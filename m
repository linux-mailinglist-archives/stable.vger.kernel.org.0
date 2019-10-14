Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 894D2D5E2D
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 11:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbfJNJI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 05:08:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44506 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730655AbfJNJI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 05:08:28 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C9BE081DE0
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 09:08:27 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id m6so4046046wmf.2
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 02:08:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Y8vGpJ+uYXLTzRHKyX0G/vWCD93jE1tqmfoJDvkG+qg=;
        b=O8BchaPED0fCc9GpMhaRpsif+aX3vpVNFPS/fmfkr8SsPVG5zgLsWl4N/rwkvYciOB
         Jrz6Cw3YSCspGRyfm5Rn4PeixFjAQR05+q/lMFCB12cSeBnk92C6MtcZ8+cwzA0ZyMBw
         zW6oQdmacXBvp3xDTd+Ghq634QhmbVQFoxDdMd7ccG+19EhgJLKLGzx6jDXQ1+nigOoU
         fYYi9/2dmgVvlMKul8dKql6Fm62g0CaoUwD+Qi7wBpPsLlX8W1ot+W1iClKK1DmR2qtG
         H6jWpIngnCR+pXBKhzDe6cza1unZ5edwEA8JMBnjUrJuUpOibYtzpM0qym6ujm8GSmX0
         IDyA==
X-Gm-Message-State: APjAAAVYW7Y1+Q+Ln0endeRSm5W41/ZMo5Z6nCNANtFCLWzBn8ARxT6H
        tc2s016SHaqwCQrYO9ojFLWJIKPbmr4nq01Lbuj1a9xoWsYcqSpDtV/dAy4AAoSh3DB48FCDvut
        wan6uBgUd1HNHAUcd
X-Received: by 2002:adf:db0e:: with SMTP id s14mr26049781wri.341.1571044106285;
        Mon, 14 Oct 2019 02:08:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzxN5wVdlzCREyqfxb2sHufN+1dTG6cMFHElwZZJ+CFe6Ox9j8OQpXmCbGBuKVpe2CSSKHfCg==
X-Received: by 2002:adf:db0e:: with SMTP id s14mr26049752wri.341.1571044106008;
        Mon, 14 Oct 2019 02:08:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id r2sm28271142wrm.3.2019.10.14.02.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 02:08:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     pbonzini@redhat.com
Cc:     bugzilla-daemon@bugzilla.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [Bug 205171] New: kernel panic during windows 10pro start
In-Reply-To: <bug-205171-28872@https.bugzilla.kernel.org/>
References: <bug-205171-28872@https.bugzilla.kernel.org/>
Date:   Mon, 14 Oct 2019 11:08:24 +0200
Message-ID: <87bluj66ev.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

bugzilla-daemon@bugzilla.kernel.org writes:

> https://bugzilla.kernel.org/show_bug.cgi?id=205171
>
>             Bug ID: 205171
>            Summary: kernel panic during windows 10pro start
>            Product: Virtualization
>            Version: unspecified
>     Kernel Version: 4.19.74 and higher
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: dront78@gmail.com
>         Regression: No
>
> works fine on 4.19.73
>
> [ 5829.948945] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000000
> [ 5829.948951] PGD 0 P4D 0 
> [ 5829.948954] Oops: 0002 [#1] SMP NOPTI
> [ 5829.948957] CPU: 3 PID: 1699 Comm: CPU 0/KVM Tainted: G           OE    
> 4.19.78-2-lts #1
> [ 5829.948958] Hardware name: Micro-Star International Co., Ltd. GE62
> 6QF/MS-16J4, BIOS E16J4IMS.117 01/18/2018
> [ 5829.948989] RIP: 0010:kvm_write_guest_virt_system+0x1e/0x40 [kvm]

It seems 4.19 stable backport is broken, upstream commit f7eea636c3d50
has:

@@ -4588,7 +4589,8 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
                                vmx_instruction_info, true, len, &gva))
                        return 1;
                /* _system ok, nested_vmx_check_permission has verified cpl=0 */
-               kvm_write_guest_virt_system(vcpu, gva, &field_value, len, NULL);
+               if (kvm_write_guest_virt_system(vcpu, gva, &field_value, len, &e))
+                       kvm_inject_page_fault(vcpu, &e);
        }

and it's 4.19 counterpart (73c31bd92039):

@@ -8798,8 +8799,10 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
                                vmx_instruction_info, true, &gva))
                        return 1;
                /* _system ok, nested_vmx_check_permission has verified cpl=0 */
-               kvm_write_guest_virt_system(vcpu, gva, &field_value,
-                                           (is_long_mode(vcpu) ? 8 : 4), NULL);
+               if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
+                                               (is_long_mode(vcpu) ? 8 : 4),
+                                               NULL))
+                       kvm_inject_page_fault(vcpu, &e);
        }
 
(note the last argument to kvm_write_guest_virt_system() - it's NULL
instead of &e.

And v4.19.74 has 6e60900cfa3e (541ab2aeb282 upstream):

@@ -5016,6 +5016,13 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
        /* kvm_write_guest_virt_system can pull in tons of pages. */
        vcpu->arch.l1tf_flush_l1d = true;
 
+       /*
+        * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
+        * is returned, but our callers are not ready for that and they blindly
+        * call kvm_inject_page_fault.  Ensure that they at least do not leak
+        * uninitialized kernel stack memory into cr2 and error code.
+        */
+       memset(exception, 0, sizeof(*exception));
        return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
                                           PFERR_WRITE_MASK, exception);
 }

This all results in memset(NULL). (also, 6e60900cfa3e should come
*after* f7eea636c3d50 and not before but oh well..)

The following will likely fix the problem (untested):

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e83f4f6bfdac..d3a900a4fa0e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8801,7 +8801,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
                /* _system ok, nested_vmx_check_permission has verified cpl=0 */
                if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
                                                (is_long_mode(vcpu) ? 8 : 4),
-                                               NULL))
+                                               &e))
                        kvm_inject_page_fault(vcpu, &e);
        }

I can send a patch to stable@ if needed.

-- 
Vitaly
