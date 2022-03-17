Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFCD4DCB69
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 17:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiCQQaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 12:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiCQQaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 12:30:06 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0528139252;
        Thu, 17 Mar 2022 09:28:49 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so5934021pjl.4;
        Thu, 17 Mar 2022 09:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UWrsSvyUYUsX9uBJB0/kdPuxZQNwJ6igQetyk50XVfU=;
        b=LR9n/VsxM4TlrSligmfyVmMfTeFCv+a0295wYqgZlOBfLFyBQzhO7CddMgggmuz57/
         vzht04DCXDlDxgOL5ub+6qnFOdClF/pRS3bv3/kM/nF/r/Q1xw00xkJjjo5/Tr0bnN8F
         unSwKZApVIScVuoBKlCRJPa7XLVARso2HXcuWp6/AfVCVRcXFiagXufY/bPFU0TM8jKp
         6wLAk6MgNeXgl/e5KCVPHDNHrm7dYzJHfE0w/uUhtLgakB9DKvaPLEbOLcC8Jjmg0T4S
         lZU4uh/F6eYywz2x9QDvn+P8bVWYhvMjDbbJ3R1fG758wwpbHFZjgQmUkjYK18e64yjf
         Cg7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=UWrsSvyUYUsX9uBJB0/kdPuxZQNwJ6igQetyk50XVfU=;
        b=kNpYt4LCxQgH0JrVuvCwo7LODkrXo/yuFI8PmfLXbAc5oksqdJw0jM3TSzVomtVwkV
         NuO9lIDGESa/33dDIBA5t+ZTUJOGHTMtARby4RGggIBUxlmAS0UgiuiiyzCUed+kNuX0
         5SddISo1l2CkkG2vfomaZsScrLEYrWPogQdNY0kpPRQzVEGD3KGW6ki0uZnCVPNpCznT
         HTqQ5Ba6r59axcmjUenLReyBlwDnZajd77A0qb2lYCN9FUE7ZuwtrMtt0vi7/7MhDUKU
         LHisa6jb+e8snmkmNnacIvq4nDnsSL5lEzcxfs3vu7ycCmbr7LUN/8yXUeBDUpBuEy4N
         nS4w==
X-Gm-Message-State: AOAM530qbMJcoCHdll4qXgijHjEda9zZiCmd8y+PxFi79/4Oy62M2Hgp
        TTK0376/HU1cUEhkjanSMGY=
X-Google-Smtp-Source: ABdhPJxcJJUi6ho81MBoVkLBUq3RjXNFlAsuvneVHylauwX6wr9lMcpmiz/arxhcPZQe8tF+hIWQug==
X-Received: by 2002:a17:902:f70c:b0:14e:f1a4:d894 with SMTP id h12-20020a170902f70c00b0014ef1a4d894mr6026587plo.65.1647534529115;
        Thu, 17 Mar 2022 09:28:49 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:b625:fd41:4746:7bf5])
        by smtp.gmail.com with ESMTPSA id t9-20020a056a0021c900b004f7b425211bsm6828279pfj.36.2022.03.17.09.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 09:28:48 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Thu, 17 Mar 2022 09:28:46 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Charan Teja Kalla <quic_charante@quicinc.com>, surenb@google.com,
        vbabka@suse.cz, rientjes@google.com, sfr@canb.auug.org.au,
        edgararriaga@google.com, nadav.amit@gmail.com, mhocko@suse.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "# 5 . 10+" <stable@vger.kernel.org>
Subject: Re: [PATCH V2,2/2] mm: madvise: skip unmapped vma holes passed to
 process_madvise
Message-ID: <YjNhvhb7l2i9WTfF@google.com>
References: <cover.1647008754.git.quic_charante@quicinc.com>
 <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
 <YjEaFBWterxc3Nzf@google.com>
 <20220315164807.7a9cf1694ee2db8709a8597c@linux-foundation.org>
 <YjFAzuLKWw5eadtf@google.com>
 <5428f192-1537-fa03-8e9c-4a8322772546@quicinc.com>
 <20220316142906.e41e39d2315e35ef43f4aad6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316142906.e41e39d2315e35ef43f4aad6@linux-foundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 16, 2022 at 02:29:06PM -0700, Andrew Morton wrote:
> On Wed, 16 Mar 2022 19:49:38 +0530 Charan Teja Kalla <quic_charante@quicinc.com> wrote:
> 
> > > IMO, it's worth to note in man page.
> > > 
> > 
> > Or the current patch for just ENOMEM is sufficient here and we just have
> > to update the man page?
> 
> I think the "On success, process_madvise() returns the number of bytes
> advised" behaviour sounds useful.  But madvise() doesn't do that.
> 
> RETURN VALUE
>        On  success, madvise() returns zero.  On error, it returns -1 and errno
>        is set to indicate the error.
> 
> So why is it desirable in the case of process_madvise()?

Since process_madvise deal with multiple ranges and could fail at one of
them in the middle or pocessing, people could decide where the call
failed and then make a strategy whether they will abort at the point or
continue to hint next addresses. Here, problem of the strategy is API
doesn't return any error vaule if it has processed any bytes so they
would have limitation to decide a policy. That's the limitation for
every vector IO syscalls, unfortunately.

> 
> 
> 
> And why was process_madvise() designed this way?   Or was it
> always simply an error in the manpage?
