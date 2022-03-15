Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0584DA538
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 23:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239396AbiCOWWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 18:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbiCOWWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 18:22:08 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFE15C656;
        Tue, 15 Mar 2022 15:20:55 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id t2so1132050pfj.10;
        Tue, 15 Mar 2022 15:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=84kFTOf9/F1bpdxHLGKdmzF1pTCG4mq3396ASbcsPH0=;
        b=S6cKaJtz5ujUV0DCCwnZC3p3N4rVdwVp2PLbBPZAmCuTZTB0i6HNT8QMptZSHmuGkp
         lsv0iFjmSkdLqJcNKzqKUUDyvKpS9W34al05N1tqh39whL1PwZIZsOdUwqHJQKCJe8gn
         YlzqJQfNKUMiwF9PIELmslwzxkeICml7G7Epms9FgQC0Ap5rqviMF6GX3Xn4dtNx4px5
         ZrQvK8E9518ngBf5PwMEGXnaOyWOz9kcHkL4lnPNZn+k3/MwY33VpSlnkLQoEeTDwIcu
         VMjI7mBxz28QWTqH64lJj2AZZWZIC2a28yJvuEMcq0ZQtQwN0Nmtuy9X9nBWm4H5PIJL
         JttQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=84kFTOf9/F1bpdxHLGKdmzF1pTCG4mq3396ASbcsPH0=;
        b=tWDOAwkwH85GK5Ov1wuSowdk+anP06aUWf43v6mrXwvXM5PHW0HMnr6SZVZ+3dYvAD
         OaPBfN7FHG9W/jPow3v3JAlgljde3+9G56YuKRS056n9dRYrNW64z/o4Kq8S3dJI0/vP
         qfuINNIwAowLeUTfX7h3ouqv4NIPOgExo277L6xGT/J/nyg7c9N2j8VUFHnr4AMovT3z
         a1jVsZToJOaPPQvR4AG+GtaJh2P3GE7MUaj+kCIvRGTDSt++OMJaoHcAC6eFeaVfp1CP
         KaOPcYc3+O/1ksX/2v8G4e4xgx3oDRngR/chJPtpnMNtoUxcpXC521j/yS8fHqCTx+V0
         Nx2A==
X-Gm-Message-State: AOAM530iBwvoH+kN/VpI4E21TnkGmtMyOqnOZ+O5SSBfZqwJXF5FLJy8
        6P/hFQ3XTRqXiRDduySPCuE=
X-Google-Smtp-Source: ABdhPJxPhbkHWHq5TAaAy1B2Kg+asrvXDmUsyIHvqWnKaqzN5CfQMU5J53F1xwWQl7jWU5H2aeS6jA==
X-Received: by 2002:a65:424a:0:b0:375:6d8b:8d44 with SMTP id d10-20020a65424a000000b003756d8b8d44mr26272327pgq.170.1647382855304;
        Tue, 15 Mar 2022 15:20:55 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:7484:dc22:fe49:91cb])
        by smtp.gmail.com with ESMTPSA id y32-20020a056a001ca000b004fa201a613fsm85131pfw.196.2022.03.15.15.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 15:20:54 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Tue, 15 Mar 2022 15:20:52 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Charan Teja Kalla <quic_charante@quicinc.com>
Cc:     akpm@linux-foundation.org, surenb@google.com, vbabka@suse.cz,
        rientjes@google.com, sfr@canb.auug.org.au, edgararriaga@google.com,
        nadav.amit@gmail.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, "# 5 . 10+" <stable@vger.kernel.org>
Subject: Re: [PATCH V2,1/2] mm: madvise: return correct bytes advised with
 process_madvise
Message-ID: <YjERRJn/2GZOt4b7@google.com>
References: <cover.1647008754.git.quic_charante@quicinc.com>
 <125b61a0edcee5c2db8658aed9d06a43a19ccafc.1647008754.git.quic_charante@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <125b61a0edcee5c2db8658aed9d06a43a19ccafc.1647008754.git.quic_charante@quicinc.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SCC_BODY_URI_ONLY,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 11, 2022 at 08:59:05PM +0530, Charan Teja Kalla wrote:
> The process_madvise() system call returns error even after processing
> some VMA's passed in the 'struct iovec' vector list which leaves the
> user confused to know where to restart the advise next. It is also
> against this syscall man page[1] documentation where it mentions that
> "return value may be less than the total number of requested bytes, if
> an error occurred after some iovec elements were already processed.".
> 
> Consider a user passed 10 VMA's in the 'struct iovec' vector list of
> which 9 are processed but one. Then it just returns the error caused on
> that failed VMA despite the first 9 VMA's processed, leaving the user
> confused about on which VMA it is failed. Returning the number of bytes
> processed here can help the user to know which VMA it is failed on and
> thus can retry/skip the advise on that VMA.
> 
> [1]https://man7.org/linux/man-pages/man2/process_madvise.2.html.
> 
> Fixes: ecb8ac8b1f14("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
> Cc: <stable@vger.kernel.org> # 5.10+
> Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Acked-by: Minchan Kim <minchan@kernel.org>
