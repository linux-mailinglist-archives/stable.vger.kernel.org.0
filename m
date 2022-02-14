Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142414B52DE
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 15:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354975AbiBNOMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 09:12:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345527AbiBNOL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 09:11:59 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3BBD4B
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 06:11:50 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id i19so8309274wmq.5
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 06:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3Is2B0GtPj2dMI82ExWIaXz6ThN1J8/FAH1EK+krjOg=;
        b=MKm3nds0nV9zOc2iPb5KMgc+NuvN03dS8U5wqTT7d+ohNW8FqNpEXNaZ8TYLW0lzRj
         5wVbi8iI6TCF7KGazkV5N9/7T0EEcqLK/k2FoBAU1/vPaknk+4rO4uwC6BN252U8YjDj
         gVRJ6mu584iKt3T1EzddaQPg7IsOx+LN9ebrPej9IvkYSyHBKRGwGCSQVwjGlyCaTXPz
         KV2AVdZmkPQitXDwDObd7L5vo/ER7TZA2ARGbnuLd+vsorTfVRE+dXFGKeW4kRtaLRP+
         JPmnAUz2++aDVeuv9GblSkE6D+qnudLwVthMndPsqikAERsEsTyTex5zMv6WrAMRjn48
         uouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3Is2B0GtPj2dMI82ExWIaXz6ThN1J8/FAH1EK+krjOg=;
        b=4Anq+Frx7iER3yGZwcYVK3DhOhnV58uI6OQ5e8XhXiGgJnSEdwNZZ8qL6TkOD964Nf
         dZB/NF51VBK9TYiyHgOU9vyr2G7tdaolnvWaeTMIx92+cWzmOaeFazVQ20Op9ZsThT8a
         AuXT82cJUlVCa84IS7aZjsrJaSQxY/yIXaQGAddQSFstmjl87C+4r7Nw0xrEBRg3bzpj
         2uTQD6Rcz8VA9HjMizfHFijG2pTMqaalbeSAmfdIKTXpiybJhFDES4uAow7pWg4ljllo
         FurF+HaD7Zxf20FrlECLQhaqPk8ibfZd92HwOQnhFKYlhTGroytc2KiH+h9RCkvnXY3K
         NCBg==
X-Gm-Message-State: AOAM530cikPi+AkSBJQVVq/ggkQqbdZjX8g7UBcAFZs7Q7KmHkBaQBxk
        CKBe+oyZs/itVKnPD58fiLYocA==
X-Google-Smtp-Source: ABdhPJycc2AeNgDLeMcPq709jDg3r69PS0m8CwcCpEyvCW2mDtnrAFFDMHyQuEReiKG5356uJWPxRg==
X-Received: by 2002:a1c:a104:: with SMTP id k4mr11292346wme.68.1644847909280;
        Mon, 14 Feb 2022 06:11:49 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id j6sm17636672wrt.70.2022.02.14.06.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 06:11:48 -0800 (PST)
Date:   Mon, 14 Feb 2022 14:11:46 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel@redhat.com,
        syzbot+0ed9f769264276638893@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] Revert "iomap: fall back to buffered writes for
 invalidation failures"
Message-ID: <YgpjIustbUeRqvR2@google.com>
References: <20220209085243.3136536-1-lee.jones@linaro.org>
 <20220210045911.GF8338@magnolia>
 <YgTl2Lm9Vk50WNSj@google.com>
 <YgZ0lyr91jw6JaHg@casper.infradead.org>
 <YgowAl01rq5A8Sil@google.com>
 <20220214134206.GA29930@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220214134206.GA29930@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Feb 2022, Christoph Hellwig wrote:

> Let me repeat myself:  Please send a proper bug report to the linux-ext4
> list.  Thanks!

Okay, so it is valid.  Question answered, thanks.

I still believe that I am unqualified to attempt to debug this myself.

In order to do so, I'll at least require some guidance from you SMEs.

Please bear with me while I clear my desk - lots on currently.

Bug report to follow.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
