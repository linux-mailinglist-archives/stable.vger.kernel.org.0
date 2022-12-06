Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADD964491D
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 17:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbiLFQW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 11:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiLFQW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 11:22:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4855038E
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 08:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670343717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sCUP81xXIy/70El6lCPLbAYE27sraoFkLSJy6O9sUWw=;
        b=Qo//7Xwb1DTVE8DU8wSygrxu8g7bpbrM8kYE5wdRx2hKNQP6u9sInR4t7Y8SZCKCkZuDJk
        O+uj26RSDpfEQTKvu2xSFiwSnzTTVJ16ysA7L3q4pMdd6+1pe53CcAD8dIWn1K37u5TqkH
        xaeQ6K12AUp6uGibS8/9hIoJBYkeD8U=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-515-ycX4PvkuPZeX1eZcfqX0CA-1; Tue, 06 Dec 2022 11:21:56 -0500
X-MC-Unique: ycX4PvkuPZeX1eZcfqX0CA-1
Received: by mail-qv1-f70.google.com with SMTP id u15-20020a0cec8f000000b004c704e015f7so33139346qvo.1
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 08:21:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sCUP81xXIy/70El6lCPLbAYE27sraoFkLSJy6O9sUWw=;
        b=gDiU2W6pSnKvoUu2vAw3lHb14ZYc8SpeaGQHHSVG3bXa/AtIrlkfS4LStBmwbabFS6
         IrCNQEQxKqJEqJILqZFEmxrUmgdv10NwrzmitMeWslAw164IM+deVaHVf/TKTtLZbI2l
         M3d0TdcLBAt70RrpW1CM/G9/ntNVCSPeryDGSB69xWCc0R36xt3QaElZOHkSv8HA61rz
         7729f9sCre0PX4h2+qlFB9t1lBod8RTiqRJXNO8b7X0wfROf2CnatCoZfafssWueu23X
         hJDzA8zZsf7T9uloTBYy2bxU5LAc4LYn797oxFr2FPJrGQ+L5Eso2w26Q4Rl5DGO7Aga
         sMWg==
X-Gm-Message-State: ANoB5pk8mxkhm0WHs8qvofEpBLG1QwPAjNwr+ElvOSG4dSAgtHZ4/lfe
        DkAr2ZIrFTV00EwMvTtjBTXyJgZsyrUrEa0i53zx5jEEj51FnKuLd2mDeaP78u0s/GIVaA7rXnL
        2PQ8d2nEaRrFqzU8T
X-Received: by 2002:a05:620a:b9a:b0:6fa:432f:298a with SMTP id k26-20020a05620a0b9a00b006fa432f298amr63417873qkh.159.1670343715699;
        Tue, 06 Dec 2022 08:21:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4EsM3BohWqkEZPkf2Bazdn88pyZKyN2ExwE9KgYwrNWoq74e43cW2/M3n+Ei57iDV3EOHs+Q==
X-Received: by 2002:a05:620a:b9a:b0:6fa:432f:298a with SMTP id k26-20020a05620a0b9a00b006fa432f298amr63417854qkh.159.1670343715469;
        Tue, 06 Dec 2022 08:21:55 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id bj9-20020a05620a190900b006b95b0a714esm14931361qkb.17.2022.12.06.08.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 08:21:55 -0800 (PST)
Date:   Tue, 6 Dec 2022 11:21:53 -0500
From:   Peter Xu <peterx@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     David Hildenbrand <david@redhat.com>,
        oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Ives van Hoorne <ives@codesandbox.io>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>,
        Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] mm/uffd: Always wr-protect pte in pte_mkuffd_wp()
Message-ID: <Y49sIRZ1y6wq884J@x1n>
References: <Y45duzmGGUT0+u8t@x1n>
 <202212060801.yenOQCHL-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202212060801.yenOQCHL-lkp@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 08:46:17AM +0800, kernel test robot wrote:
> vim +316 arch/x86/include/asm/pgtable.h
> 
>    313	
>    314	static inline pte_t pte_mkuffd_wp(pte_t pte)
>    315	{
>  > 316		return pte_wrprotect(pte_set_flags(pte, _PAGE_UFFD_WP));
>    317	}

It's interesting to know the bot will test any patch I attach in an mail
reply, which is very nice...

I'll send a formal patch for this one soon.

-- 
Peter Xu

