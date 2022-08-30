Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5E95A6D80
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 21:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiH3Tk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 15:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiH3Tkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 15:40:55 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38AB6B15D
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 12:40:54 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id z3-20020a17090abd8300b001fd803e34f1so10381993pjr.1
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 12:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=cmkGTb9L9OeIMFxD3jKQUsg9TEkzwU9aSjE2Dw5vIEQ=;
        b=pE4Bx71pvd9dZKRF5z6T8Pt+bB46qQGtd9GcQDH2oAD1s76fa9WKjAuSmWyzPWGQpG
         FNbMF1rYoivPT1f8QXiYqZ+1HjEdCPv3zARTVSchZnowgeH7pmJWpqcu786U63xjebHh
         j/mnY4Nn33R/UydBsSBPRHKotcLndCHiknF7gSjmqe60n71QICcKqNrXcat1K0VxOnO+
         c6oUjhHwUyUQUqan6gHFT6OrfVs6lupH8rxh4NVVFwKLjCj/Ko/B0MyeyqHq5D6jX3vT
         JdpcEoIAEwEawrh++3bTY7tivyd1iaD7bOYV+R6BUulsRnSyM2hduVBNyn0eCeXqyfKh
         wyPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=cmkGTb9L9OeIMFxD3jKQUsg9TEkzwU9aSjE2Dw5vIEQ=;
        b=Qm1L2O0E2Pt36B1Md3M3NkCOdeZi3Ezbhtbuw0P8skjWxA/JNTstuIFgmQrx6tcUEe
         n46pjB1G+NscpD4G3+nWWtUdSluSpPabXiVmiMqdsoiUdHWEUvCYfWOswAlTJDuIlpM1
         kKDXINNVqIB2VEJwtk5ouGe+bDWe/bLcVzO+njchkecdXQA+e1TN2wS6oxyQZZDQBLHU
         MXiW4tYFRmEyE+qS3QheXOzPaE8D4cyTWVa+ea37IeAiKdVWu6xXdZWbXdw1+ktF6pes
         bp/OyYehL2Bk5TpaDzeh8TrCNQs6eIE6RDDQqf9O2Scf89DW1rPmbgjA7/ZVr/hkqUXk
         CmCw==
X-Gm-Message-State: ACgBeo2FZyQkhj3rrexdtT0SZGSMTQdXkyiylcxGoFbCX71NY5mShxsU
        qZO2tBbs167uwHGkUCTIZLatcg==
X-Google-Smtp-Source: AA6agR6a2tkSKcXvOkhpwgJXaxn6qr4k21/Nygc6Bo9hxI7CsKNxw/3JGemz1LbLs53jqC6gBwaMBg==
X-Received: by 2002:a17:902:ccd1:b0:172:5c49:34be with SMTP id z17-20020a170902ccd100b001725c4934bemr22117194ple.23.1661888454066;
        Tue, 30 Aug 2022 12:40:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h21-20020a17090aa89500b001fd982478cbsm6344983pjq.45.2022.08.30.12.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 12:40:53 -0700 (PDT)
Date:   Tue, 30 Aug 2022 19:40:49 +0000
From:   Carlos Llamas <cmllamas@google.com>
To:     Liam Howlett <liam.howlett@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "syzbot+f7dc54e5be28950ac459@syzkaller.appspotmail.com" 
        <syzbot+f7dc54e5be28950ac459@syzkaller.appspotmail.com>,
        "syzbot+a75ebe0452711c9e56d9@syzkaller.appspotmail.com" 
        <syzbot+a75ebe0452711c9e56d9@syzkaller.appspotmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] binder: fix alloc->vma_vm_mm null-ptr dereference
Message-ID: <Yw5nwaNI5ewExYtC@google.com>
References: <20220829201254.1814484-1-cmllamas@google.com>
 <20220829201254.1814484-2-cmllamas@google.com>
 <20220830190515.dlrp2a3ypfyhzid5@revolver>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830190515.dlrp2a3ypfyhzid5@revolver>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 07:06:37PM +0000, Liam Howlett wrote:
> > diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
> > index 51f4e1c5cd01..9b1778c00610 100644
> > --- a/drivers/android/binder_alloc.c
> > +++ b/drivers/android/binder_alloc.c
> > @@ -322,7 +322,6 @@ static inline void binder_alloc_set_vma(struct binder_alloc *alloc,
> >  	 */
> >  	if (vma) {
> >  		vm_start = vma->vm_start;
> > -		alloc->vma_vm_mm = vma->vm_mm;
> 
> Is this really the null pointer dereference?  We check for vma above..?
> 

Not here. The sequence leading to the null-ptr-deref happens when we try
to take alloc->vma_vm_mm->mmap_lock in binder_alloc_new_buf_locked() and
in binder_alloc_print_pages() without initializing alloc->vma_vm_mm
first (e.g. mmap() was never called). These sequences are described in
the commit message but basically they translate to mmap_read_lock(NULL)
calls.
