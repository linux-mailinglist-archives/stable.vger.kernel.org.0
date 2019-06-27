Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE28258A73
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 20:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfF0S6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 14:58:23 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38181 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfF0S6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 14:58:23 -0400
Received: by mail-ot1-f67.google.com with SMTP id d17so3388954oth.5
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 11:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Buh4vYpE7LbYuKttCx2Cpr/a4GmgOyG3kH9utY0SGvg=;
        b=UVzm5lEwjmSVdXZ/dYYxW4VxfyylgZoSDFKKznMhT/DZQDkRdkfD4dF/nEqGh68zaM
         +3YpvYStDIekqEbuXuBZN58wRAUHTVoiBHVKl+9NGKGF/kpEmlvFH15MPa+nTCB+74r8
         V/EpgUV/qh9XsZwcMwyXnBdQeDazJdE03aVafP+sfQpPouimkrNjlyd7/gYgRIZu5SZ9
         nLrnX7WKLJGDNHyGUs9E1D2GFupQzbXMXIh3hcXuarKwBOdUsZk92+XY2xehCf36rcsP
         GTTy6vXV6xZOaQ3hr/cm0XuWVAUgklXz1YC4JsFJrKhPgZI1KsLncL6rQ/rn3/Vt15LE
         scxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Buh4vYpE7LbYuKttCx2Cpr/a4GmgOyG3kH9utY0SGvg=;
        b=lppb11spt++Fad9LIQXuk4GpVi8ww2XoUwp40cGUOV7JEgenBPjZEC7jC2rxz+fYEz
         fZjiU3t981Bx+aHOtLmdIHcZZcOvrzM7eq/op1sgxpR4rPf3pAj/woN92I5wFEgExAqY
         bi/85oz9XB8ppDT20+nMrO/lOsXY9I9mDdUltR7UzwjGe3BnFyfx0pjLOIYW4ROJm5Q/
         gbiXoGf7FgF5qyFf8wjz1zxghPQmLMLrlEYr2R1Y8R+ISIkLQqjzyrwtufnpuRpWVe++
         94qzf8feXt5W1S9+M140mnYcX+mG92EiHQ5hEO0xmeG4uVrgk9B9dLiT89BbODrYn4b5
         RZxQ==
X-Gm-Message-State: APjAAAWsgOkjGt/O8NhxlptyE2LUbKbQTpuUMQsoygSY1A30oJhXA1QF
        jmNQsLTZutCD6RyGYarm1YfSQpGFungKywl3AjefGw==
X-Google-Smtp-Source: APXvYqxZzA0OhG2w6y05Ufc3lrkT11UvPecZsn+mzZCDhjjL01pL3ybEOaSVC61vjyT57hy6ydReTOdG+lBiHcpQk+g=
X-Received: by 2002:a9d:7b48:: with SMTP id f8mr4560030oto.207.1561661902921;
 Thu, 27 Jun 2019 11:58:22 -0700 (PDT)
MIME-Version: 1.0
References: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190627123415.GA4286@bombadil.infradead.org> <CAPcyv4jQP-SFJGor-Q3VCRQ0xwt3MuVpH2qHx2wzyRA88DGQww@mail.gmail.com>
 <CAPcyv4jjqooboxivY=AsfEPhCvxdwU66GpwE9vM+cqrZWvtX3g@mail.gmail.com>
In-Reply-To: <CAPcyv4jjqooboxivY=AsfEPhCvxdwU66GpwE9vM+cqrZWvtX3g@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 27 Jun 2019 11:58:12 -0700
Message-ID: <CAPcyv4h6HgNE38RF5TxO3C268ZvrxgcPNrPWOt94MnO5gP_pjw@mail.gmail.com>
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 27, 2019 at 11:29 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Thu, Jun 27, 2019 at 9:06 AM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > On Thu, Jun 27, 2019 at 5:34 AM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Wed, Jun 26, 2019 at 05:15:45PM -0700, Dan Williams wrote:
> > > > Ever since the conversion of DAX to the Xarray a RocksDB benchmark has
> > > > been encountering intermittent lockups. The backtraces always include
> > > > the filesystem-DAX PMD path, multi-order entries have been a source of
> > > > bugs in the past, and disabling the PMD path allows a test that fails in
> > > > minutes to run for an hour.
> > >
> > > On May 4th, I asked you:
> > >
> > > Since this is provoked by a fatal signal, it must have something to do
> > > with a killable or interruptible sleep.  There's only one of those in the
> > > DAX code; fatal_signal_pending() in dax_iomap_actor().  Does rocksdb do
> > > I/O with write() or through a writable mmap()?  I'd like to know before
> > > I chase too far down this fault tree analysis.
> >
> > RocksDB in this case is using write() for writes and mmap() for reads.
>
> It's not clear to me that a fatal signal is a component of the failure
> as much as it's the way to detect that the benchmark has indeed locked
> up.

Even though db_bench is run with the mmap_read=1 option:

  cmd="${rocksdb_dir}/db_bench $params_r --benchmarks=readwhilewriting \
       --use_existing_db=1 \
        --mmap_read=1 \
       --num=$num_keys \
       --threads=$num_read_threads \

When the lockup occurs there are db_bench processes in the write fault path:

[ 1666.635212] db_bench        D    0  2492   2435 0x00000000
[ 1666.641339] Call Trace:
[ 1666.644072]  ? __schedule+0x24f/0x680
[ 1666.648162]  ? __switch_to_asm+0x34/0x70
[ 1666.652545]  schedule+0x29/0x90
[ 1666.656054]  get_unlocked_entry+0xcd/0x120
[ 1666.660629]  ? dax_iomap_actor+0x270/0x270
[ 1666.665206]  grab_mapping_entry+0x14f/0x230
[ 1666.669878]  dax_iomap_pmd_fault.isra.42+0x14d/0x950
[ 1666.675425]  ? futex_wait+0x122/0x230
[ 1666.679518]  ext4_dax_huge_fault+0x16f/0x1f0
[ 1666.684288]  __handle_mm_fault+0x411/0x1350
[ 1666.688961]  ? do_futex+0xca/0xbb0
[ 1666.692760]  ? __switch_to_asm+0x34/0x70
[ 1666.697144]  handle_mm_fault+0xbe/0x1e0
[ 1666.701429]  __do_page_fault+0x249/0x4f0
[ 1666.705811]  do_page_fault+0x32/0x110
[ 1666.709903]  ? page_fault+0x8/0x30
[ 1666.713702]  page_fault+0x1e/0x30

...where __handle_mm_fault+0x411 is in wp_huge_pmd():

(gdb) li *(__handle_mm_fault+0x411)
0xffffffff812713d1 is in __handle_mm_fault (mm/memory.c:3800).
3795    static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf,
pmd_t orig_pmd)
3796    {
3797            if (vma_is_anonymous(vmf->vma))
3798                    return do_huge_pmd_wp_page(vmf, orig_pmd);
3799            if (vmf->vma->vm_ops->huge_fault)
3800                    return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
3801
3802            /* COW handled on pte level: split pmd */
3803            VM_BUG_ON_VMA(vmf->vma->vm_flags & VM_SHARED, vmf->vma);
3804            __split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);

This bug feels like we failed to unlock, or unlocked the wrong entry
and this hunk in the bisected commit looks suspect to me. Why do we
still need to drop the lock now that the radix_tree_preload() calls
are gone?

                /*
                 * Besides huge zero pages the only other thing that gets
                 * downgraded are empty entries which don't need to be
                 * unmapped.
                 */
-               if (pmd_downgrade && dax_is_zero_entry(entry))
-                       unmap_mapping_pages(mapping, index & ~PG_PMD_COLOUR,
-                                                       PG_PMD_NR, false);
-
-               err = radix_tree_preload(
-                               mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM);
-               if (err) {
-                       if (pmd_downgrade)
-                               put_locked_mapping_entry(mapping, index);
-                       return ERR_PTR(err);
-               }
-               xa_lock_irq(&mapping->i_pages);
-
-               if (!entry) {
-                       /*
-                        * We needed to drop the i_pages lock while calling
-                        * radix_tree_preload() and we didn't have an entry to
-                        * lock.  See if another thread inserted an entry at
-                        * our index during this time.
-                        */
-                       entry = __radix_tree_lookup(&mapping->i_pages, index,
-                                       NULL, &slot);
-                       if (entry) {
-                               radix_tree_preload_end();
-                               xa_unlock_irq(&mapping->i_pages);
-                               goto restart;
-                       }
+               if (dax_is_zero_entry(entry)) {
+                       xas_unlock_irq(xas);
+                       unmap_mapping_pages(mapping,
+                                       xas->xa_index & ~PG_PMD_COLOUR,
+                                       PG_PMD_NR, false);
+                       xas_reset(xas);
+                       xas_lock_irq(xas);
                }

-               if (pmd_downgrade) {
-                       dax_disassociate_entry(entry, mapping, false);
-                       radix_tree_delete(&mapping->i_pages, index);
-                       mapping->nrexceptional--;
-                       dax_wake_mapping_entry_waiter(&mapping->i_pages,
-                                       index, entry, true);
-               }
+               dax_disassociate_entry(entry, mapping, false);
+               xas_store(xas, NULL);   /* undo the PMD join */
+               dax_wake_entry(xas, entry, true);
+               mapping->nrexceptional--;
