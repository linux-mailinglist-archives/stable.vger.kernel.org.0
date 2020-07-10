Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9F021BD64
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 21:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgGJTKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 15:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbgGJTKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 15:10:51 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3119DC08C5DC
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 12:10:51 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id 12so5666465oir.4
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 12:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rz/02I+ZskpSCMTSI0IcvBf3VlpD9Jd130lPfA38WiI=;
        b=sGGNolFeaesQIbKnHTeWVUXUk0pE0EIShd3U98UpPPudUck9xZUw6iesxMBvhPuLzG
         A5abXs5mkn3Kmz1pI3s+M9PhkBgETvo22u2JuapWfC4pnPaXQMpNWcWton1MSdjfFog1
         PK44HgeOe6oUhRUFoIEdeZDWVRzbSoSbVdKn1XMgOX/XeVJ6NS7lm5+BA15Y8LXN4YYu
         OgZEruf3By3uZ0mx9dlmG4dNUSrgbPExksEmumVD/so2gUfryVM0wQOkA8bkfNvxZzcm
         BnMSt7wYH4Py8vcg/8i9zp4UGhs1NRU/hSsRQ2PK8N/0X+n6xdcB3DBqv4Bo/avjWT/j
         CjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rz/02I+ZskpSCMTSI0IcvBf3VlpD9Jd130lPfA38WiI=;
        b=r8WkpmiDDmLvgm5tDci/JAcigJLEYH7Y+o14AX8ZY7ccOkOIOINnuqo4kThNEy4QSn
         73YfdO5QQUicX2BCPYHH5TPSfW9jyGSUPY3kNrGxO5L2VfybAdX8eMQibQmRoAtxKiai
         ztQYGm2Sg4mXtdLmq0AT3Vqhd/HgGltTI8bK7UdUiT/zqO6kcD3LYqTuFwbEZe+LbmHi
         hQcTpsB7OLn7asTi43ec5Afd4HpakLg1CLSz5qdUokswW6L2wJEHF3hlVJ9suo8gg3yf
         AKmmWmnWXSZ/PIxsL9pGg/D/dmGn2cFBeW19bd4U7FXFEKJpPE6w8sdG3O1BFqa5tqaj
         65gQ==
X-Gm-Message-State: AOAM530UCvBR1ztHPUgAz9uRu6OGrbg7rPTcAejFyRd3cmhuojU5/Gzu
        MTVQNnYAMR03fqyhBfN/jI30kw==
X-Google-Smtp-Source: ABdhPJyxK9fK/cSfgwjezpCoT9KuqQhSySRFPg3ISip4/u5XnxCkuDoFTx3smoQ2rqj13mRjZl/TFw==
X-Received: by 2002:aca:ecc7:: with SMTP id k190mr5152013oih.92.1594408250568;
        Fri, 10 Jul 2020 12:10:50 -0700 (PDT)
Received: from cisco ([2601:282:902:b340:dd70:9e19:5b5e:7f32])
        by smtp.gmail.com with ESMTPSA id f16sm1238255otp.47.2020.07.10.12.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 12:10:49 -0700 (PDT)
Date:   Fri, 10 Jul 2020 13:10:48 -0600
From:   Tycho Andersen <tycho@tycho.ws>
To:     Kees Cook <keescook@chromium.org>
Cc:     Will Deacon <will@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-next/seccomp 2/2] selftests/seccomp: Set NNP for
 TSYNC ESRCH flag test
Message-ID: <20200710191048.GB2700617@cisco>
References: <20200710185156.2437687-1-keescook@chromium.org>
 <20200710185156.2437687-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710185156.2437687-3-keescook@chromium.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 10, 2020 at 11:51:56AM -0700, Kees Cook wrote:
> The TSYNC ESRCH flag test will fail for regular users because NNP was
> not set yet. Add NNP setting.
> 
> Fixes: 51891498f2da ("seccomp: allow TSYNC and USER_NOTIF together")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Tycho Andersen <tycho@tycho.ws>
