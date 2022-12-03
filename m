Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86750641825
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 18:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiLCRlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 12:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiLCRlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 12:41:45 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F501F9DB
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 09:41:44 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1441d7d40c6so8922682fac.8
        for <stable@vger.kernel.org>; Sat, 03 Dec 2022 09:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BfYXengFDnfnOzmVghAMxVJe0q0bhZjcIwVtDVixuuc=;
        b=qkO1FGGFU/Tgle0WWvj8cXccebEqE76t1Re96EQ14f2BiHxJWrkXqoP6SCU9QcvhBx
         vZGnX6XiJFdZyMMbqeHm27I/cbr8XsiyJfeVpyVGbBNF+YzPMDJYvBMe4oPlBajwn4W7
         Og7JpOV119hh6f6HAERgTq58eF4CLkhBl5Q3lKGwj058bdN3pL8yRLOjOrpSqgnPbNdz
         Glg5VI4K4UxTx2m7bedNQ96kTVquQAigJKVVeExBTNgewhFJKVhuDK9vMFep4cIvtmK5
         FOjdMR/3f4zchSpjKY9VGDop1Jpg/3oY0hRitMj+dZJKC2Y4R2qQXk6L0BeV92N1dDUa
         KAHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BfYXengFDnfnOzmVghAMxVJe0q0bhZjcIwVtDVixuuc=;
        b=jw6/sHAJcQ2QSV6PM3fNwXubRoFfDoiXfdEljuMPqMBPIZ32beethcwulkmjXnUByE
         XvYkR6s5WaT0TW8VB+h8jtV5ptbd9VxBd3D6Muwm9RgP2lVrL3wGJS4Q9xy1HXZ/hmFf
         rzAc/ZMj6LrtM65bXOfWImwWzZvAI9Kc9W8kWDJhQis1RxtwHpcMUFiD4PRfjLEFuf2K
         EPzgLWbvBXjsxVoXrm4hXXRIDx3llI/fakeoRf53xZyBxESM/wN/LRt2iUocawKxgYjE
         s2w+R9y1l9QI34DG5y8JhO+pPzUTbIb4MzR/0jVjt7xhBK/e4DA/Lr26RCKP6HtQ56b6
         FSpA==
X-Gm-Message-State: ANoB5pnRTkaCd3LCwclERucdyly/RIueQH4gNcJPNEMXnrmYOezUwd16
        +W/YhxOCZ/Bo3buHZtxAMz3viw==
X-Google-Smtp-Source: AA0mqf5NTOz+apWMFPKcQ9XNXEfFfCp/9DuksPQB/0T2wlJqAYXbypf5mVgq+AgXW5y/9tkbN4YfnA==
X-Received: by 2002:a05:6870:238f:b0:132:4782:72a8 with SMTP id e15-20020a056870238f00b00132478272a8mr36493950oap.136.1670089304057;
        Sat, 03 Dec 2022 09:41:44 -0800 (PST)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id f199-20020a4a58d0000000b004a084b7062asm3193064oob.40.2022.12.03.09.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 09:41:43 -0800 (PST)
Date:   Sat, 3 Dec 2022 09:41:34 -0800 (PST)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Hugh Dickins <hughd@google.com>, llvm@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 and earlier only] mm: Fix '.data.once' orphan section
 warning
In-Reply-To: <Y4tQYgjDgodwR2pP@kroah.com>
Message-ID: <5f9317c7-e899-a6b2-dd23-664a1b6d629@google.com>
References: <20221128225345.9383-1-nathan@kernel.org> <Y4tQYgjDgodwR2pP@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

On Sat, 3 Dec 2022, Greg Kroah-Hartman wrote:
> On Mon, Nov 28, 2022 at 03:53:46PM -0700, Nathan Chancellor wrote:
> > 
> > As far as I can tell, this should be applied to 5.4 and earlier. It
> > should apply cleanly but let me know if not.
> 
> Queued up everywhere, thanks.

Thanks for queueing them up, Greg, but please read through the thread:
I have doubts on the 4.14 and 4.9 ones, which would want a different patch
if we're going to make any change; but thought we could just leave those
trees without the patch, and Nathan agreed.

Thanks,
Hugh
