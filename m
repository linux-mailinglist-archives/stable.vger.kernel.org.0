Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47806AE520
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 16:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjCGPni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 10:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCGPng (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 10:43:36 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346DA2B633
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 07:43:09 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id n6so14533702plf.5
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 07:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678203788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ilfr+1i799vX4Awe1xzUE2lv9oMRNYBat0+WkLXzJh4=;
        b=JGnI3nQgJGHR/Q/Zwt5DW83P/LwKODyBhJHXws9ipHtoOhUIgdsXCaHscPh8kFkZnF
         wxar0A216bOxVopFnY5bdE1JOv/CzjzCtkvyybzsspkL3toK+g4Ub/D3t/+71cS8kbXR
         20sRnQG5S3Gp9uvDy++9EHEYI6OnMegzkOQRmvAnZYuuSeEGYAolxs/ANq3RTTegCM8M
         eOMBWLYdxuaZPWnKNwtfJ71rtmeOBZXDeeF/tubG+rRUj6OT5cs5gPfk6wBOuWP4S/BX
         tDFAbfNupju2CPJvoq0INdOb2B7pPsBJ0s23ICUILy8M55mIpgoyv+NSIDivcS5tizTh
         Zc7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678203788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ilfr+1i799vX4Awe1xzUE2lv9oMRNYBat0+WkLXzJh4=;
        b=cG3BbeWasYoa2ozOwokbXCsCNQitOUK1tQ6r+2L45IF2qJjj7OwFmPY+6HYwh5+HTA
         nPH7CN9UFmK1ZFTrx7GR5HNFPWBx1zSbDWIb9iBAV77nf9/5kCg/Yw7oZGoFbTvCvdLf
         YoDT5JFsqPF/ypJglJnN8eski4kcORYN+OSVKkPJPel2PUSZxu6vAnWrJdyrZdnARq9Q
         nONTCqWt9oFAoLJ+xqZdm/omXnqNGQwMTFJMWaSPm3RvNjOZzQgav7wajn8Dbsy5M5Nn
         Fwi8l+ldoQDO23UxVY0Epu5IcDdy+cnyP+phF0upD2YjHbjfIgsyVZLJ5Z9Wf183Qa5y
         ftYA==
X-Gm-Message-State: AO0yUKW5g5DMPWWFmryOv6w7JRMRY2Rv3iJNWt7is7GYzkueDRR5/6N/
        7jO18Gh3tysJ4o4iGVyjN4ZFsJLT1EWRBnKRB2ZzsQ==
X-Google-Smtp-Source: AK7set+MgPF5QPlQTLNs4LHgUI2HeZ1K3YqQFekmIqHmRkXcwvFqToPXYxYWK/CTwDYC06sjeS58JA==
X-Received: by 2002:a05:6a20:8987:b0:c7:7248:4e49 with SMTP id h7-20020a056a20898700b000c772484e49mr12097988pzg.38.1678203787735;
        Tue, 07 Mar 2023 07:43:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u6-20020aa78386000000b005d35695a66csm8023928pfm.137.2023.03.07.07.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 07:43:07 -0800 (PST)
Date:   Tue, 7 Mar 2023 15:43:03 +0000
From:   Carlos Llamas <cmllamas@google.com>
To:     Jialu Xu <xujialu@vimux.org>
Cc:     gregkh@linuxfoundation.org, cristian.ciocaltea@collabora.com,
        masahiroy@kernel.org, vipinsh@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] scripts/tags.sh: fix incompatibility with PCRE2
Message-ID: <ZAdbhyW+tv0krirG@google.com>
References: <20230215183850.3353198-1-cmllamas@google.com>
 <20230303112051.3890371-1-xujialu@vimux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303112051.3890371-1-xujialu@vimux.org>
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

On Fri, Mar 03, 2023 at 07:20:51PM +0800, Jialu Xu wrote:
> 
> Just got a working grep without \K, seems that it is three times more
> efficient than sed in my test, is it necessary to update?
> 
> 	grep -Poh '(?<=^  )\S+|(?<== )\S+[^\\](?=$)' {} \+ |
> 
> --
> Jialu
>

I just tried this and it does have better performance. Even better than
your previous grep expression it seems, so I would definitely send a
patch.

--
Carlos Llamas
