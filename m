Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69A468A173
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 19:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbjBCSTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 13:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbjBCSTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 13:19:41 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49836A8A0D;
        Fri,  3 Feb 2023 10:19:38 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u9so1816872plf.3;
        Fri, 03 Feb 2023 10:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YSS5FHpKylReMoriRyUg0We8dtM/MH25AI25xTf4cJo=;
        b=IqeQpMbEjIhwCGAabrt7tF3pabIq4V/NaysBudDP7S/Y4S3f0i9hmbwWCD2gVjvc/z
         TPYEWotwlrW4jvKTAqXIBEXwV+ds3/1uBn/ebJqISzYcbvA2G+Ga7cj2IwTwbX6wRwln
         AkuMFz57nJaupuDPtoKzDA3Rj2MEYp9PMLTowU47gM1H+RmBS+Omy8QOi9hSuB/CK05X
         2ucSC6ixjnuJjTNMCh24jf0VYgc/oWIqROF/PxiTM5HodUBUGljBvlPOdKECTRq5oxcx
         NB3xYv1/85bCKC808TfIK2/c5ayXdE+S6FzhA+PYPRgHCDdTcl0KTU1zooPrw3TFsJ3j
         ZwJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YSS5FHpKylReMoriRyUg0We8dtM/MH25AI25xTf4cJo=;
        b=TTgawlChKqDa2S2obqVW+sD/c7NIczx5JfDF3V9KanEfjm7AgSj5PrzaosaMMR8PrU
         EXi7rVI3IYTbyhirZ+GTI6ZLIvpz7j2S9JO8ULbzhngpRiWhuSpjNN6/+V0WnIKFzpum
         qvYTSj32X0emjYscsJJJGC4GBl4ze/rfS1cGLmsfrLx8JMTqobg1F+TlOZdtUUKDiH1H
         bJjzWUWx/V+F7Tr1Hi6EqznoUeacBMy1JxXvTpmb6PREYSVsPfELAEetys0QP/RW7YBu
         1h+LWgOyg13zF0ZHuaRZuodDjwl/DLpKjaxDehjVKPIUvpfhbre/rWI02mbfQb0rPrt3
         IdZA==
X-Gm-Message-State: AO0yUKW/KHlkyUju45uzDikBLcexEEd5BKajAwgo4EWv7YP/xj605qlP
        +b2fUT8GJFgCgbK4Fg3RCBQ=
X-Google-Smtp-Source: AK7set+2sz2GPwQN9uMeo+pKZ5i6QPDH96mtP0CKmZNkJrtkhv/+GyIvFEFWDyzEIDJS0SBD9c2BGg==
X-Received: by 2002:a17:90b:4c0e:b0:229:4dcd:ff61 with SMTP id na14-20020a17090b4c0e00b002294dcdff61mr11456794pjb.28.1675448377399;
        Fri, 03 Feb 2023 10:19:37 -0800 (PST)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id o60-20020a17090a0a4200b00229bc852468sm5261047pjo.0.2023.02.03.10.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 10:19:36 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 3 Feb 2023 08:19:35 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: fix cgroup writeback accounting with fs-layer
 encryption
Message-ID: <Y91QNz+U/MGs9cPc@slm.duckdns.org>
References: <20230203005503.141557-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203005503.141557-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 02, 2023 at 04:55:03PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When writing a page from an encrypted file that is using
> filesystem-layer encryption (not inline encryption), ext4 encrypts the
> pagecache page into a bounce page, then writes the bounce page.
> 
> It also passes the bounce page to wbc_account_cgroup_owner().  That's
> incorrect, because the bounce page is a newly allocated temporary page
> that doesn't have the memory cgroup of the original pagecache page.
> This makes wbc_account_cgroup_owner() not account the I/O to the owner
> of the pagecache page as it should.
> 
> Fix this by always passing the pagecache page to
> wbc_account_cgroup_owner().
> 
> Fixes: 001e4a8775f6 ("ext4: implement cgroup writeback support")
> Cc: stable@vger.kernel.org
> Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
