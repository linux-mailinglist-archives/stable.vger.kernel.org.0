Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386754BA539
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 16:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240474AbiBQP5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 10:57:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239978AbiBQP5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 10:57:42 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5031F165C02
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 07:57:27 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id v12so9869785wrv.2
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 07:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rQmm18LD8LzGhmEqWAfbxg3zErK9TaDoNZBieeTcqTM=;
        b=wIsoo7NSgjR7PREo87oiJoegHy+NVuK+rz0xszE/6spbn88POg6hL9rWZMsod2OX8V
         xnFWmNUEXPJznEZH/ZRo7w44ZKcjkOl9E/46x/5uUXKFipANlb9UDrLXvM6s4bKnOkcs
         3fEz/8GLQHkD0PbO7/ub0DCitX7XZcZcSNnyYJmKx0C0wb31gxxunlEFbtRs5M6wuG1b
         lDCb3NSPDI5bBB1XtpgWM9JvwmfUCgE+i68xmnBVwvag4IicgXlp7HwgZG0Y1C0Rim5N
         5Qo3JpfYJKVSGkjA0lrVByugR5rGcEICTWLeWfXSca7aRr3fRsbiGjvmtvTbxP+44B6d
         /3cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rQmm18LD8LzGhmEqWAfbxg3zErK9TaDoNZBieeTcqTM=;
        b=Ek4EG8aMKtn+zDPuOP+HIC0QdDFxnJ2d2Yjxsf8gS5vFWO2fFAoHVFUOrKnoMPDFo/
         UNl9qngHb2ys2plC394gVIRDELdUax4a2AP96MLnRT+ZgogPzK5DDXhp0LOWQoHcj964
         YroWXb60ra6EB6uClHVtSwtkiBGbgVWDb+lHMNdByXG8kO4P66sm9FSzpbKazFbjPrvK
         jVehx7ifiUM0UfkpOxNmiNcs2clRmUuDmKyzc8R7inwa6sEN7h520YsUzKE5w+EPGfoF
         ycD2T3Kr7BZgoewBV8lbWZgO+kpvyA0KB1zmHhJo08frCpRWxnm40sgewKxK8HZCFfH2
         +01g==
X-Gm-Message-State: AOAM531J+QZ4wHpelV/axVGBLTEjgG12iCr1teTjSnjxQAzdmc7lGBp7
        oDf9/TihmPGKK7o0WRX565GfzfFM7mJt0g==
X-Google-Smtp-Source: ABdhPJzhqmtLVfKSOXPExQ02knSYv2H+cFadvNUYTkfpMLf9tMrymMcd4VfTREuz0ykVlcygzZUCfg==
X-Received: by 2002:adf:e4c2:0:b0:1e3:3e5d:bd65 with SMTP id v2-20020adfe4c2000000b001e33e5dbd65mr2852687wrm.422.1645113445791;
        Thu, 17 Feb 2022 07:57:25 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id 7sm22760730wrb.43.2022.02.17.07.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 07:57:25 -0800 (PST)
Date:   Thu, 17 Feb 2022 15:57:23 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, ast@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bpf: Fix toctou on read-only map's
 constant scalar tracking" failed to apply to 5.4-stable tree
Message-ID: <Yg5wY5FKj0ikiq+A@google.com>
References: <163757721744154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <163757721744154@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Good afternoon Daniel,

On Mon, 22 Nov 2021, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

We are in receipt of a bug report which cites this patch as the fix.

The kernel in question is v5.4 and as you can see by the statement
above, it was not possible to back-port the fix into this Stable
release.

I did attempt to also back-port the commits mentioned in the commit
message of the patch you authored, in order to elevate the large merge
conflict that followed:

  fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
  1f6cb19be2e2 ("bpf: Prevent re-mmap()'ing BPF map as writable for initially r/o mapping")

... but this just led me down a seemingly never ending rabbit hole.

Does v5.4 suffer with the problem you reported?  The Fixes tag would
suggest that it does.  If so, how would we go about patching it?  As
you can image that kernel is still in support and running freely on an
innumerable amount of consumer devices.

Would you mind advising us how we might proceed please?

Kind regards,
Lee

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
