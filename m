Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227D65963DF
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 22:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbiHPUoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 16:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236890AbiHPUnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 16:43:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142804055C
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 13:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660682632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fxf9g37yt4QV3sYboUS8drWbHKZT6H8bVu/xJaEn0Rg=;
        b=eM9xgZnWVRvaSgxvkkrf6XteBA4JBMCBAouVpEbd/7DwtO2s0UswW+onMG187+UtGyhpPX
        dhdJ+YQ/+FR0RWC26/7baPhnR0eEcSSHeEgpjvTxZQZoU36ZQ7Jk1Qs5gh+zPPdesDRMJu
        rzlTo7XfybbxnHlUYQGAYGe74NiM3rA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-639-R__qYStNPSmtk8UOU-SVeQ-1; Tue, 16 Aug 2022 16:43:50 -0400
X-MC-Unique: R__qYStNPSmtk8UOU-SVeQ-1
Received: by mail-ej1-f69.google.com with SMTP id ga16-20020a1709070c1000b007331af32d3aso2233158ejc.4
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 13:43:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Fxf9g37yt4QV3sYboUS8drWbHKZT6H8bVu/xJaEn0Rg=;
        b=hQ3AssAuo1U45Ac/WViAD5++D0K5P7LyafZ+eJOBAA/B47QcAENykdCx8OzrMe5tqe
         OcSyboWhcaQMysknC8s7ImbMKSrRMLE5eApTprr5mX4DVIc0OaXFZEpx+rNgHtMJ1gRi
         QGML9QYiNdP5BlHhV1k2F7m4WGUovQVnoBl4T44M2oWBmqyR4VKRDvyYESLBPbosoOkc
         4v0K4/+wqu6/i9R2ifB18bYc2kIVvsp2Vf9IPyJIN26s7pwkjhjlWaDGpRkjOW16EdQC
         dh/+xeeRNCeq6Ygtrk8g6AclgJvDbn013SxXi2Ph6Owd8+LUK8znYW10cqwqKbPug0u+
         DkEg==
X-Gm-Message-State: ACgBeo2aVECvbPQmJ5FVQb/Y0s/TUmJ28iMYJIn9Wrv/DuGKc+RgN0RJ
        hKzwEgDdC3ipC5QErED2c5FWeeW1zsu7iGCkrATs9lTmtVHktbCBy3RZujUewe3R5dVeF9mTa7l
        lmPekMiIsVVcTHTUI0I6e9mzyUplcqv3h
X-Received: by 2002:a17:907:2d12:b0:731:6a4e:ceb0 with SMTP id gs18-20020a1709072d1200b007316a4eceb0mr14858117ejc.115.1660682628497;
        Tue, 16 Aug 2022 13:43:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6mQoJ2O5YQF6G2r3WkspIUVkvBOxFCch0fVBSiDl1gYE66/cPrbW4OldsDj5twWFTyEbDTfZf7egY2AUaRKbQ=
X-Received: by 2002:a17:907:2d12:b0:731:6a4e:ceb0 with SMTP id
 gs18-20020a1709072d1200b007316a4eceb0mr14858098ejc.115.1660682628222; Tue, 16
 Aug 2022 13:43:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220811103435.188481-1-david@redhat.com> <20220811103435.188481-3-david@redhat.com>
 <YvVRfSYsPOraTo6o@monkey> <20220815153549.0288a9c6@thinkpad>
 <CADFyXm7-0zXDG+ZHjft95aAAiSZh_RyAqgJw1nGsALwEL1XKiw@mail.gmail.com>
 <20220815175929.303774fd@thinkpad> <CADFyXm40iiz-xFpLK4qGgHGh5Qp+98G9qxnqC20c8qtRiKt9_A@mail.gmail.com>
 <20220815203844.43b74fd1@thinkpad> <Yvq99MmpaGJBhlt4@monkey> <20220816113359.33843f54@thinkpad>
In-Reply-To: <20220816113359.33843f54@thinkpad>
From:   David Hildenbrand <david@redhat.com>
Date:   Tue, 16 Aug 2022 22:43:37 +0200
Message-ID: <CADFyXm5m1a+ZRwp1Kejt0L4HFcVBSoSz6mG-19_65CnR7s7Q-A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/hugetlb: support write-faults in shared mappings
To:     Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, stable <stable@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Gerald,

>
> Thanks, we were also trying to reproduce on x86, w/o success so far. But
> I guess that matches David latest observations wrt to our exception handling
> code on s390.
>
> Good news is that the problem goes away when I add this simple patch, which
> should result in proper VM_WRITE check for vma flags, before triggering a
> FAULT_FLAG_WRITE fault:
>
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -379,7 +379,9 @@ static inline vm_fault_t do_exception(struct pt_regs *regs, int access)
>         flags = FAULT_FLAG_DEFAULT;
>         if (user_mode(regs))
>                 flags |= FAULT_FLAG_USER;
> -       if (access == VM_WRITE || is_write)
> +       if (is_write)
> +               access = VM_WRITE;
> +       if (access == VM_WRITE)
>                 flags |= FAULT_FLAG_WRITE;
>         mmap_read_lock(mm);

That's what I had in mind, good.

>
> Still find it a bit hard to believe that this > 10 years old logic really
> is/was broken all the time. I guess it simply did not matter for normal
> PTE faults, probably because the common fault handling code later would
> check itself via maybe_mkwrite(). And for hugetlb PTEs, it might not have
> mattered before commit bcd51a3c679d.

It is akward, but maybe we never really noticed for hugetlb (not sure
how common read-only mappings are after all).

>
> >
> > bcd51a3c679d eliminates the copying of page tables at fork for non-anon
> > hugetlb vmas.  So, in these tests you would likely see more pte_none()
> > faults.
>
> Yes, makes sense, assuming now that it actually is related to s390
> exception handling code, not checking for VM_WRITE before triggering a
> write fault for pte_none().
>
> Thanks for checking! And Thanks a lot to David for finding that issue
> in s390 exception handling code!

Thanks! Looks like adding the WARN_ON_ONCE was the right decision.

