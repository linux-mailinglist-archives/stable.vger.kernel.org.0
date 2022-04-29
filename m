Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17A0514305
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 09:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbiD2HOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 03:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354979AbiD2HN4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 03:13:56 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FED165F9
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 00:10:37 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d5so9533063wrb.6
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 00:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eU2K7hFb85v49HupfOauBv/JqeNYoVQ8Es/ogQztH9I=;
        b=rVNkFnQDzCpWsi8uW5f3jUysx64p01AAL/g7+RbN3B7asBhziEA7oArOam0DI2l82n
         6rQKGqiMYE/wAdGmf+MpbfoWl9VxCLDhT4sZkf3z1OR4nkcm+j2OAlEN+AJzlRfzA6++
         9KoUDxK9aSSPqcTe/6H6UZZyEFE2gHADijMc4PyIcLLxk8ikC2qHYubwA0ltdXeeZ/yS
         rprRpZWrEPm9Xq0b8mXkUvfo/rsqSH7JjvbK0uT2TcTtyDDSoLn1r4L2FOUXf0us2RQf
         IHOBV2ED0xSUi1+9WFSIRSIG3OA5lotwKQVxOleqKoc17txpfeftRq0KfjyQM2qlSg6b
         8eLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eU2K7hFb85v49HupfOauBv/JqeNYoVQ8Es/ogQztH9I=;
        b=79DW3tpUYKdOtN8+qJhbzPVaKC2H0ey9Dwi6o+b1IgpAUBdfbIE3eH6Y/9UDlJPRCB
         RuHXUeFhSDtSiGls88qSZWGrjiAWyTnHsj+hvg6PIjK3hpDTDbpEFtC1jrfoL0XNMbQe
         trFMl8HZYUw/mBwBEwAkJzv8Nw88HedF1PKJR9+BQFvyRjMBVXWweGlcF9MWeR960PvI
         frMo0nfe5WlfYPWZ170ml1YhreSipGpBEY0392j2jtV7eBFADp/oASYJhOZLUcypff0m
         h2j+e8lo54zJ1YE1/VP4HAic4bBnkSvoO9j8JqB/2l89etMzEmhL19UEW1+AGN+/F7+m
         8UaQ==
X-Gm-Message-State: AOAM530AIATZrqeYf+ynP7KRzFl6CmbPN30RHIHZ4d8W0StD7vppzpfA
        VEYVHvBije/zNu3aLq1auxG+lQ==
X-Google-Smtp-Source: ABdhPJyZal4neXE/dKPKaoOqDGmypXJSpsymt46sH4fu/rK9ljAoneXvv0uUuZfUL767GNjUvhNVwA==
X-Received: by 2002:a5d:638b:0:b0:20a:f2ea:f8ef with SMTP id p11-20020a5d638b000000b0020af2eaf8efmr7674124wru.186.1651216235489;
        Fri, 29 Apr 2022 00:10:35 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:15:13:1476:89ab:7172:aa69])
        by smtp.gmail.com with ESMTPSA id i27-20020a1c541b000000b003928e866d32sm5877213wmb.37.2022.04.29.00.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 00:10:35 -0700 (PDT)
Date:   Fri, 29 Apr 2022 09:10:29 +0200
From:   Marco Elver <elver@google.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        duanxiongchun@bytedance.com, dvyukov@google.com, glider@google.com,
        roman.gushchin@linux.dev, torvalds@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [External] FAILED: patch "[PATCH] mm: kfence: fix objcgs vector
 allocation" failed to apply to 5.15-stable tree
Message-ID: <YmuPZQLKLfV3X6cW@elver.google.com>
References: <165116018052255@kroah.com>
 <CAMZfGtXuQr77H2juiJTK5ZhP6tHFj4fNLDFZ82VBOfknnoa3pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZfGtXuQr77H2juiJTK5ZhP6tHFj4fNLDFZ82VBOfknnoa3pg@mail.gmail.com>
User-Agent: Mutt/2.1.4 (2021-12-11)
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 29, 2022 at 12:15PM +0800, Muchun Song wrote:
> On Thu, Apr 28, 2022 at 11:36 PM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> 
> I have fixed all conflicts and the attachment is the new patch for 5.15.
> 
> Thanks.

I wanted to test, but unfortunately this doesn't apply to 5.15.36.
