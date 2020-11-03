Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B622A446B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 12:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgKCLmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 06:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbgKCLmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 06:42:43 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF64C0613D1;
        Tue,  3 Nov 2020 03:42:42 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id 62so6189466pgg.12;
        Tue, 03 Nov 2020 03:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ctG4ytBtgwuFkE0xSNIg1PiQTdhbQPLDtymlP6cXirU=;
        b=bAHpNPFNWl9Wj7GB/VRtFSRPl4eRypZTjM7SOaiw0jMGq62v1DGXUW8yu8m5vyjZay
         oXNXA6STbqYuydwNTig+BJ1svw+5HQINepuokgVFIuC079IQg0erOMIDzMuT+9lL6S9t
         cmrPpuWfp5mDEkjluD8bnaXvjjwLP3fsnfru9WiSXlmmmnegSiebJokceDNl6wtTtmoh
         wQD5fsutvBrYRSXoGKjdxdIynm36Pm5Yjlj6OfwDuLmcLBgxKf3L3IwrQIWkbozyOuYl
         mxPJB2CKP1nmYJAWlPF+1UxwdIxHjfgeBlCAwe9O57EuFfvi/dA7ypHW20eTk+q19pR2
         GEoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ctG4ytBtgwuFkE0xSNIg1PiQTdhbQPLDtymlP6cXirU=;
        b=R9374z3QPUJrngT10J6Nz88yOgNXuxHXmfXSltGT01BzYF1FDGm38DwazcmnEp9P2y
         WSHgytWJqR1cUtRde/bCsmR0Ty49bKNU1qK0DCi2f2E15VcTlGRElOF+ENdztXbXzHOt
         bAZH2PQAVjxQKgD+vd2qvUBEHSM8SjT25mLfF7bZsIaEB2RN0fmiui2mch8mCZ3rZn4s
         zCS6dd9HLjUpqEDkAcAUr4OdrKpqZ1+3g+gtd+GcPD0z4GG1iiViX2UrBqEvr8Nji1GA
         5ZD6D8HiAxvvDRvYTFUrI2hTp6edl9xdSmX2onyQmlFpOR0MAxyYjM5jPeTjzihCpm1p
         uG2Q==
X-Gm-Message-State: AOAM532uKyUwy8phSUs/dqYC4VZjxRi3NMSjaOjboK5pHy2IWnV0RiYl
        jOc9j5i419bsmk4jaNTFJJcbt5TlPPW+
X-Google-Smtp-Source: ABdhPJw98FvZviRs8QErmmAdiHmneWI4QXb4XUTdEeZVlkMVeZyMJ+JtFLNi64c2n/lbdlNIuczWyQ==
X-Received: by 2002:a05:6a00:1392:b029:18b:3735:8911 with SMTP id t18-20020a056a001392b029018b37358911mr2047620pfg.9.1604403762472;
        Tue, 03 Nov 2020 03:42:42 -0800 (PST)
Received: from PWN (59-125-13-244.HINET-IP.hinet.net. [59.125.13.244])
        by smtp.gmail.com with ESMTPSA id 30sm16076853pgl.45.2020.11.03.03.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 03:42:41 -0800 (PST)
Date:   Tue, 3 Nov 2020 06:42:35 -0500
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] Fonts: Replace discarded const qualifier
Message-ID: <20201103114235.GA2045431@PWN>
References: <20201030181822.570402-1-lee.jones@linaro.org>
 <20201102183242.2031659-1-yepeilin.cs@gmail.com>
 <20201103085324.GL4488@dell>
 <CAKMK7uGV10+TEWWMJod1-MRD1jkLqvOGUu4Qk9S84WJAUaB7Mg@mail.gmail.com>
 <20201103091538.GA2663113@kroah.com>
 <20201103095239.GW401619@phenom.ffwll.local>
 <20201103105523.GO4488@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103105523.GO4488@dell>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 10:55:23AM +0000, Lee Jones wrote:
> Would you be kind enough to let us know when this lands in Mainline
> please?  We'll need to back-port it to start fixing up our Stable
> kernels ASAP.

Sure, I will keep track of it, and update here when it happens. Thank
you, and sorry again for the trouble,

Peilin Ye

